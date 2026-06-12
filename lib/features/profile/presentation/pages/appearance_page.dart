import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/theme/card_theme_cubit.dart';
import 'package:motivation_app/core/theme/card_visual_theme.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  ThemeCategory _filter = ThemeCategory.tous;

  static const _filterLabels = {
    ThemeCategory.tous: 'Tous',
    ThemeCategory.nature: 'Nature',
    ThemeCategory.urbain: 'Urbain',
    ThemeCategory.cosmos: 'Cosmos',
    ThemeCategory.sombre: 'Sombre',
    ThemeCategory.clair: 'Clair',
  };

  List<CardVisualTheme> get _filtered {
    final list = (_filter == ThemeCategory.tous
            ? CardVisualTheme.values
            : CardVisualTheme.values.where((t) => t.data.category == _filter))
        .toList();
    list.sort((a, b) {
      final aPhoto = a.data.assetImage != null ? 0 : 1;
      final bPhoto = b.data.assetImage != null ? 0 : 1;
      return aPhoto.compareTo(bPhoto);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final currentCardTheme = context.watch<CardThemeCubit>().state;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black, Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Apparence',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Filtres ─────────────────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  children: ThemeCategory.values.map((cat) {
                    final active = _filter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            _filterLabels[cat]!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Grille ──────────────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final theme = _filtered[index];
                    final data = theme.data;
                    final selected = currentCardTheme == theme;

                    return GestureDetector(
                      onTap: () => context.read<CardThemeCubit>().setTheme(theme),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? colors.primary : Colors.white.withValues(alpha: 0.1),
                            width: 2.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.5),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // ── Fond ─────────────────────────────────
                              if (data.isAdaptive)
                                Container(color: const Color(0xFF1C1C1E))
                              else if (data.assetImage != null) ...[
                                Image.asset(
                                  data.assetImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0x66000000),
                                        Color(0x22000000),
                                        Color(0x44000000),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 0.45, 1.0],
                                    ),
                                  ),
                                ),
                              ] else
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: data.gradientColors,
                                      begin: data.begin,
                                      end: data.end,
                                    ),
                                  ),
                                ),

                              // ── Contenu preview ──────────────────────
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: (data.isAdaptive
                                                ? Colors.white
                                                : data.textColor)
                                            .withValues(alpha: 0.55),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 3,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        color: (data.isAdaptive
                                                ? Colors.white
                                                : data.textColor)
                                            .withValues(alpha: 0.35),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _MiniButton(bg: data.buttonBg),
                                        const SizedBox(width: 6),
                                        _MiniButton(bg: data.buttonBg),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),

                              // ── Nom du thème ─────────────────────────
                              Positioned(
                                bottom: 7,
                                left: 0,
                                right: 0,
                                child: Text(
                                  data.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                    color: data.textColor.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),

                              // ── Checkmark ────────────────────────────
                              if (selected)
                                Positioned(
                                  top: 7,
                                  right: 7,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: colors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 11,
                                      color: colors.scaffold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final Color bg;
  const _MiniButton({required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    );
  }
}
