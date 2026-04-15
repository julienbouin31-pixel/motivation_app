import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_cubit.dart';
import 'package:motivation_app/features/goal/presentation/bloc/goal_state.dart';
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
  late String _initialObjectiveType;
  late String? _initialStripeKey;
  String? _mrrTarget;
  bool _saving = false;

  static const _mrrTargets = [
    (amount: '1K€', label: 'Premier palier', value: 1000.0),
    (amount: '5K€', label: 'Quitter le CDI', value: 5000.0),
    (amount: '10K€', label: 'Liberté financière', value: 10000.0),
    (amount: '25K€', label: 'Scale mode', value: 25000.0),
    (amount: '50K€+', label: 'Empire builder', value: 50000.0),
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
    _initialObjectiveType = _objectiveType;
    _initialStripeKey = profile?.stripeApiKey;
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


    if (!mounted) return;
    setState(() => _saving = false);

    // Re-fetch les données goal avec le nouveau profil
    final updatedState = context.read<OnboardingCubit>().state;
    final updatedProfile = switch (updatedState) {
      OnboardingDataSaved(:final profile) => profile,
      OnboardingProfileLoaded(:final profile) => profile,
      _ => null,
    };
    context.read<GoalCubit>().fetchGoal(updatedProfile);

    final switchedToMrr =
        _objectiveType == 'mrr' && _initialObjectiveType != 'mrr';
    final needsStripe = _initialStripeKey == null;

    if (switchedToMrr && needsStripe) {
      context.pop();
      context.push(AppRouter.onboardingStripe);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final canSave = _nameController.text.trim().isNotEmpty &&
        (_objectiveType != 'mrr' || _mrrTarget != null) &&
        (_objectiveType != 'mrr' || _mrrTarget != null);

    final goalState = context.watch<GoalCubit>().state;
    final goalCurrent = switch (goalState) {
      GoalLoaded(:final data) => data.current,
      _ => 0.0,
    };

    return Scaffold(
      backgroundColor: colors.scaffold,
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
                        color: colors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Modifier le profil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
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
                  _SectionLabel('NOM'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(fontSize: 15, color: colors.primary),
                        decoration: InputDecoration(
                          hintText: 'Ton prénom',
                          hintStyle: TextStyle(color: colors.secondary, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Objectif ──────────────────────────────────────────────────
                  _SectionLabel('TYPE D\'OBJECTIF'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.card,
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
                        Divider(height: 1, thickness: 1, indent: 58, color: colors.border),
                        _ObjectiveRow(
                          icon: Icons.block,
                          iconColor: Colors.black54,
                          iconBg: colors.surface,
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
                    _SectionLabel('CIBLE MRR'),
                    const SizedBox(height: 8),
                    _TargetList(
                      targets: _mrrTargets,
                      selected: _mrrTarget,
                      currentValue: goalCurrent,
                      onSelect: (v) => setState(() => _mrrTarget = v),
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
                                'Enregistrer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: canSave ? colors.scaffold : colors.secondary,
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
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.secondary,
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
    final colors = Theme.of(context).extension<AppColors>()!;
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: colors.secondary),
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
                color: selected ? colors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? colors.primary : colors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? Icon(Icons.check, size: 12, color: colors.scaffold)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetList extends StatelessWidget {
  final List<({String amount, String label, double value})> targets;
  final String? selected;
  final double? currentValue;
  final ValueChanged<String> onSelect;

  const _TargetList({
    required this.targets,
    required this.selected,
    required this.onSelect,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < targets.length; i++) ...[
            _TargetRow(
              amount: targets[i].amount,
              label: targets[i].label,
              selected: selected == targets[i].amount,
              achieved: currentValue != null && targets[i].value <= currentValue!,
              onTap: () {
                if (currentValue == null || targets[i].value > currentValue!) {
                  onSelect(targets[i].amount);
                }
              },
            ),
            if (i < targets.length - 1)
              Divider(height: 1, thickness: 1, indent: 20, endIndent: 20, color: Colors.grey[100]),
          ],
        ],
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  final String amount;
  final String label;
  final bool selected;
  final bool achieved;
  final VoidCallback onTap;

  const _TargetRow({
    required this.amount,
    required this.label,
    required this.selected,
    required this.onTap,
    this.achieved = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
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
                color: achieved ? colors.border : colors.primary,
              ),
            ),
            const Spacer(),
            if (achieved)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Atteint ✓',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else ...[
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: selected ? colors.primary : colors.secondary,
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
                  color: selected ? colors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? colors.primary : colors.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check, size: 12, color: colors.scaffold)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
