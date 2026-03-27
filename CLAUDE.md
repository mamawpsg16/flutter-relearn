# Flutter Relearn — Claude Code Guide

## Project Purpose
A personal Flutter learning app. Each screen teaches one Flutter concept through
**interactive live demos + code snippets**, mirroring the Flutter official docs.
The user learns by running the app, not by reading external docs.

## Project Structure
```
lib/
  main.dart                        # Entry point → AdaptiveHome (current top-level)
  screens/
    adaptive/                      # Adaptive & responsive design
      adaptive_home.dart           # Section menu
      best_practices_screen.dart   # Sub-menu
      best_practices/              # One file per sub-topic
    design_theming/                # Design & Theming (Material, fonts, shaders)
      design_theming_home.dart
      <topic>_screen.dart
    accessibility/
    forms/
    layout/
    lists_and_grids/
    platform_adaptations/
    scrolling/
    shopping/
```

## Screen Conventions (always follow these)

### Every topic screen must contain:
1. **Concept explanation** — 1–3 plain-English sentences at the top
2. **BAD / GOOD code blocks** (where applicable) — dark `Colors.grey.shade900` container,
   red label for bad, green for good, white monospace text
3. **Live interactive demo** — the actual widget running, not just a description
4. **Tip card** — `Colors.purple.shade50` card with a lightbulb icon summarising the rule

### Shared private widgets (copy into each screen file, keep them `_` private):
- `_CodeSection({label, labelColor, code})` — dark code block
- `_TipCard({tip})` — purple tip card

### Naming
- Class: `PascalCase` + `Screen` suffix (e.g. `ShareStylesScreen`)
- File: `snake_case_screen.dart`
- Private helpers: underscore prefix (`_CodeSection`, `_TipCard`)

### Menu / home screens
Use the `_Topic` + `_TopicCard` pattern from `adaptive_home.dart`:
- `_Topic` data class: `title`, `description`, `icon`, `color`, `screen`
- `_TopicCard`: `Card > ListTile` with `CircleAvatar` leading icon
- `ListView.separated`, `padding: EdgeInsets.all(16)`, `SizedBox(height: 12)` separator

### AppBar
```dart
AppBar(
  title: const Text('Screen Title'),
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
)
```

### State in demos
Use `StatefulWidget` + `setState`. No external state management packages.

## When adding a new topic screen
1. Create the file in the correct section folder
2. Follow screen conventions above
3. Add it to the section's home/menu screen `_topics` list
4. If it's a brand-new section, wire it into the top-level menu (`AdaptiveHome` for now)

## Sections built so far
- **Adaptive** — MediaQuery, LayoutBuilder, SafeArea, Flexible/Expanded,
  AdaptiveScaffold, NestedTheme, Best Practices (7 sub-topics)
- **Platform Adaptations** — scrolling physics, haptics, text fields, nav bars
- **Accessibility** — semantics, focus, gestures
