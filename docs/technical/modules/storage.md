# Storage Module

## Overview

Handles persistent storage of quizzes, settings, and statistics using WoW's SavedVariables system.

## Related Documentation

- For data formats, see [[/docs/technical/data_formats|Data Formats]]
- For quiz engine integration, see [[/docs/technical/modules/quiz_engine|Quiz Engine]]
- For UI integration, see [[/docs/technical/modules/ui|UI Module]]
- For performance monitoring, see [[/docs/technical/implementation_details#performance-monitoring|Performance Monitoring]]
- For WoW API usage, see [[/docs/technical/api#saved-variables|SavedVariables API]]

## Data Structures

### SavedVariables

```lua
RiddlerDB = {
  -- Global settings
  global = {
    version = "1.0.0",
    questions = {},
    statistics = {},
    configurations = {}
  },
  
  -- Character-specific settings
  char = {
    preferences = {
      ui = {
        scale = 1.0,
        position = { x = 0, y = 0 },
        font_size = 12
      },
      quiz = {
        default_time = 20,
        show_explanations = true,
        sound_enabled = true
      }
    },
    statistics = {
      total_points = 0,
      questions_answered = 0,
      best_streak = 0
    }
  }
}
```

### Question Cache

```lua
local questionCache = {
  byCategory = {},
  byTag = {},
  byDifficulty = {},
  preloadQuestions = function() end,
  updateCache = function(question) end
}
```

## File Management

### Quiz Files

- JSON format for quiz files
- Stored in addon's quiz directory
- Loaded on demand to minimize memory usage
- Automatic discovery of new files

### Directory Structure

```diagram
Riddler/
├── quizzes/
│   ├── default/        # Bundled quizzes
│   └── custom/         # User-created quizzes
├── backups/            # Auto-saved states
└── config/             # User configurations
```

## Memory Management

### Question Pooling

```lua
local questionPool = {
  size = 50,  -- Maximum questions to keep in memory
  preload = function(categories, tags) end,
  release = function() end
}
```

### Cache Management

- Lazy loading of quiz files
- LRU cache for frequently used questions
- Automatic cleanup of unused data
- Memory usage monitoring

## Backup System

- Periodic state saves during quizzes
- Auto-recovery from crashes
- Manual backup/restore through file system
- No cloud backup (out of scope)
