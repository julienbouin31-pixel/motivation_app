import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/widgets/home_widget_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


void showAffirmationShareSheet(
  BuildContext context, {
  required String text,
  required String category,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AffirmationShareSheet(text: text, category: category),
  );
}

class AffirmationShareSheet extends StatefulWidget {
  final String text;
  final String category;

  const AffirmationShareSheet({
    super.key,
    required this.text,
    required this.category,
  });

  @override
  State<AffirmationShareSheet> createState() => _AffirmationShareSheetState();
}

class _AffirmationShareSheetState extends State<AffirmationShareSheet> {
  final _previewKey = GlobalKey();

  Future<File?> _captureCard() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final boundary =
          _previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/affirmation.png');
      await file.writeAsBytes(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.scaffold,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle + titre ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: colors.secondary),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Partager',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
          ),

          // ── Prévisualisation ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: RepaintBoundary(
              key: _previewKey,
              child: _PreviewCard(
                text: widget.text,
                category: widget.category,
              ),
            ),
          ),

          // ── Actions ─────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareAction(
                  icon: Icons.download_outlined,
                  label: 'Enregistrer',
                  onTap: () async {
                    final file = await _captureCard();
                    if (file == null || !mounted) return;
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      sharePositionOrigin: Rect.fromLTWH(
                        size.width / 4, size.height / 2, size.width / 2, 1,
                      ),
                    );
                  },
                ),
                _ShareAction(
                  icon: Icons.share_outlined,
                  label: 'Partager',
                  onTap: () async {
                    final file = await _captureCard();
                    if (file == null || !mounted) return;
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      sharePositionOrigin: Rect.fromLTWH(
                        size.width / 4, size.height / 2, size.width / 2, size.height / 4,
                      ),
                    );
                  },
                ),
                _ShareAction(
                  icon: Icons.copy_outlined,
                  label: 'Copier',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: '"${widget.text}"'));
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(context);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Texte copié !')),
                    );
                  },
                ),
                _ShareAction(
                  icon: Icons.widgets_outlined,
                  label: 'Widget',
                  onTap: () {
                    HomeWidgetService.updateAffirmation(
                      text: widget.text,
                      category: widget.category.toLowerCase(),
                    );
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(context);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Widget mis à jour !')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Preview card ─────────────────────────────────────────────────────────────

class _PreviewCard extends StatelessWidget {
  final String text;
  final String category;

  const _PreviewCard({required this.text, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0EDE7);
    final primary = isDark ? Colors.white : const Color(0xFF111111);
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : const Color(0xFF111111).withValues(alpha: 0.1);
    final secondary = isDark
        ? Colors.white.withValues(alpha: 0.38)
        : const Color(0xFFAAAAAA);

    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quote mark décoratif
            Text(
              '\u201C',
              style: TextStyle(
                fontSize: 72,
                height: 0.85,
                fontWeight: FontWeight.w900,
                color: muted,
              ),
            ),

            const Spacer(),

            // Texte de l'affirmation
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.45,
                color: primary,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 16),

            // Séparateur
            Container(
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                color: muted,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 12),

            // Catégorie
            Text(
              category.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: secondary,
              ),
            ),

            const Spacer(),

            // Branding
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'curves',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: secondary,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bouton d'action ──────────────────────────────────────────────────────────

class _ShareAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colors.card,
              shape: BoxShape.circle,
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Icon(icon, size: 22, color: colors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
