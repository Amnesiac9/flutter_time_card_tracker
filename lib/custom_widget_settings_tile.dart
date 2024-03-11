import 'package:flutter/material.dart';

enum SettingType {
  normal,
  toggle,
  dropdown,
}

class CustomSettingsTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    switch (settingType) {
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
      padding: padding,
      child: ListTile(
        leading: leadingIcon != null ? Icon(leadingIcon) : null,
        title: title,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget buildToggleTile() {
    return Padding(
      padding: padding,
      child: ListTile(
        leading: leadingIcon != null ? Icon(leadingIcon) : null,
        title: title,
        trailing: Switch(
          value: toggleValue,
          onChanged: onToggleChanged!,
        ),
      ),
    );
  }

  Widget buildDropdownTile() {
    return Padding(
      padding: padding,
      child: ListTile(
        leading: leadingIcon != null ? Icon(leadingIcon) : null,
        title: title,
        trailing: DropdownButton<String>(
          value: selectedDropdownOption,
          items: dropdownOptions!.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onDropdownChanged,
        ),
      ),
    );
  }
}
