-- Riddler - In-game trivia quiz addon
-- Storage Module

Riddler = Riddler or {}
Riddler.Storage = Riddler.Storage or {}

-- Initialize storage module
function Riddler.Storage:Init()
    Riddler:Debug("Storage initialized")
    
    -- Ensure database structure is valid
    self:ValidateDB()
    
    -- Load default quizzes if first time setup
    if not RiddlerDB.firstTimeSetupDone then
        self:LoadDefaultQuizzes()
        RiddlerDB.firstTimeSetupDone = true
    end
end

-- Validate database structure
function Riddler.Storage:ValidateDB()
    if not RiddlerDB then
        RiddlerDB = {}
    end
    
    if not RiddlerDB.quizzes then
        RiddlerDB.quizzes = {}
    end
    
    if not RiddlerDB.settings then
        RiddlerDB.settings = {
            debugMode = false,
            defaultQuizDuration = 30,
            defaultHintTime = 15
        }
    end
    
    if not RiddlerDB.playerStats then
        RiddlerDB.playerStats = {}
    end
end

-- Load default quizzes
function Riddler.Storage:LoadDefaultQuizzes()
    -- TODO: Implement loading of default quizzes
    -- This would load quizzes from the Data/Templates directory
    
    Riddler:Debug("Default quizzes loaded")
end

-- Get a quiz by ID
function Riddler.Storage:GetQuiz(quizId)
    return RiddlerDB.quizzes[quizId]
end

-- Get a list of all available quizzes
function Riddler.Storage:GetAllQuizzes()
    local quizList = {}
    
    for id, quiz in pairs(RiddlerDB.quizzes) do
        table.insert(quizList, {
            id = id,
            name = quiz.name,
            category = quiz.category,
            questionCount = #quiz.questions
        })
    end
    
    return quizList
end

-- Save a quiz
function Riddler.Storage:SaveQuiz(quiz)
    if not quiz.id then
        quiz.id = "quiz_" .. time()
    end
    
    RiddlerDB.quizzes[quiz.id] = quiz
    Riddler:Debug("Quiz saved: " .. quiz.name)
    return quiz.id
end

-- Delete a quiz
function Riddler.Storage:DeleteQuiz(quizId)
    if RiddlerDB.quizzes[quizId] then
        local name = RiddlerDB.quizzes[quizId].name
        RiddlerDB.quizzes[quizId] = nil
        Riddler:Debug("Quiz deleted: " .. name)
        return true
    end
    
    return false
end

-- Import a quiz from JSON
function Riddler.Storage:ImportQuiz(jsonString)
    local success, quiz = pcall(function() return JSON:decode(jsonString) end)
    
    if not success or not quiz.name or not quiz.questions then
        Riddler:Print("Failed to import quiz: Invalid format")
        return nil
    end
    
    quiz.id = "quiz_" .. time()
    quiz.imported = true
    quiz.importDate = date("%Y-%m-%d")
    
    RiddlerDB.quizzes[quiz.id] = quiz
    Riddler:Debug("Quiz imported: " .. quiz.name)
    return quiz.id
end

-- Export a quiz to JSON
function Riddler.Storage:ExportQuiz(quizId)
    local quiz = self:GetQuiz(quizId)
    
    if not quiz then
        Riddler:Print("Quiz not found: " .. quizId)
        return nil
    end
    
    local exportQuiz = CopyTable(quiz)
    exportQuiz.id = nil  -- Remove ID for export
    
    local jsonString = JSON:encode(exportQuiz)
    
    return jsonString
end

-- Update player statistics
function Riddler.Storage:UpdatePlayerStats(playerName, correct, points)
    if not RiddlerDB.playerStats[playerName] then
        RiddlerDB.playerStats[playerName] = {
            totalPlayed = 0,
            correct = 0,
            totalPoints = 0
        }
    end
    
    local stats = RiddlerDB.playerStats[playerName]
    stats.totalPlayed = stats.totalPlayed + 1
    
    if correct then
        stats.correct = stats.correct + 1
    end
    
    stats.totalPoints = stats.totalPoints + points
end

-- Get player statistics
function Riddler.Storage:GetPlayerStats(playerName)
    return RiddlerDB.playerStats[playerName] or {
        totalPlayed = 0,
        correct = 0,
        totalPoints = 0
    }
end 