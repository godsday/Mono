import 'package:flutter/material.dart';

import '../models/app_navigation_model.dart';

/// A provider class for the AppNavigationScreen.
///
/// This provider manages the state of the AppNavigationScreen, including the
/// current appNavigationModelObj
class AppNavigationProvider extends ChangeNotifier {
  AppNavigationModel _appNavigationModel = AppNavigationModel();

  AppNavigationModel get appNavigationModel => _appNavigationModel;

  /// Calls [notifyListeners] to update listeners.
  void _onInitialize() {}
}
