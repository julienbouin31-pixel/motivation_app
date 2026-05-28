import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
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
    final colors = Theme.of(context).extension<AppColors>()!;
    final affirmations = context.watch<CustomAffirmationsCubit>().state;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes affirmations',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                        if (affirmations.isNotEmpty)
                          Text(
                            '${affirmations.length} créée${affirmations.length > 1 ? 's' : ''}',
                            style: TextStyle(fontSize: 12, color: colors.secondary),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showEditSheet(context, null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 16, color: colors.scaffold),
                          const SizedBox(width: 4),
                          Text(
                            'Créer',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.scaffold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: affirmations.isEmpty
                  ? _EmptyState(onTap: () => _showEditSheet(context, null))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: affirmations.length,
                      separatorBuilder: (context, _) => const SizedBox(height: 10),
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

// ─── Tuile affirmation ────────────────────────────────────────────────────────

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
    final colors = Theme.of(context).extension<AppColors>()!;

    return Dismissible(
      key: ValueKey(widget.affirmation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade800,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
      ),
      onDismissed: (_) =>
          context.read<CustomAffirmationsCubit>().delete(widget.affirmation.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.affirmation.text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(widget.affirmation.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: widget.onEdit,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.edit_outlined, size: 18, color: colors.secondary),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _share(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.ios_share_outlined, size: 18, color: colors.secondary),
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
    const weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'août', 'sep', 'oct', 'nov', 'déc'];
    final day = weekdays[dt.weekday - 1];
    final month = months[dt.month - 1];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$day. ${dt.day} $month · $h:$m';
  }
}

// ─── État vide ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_note_rounded, size: 34, color: colors.secondary),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune affirmation',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Crée ta première affirmation\npersonnalisée.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: colors.secondary, height: 1.4),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Créer une affirmation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.scaffold,
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
    final colors = Theme.of(context).extension<AppColors>()!;
    final canSave = _controller.text.trim().isNotEmpty;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.scaffold,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            _isEdit ? 'Modifier l\'affirmation' : 'Nouvelle affirmation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.primary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              autofocus: true,
              maxLines: 4,
              minLines: 3,
              style: TextStyle(
                fontSize: 15,
                color: colors.primary,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Écris ton affirmation…',
                hintStyle: TextStyle(color: colors.secondary, fontSize: 15),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: (canSave && !_saving) ? _save : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: canSave ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: _saving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.scaffold,
                        ),
                      )
                    : Text(
                        _isEdit ? 'Enregistrer' : 'Ajouter',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: canSave ? colors.scaffold : colors.secondary,
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
