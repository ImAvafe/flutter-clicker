import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:window_manager/window_manager.dart';

import 'theme/theme.dart';

void main() {
  setWindowSize();
  runApp(const Application());
}

void setWindowSize() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  int _interval = 100;

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
            initial: TextEditingValue(text: '100'),
            onChange: (value) {
              setState(() {
                _interval = int.tryParse(value.text) ?? 1;
              });
            },
          ),
        ),
      ],
    ),
  );
}
