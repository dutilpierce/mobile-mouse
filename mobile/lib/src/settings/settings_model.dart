import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  double sensitivity = 1.0; // 0.5 - 2.0
  double scrollSpeed = 1.0; // 0.5 - 2.0
  bool haptics = true;

  bool gestureTap = true;
  bool gestureRightClick = true;
  bool gestureScroll = true;
  bool gesturePinchZoom = true; // UI only in MVP
  bool gestureThreeFinger = false; // UI only in MVP

  ThemeMode themeMode = ThemeMode.system;

  void setSensitivity(double v) { sensitivity = v; notifyListeners(); }
  void setScrollSpeed(double v) { scrollSpeed = v; notifyListeners(); }
  void setHaptics(bool v) { haptics = v; notifyListeners(); }

  void setThemeMode(ThemeMode v) { themeMode = v; notifyListeners(); }

  void toggleGestureTap(bool v) { gestureTap = v; notifyListeners(); }
  void toggleGestureRightClick(bool v) { gestureRightClick = v; notifyListeners(); }
  void toggleGestureScroll(bool v) { gestureScroll = v; notifyListeners(); }
  void toggleGesturePinch(bool v) { gesturePinchZoom = v; notifyListeners(); }
  void toggleGestureThreeFinger(bool v) { gestureThreeFinger = v; notifyListeners(); }
}
