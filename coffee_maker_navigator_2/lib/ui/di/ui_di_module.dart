import 'package:coffee_maker_navigator_2/di/dependency_injection.dart';
import 'package:coffee_maker_navigator_2/domain/auth/auth_service.dart';
import 'package:coffee_maker_navigator_2/domain/onboarding/onboarding_service.dart';
import 'package:coffee_maker_navigator_2/ui/add_water/view_model/add_water_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/auth/view_model/auth_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';

class UiDiModule {
  static Future<void> setup() async {
    /// Auth
    DependencyInjection.bind<AuthScreenViewModel>(
      (i) => AuthScreenViewModel(authService: i.get()),
    );

    /// Add Water
    DependencyInjection.bind<AddWaterViewModel>(
      (i) => AddWaterViewModel(
        addWaterService: i.get(),
        ordersService: i.get(),
      ),
    );
  }
}
