import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart' as db;
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/categories/providers/category_provider.dart';
import 'package:the_accountant/features/transactions/widgets/category_picker_sheet.dart';

/// Rules that file a transaction by what it is called.
///
/// The table, the matching and the backend endpoints all existed; nothing let
/// anyone see or change a rule. So the app could learn "Tesco means Groceries"
/// and there was no way to correct it when it learned wrong, which is worse
/// than not learning at all.
class TitleRulesScreen extends ConsumerStatefulWidget {
  const TitleRulesScreen({super.key});

  @override
  ConsumerState<TitleRulesScreen> createState() => _TitleRulesScreenState();
}

class _TitleRulesScreenState extends ConsumerState<TitleRulesScreen> {
  List<db.AssociatedTitle>? _rules;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rules = await ref.read(databaseProvider).getAllAssociatedTitles();
    if (!mounted) return;
    rules.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
    setState(() => _rules = rules);
  }

  @override
  Widget build(BuildContext context) {
    final rules = _rules;
    final categories = ref.watch(categoryProvider).categories;

    String categoryName(String id) =>
        categories.where((c) => c.id == id).firstOrNull?.name ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Naming rules')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('Add rule'),
      ),
      body: rules == null
          ? const Center(child: CircularProgressIndicator())
          : rules.isEmpty
          ? _empty()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 96),
              itemCount: rules.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == rules.length) {
                  return Padding(
                    padding: AppSpacing.paddingLg,
                    child: Text(
                      'A rule matches anywhere in the title unless you make it '
                      'exact. The app adds one for you each time you file '
                      'something by hand.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                }

                final rule = rules[index];
                return ListTile(
                  leading: Icon(
                    rule.isExactMatch
                        ? Icons.check_circle_outline
                        : Icons.search,
                    color: AppColors.textMuted,
                  ),
                  title: Text(rule.title),
                  subtitle: Text(
                    '${rule.isExactMatch ? 'Exactly this' : 'Anything containing this'}'
                    ' → ${categoryName(rule.categoryId)}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(rule),
                  ),
                  onTap: () => _edit(existing: rule),
                );
              },
            ),
    );
  }

  Widget _empty() => Center(
    child: Padding(
      padding: AppSpacing.paddingXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.glassWhite,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              size: 40,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapXl,
          Text(
            'No rules yet',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'Teach the app where something belongs once, and it files it that '
            'way from then on.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    ),
  );

  Future<void> _edit({db.AssociatedTitle? existing}) async {
    final result = await showDialog<({String title, bool exact})>(
      context: context,
      builder: (context) => _RuleDialog(existing: existing),
    );
    if (result == null || !mounted) return;

    final category = await showCategoryPickerSheet(
      context: context,
      ref: ref,
      selectedCategoryId: existing?.categoryId,
    );
    if (category == null) return;

    await ref
        .read(databaseProvider)
        .setAssociatedTitle(
          title: result.title,
          categoryId: category.id,
          isExactMatch: result.exact,
        );
    await _load();
  }

  Future<void> _delete(db.AssociatedTitle rule) async {
    await ref.read(databaseProvider).deleteAssociatedTitle(rule.id);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed the rule for ${rule.title}')),
    );
  }
}

class _RuleDialog extends StatefulWidget {
  final db.AssociatedTitle? existing;

  const _RuleDialog({this.existing});

  @override
  State<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<_RuleDialog> {
  late final TextEditingController _title;
  late bool _exact;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _exact = widget.existing?.isExactMatch ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'New rule' : 'Edit rule'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'When the title says',
              hintText: 'Tesco',
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _exact,
            onChanged: (v) => setState(() => _exact = v),
            title: const Text('Match exactly'),
            subtitle: Text(
              _exact
                  ? 'Only titles that are exactly this'
                  : 'Any title containing it',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _title.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(context, (title: title, exact: _exact));
          },
          child: const Text('Choose category'),
        ),
      ],
    );
  }
}
