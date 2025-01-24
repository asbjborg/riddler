# Data Formats

## Question Format

### Multiple Choice Question

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "version": 1,
  "archived": null,
  "category": "Lore",
  "difficulty": "Easy",
  "tags": ["Vanilla", "Alliance", "Zones"],
  "type": "multiple_choice",
  "question": "Which city is the capital of the Alliance in Vanilla WoW?",
  "choices": [
    "Stormwind",
    "Ironforge",
    "Darnassus",
    "Theramore"
  ],
  "answer": "Stormwind",
  "hint": "This city was rebuilt after being destroyed in the First War",
  "explanation": "Stormwind has been the central capital of the Alliance since Vanilla WoW.",
  "created_by": "PlayerName",
  "created_at": "2024-01-23T14:15:00Z",
  "last_modified": "2024-01-23T14:15:00Z",
  "times_used": 42,
  "correct_answers": 35,
  "average_response_time": 8.5,
  "language": "enUS",
  "source": "Manual Entry",
  "verified": true,
  "verified_by": "ModeratorName",
  "verified_at": "2024-01-24T10:00:00Z"
}
```

### Typed Answer Question

```json
{
  "id": "660f9500-e29b-41d4-a716-446655440001",
  "type": "typed_answer",
  "category": "Items",
  "difficulty": "Hard",
  "question": "What mount drops from Kael'thas in Tempest Keep?",
  "answer": [
    "Ashes of Al'ar",
    "ashes of alar",
    "alar",
    "ashes"
  ],
  "hint": "It's a phoenix mount",
  "explanation": "The Ashes of Al'ar is a rare phoenix mount with a roughly 1% drop rate from Kael'thas in Tempest Keep.",
  "tags": [
    "lore",                  
    "items",                 
    "Tempest Keep",          
    "The Burning Crusade",   
    "Raid",                  
    "Mounts"                 
  ]
}
```

## Metadata Fields

### Required Fields

- `id`: UUID for unique identification
- `version`: Incremented when question is edited
- `type`: Question type (multiple_choice, typed_answer)
- `category`: Primary categorization
- `difficulty`: Easy, Medium, or Hard
- `question`: The actual question text
- `answer`: Single string for multiple choice, array of accepted answers for typed

### Optional Fields

- `archived`: Timestamp when archived (null if active)
- `tags`: Array of strings for flexible categorization
- `hint`: Optional hint that can be revealed
- `explanation`: Detailed explanation of the answer
- `created_by`: Original author's character name
- `created_at`: Creation timestamp
- `last_modified`: Last edit timestamp
- `times_used`: Usage count
- `correct_answers`: Number of correct responses
- `average_response_time`: Mean time to answer
- `language`: WoW client language code
- `source`: Origin of the question
- `verified`: Review status
- `verified_by`: Reviewer's name
- `verified_at`: Review timestamp

## Tag Groups

```lua
local tagGroups = {
  question_type = {
    "mechanics",
    "lore",
    "items",
    "achievements"
  },
  expansions = {
    "Vanilla",
    "The Burning Crusade",
    "Wrath of the Lich King",
    "The War Within"
  },
  content_type = {
    "Raid",
    "Dungeon",
    "Questline",
    "Achievement",
    "World Boss"
  },
  difficulty = {
    "Easy",
    "Medium",
    "Hard"
  }
}
```

## Quiz Configuration

```lua
local quizConfig = {
  name = "Raid Night Quiz",
  description = "Quick mechanics check before pull",
  question_count = 5,  -- or 0 for "until stopped"
  time_per_question = 20,  -- seconds
  difficulty_distribution = {
    easy = 60,    -- percentage
    medium = 30,
    hard = 10
  }
}

local advancedConfig = {
  scoreboard = {
    display_frequency = 5,  -- questions
    top_players_shown = 10,
    show_difficulty_breakdown = true,
    show_response_times = true
  },
  countdown = {
    enabled = true,
    start_at = 5,  -- seconds
    warning_sound = true
  },
  explanations = {
    show = true,
    duration = 8,  -- seconds
    auto_extend = true  -- extends if explanation is long
  },
  voting = {
    enable_skip_votes = true,
    skip_threshold = {
      type = "percentage",  -- or "fixed"
      value = 50,  -- 50% or 5 votes
      minimum_votes = 3
    }
  }
}
```

## Statistics Format

```lua
local playerStats = {
  session = {
    questions_answered = 0,
    correct_answers = 0,
    total_points = 0,
    average_time = 0,
    best_streak = 0,
    difficulty_breakdown = {
      easy = { attempted = 0, correct = 0 },
      medium = { attempted = 0, correct = 0 },
      hard = { attempted = 0, correct = 0 }
    }
  },
  lifetime = {
    -- Same structure as session
    -- Persisted between quiz sessions
  }
}
```
