import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../ui_components/ui_constants.dart';
import '../close_panel_button.dart';
import '../control_panel_controller.dart';
import '../pop_up_panel_decoration.dart';
import 'brush_preview.dart';
import 'brush_settings_controller.dart';

class BrushPanel extends StatelessWidget {
  const BrushPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
              child: PopUpPanelDecoration(
                child: Column(
                  children: [
                    const BrushPanelTopBar(),
                    Expanded(
                      child: PageView(
                        controller: context
                            .read<ControlPanelController>()
                            .brushPanelPageController,
                        children: const [
                          BrushPreviewList(
                              style: BrushPreviewListStyle.allBrushes),
                          BrushPreviewList(
                              style: BrushPreviewListStyle.favorites),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BrushPreviewListStyle { allBrushes, favorites }

class BrushPreviewList extends StatefulWidget {
  const BrushPreviewList({
    super.key,
    required this.style,
  });
  final BrushPreviewListStyle style;

  @override
  State<BrushPreviewList> createState() => _BrushPreviewListState();
}

class _BrushPreviewListState extends State<BrushPreviewList> {
  int? showSettingsIndex;
  final controller = ScrollController();
  double? scrollOffset;
  @override
  Widget build(BuildContext context) {
    final brushSettings = context.read<BrushSettingsController>();
    // final favLength =
    //     context.select<BrushSettingsController, int>((c) => c.favorites.length);
    final brushes = widget.style == BrushPreviewListStyle.allBrushes
        ? brushSettings.allBrushes
        : brushSettings.favorites;
    //Skip the eraser brush
    final brushesLength = widget.style == BrushPreviewListStyle.allBrushes
        ? brushes.length - 1
        : brushes.length;
    final isFavorite = widget.style == BrushPreviewListStyle.favorites;

    if (isFavorite && brushes.isEmpty) {
      return Center(
        child: Text(
          'No favorites added yet',
          style: GameTextStyles.standardTextStyle(
            media: MediaQuery.of(context),
          ),
        ),
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: showSettingsIndex == null,
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            bottom: showSettingsIndex != null ? 0 : 12,
          ),
          child: showSettingsIndex != null
              ? ConstrainedBox(
                  constraints: constraints,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: BrushPreview.settings(
                      brushStyle: brushes[showSettingsIndex!].brushStyle,
                      isFavorite: isFavorite,
                      favoriteIndex: isFavorite ? showSettingsIndex! : null,
                      onShowSettingsPressed: (showSettings) {
                        toggleSettings(null);
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      for (int i = 0; i < brushesLength; i += 2)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(),
                                  child: BrushPreview(
                                    brushStyle: brushes[i].brushStyle,
                                    isFavorite: isFavorite,
                                    favoriteIndex: isFavorite ? i : null,
                                    onShowSettingsPressed: (showSettings) {
                                      toggleSettings(showSettings ? i : null);
                                    },
                                  ),
                                ),
                              ),
                              if (i + 1 < brushesLength) ...[
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(),
                                    child: BrushPreview(
                                      brushStyle: brushes[i + 1].brushStyle,
                                      isFavorite: isFavorite,
                                      favoriteIndex: isFavorite ? i + 1 : null,
                                      onShowSettingsPressed: (showSettings) {
                                        toggleSettings(
                                            showSettings ? i + 1 : null);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              if (i + 1 >= brushesLength)
                                Expanded(
                                  child: SizedBox.shrink(),
                                )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  void toggleSettings(int? settingsIndex) {
    setState(() {
      showSettingsIndex = settingsIndex;
      if (settingsIndex != null && controller.positions.length == 1) {
        scrollOffset = controller.offset;
        controller.jumpTo(0);
      } else if (scrollOffset != null && controller.positions.isNotEmpty) {
        controller.jumpTo(scrollOffset!);
      }
    });
  }
}

class BrushPanelTopBar extends StatelessWidget {
  const BrushPanelTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        SizedBox.shrink(),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppConstants.smallVerticalSpacing,
          ),
          child: SectionPicker(),
        ),
        ClosePanelButton(),
      ],
    );
  }
}

class SectionPicker extends StatelessWidget {
  const SectionPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controlPanelSettings = context.watch<ControlPanelController>();

    return Theme(
      data: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.black,
              secondaryContainer: Color(0xFFE5F0FF), //Color(0xFFD6E5FF),
              onSurface: Color(0xFF849FC8),
              onSecondaryContainer: brushButtonTextColor, //Color(0xFF0F52B3),
            ),
      ),
      child: SegmentedButton<BrushPanelTab>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment<BrushPanelTab>(
            icon: null,
            value: BrushPanelTab.allBrushes,
            label: Text(BrushPanelTab.allBrushes.tabTitleString),
          ),
          ButtonSegment<BrushPanelTab>(
            icon: null,
            value: BrushPanelTab.favorites,
            label: Text(BrushPanelTab.favorites.tabTitleString),
          ),
        ],
        selected: <BrushPanelTab>{controlPanelSettings.activeBrushPanelTab},
        onSelectionChanged: (tabSet) {
          controlPanelSettings.activeBrushPanelTab = tabSet.first;
        },
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return GameTextStyles.brushPanelButtonTextStyle();
              }
              if (states.contains(MaterialState.selected)) {
                return GameTextStyles.brushPanelButtonTextStyle();
              }
              return GameTextStyles.brushPanelButtonTextStyle();
            },
          ),
          padding: MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 20),
          ),
          side: MaterialStatePropertyAll(
            BorderSide(
              color: panelDarkColor,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
    );
  }
}
