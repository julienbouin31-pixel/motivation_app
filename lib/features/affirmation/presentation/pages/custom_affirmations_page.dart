import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation.dart';
import 'package:motivation_app/features/affirmation/domain/entities/affirmation_category.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/custom_affirmations_cubit.dart';
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
            // ─── Header ──────────────────────────────────────────────────────
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
                    onTap: () => _showCreateSheet(context),
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

            // ─── Contenu ─────────────────────────────────────────────────────
            Expanded(
              child: affirmations.isEmpty
                  ? _EmptyState(onTap: () => _showCreateSheet(context))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: affirmations.length,
                      separatorBuilder: (context, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final a = affirmations[index];
                        return _AffirmationTile(affirmation: a);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CustomAffirmationsCubit>(),
        child: const _CreateSheet(),
      ),
    );
  }
}

// ─── Tuile affirmation ────────────────────────────────────────────────────────

class _AffirmationTile extends StatelessWidget {
  final Affirmation affirmation;
  const _AffirmationTile({required this.affirmation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Dismissible(
      key: ValueKey(affirmation.id),
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
          context.read<CustomAffirmationsCubit>().delete(affirmation.id),
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
                    affirmation.text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      affirmation.category.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _confirmDelete(context, affirmation),
              child: Icon(Icons.delete_outline, size: 18, color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Affirmation affirmation) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).extension<AppColors>()!;
        return AlertDialog(
          backgroundColor: colors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Supprimer',
            style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Supprimer cette affirmation ?',
            style: TextStyle(color: colors.secondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Annuler', style: TextStyle(color: colors.secondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<CustomAffirmationsCubit>().delete(affirmation.id);
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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

// ─── Sheet de création ────────────────────────────────────────────────────────

class _CreateSheet extends StatefulWidget {
  const _CreateSheet();

  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _saving) return;
    setState(() => _saving = true);
    await context.read<CustomAffirmationsCubit>().add(text);
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
          // ── Poignée ──────────────────────────────────────────────────────
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
            'Nouvelle affirmation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.primary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),

          // ── Champ texte ───────────────────────────────────────────────────
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

          // ── Bouton sauvegarder ────────────────────────────────────────────
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
                        'Ajouter',
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
