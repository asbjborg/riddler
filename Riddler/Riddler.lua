-- Riddler - In-game trivia quiz addon
-- Main addon file

-- Global addon namespace
Riddler = Riddler or {}
Riddler.version = "0.0.3"

-- Debug function
function Riddler:Debug(msg)
    if Riddler.debugMode then
        print("|cFF33FF99Riddler Debug:|r " .. msg)
    end
end

-- Addon initialization
function Riddler:Init()
    -- Initialize database if needed
    if not RiddlerDB then
        RiddlerDB = {
            quizzes = {},
            settings = {
                debugMode = false,
                defaultQuizDuration = 30,
                defaultHintTime = 15
            },
            playerStats = {},
            version = Riddler.version
        }
    end
    
    Riddler.debugMode = RiddlerDB.settings.debugMode
    
    -- Initialize modules
    Riddler:Debug("Initializing modules...")
    Riddler.QuizEngine:Init()
    Riddler.Storage:Init()
    Riddler.UI:Init()
    Riddler.Sharing:Init()
    
    Riddler:Print("Riddler v" .. Riddler.version .. " loaded. Type /riddler for help.")
end

-- Print a formatted message to the chat frame
function Riddler:Print(msg)
    print("|cFF33FF99Riddler:|r " .. msg)
end

-- Command handler
function Riddler:HandleCommand(msg)
    local command, rest = msg:match("^(%S+)%s*(.*)$")
    command = command and command:lower() or "help"
    
    if command == "help" then
        Riddler:Print("Available commands:")
        Riddler:Print("/riddler quiz start - Start a new quiz")
        Riddler:Print("/riddler quiz stop - Stop the current quiz")
        Riddler:Print("/riddler editor - Open the quiz editor")
        Riddler:Print("/riddler settings - Open settings panel")
    elseif command == "debug" then
        RiddlerDB.settings.debugMode = not RiddlerDB.settings.debugMode
        Riddler.debugMode = RiddlerDB.settings.debugMode
        Riddler:Print("Debug mode " .. (Riddler.debugMode and "enabled" or "disabled"))
    else
        Riddler:Print("Unknown command. Type /riddler help for available commands.")
    end
end

-- Register addon events
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Riddler" then
        Riddler:Init()
    end
end)

-- Register slash commands
SLASH_RIDDLER1 = "/riddler"
SLASH_RIDDLER2 = "/rd"
SlashCmdList["RIDDLER"] = function(msg)
    Riddler:HandleCommand(msg)
end 