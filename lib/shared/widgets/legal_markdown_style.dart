import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:the_accountant/core/themes/app_colors.dart';

MarkdownStyleSheet legalMarkdownStyleSheet() {
  return MarkdownStyleSheet(
    h1: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    h2: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryGlow,
      height: 1.6,
    ),
    h3: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    p: TextStyle(
      fontSize: 14,
      color: AppColors.textPrimary.withValues(alpha: 0.85),
      height: 1.6,
    ),
    listBullet: TextStyle(
      fontSize: 14,
      color: AppColors.textPrimary.withValues(alpha: 0.85),
    ),
    strong: TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    em: TextStyle(
      fontStyle: FontStyle.italic,
      color: AppColors.textPrimary.withValues(alpha: 0.9),
    ),
    tableHead: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    tableBody: TextStyle(
      fontSize: 13,
      color: AppColors.textPrimary.withValues(alpha: 0.8),
    ),
    tableBorder: TableBorder.all(color: AppColors.glassBorder, width: 1),
    tableHeadAlign: TextAlign.left,
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.glassBorder, width: 1)),
    ),
    blockquoteDecoration: BoxDecoration(
      color: AppColors.glassWhite,
      borderRadius: BorderRadius.circular(8),
      border: Border(
        left: BorderSide(color: AppColors.primaryAccent, width: 3),
      ),
    ),
    a: TextStyle(
      color: AppColors.neonCyan,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.neonCyan.withValues(alpha: 0.5),
    ),
  );
}
