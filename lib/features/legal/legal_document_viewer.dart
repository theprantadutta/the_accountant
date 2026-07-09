import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/shared/widgets/legal_markdown_style.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';

class LegalDocumentViewer extends StatefulWidget {
  final String title;
  final String assetPath;

  const LegalDocumentViewer({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<LegalDocumentViewer> createState() => _LegalDocumentViewerState();
}

class _LegalDocumentViewerState extends State<LegalDocumentViewer> {
  String _content = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await rootBundle.loadString(widget.assetPath);
    setState(() {
      _content = content;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerCard(height: 28, width: 200),
                  SizedBox(height: 16),
                  ShimmerCard(height: 14),
                  SizedBox(height: 8),
                  ShimmerCard(height: 14),
                  SizedBox(height: 8),
                  ShimmerCard(height: 14),
                  SizedBox(height: 24),
                  ShimmerCard(height: 14),
                  SizedBox(height: 8),
                  ShimmerCard(height: 14),
                ],
              ),
            )
          : Markdown(
              data: _content,
              selectable: true,
              padding: const EdgeInsets.all(16),
              styleSheet: legalMarkdownStyleSheet(),
            ),
    );
  }
}
