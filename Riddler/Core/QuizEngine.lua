-- Riddler - In-game trivia quiz addon
-- Quiz Engine Module

Riddler = Riddler or {}
Riddler.QuizEngine = Riddler.QuizEngine or {}

-- Quiz state constants
local QuizState = {
    INACTIVE = 0,
    STARTING = 1,
    QUESTION_ACTIVE = 2,
    BETWEEN_QUESTIONS = 3,
    ENDING = 4
}

-- Local state variables
local currentState = QuizState.INACTIVE
local currentQuiz = nil
local currentQuestion = nil
local questionTimer = nil
local participants = {}
local scores = {}
local questionNumber = 0
local totalQuestions = 0

-- Initialize module
function Riddler.QuizEngine:Init()
    Riddler:Debug("QuizEngine initialized")
    
    -- Register chat event handlers
    self:RegisterChatHandlers()
end

-- Register chat handlers to collect answers
function Riddler.QuizEngine:RegisterChatHandlers()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CHAT_MSG_SAY")
    frame:RegisterEvent("CHAT_MSG_PARTY")
    frame:RegisterEvent("CHAT_MSG_RAID")
    frame:RegisterEvent("CHAT_MSG_GUILD")
    
    frame:SetScript("OnEvent", function(self, event, text, playerName)
        if currentState == QuizState.QUESTION_ACTIVE then
            Riddler.QuizEngine:ProcessAnswer(text, playerName, event)
        end
    end)
end

-- Start a new quiz
function Riddler.QuizEngine:StartQuiz(quizId, channel)
    if currentState ~= QuizState.INACTIVE then
        Riddler:Print("A quiz is already in progress!")
        return false
    end
    
    -- Load quiz data
    local quizData = Riddler.Storage:GetQuiz(quizId)
    if not quizData then
        Riddler:Print("Quiz not found: " .. quizId)
        return false
    end
    
    -- Initialize quiz state
    currentQuiz = quizData
    currentState = QuizState.STARTING
    participants = {}
    scores = {}
    questionNumber = 0
    totalQuestions = #quizData.questions
    
    -- Announce quiz start
    Riddler:Print("Starting quiz: " .. quizData.name)
    Riddler:Print("Channel: " .. channel)
    Riddler:Print("Total questions: " .. totalQuestions)
    
    -- Start first question after a short delay
    C_Timer.After(3, function()
        Riddler.QuizEngine:NextQuestion()
    end)
    
    return true
end

-- Process to the next question
function Riddler.QuizEngine:NextQuestion()
    questionNumber = questionNumber + 1
    
    if questionNumber > totalQuestions then
        -- End of quiz
        Riddler.QuizEngine:EndQuiz()
        return
    end
    
    currentQuestion = currentQuiz.questions[questionNumber]
    currentState = QuizState.QUESTION_ACTIVE
    
    -- Display question
    Riddler.UI:DisplayQuestion(currentQuestion, questionNumber, totalQuestions)
    
    -- Start timer
    local duration = currentQuestion.duration or RiddlerDB.settings.defaultQuizDuration
    questionTimer = C_Timer.NewTimer(duration, function()
        Riddler.QuizEngine:QuestionTimeout()
    end)
    
    Riddler:Debug("Question " .. questionNumber .. " started")
end

-- Process answer from a player
function Riddler.QuizEngine:ProcessAnswer(text, playerName, channel)
    -- TODO: Implement answer processing logic
    -- This will check if the answer is correct and update scores
    
    Riddler:Debug("Answer from " .. playerName .. ": " .. text)
end

-- Handle question timeout
function Riddler.QuizEngine:QuestionTimeout()
    if currentState ~= QuizState.QUESTION_ACTIVE then
        return
    end
    
    currentState = QuizState.BETWEEN_QUESTIONS
    
    -- Show correct answer
    Riddler.UI:ShowAnswer(currentQuestion)
    
    -- Proceed to next question after delay
    C_Timer.After(5, function()
        Riddler.QuizEngine:NextQuestion()
    end)
    
    Riddler:Debug("Question " .. questionNumber .. " timed out")
end

-- End the current quiz
function Riddler.QuizEngine:EndQuiz()
    currentState = QuizState.ENDING
    
    -- Display final scores
    Riddler.UI:DisplayFinalScores(scores)
    
    -- Reset state
    C_Timer.After(10, function()
        currentState = QuizState.INACTIVE
        currentQuiz = nil
        currentQuestion = nil
        questionTimer = nil
        Riddler:Debug("Quiz ended")
    end)
end

-- External accessor for current state
function Riddler.QuizEngine:GetState()
    return currentState
end 