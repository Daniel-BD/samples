import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monstermaker/custom_painting/brushes/brushes.dart';
import 'package:monstermaker/models/brush_settings_model.dart';

class BrushSettingsController extends GetxController {
  BrushSettingsController() {
    loadDataFromDisk();
  }

  BrushSettingsModel _brushSettings = BrushSettingsModel.defaultSettings();

  List<BrushSettings> get allBrushes => _brushSettings.allBrushes;
  List<BrushSettings> get favorites => _brushSettings.favorites;

  /// Returns true if successful
  bool addNewFavorite(BrushSettings newFavorite) {
    if (favorites.length < BrushSettingsModel.maxFavoriteBrushes) {
      var favCopy = favorites;
      favCopy.add(newFavorite);
      _brushSettings =
          BrushSettingsModel(allBrushes: allBrushes, favorites: favCopy);
      update();
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
      _brushSettings =
          BrushSettingsModel(allBrushes: allBrushes, favorites: favCopy);
      update();
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
      var allCopy = allBrushes;
      final index = allCopy.indexWhere(
          (element) => element.brushStyle == newSettings.brushStyle);
      allCopy[index] = newSettings;
      _brushSettings =
          BrushSettingsModel(allBrushes: allCopy, favorites: favorites);
      update();
      _saveDataToDisk();
    } else {
      if (favoriteIndex != null &&
          favorites.length - 1 <= favoriteIndex &&
          favoriteIndex >= 0 &&
          favorites[favoriteIndex].brushStyle == newSettings.brushStyle) {
        var favoritesCopy = favorites;
        favoritesCopy[favoriteIndex] = newSettings;
        _brushSettings = BrushSettingsModel(
            allBrushes: allBrushes, favorites: favoritesCopy);
        update();
        _saveDataToDisk();
      }
    }
  }

  void defaultSettings() async {
    _brushSettings = BrushSettingsModel.defaultSettings();
    _saveDataToDisk();
    update();
  }

  void _saveDataToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('brushSettings', jsonEncode(_brushSettings.toJson()));
  }

  void loadDataFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('brushSettings');
    if (json != null) {
      _brushSettings = BrushSettingsModel.fromJson(jsonDecode(json));
      update();
    }
  }
}
