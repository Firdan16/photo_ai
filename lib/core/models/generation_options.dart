/// Color tone/filter presets for Instagram-style photos
class ColorTone {
  final String id;
  final String name;
  final String emoji;
  final String promptAddition;

  const ColorTone({
    required this.id,
    required this.name,
    required this.emoji,
    required this.promptAddition,
  });

  static const List<ColorTone> all = [
    natural,
    warmCozy,
    coolMoody,
    vintageFilm,
    cleanBright,
    darkDramatic,
    pastelSoft,
    vibrantPop,
  ];

  static const natural = ColorTone(
    id: 'natural',
    name: 'Natural',
    emoji: '🌿',
    promptAddition: 'natural colors, balanced exposure, true-to-life tones',
  );

  static const warmCozy = ColorTone(
    id: 'warm_cozy',
    name: 'Warm & Cozy',
    emoji: '🔥',
    promptAddition:
        'warm orange and yellow tones, cozy atmosphere, soft warm lighting',
  );

  static const coolMoody = ColorTone(
    id: 'cool_moody',
    name: 'Cool & Moody',
    emoji: '🌊',
    promptAddition: 'cool blue tones, moody atmosphere, desaturated colors',
  );

  static const vintageFilm = ColorTone(
    id: 'vintage_film',
    name: 'Vintage Film',
    emoji: '📷',
    promptAddition:
        'vintage film grain, faded colors, retro aesthetic, nostalgic look',
  );

  static const cleanBright = ColorTone(
    id: 'clean_bright',
    name: 'Clean & Bright',
    emoji: '✨',
    promptAddition:
        'bright and airy, clean white tones, high key lighting, fresh look',
  );

  static const darkDramatic = ColorTone(
    id: 'dark_dramatic',
    name: 'Dark & Dramatic',
    emoji: '🖤',
    promptAddition:
        'dark moody tones, dramatic shadows, high contrast, cinematic',
  );

  static const pastelSoft = ColorTone(
    id: 'pastel_soft',
    name: 'Pastel Soft',
    emoji: '🎀',
    promptAddition:
        'soft pastel colors, dreamy aesthetic, gentle tones, ethereal',
  );

  static const vibrantPop = ColorTone(
    id: 'vibrant_pop',
    name: 'Vibrant Pop',
    emoji: '🌈',
    promptAddition: 'vibrant saturated colors, bold and punchy, eye-catching',
  );
}

/// Framing/composition options
class FramingOption {
  final String id;
  final String name;
  final String emoji;
  final String promptAddition;

  const FramingOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.promptAddition,
  });

  static const List<FramingOption> all = [
    auto,
    closeUp,
    halfBody,
    fullBody,
    centered,
    ruleOfThirds,
  ];

  static const auto = FramingOption(
    id: 'auto',
    name: 'Auto',
    emoji: '🎯',
    promptAddition: '', // Let AI decide
  );

  static const closeUp = FramingOption(
    id: 'close_up',
    name: 'Close-up',
    emoji: '👤',
    promptAddition:
        'close-up portrait shot, face and shoulders visible, intimate framing',
  );

  static const halfBody = FramingOption(
    id: 'half_body',
    name: 'Half Body',
    emoji: '👔',
    promptAddition: 'half body shot, waist up visible, medium shot framing',
  );

  static const fullBody = FramingOption(
    id: 'full_body',
    name: 'Full Body',
    emoji: '🧍',
    promptAddition:
        'full body shot, entire person visible from head to toe, wide framing',
  );

  static const centered = FramingOption(
    id: 'centered',
    name: 'Centered',
    emoji: '⬜',
    promptAddition: 'subject centered in frame, symmetrical composition',
  );

  static const ruleOfThirds = FramingOption(
    id: 'rule_of_thirds',
    name: 'Rule of Thirds',
    emoji: '📐',
    promptAddition:
        'rule of thirds composition, subject positioned off-center, artistic framing',
  );
}

/// Variation intensity - how different from original
class VariationLevel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final double value; // 0.0 to 1.0

  const VariationLevel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.value,
  });

  static const List<VariationLevel> all = [
    subtle,
    balanced,
    creative,
    artistic,
  ];

  static const subtle = VariationLevel(
    id: 'subtle',
    name: 'Subtle',
    emoji: '🎚️',
    description: 'Keep close to original',
    value: 0.25,
  );

  static const balanced = VariationLevel(
    id: 'balanced',
    name: 'Balanced',
    emoji: '⚖️',
    description: 'Good mix of original & new',
    value: 0.5,
  );

  static const creative = VariationLevel(
    id: 'creative',
    name: 'Creative',
    emoji: '🎨',
    description: 'More artistic freedom',
    value: 0.75,
  );

  static const artistic = VariationLevel(
    id: 'artistic',
    name: 'Artistic',
    emoji: '🚀',
    description: 'Maximum creativity',
    value: 1.0,
  );
}
