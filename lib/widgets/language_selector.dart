import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/language_model.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({
    super.key,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final sp = AppConstants.spanish;
  final en = AppConstants.english;
  final fontWeight = FontWeight.w300;

  late List<DropdownMenuEntry> entries;

  @override
  void initState() {
    // Estilo para las opciones del dropdown
    final dropdownLabelStyle = TextStyle(
      color:  Color.fromRGBO(4, 134, 170, 1), // Color del texto de las opciones
      fontWeight: fontWeight,
      fontSize: AppConstants.appBarTextSize,
    );
    
    // Estilo para el selector principal (en la AppBar)
    final selectorLabelStyle = TextStyle(
      color: Colors.white, // Color blanco para el selector
      fontWeight: fontWeight,
      fontSize: AppConstants.appBarTextSize,
    );
    
    entries = [
      DropdownMenuEntry<String>(
        value: sp,
        label: sp,
        labelWidget: Text(
          sp,
          style: dropdownLabelStyle, // Usar el estilo del dropdown
        ),
      ),
      DropdownMenuEntry<String>(
        value: en,
        label: en,
        labelWidget: Text(
          en,
          style: dropdownLabelStyle, // Usar el estilo del dropdown
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = context.watch<LanguageModel>().currentLanguage;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 80.0,
        child: DropdownMenu(
          initialSelection: currentLanguage,
          dropdownMenuEntries: entries,
          hintText: currentLanguage,
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            labelStyle: const TextStyle(
              color: Colors.white, // Color blanco para el label
            ),
          ),
          textStyle: TextStyle(
            color: Colors.white, // Color blanco para el texto
            fontWeight: fontWeight,
          ),
          trailingIcon: Icon(
            Icons.arrow_drop_down_outlined,
            color:Color.fromRGBO(255, 255, 255, 1),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  // Color cuando está seleccionado
                  return AppConstants.primary.withOpacity(0.3);
                }
                // Color de fondo normal de las opciones
                return Colors.grey[100] ?? Colors.white; // Cambia este color
              },
            ),
          ),
          onSelected: (selected) => setLanguage(selected),
        ),
      ),
    );
  }

  void setLanguage(String selected) {
    context.read<LanguageModel>().changeLanguage(selected);
  }
}
