# UI Module

## Overview

Handles all user interface components including quiz creation, management, and display.

## Related Documentation

- For UI examples, see [[/docs/technical/examples|Quiz Flow Examples]]
- For editor details, see [[/docs/technical/implementation_details#question-editor-ui|Question Editor UI]]
- For command handling, see [[/docs/technical/commands#host-controls-interface|Host Controls]]
- For WoW UI APIs, see [[/docs/technical/api#ui-framework|UI Framework]]
- For quiz engine integration, see [[/docs/technical/modules/quiz_engine|Quiz Engine]]

For performance considerations, see [[/docs/technical/implementation_details#performance-monitoring|Performance Monitoring]].

## Components

### Main Interface

```lua
local mainFrame = {
  width = 400,
  height = 300,
  backdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  }
}
```

### Quiz Editor

- Question creation/editing form
- Category and tag management
- Preview mode
- JSON import/export
- Default quiz templates

### Quiz Display

```lua
local questionFrame = {
  text = CreateFontString(nil, "OVERLAY", "GameFontNormal"),
  choices = {}, -- For multiple choice
  timer = CreateStatusBar(),
  explanation = CreateFontString(nil, "OVERLAY", "GameFontNormal")
}
```

### Scoreboard

```lua
local scoreboardFrame = {
  header = CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"),
  rows = {}, -- Dynamic player score rows
  scrollFrame = CreateFrame("ScrollFrame"),
  updateFrequency = 1 -- seconds
}
```

## Performance

### UI Recycling

```lua
local uiPool = {
  scoreRows = {},
  choiceButtons = {},
  recycleComponents = function() end
}
```

### Frame Management

- Minimal frame updates
- Component pooling
- Efficient string handling
- Memory-conscious design

## Layouts

### Main Window Tabs

1. Quiz Browser
   - List of available quizzes
   - Search and filter options
   - Quick start options

2. Quiz Editor
   - Question form
   - Category/tag management
   - Import/export tools

3. Settings
   - UI preferences
   - Quiz defaults
   - Performance options

4. Statistics
   - Personal stats
   - Quiz history
   - Achievement tracking

## Themes

- Uses WoW's built-in UI elements
- Consistent with game styling
- Minimal custom textures
- Readable fonts
