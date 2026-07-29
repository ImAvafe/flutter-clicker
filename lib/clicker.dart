import 'package:nutdart/nutdart.dart' as nutdart;

class Clicker {
  int interval;

  bool _running = true;

  void spawn() async {
    while (_running) {
      nutdart.Mouse.click();
      await Future.delayed(Duration(milliseconds: interval));
    }
  }

  void kill() async {
    _running = false;
  }

  Clicker(this.interval);
}
