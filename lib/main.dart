import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'clicker.dart';
import 'theme/theme.dart';

Clicker? clicker;

final ValueNotifier<int> intervalNotifier = ValueNotifier<int>(100);
final ValueNotifier<bool> clickingNotifier = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeWindow();
  initializeHotkey();

  runApp(const Application());
}

void initializeWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(400, 500),
    center: true,
    title: "Flutter Clicker",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

void initializeHotkey() async {
  await hotKeyManager.unregisterAll();

  HotKey hotkey = HotKey(
    key: PhysicalKeyboardKey.f6,
    modifiers: [],
    scope: HotKeyScope.system,
  );
  await hotKeyManager.register(
    hotkey,
    keyDownHandler: (hotkey) {
      toggleClicker();
    },
  );
}

void toggleClicker() {
  if (clicker != null) {
    clickingNotifier.value = false;
    clicker?.kill();
    clicker = null;
  } else {
    clickingNotifier.value = true;
    clicker = Clicker(intervalNotifier.value);
    clicker?.spawn();
  }
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    supportedLocales: FLocalizations.supportedLocales,
    localizationsDelegates: const [...FLocalizations.localizationsDelegates],
    theme: lightTheme.toApproximateMaterialTheme(),
    darkTheme: darkTheme.toApproximateMaterialTheme(),
    builder: (context, child) => FTheme(
      data: Theme.brightnessOf(context) == .light ? lightTheme : darkTheme,
      child: FToaster(child: FTooltipGroup(child: child!)),
    ),
    home: const FScaffold(child: Example()),
  );
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool _buttonDebounce = false;

  @override
  Widget build(BuildContext context) => Padding(
    padding: context.theme.style.pagePadding,
    child: Column(
      mainAxisSize: .min,
      spacing: 10,
      children: [
        FTextField(
          label: Text("Interval (ms)"),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          control: .managed(
            initial: TextEditingValue(text: intervalNotifier.value.toString()),
            onChange: (value) {
              intervalNotifier.value = int.tryParse(value.text) ?? 100;
            },
          ),
        ),
        FButton(
          onPress: !_buttonDebounce
              ? () async {
                  setState(() {
                    _buttonDebounce = true;
                  });
                  Future.delayed(Duration(seconds: 1)).then((_) {
                    setState(() {
                      _buttonDebounce = false;
                    });
                  });

                  toggleClicker();
                }
              : null,
          child: ValueListenableBuilder<bool>(
            valueListenable: clickingNotifier,
            builder: (BuildContext context, bool clicking, Widget? child) {
              return Text(!clickingNotifier.value ? "Start" : "Stop");
            },
          ),
        ),
      ],
    ),
  );
}
