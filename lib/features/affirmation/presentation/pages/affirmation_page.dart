import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_header.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/affirmation_card.dart';
import 'package:motivation_app/features/affirmation/presentation/widgets/revenue_bar.dart';
import 'package:motivation_app/config/routes/app_router.dart';

class AffirmationPage extends StatefulWidget {
  final String userName;

  const AffirmationPage({super.key, required this.userName});

  @override
  State<AffirmationPage> createState() => _AffirmationPageState();
}

class _AffirmationPageState extends State<AffirmationPage> {
  late PageController _pageController;
  final Set<int> _favorites = {};

  static const _affirmations = [
    (category: 'Mindset', text: 'Chaque obstacle est une opportunité déguisée en défi.'),
    (category: 'Action', text: 'L\'action d\'aujourd\'hui construit la liberté de demain.'),
    (category: 'Focus', text: 'Je concentre mon énergie sur ce qui compte vraiment.'),
    (category: 'Mindset', text: 'Mon succès est inévitable, je fais confiance au processus.'),
    (category: 'Action', text: 'Je prends une action concrète chaque jour vers mon objectif.'),
    (category: 'Mindset', text: 'Je suis capable de créer la vie que je désire.'),
    (category: 'Focus', text: 'Je reste ancré dans le moment présent et agis avec intention.'),
    (category: 'Action', text: 'Chaque petit pas compte, je n\'abandonne jamais.'),
    (category: 'Mindset', text: 'Je transforme mes peurs en carburant pour avancer.'),
    (category: 'Focus', text: 'Ma discipline d\'aujourd\'hui est ma liberté de demain.'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AffirmationHeader(userName: widget.userName),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _affirmations.length,
                onPageChanged: (_) {},
                itemBuilder: (context, index) {
                  final affirmation = _affirmations[index];
                  return AffirmationCard(
                    category: affirmation.category,
                    text: affirmation.text,
                    isFavorite: _favorites.contains(index),
                    onFavorite: () => setState(() {
                      if (_favorites.contains(index)) {
                        _favorites.remove(index);
                      } else {
                        _favorites.add(index);
                      }
                    }),
                    onShare: () {},
                  );
                },
              ),
            ),
            RevenueBar(
              currentRevenue: 0,
              targetRevenue: 1000,
              onTap: () => context.push(AppRouter.revenue),
            ),
          ],
        ),
      ),
    );
  }
}
