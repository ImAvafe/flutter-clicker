import 'package:nutdart/nutdart.dart';

class Clicker {
  int interval;
  MouseButton mouseButton;

  bool _running = true;

  void spawn() async {
    while (_running) {
      Mouse.click(mouseButton);
      await Future.delayed(Duration(milliseconds: interval));
    }
  }

  void kill() async {
    _running = false;
  }

  Clicker(this.interval, this.mouseButton);
}
