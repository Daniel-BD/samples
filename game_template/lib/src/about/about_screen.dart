import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/theme/text_styles.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../ui_components/buttons.dart';
import '../ui_components/clouds_background_page.dart';
import '../ui_components/ui_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return CloudsBackgroundScreen(
      cloudPosition: CloudPosition.middle,
      topLeftButton: TopLeftButtonType.backButton,
      firstChild: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.textMaxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.smallVerticalSpacing,
            horizontal: AppConstants.horizontalEdgePadding,
          ),
          child: Center(
            child: AutoSizeText(
              'Thank you for playing MonsterMaker.\nIf you have any feedback, please send an email.\n\n'
              'This game is made by a single person, Daniel Duvanå, in my spare time.\n\n'
              'The best way you can support the game is by rating the app and spreading the word to your friends!',
              style: GameTextStyles.paragraphTextStyle(media: mediaQuery),
              minFontSize: GameTextStyles.fontSizeMin,
              maxFontSize: GameTextStyles.fontSizeMax,
            ),
          ),
        ),
      ),
      secondChild: Column(
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GameButton(
                  assetPath: 'assets/images/Privacy policy normal.png',
                  onPressed: () => context.go('/about/privacy_policy'),
                ),
                GameButton(
                  assetPath: 'assets/images/Licence info normal.png',
                  onPressed: () => context.go('/about/licence_information'),
                ),
                GameButton(
                  assetPath: 'assets/images/Rate app normal.png',
                  onPressed: () {
                    // final InAppReview inAppReview = InAppReview.instance;
                    // inAppReview.openStoreListing(appStoreId: '1512945753');
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: AppConstants.horizontalEdgePadding,
                  bottom: AppConstants.mediumVerticalSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: GameTextStyles.thinTextStyle(media: mediaQuery),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      color: dividerColor,
                      height: 2.0,
                      width: 60.0,
                    ),
                  ),
                  SelectableText(
                    'monstermaker@gmail.com',
                    style: GameTextStyles.boldTextStyle(media: mediaQuery),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AboutInfoScreenType {
  privacyPolicy,
  licenceInformation,
}

class PolicyAndLicenceScreen extends StatelessWidget {
  /// Whether this is supposed to show privacy policy or licence information.
  final AboutInfoScreenType aboutInfoScreen;
  const PolicyAndLicenceScreen({
    super.key,
    this.aboutInfoScreen = AboutInfoScreenType.privacyPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return CloudsBackgroundScreen(
      cloudPosition: CloudPosition.top,
      topLeftButton: TopLeftButtonType.backButton,
      firstChild: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.horizontalEdgePadding,
            right: AppConstants.horizontalEdgePadding,
            top: AppConstants.smallVerticalSpacing,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Text(aboutInfoScreen == AboutInfoScreenType.privacyPolicy
                  ? _privacyPolicy
                  : _licenceInformation),
            ),
          ),
        ),
      ),
    );
  }

  static const String _licenceInformation = "This is licence information.";

  static const String _privacyPolicy =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Gravida in fermentum et sollicitudin ac orci phasellus egestas tellus. Commodo sed egestas egestas fringilla phasellus faucibus scelerisque eleifend donec. Quam adipiscing vitae proin sagittis nisl rhoncus mattis. Amet commodo nulla facilisi nullam vehicula. Est velit egestas dui id ornare arcu. In fermentum posuere urna nec. Mollis nunc sed id semper risus in hendrerit. Risus commodo viverra maecenas accumsan lacus vel facilisis. Volutpat est velit egestas dui. Nullam ac tortor vitae purus faucibus ornare suspendisse sed nisi. Nunc pulvinar sapien et ligula ullamcorper malesuada proin libero. Quam id leo in vitae turpis. Aliquet nec ullamcorper sit amet. Fames ac turpis egestas sed tempus urna et. Neque ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Diam sollicitudin tempor id eu nisl nunc mi.\n\nSem et tortor consequat id porta nibh venenatis. Eu augue ut lectus arcu bibendum. Consequat id porta nibh venenatis cras sed felis eget. Viverra orci sagittis eu volutpat odio facilisis mauris sit. Tortor vitae purus faucibus ornare. Diam quis enim lobortis scelerisque fermentum dui. Senectus et netus et malesuada fames ac turpis egestas integer. Nulla pharetra diam sit amet nisl suscipit adipiscing. Erat imperdiet sed euismod nisi porta lorem mollis aliquam. Dui nunc mattis enim ut tellus elementum sagittis vitae et. Fames ac turpis egestas maecenas pharetra convallis posuere morbi leo. Et tortor at risus viverra adipiscing at in tellus. Congue quisque egestas diam in. Porttitor eget dolor morbi non arcu risus. Aliquet nibh praesent tristique magna sit amet purus. Et leo duis ut diam. Est lorem ipsum dolor sit.\n\nArcu ac tortor dignissim convallis aenean. Sit amet mattis vulputate enim nulla aliquet porttitor. Tellus elementum sagittis vitae et. Volutpat odio facilisis mauris sit amet massa. Ipsum dolor sit amet consectetur adipiscing elit. Aliquam etiam erat velit scelerisque in. Ipsum a arcu cursus vitae congue mauris rhoncus. Enim lobortis scelerisque fermentum dui faucibus in. Velit sed ullamcorper morbi tincidunt ornare massa. Eget nunc lobortis mattis aliquam faucibus purus. Felis eget velit aliquet sagittis id consectetur purus ut. Semper feugiat nibh sed pulvinar. Tortor consequat id porta nibh venenatis cras sed. Tellus cras adipiscing enim eu. Parturient montes nascetur ridiculus mus mauris vitae ultricies leo integer. Malesuada fames ac turpis egestas. Curabitur vitae nunc sed velit. Elementum tempus egestas sed sed risus pretium. Pulvinar mattis nunc sed blandit libero volutpat sed. Euismod elementum nisi quis eleifend quam adipiscing vitae proin sagittis.';
}
