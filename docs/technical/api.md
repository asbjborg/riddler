# WoW API Usage

## Chat System

### Message Handling

```lua
-- Register chat events
local function OnChatMessage(self, event, ...)
    if event == "CHAT_MSG_CHANNEL" then
        local message, sender = ...
        ProcessAnswer(sender, message)
    end
end
frame:RegisterEvent("CHAT_MSG_CHANNEL")
```

### Channel Management

```lua
-- Join/leave channels
JoinChannelByName("RiddlerQuiz")
LeaveChannelByName("RiddlerQuiz")

-- Send messages
SendChatMessage("Question: " .. question, "CHANNEL", nil, GetChannelName("RiddlerQuiz"))
```

## UI Framework

### Frame Creation

```lua
-- Main addon frame
local frame = CreateFrame("Frame", "RiddlerFrame", UIParent)
frame:SetSize(400, 300)
frame:SetPoint("CENTER")

-- Scrolling content
local scrollFrame = CreateFrame("ScrollFrame", nil, frame)
local content = CreateFrame("Frame", nil, scrollFrame)
scrollFrame:SetScrollChild(content)
```

### Event Handling

```lua
-- Register events
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

-- Event handler
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        InitializeAddon()
    end
end)
```

## SavedVariables

### Data Storage

```lua
-- In .toc file
## SavedVariables: RiddlerDB
## SavedVariablesPerCharacter: RiddlerCharDB

-- In Lua
RiddlerDB = RiddlerDB or {}
RiddlerCharDB = RiddlerCharDB or {}
```

### Version Management

```lua
local function UpdateSavedVariables()
    if not RiddlerDB.version then
        -- First time initialization
        RiddlerDB.version = "1.0"
    elseif RiddlerDB.version ~= CURRENT_VERSION then
        -- Perform version-specific updates
        MigrateData(RiddlerDB.version)
    end
end
```

## Timer System

### Question Timer

```lua
-- Create timer
local timer = C_Timer.NewTimer(duration, function()
    OnQuestionTimeout()
end)

-- Cancel timer
if timer then
    timer:Cancel()
end
```

### Throttling

```lua
local throttle = {}
local THROTTLE_INTERVAL = 1.0 -- seconds

local function IsThrottled(player)
    local now = GetTime()
    if not throttle[player] or (now - throttle[player]) > THROTTLE_INTERVAL then
        throttle[player] = now
        return false
    end
    return true
end
```

## File System

### JSON Handling

```lua
-- Load quiz file
local function LoadQuizFile(filename)
    local path = "Interface\\AddOns\\Riddler\\Data\\Questions\\" .. filename
    local file = io.open(path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return LibJSON.decode(content)
    end
    return nil
end
```

## Slash Commands

### Command Registration

```lua
SLASH_RIDDLER1 = "/riddler"
SLASH_RIDDLER2 = "/rid"

SlashCmdList["RIDDLER"] = function(msg)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    if command == "start" then
        StartQuiz(rest)
    elseif command == "stop" then
        StopQuiz()
    end
end
```

## Localization

### String Management

```lua
local L = {}
setmetatable(L, {
    __index = function(t, k)
        return k -- Fallback to key if translation missing
    end
})

-- Load locale
local locale = GetLocale()
if locale == "deDE" then
    L["Start Quiz"] = "Quiz starten"
end
```

## Error Handling

### Protected Functions

```lua
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        -- Log error and recover
        print("Riddler Error:", result)
        return nil
    end
    return result
end
```
