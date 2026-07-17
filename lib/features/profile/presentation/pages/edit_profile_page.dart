import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  bool _saving = false;

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
    await context.read<OnboardingCubit>().saveName(name);

    if (!mounted) return;
    setState(() => _saving = false);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _nameController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────────────────────────
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
                  Text('ton profil', style: AppStyle.display(size: 30)),
                ],
              ),
            ),

            // ─── Contenu ─────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                children: [
                  const Text('prénom', style: AppStyle.overline),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    textCapitalization: TextCapitalization.words,
                    cursorColor: AppStyle.ink,
                    style: AppStyle.display(size: 26),
                    decoration: InputDecoration(
                      hintText: 'ton prénom',
                      hintStyle: AppStyle.displayItalic(size: 26)
                          .copyWith(color: AppStyle.dim.withValues(alpha: 0.5)),
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppStyle.hairline),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppStyle.ink.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 44),

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
                                'enregistrer',
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
            ),
          ],
        ),
      ),
    );
  }
}
