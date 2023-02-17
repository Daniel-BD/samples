import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum ControlPanelState { none, eraserSettings, brushSettings, otherSettings }

enum BrushPanelTab { allBrushes, favorites }

extension TabNames on BrushPanelTab {
  String get tabTitleString {
    switch (this) {
      case BrushPanelTab.allBrushes:
        return 'All Brushes';
      case BrushPanelTab.favorites:
        return 'Favorites';
    }
  }

  int get pageNumber {
    switch (this) {
      case BrushPanelTab.allBrushes:
        return 0;
      case BrushPanelTab.favorites:
        return 1;
    }
  }

  static BrushPanelTab fromPageNumber(int page) {
    switch (page) {
      case 0:
        return BrushPanelTab.allBrushes;
      case 1:
        return BrushPanelTab.favorites;
      default:
        return BrushPanelTab.allBrushes;
    }
  }
}

class ControlPanelController extends GetxController {
  ControlPanelController() {
    brushPanelPageController = PageController();
    brushPanelPageController.addListener(() {
      final page = brushPanelPageController.page?.round();
      if (page != null && page != _activeBrushPanelTab.pageNumber) {
        _activeBrushPanelTab = TabNames.fromPageNumber(page);
        update();
      }
    });
  }

  late final PageController brushPanelPageController;

  var _showingPanel = true;
  bool get showingPanel => _showingPanel;
  set showingPanel(bool value) {
    _showingPanel = value;
    update();
  }

  var _panelState = ControlPanelState.none;
  ControlPanelState get panelState => _panelState;
  set panelState(ControlPanelState value) {
    _panelState = value;
    update();
  }

  var _activeBrushPanelTab = BrushPanelTab.allBrushes;
  BrushPanelTab get activeBrushPanelTab => _activeBrushPanelTab;
  set activeBrushPanelTab(BrushPanelTab value) {
    _activeBrushPanelTab = value;
    brushPanelPageController.animateToPage(
      value.pageNumber,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
    update();
  }
}
