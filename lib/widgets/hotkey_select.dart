import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotkeySelect extends StatefulWidget {
  const HotkeySelect({
    super.key,
    required this.initialHotkey,
    required this.onChange,
  });

  final PhysicalKeyboardKey initialHotkey;
  final ValueChanged<PhysicalKeyboardKey> onChange;

  @override
  State<HotkeySelect> createState() => _HotkeySelectState();
}

class _HotkeySelectState extends State<HotkeySelect> {
  PhysicalKeyboardKey _hotkey = PhysicalKeyboardKey.f6;
  bool _listening = false;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      FTextField(
        label: const Text("Hotkey"),
        hint: "Record hotkey",
        readOnly: true,
        control: .lifted(
          value: TextEditingValue(text: _hotkey.debugName ?? "F6"),
          onChange: (_) {},
        ),
        onTap: () {
          setState(() {
            _listening = true;
          });
        },
        onTapOutside: (event) {
          setState(() {
            _listening = false;
          });
        },
      ),
      Opacity(
        opacity: 0,
        child: _listening
            ? HotKeyRecorder(
                initalHotKey: HotKey(key: _hotkey),
                onHotKeyRecorded: (hotkey) {
                  setState(() {
                    _hotkey = hotkey.physicalKey;
                  });
                  widget.onChange(_hotkey);
                },
              )
            : null,
      ),
    ],
  );
}
