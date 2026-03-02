import 'dart:io';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:the_accountant/core/utils/date_formatter.dart';
import 'package:the_accountant/core/utils/number_formatter.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';

class PdfExportService {
  static Future<File> generateTransactionReport({
    required List<ExportTransaction> transactions,
    DateTimeRange? dateRange,
    required String currencySymbol,
    bool includeCategories = true,
    bool includeWallets = true,
    String dateFormat = 'MM/dd/yyyy',
    String numberFormat = 'comma_dot',
  }) async {
    final pdf = pw.Document();

    // Calculate summaries
    double totalIncome = 0;
    double totalExpense = 0;
    final categoryTotals = <String, double>{};
    final walletTotals = <String, double>{};

    for (final item in transactions) {
      final txn = item.transaction;
      if (txn.isIncome == true) {
        totalIncome += txn.amount.abs();
      } else {
        totalExpense += txn.amount.abs();
      }

      // Category totals using resolved name
      categoryTotals[item.categoryName] =
          (categoryTotals[item.categoryName] ?? 0) + txn.amount.abs();

      // Wallet totals using resolved name
      walletTotals[item.walletName] =
          (walletTotals[item.walletName] ?? 0) + txn.amount.abs();
    }

    final netAmount = totalIncome - totalExpense;
    final currencyFormatter = AppNumberFormatter.currency(
      currencySymbol,
      numberFormat,
      decimalDigits: 2,
    );

    // Build PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          _buildHeader(dateRange, dateFormat),
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

          // Wallet Breakdown
          if (includeWallets && walletTotals.isNotEmpty) ...[
            _buildSectionTitle('Wallet Breakdown'),
            pw.SizedBox(height: 10),
            _buildWalletTable(walletTotals, currencyFormatter),
            pw.SizedBox(height: 20),
          ],

          // Transactions
          _buildSectionTitle('Transactions'),
          pw.SizedBox(height: 10),
          _buildTransactionTable(
            transactions,
            currencyFormatter,
            dateFormat,
          ),
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    // Save PDF to file
    final output = await getTemporaryDirectory();
    String fileName;
    if (dateRange != null) {
      final startDate = AppDateFormatter.formatDate(dateRange.start, dateFormat)
          .replaceAll('/', '-')
          .replaceAll(' ', '_')
          .replaceAll(',', '');
      final endDate = AppDateFormatter.formatDate(dateRange.end, dateFormat)
          .replaceAll('/', '-')
          .replaceAll(' ', '_')
          .replaceAll(',', '');
      fileName = 'the_accountant_report_${startDate}_to_$endDate.pdf';
    } else {
      final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      fileName = 'the_accountant_report_all_time_$dateStr.pdf';
    }
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget _buildHeader(DateTimeRange? dateRange, String dateFormat) {
    final periodText = dateRange != null
        ? '${AppDateFormatter.formatDate(dateRange.start, dateFormat)} - ${AppDateFormatter.formatDate(dateRange.end, dateFormat)}'
        : 'All Time';

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
                    periodText,
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

    // Show top 15 + "Other" row if more than 15 categories
    final displayCategories = sortedCategories.length > 15
        ? sortedCategories.take(15).toList()
        : sortedCategories;
    final otherTotal = sortedCategories.length > 15
        ? sortedCategories.skip(15).fold<double>(0, (sum, e) => sum + e.value)
        : 0.0;

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
        ...displayCategories.map((entry) {
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
        // "Other" row if needed
        if (otherTotal > 0)
          pw.TableRow(
            children: [
              _buildTableCell('Other'),
              _buildTableCell(
                currencyFormatter.format(otherTotal),
                alignment: pw.Alignment.centerRight,
              ),
              _buildTableCell(
                '${(otherTotal / total * 100).toStringAsFixed(1)}%',
                alignment: pw.Alignment.centerRight,
              ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildWalletTable(
    Map<String, double> walletTotals,
    NumberFormat currencyFormatter,
  ) {
    final sortedWallets = walletTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = sortedWallets.fold<double>(0, (sum, e) => sum + e.value);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Wallet', isHeader: true),
            _buildTableCell(
              'Total',
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
        ...sortedWallets.map((entry) {
          final percentage = total > 0
              ? (entry.value / total * 100).toStringAsFixed(1)
              : '0.0';
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
    List<ExportTransaction> transactions,
    NumberFormat currencyFormatter,
    String dateFormat,
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
        // All transaction rows (no cap)
        ...transactions.map((item) {
          final txn = item.transaction;
          final isIncome = txn.isIncome == true;
          return pw.TableRow(
            children: [
              _buildTableCell(AppDateFormatter.formatDate(txn.date, dateFormat)),
              _buildTableCell(txn.title.isEmpty ? 'No title' : txn.title),
              _buildTableCell(item.categoryName),
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
