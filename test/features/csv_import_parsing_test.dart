import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_accountant/features/import/domain/column_mapping.dart';
import 'package:the_accountant/features/import/domain/csv_reader.dart';
import 'package:the_accountant/features/import/domain/import_preview.dart';
import 'package:the_accountant/features/import/domain/import_values.dart';

/// Reading a bank statement.
///
/// Almost none of this is about CSV grammar. It is about the three things a
/// file will not tell you — what it was encoded as, what separates the fields,
/// and what `03/04/2026` and `1.234` mean — every one of which can be got wrong
/// silently, producing a year of records on the wrong days at the wrong
/// amounts with nothing on screen to say so.
Uint8List bytes(String text) => Uint8List.fromList(utf8.encode(text));

void main() {
  group('splitting a file into rows', () {
    test('a quoted field may contain the delimiter', () {
      final rows = CsvReader.parse('a,"b,still b",c', delimiter: ',');

      expect(rows.single, ['a', 'b,still b', 'c']);
    });

    test('a doubled quote inside a quoted field is one quote', () {
      final rows = CsvReader.parse('"say ""hello""",x', delimiter: ',');

      expect(rows.single.first, 'say "hello"');
    });

    test('a quoted field may run over a line break', () {
      final rows = CsvReader.parse(
        'a,"line one\nline two",c\nd,e,f',
        delimiter: ',',
      );

      expect(rows, hasLength(2));
      expect(rows.first[1], 'line one\nline two');
    });

    test('a quote in the middle of a field is just a quote', () {
      final rows = CsvReader.parse('5" pipe,10', delimiter: ',');

      expect(
        rows.single,
        ['5" pipe', '10'],
        reason:
            'reading it as an opening quote swallows the rest of the file into '
            'a single field',
      );
    });

    test('Windows line endings do not leave a stray carriage return', () {
      final rows = CsvReader.parse('a,b\r\nc,d\r\n', delimiter: ',');

      expect(rows, [
        ['a', 'b'],
        ['c', 'd'],
      ]);
    });

    test('blank lines are separators, not records', () {
      final rows = CsvReader.parse('a,b\n\n\nc,d\n', delimiter: ',');

      expect(rows, hasLength(2));
    });

    test('a row that stops short is read, not refused', () {
      final document = CsvReader.read(bytes('a,b,c\n1,2\n'));

      expect(CsvDocument.cell(document.body.single, 2), '');
    });
  });

  group('working out what the file is', () {
    test('a comma-separated file', () {
      expect(CsvReader.detectDelimiter('a,b,c\n1,2,3'), ',');
    });

    test('a semicolon-separated file, as half of Europe exports', () {
      expect(
        CsvReader.detectDelimiter(
          'Datum;Betrag;Text\n01.02.2026;1.234,56;Miete',
        ),
        ';',
      );
    });

    test('a tab-separated file', () {
      expect(CsvReader.detectDelimiter('a\tb\tc\n1\t2\t3'), '\t');
    });

    test(
      'a file with commas inside quoted fields is still comma-separated',
      () {
        expect(
          CsvReader.detectDelimiter(
            'date,description,amount\n'
            '2026-01-01,"Shop, the",10.00',
          ),
          ',',
        );
      },
    );

    test('a UTF-8 byte order mark is not read as part of the first title', () {
      final document = CsvReader.read(
        Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode('Date,Amount\n')]),
      );

      expect(document.header.first, 'Date');
    });

    test('an accented payee survives a UTF-8 file', () {
      final document = CsvReader.read(bytes('Date,Payee\n2026-01-01,Café\n'));

      expect(document.body.single[1], 'Café');
    });

    test('a Latin-1 file is read rather than throwing', () {
      // 0xE9 is é in Latin-1 and not valid UTF-8 on its own.
      final document = CsvReader.read(
        Uint8List.fromList([
          ...utf8.encode('Date,Payee\n2026-01-01,Caf'),
          0xE9,
          0x0A,
        ]),
      );

      expect(document.body.single[1], 'Café');
    });

    test('a header is recognised by looking unlike the rows below it', () {
      final document = CsvReader.read(
        bytes('Date,Amount\n2026-01-01,10.00\n2026-01-02,20.00\n'),
      );

      expect(document.hasHeader, isTrue);
      expect(document.body, hasLength(2));
    });

    test('a file that starts straight in with data has no header', () {
      final document = CsvReader.read(
        bytes('2026-01-01,10.00\n2026-01-02,20.00\n'),
      );

      expect(document.hasHeader, isFalse);
      expect(document.body, hasLength(2));
      expect(document.header, ['Column 1', 'Column 2']);
    });
  });

  group('reading an amount', () {
    test('a plain decimal', () {
      expect(ImportValues.parseAmountCents('12.34'), 1234);
    });

    test('a negative', () {
      expect(ImportValues.parseAmountCents('-12.34'), -1234);
    });

    test('a currency symbol is decoration', () {
      expect(ImportValues.parseAmountCents(r'$1,234.56'), 123456);
    });

    test('a European number', () {
      expect(ImportValues.parseAmountCents('1.234,56'), 123456);
    });

    test('a European number with no thousands separator', () {
      expect(ImportValues.parseAmountCents('99,99'), 9999);
    });

    test('a bare thousands group is a thousand, not one and a bit', () {
      expect(ImportValues.parseAmountCents('1,234'), 123400);
      expect(ImportValues.parseAmountCents('1.234'), 123400);
    });

    test("accountants' parentheses mean negative", () {
      expect(ImportValues.parseAmountCents('(45.00)'), -4500);
    });

    test('a DR suffix means money out', () {
      expect(ImportValues.parseAmountCents('45.00 DR'), -4500);
      expect(ImportValues.parseAmountCents('45.00 CR'), 4500);
    });

    test('something with no number in it is refused, not read as zero', () {
      expect(ImportValues.parseAmountCents('n/a'), isNull);
      expect(ImportValues.parseAmountCents(''), isNull);
    });

    test('an explicit separator overrides the guess', () {
      // Left to itself this reads as a thousands group; told otherwise, it is
      // one and a bit. Both readings are defensible, which is the whole reason
      // the setting exists.
      expect(ImportValues.parseAmountCents('1,234'), 123400);
      expect(
        ImportValues.parseAmountCents('1,234', decimalSeparator: ','),
        123,
      );
      expect(ImportValues.parseAmountCents('1,20', decimalSeparator: ','), 120);
    });

    test('the column decides the separator, not each value', () {
      expect(
        ImportValues.guessDecimalSeparator(['1.234,56', '99,99', '5']),
        ',',
      );
      expect(
        ImportValues.guessDecimalSeparator(['1,234.56', '99.99', '5']),
        '.',
      );
    });
  });

  group('reading a date', () {
    test('an unambiguous file settles its own order', () {
      expect(
        ImportValues.guessDateFormat(['01/02/2026', '25/12/2026']),
        'dd/MM/yyyy',
        reason: 'a 25th cannot be a month',
      );
      expect(
        ImportValues.guessDateFormat(['01/02/2026', '12/25/2026']),
        'MM/dd/yyyy',
      );
    });

    test('ISO is preferred where it fits', () {
      expect(ImportValues.guessDateFormat(['2026-03-04']), 'yyyy-MM-dd');
    });

    test('a dotted European date', () {
      expect(ImportValues.guessDateFormat(['01.02.2026']), 'dd.MM.yyyy');
    });

    test('a written-out month', () {
      expect(
        ImportValues.parseDate('4 Mar 2026', 'd MMM yyyy'),
        DateTime(2026, 3, 4),
      );
    });

    test(
      'a date that does not fit the pattern is refused, not rolled over',
      () {
        expect(
          ImportValues.parseDate('13/05/2026', 'MM/dd/yyyy'),
          isNull,
          reason:
              'rolling month 13 into the next January is exactly the silent '
              'wrongness that makes an import untrustworthy',
        );
      },
    );

    test('a column of nonsense produces no guess at all', () {
      expect(ImportValues.guessDateFormat(['banana', 'pear']), isNull);
    });
  });

  group('guessing what the columns mean', () {
    test('from ordinary headings', () {
      final document = CsvReader.read(
        bytes(
          'Date,Description,Amount,Category\n'
          '2026-01-01,Groceries,-45.00,Food\n',
        ),
      );

      final mapping = ColumnMapping.guess(document);

      expect(mapping.indexOf(ImportField.date), 0);
      expect(mapping.indexOf(ImportField.title), 1);
      expect(mapping.indexOf(ImportField.amount), 2);
      expect(mapping.indexOf(ImportField.category), 3);
      expect(mapping.dateFormat, 'yyyy-MM-dd');
      expect(mapping.isUsable, isTrue);
    });

    test('from a money-in/money-out pair', () {
      final document = CsvReader.read(
        bytes(
          'Date,Description,Money In,Money Out\n'
          '01/02/2026,Salary,2000.00,\n',
        ),
      );

      final mapping = ColumnMapping.guess(document);

      expect(mapping.indexOf(ImportField.moneyIn), 2);
      expect(mapping.indexOf(ImportField.moneyOut), 3);
      expect(mapping.has(ImportField.amount), isFalse);
    });

    test(
      'a file with both loses the single column, which is the vaguer one',
      () {
        final document = CsvReader.read(
          bytes('Date,Amount,Paid In,Paid Out\n2026-01-01,5,5,\n'),
        );

        final mapping = ColumnMapping.guess(document);

        expect(mapping.has(ImportField.amount), isFalse);
        expect(mapping.has(ImportField.moneyIn), isTrue);
      },
    );

    test('a column can only mean one thing', () {
      const mapping = ColumnMapping(
        columns: {ImportField.date: 0, ImportField.amount: 1},
      );

      final moved = mapping.assign(ImportField.title, 1);

      expect(moved.indexOf(ImportField.title), 1);
      expect(
        moved.has(ImportField.amount),
        isFalse,
        reason:
            'two fields reading one column looks right on screen and imports '
            'nonsense',
      );
    });

    test('an unrecognisable file says what it still needs', () {
      final document = CsvReader.read(bytes('Foo,Bar\nx,y\n'));

      final mapping = ColumnMapping.guess(document);

      expect(mapping.isUsable, isFalse);
      expect(mapping.missing, ['a date column', 'an amount column']);
    });

    test('a mapping survives being saved and read back', () {
      const mapping = ColumnMapping(
        columns: {ImportField.date: 0, ImportField.amount: 2},
        dateFormat: 'dd/MM/yyyy',
        decimalSeparator: ',',
        negateAmounts: true,
      );

      final restored = ColumnMapping.decode(mapping.encode());

      expect(restored.columns, mapping.columns);
      expect(restored.dateFormat, 'dd/MM/yyyy');
      expect(restored.decimalSeparator, ',');
      expect(restored.negateAmounts, isTrue);
    });

    test(
      'a saved mapping that is damaged does not stop the screen opening',
      () {
        expect(ColumnMapping.decode('{{{').isUsable, isFalse);
      },
    );
  });

  group('what a file would bring in', () {
    ImportPreview previewOf(String csv) {
      final document = CsvReader.read(bytes(csv));
      return ImportReader.read(document, ColumnMapping.guess(document));
    }

    test('a signed amount column gives the direction', () {
      final preview = previewOf(
        'Date,Description,Amount\n'
        '2026-01-01,Groceries,-45.00\n'
        '2026-01-02,Salary,2000.00\n',
      );

      expect(preview.usableCount, 2);
      expect(preview.rows.first.amountCents, -4500);
      expect(preview.rows.first.isIncome, isFalse);
      expect(preview.rows.last.isIncome, isTrue);
    });

    test('a money-out column is money out whatever sign it carries', () {
      final preview = previewOf(
        'Date,Description,Money In,Money Out\n'
        '2026-01-01,Rent,,800.00\n'
        '2026-01-02,Pay,2000.00,\n',
      );

      expect(preview.rows.first.amountCents, -80000);
      expect(preview.rows.last.amountCents, 200000);
    });

    test('an unsigned amount plus a type word', () {
      final preview = previewOf(
        'Date,Description,Type,Amount\n'
        '2026-01-01,Rent,Debit,800.00\n'
        '2026-01-02,Pay,Credit,2000.00\n',
      );

      expect(preview.rows.first.amountCents, -80000);
      expect(preview.rows.last.amountCents, 200000);
    });

    test('a row that cannot be read is reported, never dropped', () {
      final preview = previewOf(
        'Date,Description,Amount\n'
        '2026-01-01,Fine,10.00\n'
        'not a date,Broken,10.00\n'
        '2026-01-03,No amount,\n',
      );

      expect(preview.rows, hasLength(3));
      expect(preview.usableCount, 1);
      expect(preview.unusableCount, 2);
      expect(preview.unusable.first.problem, contains('not a date'));
      expect(preview.unusable.last.problem, 'No amount');
    });

    test('a complaint names the line in the file', () {
      final preview = previewOf(
        'Date,Description,Amount\n'
        '2026-01-01,Fine,10.00\n'
        'rubbish,Broken,10.00\n',
      );

      expect(
        preview.unusable.single.lineNumber,
        3,
        reason: 'counting the header, so the number matches the file itself',
      );
    });

    test('a row with no description still gets one', () {
      final preview = previewOf('Date,Description,Amount\n2026-01-01,,10.00\n');

      expect(preview.rows.single.title, 'Imported');
    });

    test('the totals are what will actually be added', () {
      final preview = previewOf(
        'Date,Description,Amount\n'
        '2026-01-01,A,-45.00\n'
        '2026-01-02,B,-55.00\n'
        '2026-01-03,C,2000.00\n',
      );

      expect(preview.expenseCents, 10000);
      expect(preview.incomeCents, 200000);
      expect(preview.earliest, DateTime(2026, 1, 1));
      expect(preview.latest, DateTime(2026, 1, 3));
    });

    test('the names it will need are collected up front', () {
      final preview = previewOf(
        'Date,Description,Amount,Category,Account\n'
        '2026-01-01,A,-1.00,Food,Current\n'
        '2026-01-02,B,-2.00,Food,Savings\n',
      );

      expect(preview.categoryNames, {'Food'});
      expect(preview.accountNames, {'Current', 'Savings'});
    });

    test('flipping the signs turns a spend-positive export the right way', () {
      final document = CsvReader.read(
        bytes('Date,Description,Amount\n2026-01-01,Groceries,45.00\n'),
      );
      final mapping = ColumnMapping.guess(
        document,
      ).copyWith(negateAmounts: true);

      final preview = ImportReader.read(document, mapping);

      expect(preview.rows.single.amountCents, -4500);
    });

    test('a mapping that is not usable yet previews nothing', () {
      final document = CsvReader.read(bytes('Foo,Bar\nx,y\n'));

      expect(
        ImportReader.read(document, ColumnMapping.guess(document)).rows,
        isEmpty,
      );
    });
  });
}
