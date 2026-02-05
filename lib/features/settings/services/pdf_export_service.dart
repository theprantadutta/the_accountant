import 'dart:io';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:the_accountant/data/datasources/local/app_database.dart';

class PdfExportService {
  static Future<File> generateTransactionReport({
    required List<Transaction> transactions,
    required DateTimeRange dateRange,
    required String currency,
    bool includeCategories = true,
    bool includeWallets = true,
  }) async {
    final pdf = pw.Document();

    // Calculate summaries
    double totalIncome = 0;
    double totalExpense = 0;
    final categoryTotals = <String, double>{};
    final walletTotals = <String, double>{};

    for (final txn in transactions) {
      if (txn.isIncome == true) {
        totalIncome += txn.amount.abs();
      } else {
        totalExpense += txn.amount.abs();
      }

      // Category totals
      final categoryId = txn.categoryId ?? 'Uncategorized';
      categoryTotals[categoryId] =
          (categoryTotals[categoryId] ?? 0) + txn.amount.abs();

      // Wallet totals
      final walletId = txn.walletId ?? 'Unknown';
      walletTotals[walletId] = (walletTotals[walletId] ?? 0) + txn.amount.abs();
    }

    final netAmount = totalIncome - totalExpense;
    final dateFormatter = DateFormat('MMM d, yyyy');
    final currencyFormatter = NumberFormat.currency(
      symbol: currency,
      decimalDigits: 2,
    );

    // Build PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          _buildHeader(dateRange, dateFormatter),
          pw.SizedBox(height: 20),

          // Summary Section
          _buildSummarySection(
            totalIncome: totalIncome,
            totalExpense: totalExpense,
            netAmount: netAmount,
            transactionCount: transactions.length,
            currencyFormatter: currencyFormatter,
          ),
          pw.SizedBox(height: 30),

          // Category Breakdown
          if (includeCategories && categoryTotals.isNotEmpty) ...[
            _buildSectionTitle('Category Breakdown'),
            pw.SizedBox(height: 10),
            _buildCategoryTable(categoryTotals, currencyFormatter),
            pw.SizedBox(height: 20),
          ],

          // Recent Transactions
          _buildSectionTitle('Transactions'),
          pw.SizedBox(height: 10),
          _buildTransactionTable(
            transactions,
            currencyFormatter,
            dateFormatter,
          ),
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    // Save PDF to file
    final output = await getTemporaryDirectory();
    final startDate = dateFormatter
        .format(dateRange.start)
        .replaceAll(' ', '_')
        .replaceAll(',', '');
    final endDate = dateFormatter
        .format(dateRange.end)
        .replaceAll(' ', '_')
        .replaceAll(',', '');
    final fileName = 'the_accountant_report_${startDate}_to_$endDate.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget _buildHeader(DateTimeRange dateRange, DateFormat formatter) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'The Accountant',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.indigo,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Financial Report',
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.indigo50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Period',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${formatter.format(dateRange.start)} - ${formatter.format(dateRange.end)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Divider(color: PdfColors.grey300, thickness: 1),
      ],
    );
  }

  static pw.Widget _buildSummarySection({
    required double totalIncome,
    required double totalExpense,
    required double netAmount,
    required int transactionCount,
    required NumberFormat currencyFormatter,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard(
            'Total Income',
            currencyFormatter.format(totalIncome),
            PdfColors.green700,
          ),
          _buildSummaryCard(
            'Total Expenses',
            currencyFormatter.format(totalExpense),
            PdfColors.red700,
          ),
          _buildSummaryCard(
            'Net Balance',
            currencyFormatter.format(netAmount),
            netAmount >= 0 ? PdfColors.green700 : PdfColors.red700,
          ),
          _buildSummaryCard(
            'Transactions',
            transactionCount.toString(),
            PdfColors.indigo,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryCard(
    String label,
    String value,
    PdfColor color,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey600,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey800,
      ),
    );
  }

  static pw.Widget _buildCategoryTable(
    Map<String, double> categoryTotals,
    NumberFormat currencyFormatter,
  ) {
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = sortedCategories.fold<double>(0, (sum, e) => sum + e.value);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Category', isHeader: true),
            _buildTableCell(
              'Amount',
              isHeader: true,
              alignment: pw.Alignment.centerRight,
            ),
            _buildTableCell(
              '%',
              isHeader: true,
              alignment: pw.Alignment.centerRight,
            ),
          ],
        ),
        // Data rows
        ...sortedCategories.take(10).map((entry) {
          final percentage = (entry.value / total * 100).toStringAsFixed(1);
          return pw.TableRow(
            children: [
              _buildTableCell(entry.key),
              _buildTableCell(
                currencyFormatter.format(entry.value),
                alignment: pw.Alignment.centerRight,
              ),
              _buildTableCell(
                '$percentage%',
                alignment: pw.Alignment.centerRight,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTransactionTable(
    List<Transaction> transactions,
    NumberFormat currencyFormatter,
    DateFormat dateFormatter,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Date', isHeader: true),
            _buildTableCell('Title', isHeader: true),
            _buildTableCell('Category', isHeader: true),
            _buildTableCell(
              'Amount',
              isHeader: true,
              alignment: pw.Alignment.centerRight,
            ),
          ],
        ),
        // Data rows (limit to 50 for performance)
        ...transactions.take(50).map((txn) {
          final isIncome = txn.isIncome == true;
          return pw.TableRow(
            children: [
              _buildTableCell(dateFormatter.format(txn.date)),
              _buildTableCell(txn.title ?? 'No title'),
              _buildTableCell(txn.categoryId ?? 'Uncategorized'),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  '${isIncome ? '+' : '-'}${currencyFormatter.format(txn.amount.abs())}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: isIncome ? PdfColors.green700 : PdfColors.red700,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.Alignment alignment = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: alignment,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.grey800 : PdfColors.grey700,
        ),
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by The Accountant',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }
}
