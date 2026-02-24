import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/get_user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_user_profile.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final GetUserProfileUseCase getUserProfile;
  final SaveUserProfileUseCase saveUserProfile;

  OnboardingCubit({
    required this.getUserProfile,
    required this.saveUserProfile,
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

  Future<void> _save(UserProfile profile) async {
    emit(const OnboardingState.loading());
    final result = await saveUserProfile(profile);
    result.fold(
      (_) => emit(const OnboardingState.error('Impossible de sauvegarder')),
      (_) => emit(OnboardingState.dataSaved(profile)),
    );
  }

  Future<void> saveName(String name) =>
      _save(_currentProfile().copyWith(name: name));

  Future<void> saveObjectiveType(String objectiveType) =>
      _save(_currentProfile().copyWith(objectiveType: objectiveType));

  Future<void> saveStripeApiKey(String key) =>
      _save(_currentProfile().copyWith(stripeApiKey: key));

  Future<void> saveMrrTarget(String target) async {
    final profile = _currentProfile().copyWith(mrrTarget: target);
    final result = await saveUserProfile(profile);
    result.fold(
      (_) => emit(const OnboardingState.error("Impossible de sauvegarder l'objectif MRR")),
      (_) {
        emit(OnboardingState.dataSaved(profile));
        print('[OnboardingCubit] Onboarding terminé ! UserProfile: $profile');
      },
    );
  }
}
