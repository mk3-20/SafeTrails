import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'global_data.dart';

// HOW TO USE *mk_theme_provider.dart* FILE:
// 1. Make a Global Data file in your current project's lib folder
// 2. Add values to enum MkTheme: light, dark, gray... etc
// 3. Add values to enum MkColor: red, blue, navbar, themeLight, themeDark ... etc
// 4. Make Maps of type Map< MkColor, Color > and add those as values in *themesMap* : MkTheme.light : GlobalData.lightTheme
// 5. Make a variable to track theme index in your Global Data file: int lastThemeIndex = 0;
// 6. Use Getters, Setters and Watchers to set colours wherever needed.
// 7. Initialize Provider in main(): refer tips_and_tricks.txt



enum MkTheme { light } // Enter all your themes
enum MkColor{ contrast, theme, navBar, statusBar} // Enter color attributes each theme will have

Map<MkTheme,Map<MkColor,Color>> themesMap = {
  MkTheme.light : GlobalData.lightTheme,
  // MkTheme.dark : GlobalData.darkTheme,
  // MkTheme.light : GlobalData.lightTheme,
  // MkTheme.android : GlobalData.androidTheme,
}; // A map of all themes

// Make more maps if you've more than MkColor enum

class MkThemeProvider with ChangeNotifier{
  int _currentIndexOfTheme  = GlobalData.lastThemeIndex;
  late MkTheme _currentTheme = themesMap.keys.toList()[_currentIndexOfTheme];

  MkTheme get currentTheme => _currentTheme;

  Map<MkColor, Color> get colorMap => _colorMap;

  late final Map<MkColor, Color> _colorMap = { for (MkColor k in MkColor.values) k : Getters.getColorFromTheme(_currentTheme, k) };

  Color getColor(MkColor colorIndex) {
    return _colorMap[colorIndex] ?? Colors.yellowAccent;
  }

  void setColor(MkColor colorIndex, Color color){
    _colorMap[colorIndex] = color;
    notifyListeners();
  }

  void _setTheme(MkTheme themeIndex, {bool setCurrentIndexOfTheme = true}){
    Map<MkColor,Color> themeMap = themesMap[themeIndex]!;
    for (MkColor k in themeMap.keys){
      _colorMap[k] = themeMap[k]!;
    }
    if (setCurrentIndexOfTheme){
      _currentIndexOfTheme = themesMap.keys.toList().indexOf(themeIndex);
    }
    _currentTheme=themeIndex;
    GlobalData.lastThemeIndex = _currentIndexOfTheme;
    notifyListeners();
  }

  void _setNextTheme(){
    if(_currentIndexOfTheme==(themesMap.length-1)){_currentIndexOfTheme=-1;}
    _setTheme(themesMap.keys.toList()[++_currentIndexOfTheme],setCurrentIndexOfTheme: false);
  }
} // Main Color/Theme provider

class Getters{
  // GETTERS -> Get colour on demand
  static Color getColorFromTheme(MkTheme themeIndex,MkColor colorIndex) => themesMap[themeIndex]![colorIndex]!;
  static Map<MkColor, Color> getCurrentColorMap(BuildContext context) => context.read<MkThemeProvider>().colorMap; // get Current Color Map
}

class Setters{
  // SETTERS -> Set color on demand
  static void setTheme(BuildContext context,MkTheme themeIndex) => context.read<MkThemeProvider>()._setTheme(themeIndex);
  static void setColorInCurrentTheme(BuildContext context,MkColor colorIndex, Color color)=> context.read<MkThemeProvider>().setColor(colorIndex, color); // set Current Theme Color
  static void setNextTheme(BuildContext context) => context.read<MkThemeProvider>()._setNextTheme();
}

class Watchers{
  // WATCHERS -> Watch for color changes and dynamically set them
  static Color gcfct(BuildContext context,MkColor colorIndex, {bool listen = true}) => Provider.of<MkThemeProvider>(context, listen: listen).getColor(colorIndex); // get a Color from Current Theme
  static MkTheme gct(BuildContext context, {bool listen = true}) => Provider.of<MkThemeProvider>(context, listen: listen).currentTheme; // get Current Theme
}

