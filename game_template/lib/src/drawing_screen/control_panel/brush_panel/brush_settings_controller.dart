import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_painting/brushes/brushes.dart';
import '../../../models/brush_settings_model.dart';

class BrushSettingsController extends ChangeNotifier {
  BrushSettingsController() {
    loadDataFromDisk();
  }

  BrushSettingsModel _brushSettings = BrushSettingsModel.defaultSettings();

  List<BrushSettings> get allBrushes =>
      _brushSettings.allBrushesMap.values.toList();
  List<BrushSettings> get favorites => _brushSettings.favorites;

  /// Returns true if successful
  bool addNewFavorite(BrushSettings newFavorite) {
    if (favorites.length < BrushSettingsModel.maxFavoriteBrushes) {
      var favCopy = favorites;
      favCopy.add(newFavorite);
      _brushSettings = BrushSettingsModel(
        allBrushesMap: _brushSettings.allBrushesMap,
        favorites: favCopy,
      );
      notifyListeners();
      _saveDataToDisk();
      return true;
    } else {
      return false;
    }
  }

  bool removeFavorite(int favoriteIndex) {
    if (favorites.length - 1 < favoriteIndex) {
      return false;
    } else {
      var favCopy = favorites;
      favCopy.removeAt(favoriteIndex);
      _brushSettings = BrushSettingsModel(
        allBrushesMap: _brushSettings.allBrushesMap,
        favorites: favCopy,
      );
      notifyListeners();
      _saveDataToDisk();
      return true;
    }
  }

  void updateBrushSettings(
    BrushSettings newSettings, {
    bool isFavorite = false,
    int? favoriteIndex,
  }) {
    final bool validArguments = !(isFavorite && favoriteIndex == null) &&
        !(favoriteIndex != null &&
            (favoriteIndex < 0 ||
                favoriteIndex >= BrushSettingsModel.maxFavoriteBrushes));
    final bool validStyle = availableBrushes.contains(newSettings.brushStyle);
    assert(validArguments, "Invalid arguments");
    assert(validStyle, "Invalid BrushStyle");
    if (!validArguments || !validStyle) {
      return;
    }

    if (!isFavorite) {
      var updatedAllBrushes = _brushSettings.allBrushesMap;
      if (!updatedAllBrushes.containsKey(newSettings.brushStyle)) return;
      updatedAllBrushes[newSettings.brushStyle] = newSettings;
      _brushSettings = BrushSettingsModel(
        allBrushesMap: updatedAllBrushes,
        favorites: favorites,
      );
      notifyListeners();
      _saveDataToDisk();
    } else {
      if (favoriteIndex != null &&
          favorites.length - 1 <= favoriteIndex &&
          favoriteIndex >= 0 &&
          favorites[favoriteIndex].brushStyle == newSettings.brushStyle) {
        var updatedFavorites = favorites;
        updatedFavorites[favoriteIndex] = newSettings;
        _brushSettings = BrushSettingsModel(
          allBrushesMap: _brushSettings.allBrushesMap,
          favorites: updatedFavorites,
        );
        notifyListeners();
        _saveDataToDisk();
      }
    }
  }

  Future<void> defaultSettings() async {
    _brushSettings = BrushSettingsModel.defaultSettings();
    await _saveDataToDisk();
    notifyListeners();
  }

  Future<void> _saveDataToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('brushSettings', jsonEncode(_brushSettings.toJson()));
  }

  Future<void> loadDataFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('brushSettings');
    if (json != null) {
      _brushSettings =
          BrushSettingsModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
      notifyListeners();
    }
  }
}
