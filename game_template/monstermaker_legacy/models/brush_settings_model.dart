import 'package:equatable/equatable.dart';
import 'package:monstermaker/custom_painting/brushes/brush_extensions.dart';
import 'package:monstermaker/custom_painting/brushes/brushes.dart';

class BrushSettingsModel extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  BrushSettingsModel({
    required this.allBrushes,
    required this.favorites,
  });

  BrushSettingsModel.defaultSettings() {
    List<BrushSettings> defaultBrushes = [];
    for (final brushStyle in availableBrushes) {
      defaultBrushes.add(brushStyle.defaultSettings);
    }
    allBrushes = defaultBrushes;
    favorites = [];
  }

  late final List<BrushSettings> allBrushes;
  late final List<BrushSettings> favorites;
  static const maxFavoriteBrushes = 20;

  BrushSettingsModel.fromJson(Map<String, dynamic> json) {
    List<BrushSettings> allBrushesTemp = [];
    final allBrushesJSON = json["allBrushes"];

    for (final brushJSON in allBrushesJSON) {
      for (final brushStyle in availableBrushes) {
        if (brushStyle.name == brushJSON["style"]) {
          allBrushesTemp.add(brushStyle.brushFromJSON(brushJSON));
        }
      }
    }

    allBrushes = allBrushesTemp;

    List<BrushSettings> favoriteBrushesTemp = [];
    final favoriteBrushesJSON = json["favorites"];

    for (final brushJSON in favoriteBrushesJSON) {
      for (final brushStyle in availableBrushes) {
        if (brushStyle.name == brushJSON["style"]) {
          favoriteBrushesTemp.add(brushStyle.brushFromJSON(brushJSON));
        }
      }
    }

    favorites = favoriteBrushesTemp;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> allBrushesJSON = [];
    List<Map<String, dynamic>> favoriteBrushesJSON = [];

    for (final brush in allBrushes) {
      allBrushesJSON.add(brush.toJson());
    }

    for (final brush in favorites) {
      favoriteBrushesJSON.add(brush.toJson());
    }

    return {
      "allBrushes": allBrushesJSON,
      "favorites": favoriteBrushesJSON,
    };
  }

  @override
  List<Object?> get props => [allBrushes, favorites];
}
