import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/config/routes/app_router.dart';
import 'package:motivation_app/config/themes/app_style.dart';
import 'package:motivation_app/config/themes/app_theme.dart';
import 'package:motivation_app/core/purchases/premium_content.dart';
import 'package:motivation_app/core/purchases/subscription_cubit.dart';
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
    final isPremium = context.watch<SubscriptionCubit>().state;

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 16),
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
                    Text('apparence', style: AppStyle.display(size: 30)),
                  ],
                ),
              ),

              // ─── Filtres ─────────────────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
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
                            color: active ? AppStyle.ink : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? AppStyle.ink : AppStyle.hairline,
                            ),
                          ),
                          child: Text(
                            _filterLabels[cat]!.toLowerCase(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? const Color(0xFF111110)
                                  : AppStyle.ink.withValues(alpha: 0.55),
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
                    final locked = PremiumContent.themeLocked(theme, isPremium);
                    final selected = currentCardTheme == theme;

                    return GestureDetector(
                      onTap: locked
                          ? () => context.push(AppRouter.paywall)
                          : () => context.read<CardThemeCubit>().setTheme(theme),
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

                              // ── Verrou premium ───────────────────────
                              if (locked)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.45),
                                    child: Center(
                                      child: Icon(
                                        Icons.lock_outline,
                                        size: 18,
                                        color:
                                            Colors.white.withValues(alpha: 0.85),
                                      ),
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
