import 'package:flutter/material.dart';

enum SettingType {
  normal,
  toggle,
  dropdown,
}

class CustomSettingsTile extends StatefulWidget {
  final Widget title;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final SettingType settingType;
  final List<String>? dropdownOptions;
  final String? selectedDropdownOption;
  final ValueChanged<String?>? onDropdownChanged;
  final bool toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const CustomSettingsTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.settingType = SettingType.normal,
    this.dropdownOptions,
    this.selectedDropdownOption,
    this.onDropdownChanged,
    this.toggleValue = false,
    this.onToggleChanged,
  });

  @override
  _CustomSettingsTileState createState() => _CustomSettingsTileState();
}

class _CustomSettingsTileState extends State<CustomSettingsTile> {
  late bool _toggleValue;

  @override
  void initState() {
    super.initState();
    _toggleValue = widget.toggleValue;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.settingType) {
      case SettingType.normal:
        return buildNormalTile();
      case SettingType.toggle:
        return buildToggleTile();
      case SettingType.dropdown:
        return buildDropdownTile();
    }
  }

  Widget buildNormalTile() {
    return Padding(
      padding: widget.padding,
      child: ListTile(
        leading: widget.leadingIcon != null ? Icon(widget.leadingIcon) : null,
        title: widget.title,
        trailing: widget.trailing,
        onTap: widget.onTap,
      ),
    );
  }

  Widget buildToggleTile() {
    return Padding(
      padding: widget.padding,
      child: ListTile(
        leading: widget.leadingIcon != null ? Icon(widget.leadingIcon) : null,
        title: widget.title,
        trailing: Switch(
          value: _toggleValue,
          onChanged: (newValue) {
            setState(() {
              _toggleValue = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget buildDropdownTile() {
    return Padding(
      padding: widget.padding,
      child: ListTile(
        leading: widget.leadingIcon != null ? Icon(widget.leadingIcon) : null,
        title: widget.title,
        trailing: DropdownButton<String>(
          value: widget.selectedDropdownOption,
          items: widget.dropdownOptions!.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onDropdownChanged,
        ),
      ),
    );
  }
}
