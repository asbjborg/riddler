# Commands and Controls

## Host Commands

### Quiz Control

```lua
local hostCommands = {
  quiz_control = {
    "!start",    -- Start the quiz
    "!pause",    -- Pause the quiz
    "!resume",   -- Resume the quiz
    "!end",      -- End the quiz
    "!next",     -- Skip to next question
    "!time +X",  -- Add X seconds
    "!hint",     -- Show hint if available
    "!answer",   -- Show answer immediately
  },
  
  configuration = {
    "!config difficulty easy=60 medium=30 hard=10",
    "!config time 30",
    "!config streak 3=1 5=3",
    "!config scoreboard 5",
  },
  
  player_management = {
    "!mute PlayerName",
    "!unmute PlayerName",
    "!reset PlayerName",
  }
}
```

### Command Examples

```text
[LrdPatrick] !config difficulty easy=50 medium=30 hard=20
[Riddler] Difficulty distribution updated:
- Easy: 50%
- Medium: 30%
- Hard: 20%

[LrdPatrick] !time +10
[Riddler] Added 10 seconds to the current question.
Time remaining: 25s

[LrdPatrick] !mute TrollPlayer
[Riddler] TrollPlayer has been muted for this quiz session.
```

## Skip Vote System

### Configuration

```lua
local skipVoteSystem = {
  config = {
    enabled = true,
    threshold = {
      type = "percentage",  -- or "fixed"
      value = 50,          -- 50% or 5 votes
      minimum_votes = 3,
      time_window = 30     -- seconds to gather votes
    }
  },
  
  current_state = {
    votes = {},
    active_players = 0,
    vote_count = 0,
    time_remaining = 0
  },
  
  commands = {
    "!skip",      -- Cast vote to skip
    "!votes",     -- Show current vote count
    "!revoke"     -- Remove your vote
  }
}
```

### Vote Progress Example

```text
[Hikari] !skip
[Riddler] Skip vote started by Hikari (1/5 votes needed, 30s remaining)

[LrdPatrick] !skip
[Riddler] LrdPatrick voted to skip (2/5)

[SneakyRogue] !skip
[Riddler] SneakyRogue voted to skip (3/5)
Current votes: Hikari, LrdPatrick, SneakyRogue
Type !skip to vote, !revoke to remove vote
15s remaining

[Bjarnulf] !votes
[Riddler] Skip Vote Progress: 3/5 votes needed (10s remaining)
Current votes: Hikari, LrdPatrick, SneakyRogue

[SneakyRogue] !revoke
[Riddler] SneakyRogue removed their vote (2/5)
Current votes: Hikari, LrdPatrick
```

## Time Management

### Time Management Configuration

```lua
local timeControl = {
  -- Question timing
  question = {
    base_time = 20,        -- seconds
    extension_time = 10,   -- seconds for manual extension
    grace_period = 2,      -- seconds after answer submission
    minimum_time = 5       -- seconds (can't reduce below this)
  },
  
  -- Explanation timing
  explanation = {
    base_time = 8,
    auto_extend = {
      enabled = true,
      chars_per_second = 15,  -- For auto-calculating needed time
      maximum_time = 20
    }
  },
  
  -- Countdown settings
  countdown = {
    enabled = true,
    start_threshold = 5,   -- seconds remaining
    warning_sound = true,
    chat_countdown = true  -- Show countdown in chat
  }
}
```

### Time Extension Example

```text
[LrdPatrick] !time +10
[Riddler] Time extended by 10s due to active participation
[Riddler] New time remaining: 15s
```

### Auto-extension Example

```text
[Riddler] Extending explanation time by 5s due to length...
[Riddler] New time remaining: 13s
```

## Host Controls Interface

### Current Question Control

```lua
local hostControls = {
  -- Current question control
  current_question = {
    skip = function() end,
    add_time = function(seconds) end,
    reveal_hint = function() end,
    show_answer = function() end
  },
  
  -- Quiz flow control
  quiz_flow = {
    pause = function() end,
    resume = function() end,
    end_early = function() end,
    adjust_difficulty = function(new_distribution) end
  },
  
  -- Participant management
  participants = {
    mute_player = function(player_name) end,
    unmute_player = function(player_name) end,
    reset_score = function(player_name) end
  }
}
```

### Host UI Example

```diagram
+------------------------+
|   Host Controls       |
+------------------------+
| Time: 15s  [+10] [-5] |
| Players: 4  Active: 3 |
|                      |
| [Skip] [Hint] [End]  |
|                      |
| Difficulty:          |
| E: 60% M: 30% H: 10% |
| [Adjust]             |
+------------------------+
```
