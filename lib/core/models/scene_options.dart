/// Pre-defined Instagram-style scene/theme options
class SceneOption {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String promptTemplate;

  const SceneOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.promptTemplate,
  });

  /// Generate the full prompt with the scene template
  String generatePrompt({String? customDetails}) {
    if (customDetails != null && customDetails.trim().isNotEmpty) {
      return '$promptTemplate. Additional details: $customDetails';
    }
    return promptTemplate;
  }
}

/// Collection of Instagram-style scene options
class SceneOptions {
  static const List<SceneOption> all = [
    // Landscape/Environment scenes (no person required)
    landscapeNight,
    landscapeSunset,
    landscapeMoody,
    landscapeDramatic,
    // Portrait scenes (person-focused)
    cafe,
    rooftop,
    streetStyle,
    mirrorSelfie,
    gymFit,
    travel,
    goldenHour,
    beachVibes,
    nightOut,
    cozyHome,
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // LANDSCAPE / ENVIRONMENT SCENES (preserves original, no person added)
  // ═══════════════════════════════════════════════════════════════════════════

  static const landscapeNight = SceneOption(
    id: 'landscape_night',
    name: 'Night Mode',
    emoji: '🌙',
    description: 'Transform to night scene',
    promptTemplate:
        'Transform this photo into a night scene. Change the lighting to nighttime '
        'with moonlight, city lights, or starry sky as appropriate. '
        'Keep all subjects exactly as they are, only change the time of day and lighting. '
        'Do not add or remove any people or objects',
  );

  static const landscapeSunset = SceneOption(
    id: 'landscape_sunset',
    name: 'Sunset Glow',
    emoji: '🌅',
    description: 'Golden hour lighting',
    promptTemplate:
        'Transform this photo with beautiful golden hour sunset lighting. '
        'Add warm orange and pink tones from a setting sun. '
        'Keep all subjects exactly as they are, only enhance with sunset colors. '
        'Do not add or remove any people or objects',
  );

  static const landscapeMoody = SceneOption(
    id: 'landscape_moody',
    name: 'Moody Vibes',
    emoji: '🌫️',
    description: 'Atmospheric and cinematic',
    promptTemplate:
        'Transform this photo with moody, atmospheric vibes. '
        'Add soft fog or mist, muted colors, cinematic look. '
        'Keep all subjects exactly as they are, only change the atmosphere. '
        'Do not add or remove any people or objects',
  );

  static const landscapeDramatic = SceneOption(
    id: 'landscape_dramatic',
    name: 'Dramatic Sky',
    emoji: '⛈️',
    description: 'Epic cloud formations',
    promptTemplate:
        'Transform this photo with a dramatic sky - epic clouds, '
        'dramatic lighting, stormy or epic atmosphere. '
        'Keep all subjects exactly as they are, only enhance the sky and lighting. '
        'Do not add or remove any people or objects',
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // PORTRAIT / PERSON SCENES
  // ═══════════════════════════════════════════════════════════════════════════

  static const cafe = SceneOption(
    id: 'cafe',
    name: 'Cafe Aesthetic',
    emoji: '☕',
    description: 'Cozy coffee shop vibes',
    promptTemplate:
        'Create a casual Instagram photo of this person sitting in a trendy cafe, '
        'holding a coffee cup, natural lighting from the window, cozy aesthetic, '
        'candid pose, shot on iPhone, warm tones, bokeh background',
  );

  static const rooftop = SceneOption(
    id: 'rooftop',
    name: 'Rooftop Moment',
    emoji: '🌆',
    description: 'City skyline backdrop',
    promptTemplate:
        'Create a casual Instagram photo of this person on a rooftop with city skyline, '
        'golden hour lighting, relaxed pose leaning on railing, urban aesthetic, '
        'candid moment, shot on iPhone, cinematic city background',
  );

  static const streetStyle = SceneOption(
    id: 'street_style',
    name: 'Street Style',
    emoji: '🚶',
    description: 'Urban fashion look',
    promptTemplate:
        'Create a casual Instagram street style photo of this person walking in the city, '
        'fashionable urban look, natural daylight, candid walking pose, '
        'shot on iPhone, slightly blurred street background, trendy aesthetic',
  );

  static const mirrorSelfie = SceneOption(
    id: 'mirror_selfie',
    name: 'Mirror Selfie',
    emoji: '🪞',
    description: 'Classic mirror shot',
    promptTemplate:
        'Create a casual Instagram mirror selfie of this person, '
        'stylish outfit, clean aesthetic background, natural indoor lighting, '
        'holding phone for selfie pose, shot on iPhone, trendy mirror selfie style',
  );

  static const gymFit = SceneOption(
    id: 'gym_fit',
    name: 'Gym Fit',
    emoji: '💪',
    description: 'Fitness motivation',
    promptTemplate:
        'Create a casual Instagram gym photo of this person in athletic wear, '
        'modern gym background with equipment, confident pose, good lighting, '
        'fitness aesthetic, shot on iPhone, motivational gym selfie vibe',
  );

  static const travel = SceneOption(
    id: 'travel',
    name: 'Travel Moment',
    emoji: '✈️',
    description: 'Wanderlust vibes',
    promptTemplate:
        'Create a casual Instagram travel photo of this person at a scenic destination, '
        'tourist landmark or beautiful location background, happy candid expression, '
        'travel outfit, shot on iPhone, wanderlust aesthetic, vacation vibes',
  );

  static const goldenHour = SceneOption(
    id: 'golden_hour',
    name: 'Golden Hour',
    emoji: '🌅',
    description: 'Sunset glow portrait',
    promptTemplate:
        'Create a casual Instagram golden hour portrait of this person, '
        'warm sunset lighting on face, soft golden glow, outdoor setting, '
        'relaxed natural pose, shot on iPhone, dreamy aesthetic, magic hour vibes',
  );

  static const beachVibes = SceneOption(
    id: 'beach',
    name: 'Beach Vibes',
    emoji: '🏖️',
    description: 'Summer beach look',
    promptTemplate:
        'Create a casual Instagram beach photo of this person, '
        'beach or ocean background, summer outfit, natural sunlight, '
        'relaxed beach pose, shot on iPhone, summer aesthetic, vacation mode',
  );

  static const nightOut = SceneOption(
    id: 'night_out',
    name: 'Night Out',
    emoji: '🌙',
    description: 'Evening party vibes',
    promptTemplate:
        'Create a casual Instagram night out photo of this person, '
        'stylish evening outfit, moody club or bar lighting, neon accents, '
        'confident pose, shot on iPhone with flash, party aesthetic',
  );

  static const cozyHome = SceneOption(
    id: 'cozy_home',
    name: 'Cozy Home',
    emoji: '🏠',
    description: 'Homey aesthetic',
    promptTemplate:
        'Create a casual Instagram photo of this person at home, '
        'cozy living room or bedroom setting, comfortable casual outfit, '
        'soft natural lighting, relaxed candid pose, shot on iPhone, homey aesthetic',
  );
}
