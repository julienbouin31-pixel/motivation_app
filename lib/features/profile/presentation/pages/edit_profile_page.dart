import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late String _objectiveType;
  String? _mrrTarget;
  bool _saving = false;

  static const _targets = [
    (amount: '1K€', label: 'Premier palier'),
    (amount: '5K€', label: 'Quitter le CDI'),
    (amount: '10K€', label: 'Liberté financière'),
    (amount: '25K€', label: 'Scale mode'),
    (amount: '50K€+', label: 'Empire builder'),
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    final profile = switch (state) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    _nameController = TextEditingController(text: profile?.name ?? '');
    _objectiveType = profile?.objectiveType ?? 'none';
    _mrrTarget = profile?.mrrTarget;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final cubit = context.read<OnboardingCubit>();
    await cubit.saveName(name);
    await cubit.saveObjectiveType(_objectiveType);
    if (_objectiveType == 'mrr' && _mrrTarget != null) {
      await cubit.saveMrrTarget(_mrrTarget!);
    }
    if (mounted) {
      setState(() => _saving = false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _nameController.text.trim().isNotEmpty &&
        (_objectiveType != 'mrr' || _mrrTarget != null);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────────────────
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
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Modifier le profil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Contenu ──────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // ── Nom ──────────────────────────────────────────────────────
                  const _SectionLabel('NOM'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Ton prénom',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Objectif ──────────────────────────────────────────────────
                  const _SectionLabel('TYPE D\'OBJECTIF'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _ObjectiveRow(
                          icon: Icons.trending_up,
                          iconColor: const Color(0xFF4CAF50),
                          iconBg: const Color(0xFFE8F5E9),
                          title: 'Revenu (MRR)',
                          subtitle: 'Suivi du revenu mensuel récurrent',
                          selected: _objectiveType == 'mrr',
                          onTap: () => setState(() => _objectiveType = 'mrr'),
                        ),
                        Divider(height: 1, thickness: 1, indent: 58, color: Colors.grey[100]),
                        _ObjectiveRow(
                          icon: Icons.bar_chart,
                          iconColor: const Color(0xFF2196F3),
                          iconBg: const Color(0xFFE3F2FD),
                          title: 'Analytics',
                          subtitle: 'Métriques de visites & site',
                          selected: _objectiveType == 'analytics',
                          onTap: () => setState(() => _objectiveType = 'analytics'),
                        ),
                        Divider(height: 1, thickness: 1, indent: 58, color: Colors.grey[100]),
                        _ObjectiveRow(
                          icon: Icons.block,
                          iconColor: Colors.black54,
                          iconBg: Colors.grey[100]!,
                          title: 'Pas d\'objectif',
                          subtitle: 'Affirmations uniquement',
                          selected: _objectiveType == 'none',
                          onTap: () => setState(() => _objectiveType = 'none'),
                        ),
                      ],
                    ),
                  ),

                  // ── Cible MRR (conditionnel) ───────────────────────────────
                  if (_objectiveType == 'mrr') ...[
                    const SizedBox(height: 28),
                    const _SectionLabel('CIBLE MRR'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _targets.length; i++) ...[
                            _MrrTargetRow(
                              amount: _targets[i].amount,
                              label: _targets[i].label,
                              selected: _mrrTarget == _targets[i].amount,
                              onTap: () => setState(() => _mrrTarget = _targets[i].amount),
                            ),
                            if (i < _targets.length - 1)
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.grey[100],
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 36),

                  // ── Bouton Enregistrer ────────────────────────────────────
                  GestureDetector(
                    onTap: (canSave && !_saving) ? _save : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: canSave ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Enregistrer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: canSave ? Colors.white : Colors.grey[400],
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Composants ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey[400],
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ObjectiveRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ObjectiveRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.black : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MrrTargetRow extends StatelessWidget {
  final String amount;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MrrTargetRow({
    required this.amount,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(
              amount,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.black : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/mois',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: selected ? Colors.black : Colors.grey[400],
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.black : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
