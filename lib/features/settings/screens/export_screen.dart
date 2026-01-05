import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams, XFile;
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedFormat = 'csv';
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Default to current month
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Export Data'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          // Export info
          _buildInfoCard(),
          SizedBox(height: AppSpacing.lg),

          // Date range selection
          _buildSectionHeader('DATE RANGE'),
          _buildSettingsCard([
            _buildDateRangeTile(),
          ]),
          SizedBox(height: AppSpacing.md),

          // Quick date options
          _buildQuickDateOptions(),
          SizedBox(height: AppSpacing.lg),

          // Export format
          _buildSectionHeader('FORMAT'),
          _buildSettingsCard([
            _buildFormatTile(
              icon: Icons.table_chart_outlined,
              title: 'CSV',
              subtitle: 'Spreadsheet format for Excel, Google Sheets',
              value: 'csv',
            ),
            _buildDivider(),
            _buildFormatTile(
              icon: Icons.picture_as_pdf_outlined,
              title: 'PDF Report',
              subtitle: 'Formatted summary with charts',
              value: 'pdf',
            ),
          ]),
          SizedBox(height: AppSpacing.lg),

          // Export options
          _buildSectionHeader('INCLUDE'),
          _buildSettingsCard([
            _buildCheckboxTile(
              title: 'Transactions',
              subtitle: 'All income and expense records',
              checked: true,
              enabled: false,
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'Categories',
              subtitle: 'Category breakdown and totals',
              checked: true,
              enabled: true,
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'Wallets',
              subtitle: 'Wallet balances and history',
              checked: true,
              enabled: true,
            ),
          ]),
          SizedBox(height: AppSpacing.xl),

          // Export button
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.info),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Export your financial data to analyze in other apps or keep as a backup.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 56,
    );
  }

  Widget _buildDateRangeTile() {
    final dateFormat = DateFormat('MMM d, yyyy');
    final rangeText = _selectedDateRange != null
        ? '${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}'
        : 'Select date range';

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.date_range,
          color: AppColors.primaryAccent,
          size: 22,
        ),
      ),
      title: Text(
        'Date Range',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        rangeText,
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: _selectDateRange,
    );
  }

  Widget _buildQuickDateOptions() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _buildQuickDateChip('This Month', _getThisMonthRange()),
        _buildQuickDateChip('Last Month', _getLastMonthRange()),
        _buildQuickDateChip('Last 3 Months', _getLast3MonthsRange()),
        _buildQuickDateChip('This Year', _getThisYearRange()),
        _buildQuickDateChip('All Time', null),
      ],
    );
  }

  Widget _buildQuickDateChip(String label, DateTimeRange? range) {
    final isSelected = range == null
        ? _selectedDateRange == null
        : (_selectedDateRange?.start == range.start &&
            _selectedDateRange?.end == range.end);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedDateRange = range;
        });
      },
      backgroundColor: AppColors.primarySurface,
      selectedColor: AppColors.primaryAccent.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryAccent : AppColors.glassBorder,
        ),
      ),
    );
  }

  Widget _buildFormatTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedFormat == value;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (isSelected ? AppColors.primaryAccent : AppColors.textMuted)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primaryAccent : AppColors.textMuted,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
        ),
      ),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.textMuted,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryAccent,
                  ),
                ),
              )
            : null,
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedFormat = value;
        });
      },
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required String subtitle,
    required bool checked,
    required bool enabled,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          checked ? Icons.check_box : Icons.check_box_outline_blank,
          color: enabled
              ? (checked ? AppColors.primaryAccent : AppColors.textMuted)
              : AppColors.textMuted.withValues(alpha: 0.5),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? AppColors.textPrimary : AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton(
      onPressed: _isExporting ? null : _exportData,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),
      child: _isExporting
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Export ${_selectedFormat.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryAccent,
              surface: AppColors.primarySurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  DateTimeRange _getThisMonthRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
  }

  DateTimeRange _getLastMonthRange() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    return DateTimeRange(
      start: lastMonth,
      end: DateTime(now.year, now.month, 0),
    );
  }

  DateTimeRange _getLast3MonthsRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month - 3, 1),
      end: now,
    );
  }

  DateTimeRange _getThisYearRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, 1, 1),
      end: now,
    );
  }

  Future<void> _exportData() async {
    setState(() => _isExporting = true);

    try {
      final db = ref.read(databaseProvider);
      final transactions = await db.getAllTransactions();

      // Filter by date range
      final filteredTransactions = _selectedDateRange != null
          ? transactions.where((t) {
              return t.date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
                  t.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
            }).toList()
          : transactions;

      if (_selectedFormat == 'csv') {
        await _exportToCsv(filteredTransactions);
      } else {
        // TODO: Implement PDF export
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF export coming soon!'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportToCsv(List<dynamic> transactions) async {
    // Build CSV content
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Date,Title,Amount,Type,Category,Wallet,Notes');

    // Data rows
    for (final t in transactions) {
      final date = DateFormat('yyyy-MM-dd').format(t.date);
      final title = _escapeCsv(t.title ?? '');
      final amount = t.amount.toStringAsFixed(2);
      final type = t.isIncome == true ? 'Income' : 'Expense';
      final category = _escapeCsv(t.categoryId ?? 'Uncategorized');
      final wallet = _escapeCsv(t.walletId ?? '');
      final notes = _escapeCsv(t.notes ?? '');

      buffer.writeln('$date,$title,$amount,$type,$category,$wallet,$notes');
    }

    // Save to file
    final directory = await getTemporaryDirectory();
    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/the_accountant_export_$dateStr.csv');
    await file.writeAsString(buffer.toString());

    // Share file
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'The Accountant - Export',
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported ${transactions.length} transactions'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
