import 'package:coffee_maker_navigator_2/data/auth/local/auth_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/auth/repository/auth_repository.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/local/onboarding_local_data_source.dart';
import 'package:coffee_maker_navigator_2/data/onboarding/repository/onboarding_repository.dart';
import 'package:coffee_maker_navigator_2/di/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that manages app-level dependencies.
///
/// The `AppLevelDependencies` initializes and manages dependencies which are required for the
/// entire lifecycle of the application.
class AppLevelDependencyContainer extends AsyncDependencyContainer {
  late final SharedPreferences _sharedPreferences;

  late final OnboardingLocalDataSource _onboardingLocalDataSource;

  late final AuthLocalDataSource _authLocalDataSource;
  late final AuthRepository _authRepository;
  late final AuthService _authService;

  late final OnboardingRepository _onboardingRepository;
  late final OnboardingService _onboardingService;

  late final RouterViewModel _routerViewModel;

  RouterViewModel get routerViewModel => _routerViewModel;

  AppLevelDependencyContainer();

  @override
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initAuthDependencies();
    _initOnboardingDependencies();
    _initRouterViewModel();
  }

  @override
  void dispose() {
    routerViewModel.dispose();
  }

  void _initOnboardingDependencies() {
    _onboardingLocalDataSource =
        OnboardingLocalDataSource(sharedPreferences: _sharedPreferences);
    _onboardingRepository =
        OnboardingRepository(localDataSource: _onboardingLocalDataSource);
    _onboardingService =
        OnboardingService(tutorialRepository: _onboardingRepository);
  }

  void _initAuthDependencies() {
    _authLocalDataSource =
        AuthLocalDataSource(sharedPreferences: _sharedPreferences);
    _authRepository = AuthRepository(localAuthDataSource: _authLocalDataSource);
    _authService = AuthServiceImpl(authRepository: _authRepository)..onInit();
  }

  void _initRouterViewModel() {
    _routerViewModel = RouterViewModel(
      authService: _authService,
      onboardingService: _onboardingService,
      isUserLoggedIn: _authService.authStateListenable.value ?? false,
      isTutorialShown: _onboardingService.isTutorialShown(),
    );
  }
}
