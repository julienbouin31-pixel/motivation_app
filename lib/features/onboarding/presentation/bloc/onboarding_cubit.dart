import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/get_user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_mrr_target.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_objective_type.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_stripe_api_key.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_user_name.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final GetUserProfileUseCase getUserProfile;
  final SaveUserNameUseCase saveUserName;
  final SaveObjectiveTypeUseCase saveObjectiveType;
  final SaveStripeApiKeyUseCase saveStripeApiKey;
  final SaveMrrTargetUseCase saveMrrTarget;

  OnboardingCubit({
    required this.getUserProfile,
    required this.saveUserName,
    required this.saveObjectiveType,
    required this.saveStripeApiKey,
    required this.saveMrrTarget,
  }) : super(const OnboardingState.initial());

  UserProfile _currentProfile() {
    return switch (state) {
      OnboardingProfileLoaded(:final profile) => profile,
      OnboardingDataSaved(:final profile) => profile,
      _ => const UserProfile(),
    };
  }

  Future<void> loadUserProfile() async {
    emit(const OnboardingState.loading());
    final result = await getUserProfile();
    result.fold(
      (_) => emit(const OnboardingState.error('Impossible de charger le profil')),
      (profile) => emit(OnboardingState.profileLoaded(profile)),
    );
  }

  Future<void> saveUserNameAction(String name) async {
    final result = await saveUserName(name);
    result.fold(
      (_) => emit(const OnboardingState.error('Impossible de sauvegarder le prénom')),
      (_) => emit(OnboardingState.dataSaved(_currentProfile().copyWith(name: name))),
    );
  }

  Future<void> saveObjectiveTypeAction(String objectiveType) async {
    final result = await saveObjectiveType(objectiveType);
    result.fold(
      (_) => emit(const OnboardingState.error("Impossible de sauvegarder l'objectif")),
      (_) => emit(OnboardingState.dataSaved(
        _currentProfile().copyWith(objectiveType: objectiveType),
      )),
    );
  }

  Future<void> saveStripeApiKeyAction(String key) async {
    final result = await saveStripeApiKey(key);
    result.fold(
      (_) => emit(const OnboardingState.error('Impossible de sauvegarder la clé Stripe')),
      (_) => emit(OnboardingState.dataSaved(_currentProfile().copyWith(stripeApiKey: key))),
    );
  }

  Future<void> saveMrrTargetAction(String target) async {
    final result = await saveMrrTarget(target);
    result.fold(
      (_) => emit(const OnboardingState.error("Impossible de sauvegarder l'objectif MRR")),
      (_) {
        final profile = _currentProfile().copyWith(mrrTarget: target);
        emit(OnboardingState.dataSaved(profile));
        print('[OnboardingCubit] Onboarding terminé ! UserProfile: $profile');
      },
    );
  }
}
