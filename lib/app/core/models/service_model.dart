
import 'package:programacao/app/core/services/firebase_service.dart';
import 'package:programacao/app/core/services/keyboard_visible_service.dart';

abstract class Service {
  Future<void> initialize();

  static bool isInitialized = false;

  static final List<Service> _applicationServices = [
    FirebaseService(),
    KeyboardVisibleService(),
    // DateService(),
    // SharedPreferencesService(),
    // LogManagerService(),
    // AdManagerService(),
  ];

  static Future<void> initAplicationServices() async {
    if (!isInitialized) {
      isInitialized = true;
      for (Service service in _applicationServices) {
        await service.initialize();
      }
    }
  }
}
