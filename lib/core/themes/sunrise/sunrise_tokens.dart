import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// The family every Sunrise style is set in (bundled, see pubspec).
const String kSunriseFont = 'Lexend';

/// Corner radii (dp).
abstract final class SunriseRadius {
  static const double chip = 999;
  static const double iconTileSm = 11;
  static const double iconTile = 12;
  static const double iconTileLg = 14;
  static const double input = 14;
  static const double segmented = 14;
  static const double segmentedItem = 11;
  static const double category = 18;
  static const double button = 18;
  static const double card = 22;
  static const double hero = 26;
  static const double heroBig = 28;
  static const double sheet = 32;

  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius inputAll = BorderRadius.all(Radius.circular(input));
  static const BorderRadius buttonAll = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
}

/// Spacing (dp).
///
/// Sized for a 360dp phone, the narrowest common width. The page gutter and a
/// card's own padding both come out of the same few hundred points, and at 20
/// and 16 they took a fifth of the screen between them: account names, plan
/// names and subtitles were cut off on exactly the phones most people have.
abstract final class SunriseSpace {
  static const double screenX = 14;
  static const double screenTop = 10;
  static const double section = 18;
  static const double sectionTight = 14;
  static const double card = 14;
  static const double hero = 16;
  static const double rowY = 10;
  static const double rowYSettings = 12;
  static const double gap = 12;

  /// Bottom padding a scrollable needs to clear the floating tab bar.
  static const double tabBarClearance = 110;

  /// Widest a phone-shaped column grows on tablets.
  static const double maxContentWidth = 600;
}

/// Durations and curves.
abstract final class SunriseMotion {
  static const Duration press = Duration(milliseconds: 120);
  static const Duration tab = Duration(milliseconds: 220);
  static const Duration accordion = Duration(milliseconds: 200);
  static const Duration modal = Duration(milliseconds: 300);
  static const Duration theme = Duration(milliseconds: 300);
  static const Duration chart = Duration(milliseconds: 400);
  static const Duration chartStagger = Duration(milliseconds: 30);

  static const Curve emphasized = Cubic(0.2, 0, 0, 1);
  static const Curve standard = Curves.easeOutCubic;
}

/// The Sunrise type scale. Colourless: apply a token colour at the use site.
abstract final class SunriseType {
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static const TextStyle amountHero = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 64,
    fontWeight: FontWeight.w600,
    letterSpacing: -2.56,
    height: 1.05,
    fontFeatures: _tabular,
  );
  static const TextStyle largeTitle = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    height: 1.15,
  );
  static const TextStyle greeting = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: -.9,
    height: 1.15,
  );
  static const TextStyle balance = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.2,
    height: 1.1,
    fontFeatures: _tabular,
  );
  static const TextStyle heroTitle = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -.56,
    height: 1.2,
  );
  static const TextStyle statValue = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: _tabular,
  );
  static const TextStyle pushTitle = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  static const TextStyle section = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const TextStyle button = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  static const TextStyle rowTitle = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static const TextStyle amount = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
    fontFeatures: _tabular,
  );
  static const TextStyle body = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static const TextStyle label = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );
  static const TextStyle overline = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: .6,
    height: 1.35,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );
  static const TextStyle tabLabel = TextStyle(
    fontFamily: kSunriseFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}
