# Quiz Engine Module

## Overview

Core module responsible for running quizzes, handling player interactions, and managing game state.

## Related Documentation

- For data structures used, see [[/docs/technical/data_formats|Data Formats]]
- For command handling, see [[/docs/technical/commands|Commands and Controls]]
- For interaction examples, see [[/docs/technical/examples|Quiz Flow Examples]]
- For UI integration, see [[/docs/technical/modules/ui|UI Module]]
- For storage integration, see [[/docs/technical/modules/storage|Storage Module]]

For the high-level architecture, see [[/docs/technical/architecture|Architecture Overview]].

## Components

### Timer System

```lua
local timerSystem = {
  -- Core timing
  timers = {
    question = {
      start = function(duration) end,
      pause = function() end,
      resume = function() end,
      cancel = function() end,
      extend = function(seconds) end
    },
    countdown = {
      start = function(threshold) end,
      cancel = function() end
    }
  }
}
```

### Chat Integration

```lua
local chatSystem = {
  handlers = {
    CHAT_MSG_SAY = function(text, playerName) end,
    CHAT_MSG_PARTY = function(text, playerName) end,
    CHAT_MSG_RAID = function(text, playerName) end,
    CHAT_MSG_GUILD = function(text, playerName) end
  }
}
```

### Score Management

```lua
local scoringSystem = {
  calculatePoints = function(answer_data)
    local points = 0
    
    -- Base points for difficulty
    if answer_data.is_correct then
      points = points + base_points[answer_data.difficulty]
    end
    
    -- Participation point
    points = points + 1
    
    -- First answer bonus
    if answer_data.is_first_answer then
      points = points + 2
    end
    
    -- Streak bonus
    if answer_data.current_streak == 3 then
      points = points + 1
    elseif answer_data.current_streak == 5 then
      points = points + 3
    end
    
    return points
  end
}
```

### Host Controls

```lua
local hostControls = {
  current_question = {
    skip = function() end,
    add_time = function(seconds) end,
    reveal_hint = function() end,
    show_answer = function() end
  },
  
  quiz_flow = {
    pause = function() end,
    resume = function() end,
    end_early = function() end,
    adjust_difficulty = function(new_distribution) end
  }
}
```

## Error Handling

```lua
local errorHandler = {
  errors = {
    QUIZ_IN_PROGRESS = "Quiz already in progress",
    CHANNEL_UNAVAILABLE = "Channel unavailable, stopping quiz",
    INVALID_ANSWER = "Invalid answer format"
  },
  
  recovery = {
    saveState = function() end,
    restoreState = function() end,
    resetQuiz = function() end
  }
}
```

## State Management

### Quiz State

```lua
local quizState = {
  status = "idle", -- idle, running, paused, ended
  current_question = nil,
  participants = {},
  scores = {},
  timer = nil,
  settings = nil
}
```

### Save States

- Periodic state saves during quiz
- Save on crash/disconnect
- Manual save points
- Auto-recovery from last valid state

## Channel Management

- Single quiz per channel
- Channel availability checking
- Auto-stop on channel loss (group -> raid conversion)
- Error messaging for channel issues
