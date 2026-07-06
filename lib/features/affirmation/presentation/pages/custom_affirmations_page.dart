import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/custom_affirmations_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_share_sheet.dart';
import 'package:motivation_app/injection_container.dart' as di;

class CustomAffirmationsPage extends StatelessWidget {
  const CustomAffirmationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomAffirmationsCubit(di.sl())..load(),
      child: const _CustomAffirmationsView(),
    );
  }
}

class _CustomAffirmationsView extends StatelessWidget {
  const _CustomAffirmationsView();

  @override
  Widget build(BuildContext context) {
    final affirmations = context.watch<CustomAffirmationsCubit>().state;

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppStyle.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text('mes affirmations',
                            style: AppStyle.display(size: 30)),
                      ),
                      GestureDetector(
                        onTap: () => _showEditSheet(context, null),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            color: AppStyle.ink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add,
                                  size: 15, color: Color(0xFF111110)),
                              SizedBox(width: 4),
                              Text(
                                'créer',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111110),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (affirmations.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${affirmations.length} créée${affirmations.length > 1 ? 's' : ''}',
                      style: AppStyle.overline,
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: affirmations.isEmpty
                  ? _EmptyState(onTap: () => _showEditSheet(context, null))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
                      itemCount: affirmations.length,
                      itemBuilder: (context, index) {
                        final a = affirmations[index];
                        return _AffirmationTile(
                          affirmation: a,
                          onEdit: () => _showEditSheet(context, a),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, Affirmation? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CustomAffirmationsCubit>(),
        child: _EditSheet(existing: existing),
      ),
    );
  }
}

// ─── Rangée affirmation ───────────────────────────────────────────────────────

class _AffirmationTile extends StatefulWidget {
  final Affirmation affirmation;
  final VoidCallback onEdit;
  const _AffirmationTile({required this.affirmation, required this.onEdit});

  @override
  State<_AffirmationTile> createState() => _AffirmationTileState();
}

class _AffirmationTileState extends State<_AffirmationTile> {
  void _share(BuildContext context) {
    final themeData = context.read<CardThemeCubit>().state.data;
    showAffirmationShareSheet(
      context,
      text: widget.affirmation.text,
      themeData: themeData.isAdaptive ? null : themeData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.affirmation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade900.withValues(alpha: 0.4),
        child: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 20),
      ),
      onDismissed: (_) =>
          context.read<CustomAffirmationsCubit>().delete(widget.affirmation.id),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppStyle.hairline)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.affirmation.text,
                    style: AppStyle.display(size: 16).copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(widget.affirmation.createdAt),
                    style: AppStyle.overline,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: widget.onEdit,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppStyle.ink.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _share(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.ios_share_outlined,
                      size: 18,
                      color: AppStyle.ink.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    const weekdays = ['lun', 'mar', 'mer', 'jeu', 'ven', 'sam', 'dim'];
    const months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'août', 'sep', 'oct', 'nov', 'déc'];
    final day = weekdays[dt.weekday - 1];
    final month = months[dt.month - 1];
    return '$day. ${dt.day} $month';
  }
}

// ─── État vide ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppStyle.hairline),
            ),
            child: Icon(
              Icons.edit_note_rounded,
              size: 32,
              color: AppStyle.ink.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text('à toi d\'écrire.', style: AppStyle.display(size: 20)),
          const SizedBox(height: 8),
          const Text(
            'Crée ta première affirmation personnalisée.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppStyle.dim, height: 1.4),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: AppStyle.ink,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Text(
                'créer une affirmation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111110),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sheet création / édition ─────────────────────────────────────────────────

class _EditSheet extends StatefulWidget {
  final Affirmation? existing;
  const _EditSheet({this.existing});

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late final TextEditingController _controller;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.text ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _saving) return;
    setState(() => _saving = true);
    final cubit = context.read<CustomAffirmationsCubit>();
    if (_isEdit) {
      await cubit.update(widget.existing!.id, text);
    } else {
      await cubit.add(text);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _controller.text.trim().isNotEmpty;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161615),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(28, 20, 28, 28 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppStyle.ink.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            _isEdit ? 'modifier l\'affirmation' : 'nouvelle affirmation',
            style: AppStyle.display(size: 22),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            autofocus: true,
            maxLines: 4,
            minLines: 3,
            style: AppStyle.display(size: 18).copyWith(height: 1.5),
            cursorColor: AppStyle.ink,
            decoration: InputDecoration(
              hintText: 'écris ton affirmation…',
              hintStyle: AppStyle.displayItalic(size: 18)
                  .copyWith(color: AppStyle.dim.withValues(alpha: 0.6)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppStyle.hairline),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppStyle.ink.withValues(alpha: 0.5),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          const SizedBox(height: 28),

          GestureDetector(
            onTap: (canSave && !_saving) ? _save : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: canSave
                    ? AppStyle.ink
                    : AppStyle.ink.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(27),
              ),
              child: Center(
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF111110),
                        ),
                      )
                    : Text(
                        _isEdit ? 'enregistrer' : 'ajouter',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: canSave
                              ? const Color(0xFF111110)
                              : AppStyle.ink.withValues(alpha: 0.3),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
