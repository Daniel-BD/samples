import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_template/src/custom_painting/brushes/brush_extensions.dart';

import '../custom_painting/brushes/brushes.dart';

@immutable
class BrushSettingsModel extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  BrushSettingsModel({
    required this.allBrushesMap,
    required this.favorites,
  });

  BrushSettingsModel.defaultSettings() {
    Map<BrushStyle, BrushSettings> defaultBrushes = {};
    for (final brushStyle in availableBrushes) {
      defaultBrushes[brushStyle] = brushStyle.defaultSettings;
    }
    allBrushesMap = defaultBrushes;
    favorites = [];
  }

  late final Map<BrushStyle, BrushSettings> allBrushesMap;
  late final List<BrushSettings> favorites;
  static const maxFavoriteBrushes = 20;

  BrushSettingsModel.fromJson(Map<String, dynamic> json) {
    List<BrushSettings> allBrushesTemp = [];
    Map<BrushStyle, BrushSettings> allBrushesTempMap = {};
    for (final brushStyle in availableBrushes) {
      allBrushesTempMap[brushStyle] = brushStyle.defaultSettings;
    }

    final allBrushesJSON = json["allBrushes"] as Iterable;

    for (final brushJSON in allBrushesJSON) {
      for (final brushStyle in availableBrushes) {
        if (brushStyle.name == brushJSON["style"]) {
          allBrushesTemp.add(
            brushStyle.brushFromJSON(brushJSON as Map<String, dynamic>),
          );
          allBrushesTempMap[brushStyle] = brushStyle.brushFromJSON(brushJSON);
        }
      }
    }

    allBrushesMap = allBrushesTempMap;

    List<BrushSettings> favoriteBrushesTemp = [];
    final favoriteBrushesJSON = json["favorites"] as Iterable;

    for (final brushJSON in favoriteBrushesJSON) {
      for (final brushStyle in availableBrushes) {
        if (brushStyle.name == brushJSON["style"]) {
          favoriteBrushesTemp
              .add(brushStyle.brushFromJSON(brushJSON as Map<String, dynamic>));
        }
      }
    }

    favorites = favoriteBrushesTemp;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> allBrushesJSON = [];
    List<Map<String, dynamic>> favoriteBrushesJSON = [];

    for (final brush in allBrushesMap.values) {
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
  List<Object?> get props => [allBrushesMap, favorites];
}
