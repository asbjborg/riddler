-- Riddler - In-game trivia quiz addon
-- UI Module

Riddler = Riddler or {}
Riddler.UI = Riddler.UI or {}

-- Local references to UI elements
local mainFrame = nil
local questionFrame = nil
local editorFrame = nil
local settingsFrame = nil

-- Initialize UI module
function Riddler.UI:Init()
    Riddler:Debug("UI initialized")
    
    -- Create main UI frames
    self:CreateMainFrame()
    self:CreateQuestionFrame()
    
    -- Register slash command for UI toggle
    SLASH_RIDDLERUI1 = "/riddlerui"
    SlashCmdList["RIDDLERUI"] = function(msg)
        Riddler.UI:ToggleMainFrame()
    end
end

-- Create main addon frame
function Riddler.UI:CreateMainFrame()
    -- Create main frame
    mainFrame = CreateFrame("Frame", "RiddlerMainFrame", UIParent, "BasicFrameTemplateWithInset")
    mainFrame:SetSize(400, 500)
    mainFrame:SetPoint("CENTER")
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
    mainFrame:Hide()
    
    -- Set title
    mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    mainFrame.title:SetPoint("TOP", mainFrame, "TOP", 0, -6)
    mainFrame.title:SetText("Riddler")
    
    -- Create tabs
    mainFrame.Tabs = {}
    mainFrame.TabContents = {}
    
    -- Create Quiz List tab
    self:CreateQuizListTab(mainFrame)
    
    -- Create Quiz Editor tab
    self:CreateQuizEditorTab(mainFrame)
    
    -- Create Settings tab
    self:CreateSettingsTab(mainFrame)
    
    Riddler:Debug("Main frame created")
end

-- Create quiz list tab (placeholder)
function Riddler.UI:CreateQuizListTab(parent)
    -- TODO: Implement Quiz List tab
    Riddler:Debug("Quiz List tab created")
end

-- Create quiz editor tab (placeholder)
function Riddler.UI:CreateQuizEditorTab(parent)
    -- TODO: Implement Quiz Editor tab
    Riddler:Debug("Quiz Editor tab created")
end

-- Create settings tab (placeholder)
function Riddler.UI:CreateSettingsTab(parent)
    -- TODO: Implement Settings tab
    Riddler:Debug("Settings tab created")
end

-- Create question frame for displaying questions
function Riddler.UI:CreateQuestionFrame()
    -- Create question frame
    questionFrame = CreateFrame("Frame", "RiddlerQuestionFrame", UIParent, "BasicFrameTemplateWithInset")
    questionFrame:SetSize(500, 300)
    questionFrame:SetPoint("CENTER")
    questionFrame:SetMovable(true)
    questionFrame:EnableMouse(true)
    questionFrame:RegisterForDrag("LeftButton")
    questionFrame:SetScript("OnDragStart", questionFrame.StartMoving)
    questionFrame:SetScript("OnDragStop", questionFrame.StopMovingOrSizing)
    questionFrame:Hide()
    
    -- Set title
    questionFrame.title = questionFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    questionFrame.title:SetPoint("TOP", questionFrame, "TOP", 0, -6)
    questionFrame.title:SetText("Riddler - Question")
    
    -- Question text
    questionFrame.questionText = questionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    questionFrame.questionText:SetPoint("TOP", questionFrame.title, "BOTTOM", 0, -15)
    questionFrame.questionText:SetWidth(460)
    questionFrame.questionText:SetJustifyH("CENTER")
    questionFrame.questionText:SetText("Question text will appear here")
    
    -- Answer options container
    questionFrame.optionsFrame = CreateFrame("Frame", nil, questionFrame)
    questionFrame.optionsFrame:SetSize(460, 180)
    questionFrame.optionsFrame:SetPoint("TOP", questionFrame.questionText, "BOTTOM", 0, -15)
    
    -- Create answer buttons (placeholder)
    questionFrame.answerButtons = {}
    
    -- Timer bar
    questionFrame.timerBar = CreateFrame("StatusBar", nil, questionFrame)
    questionFrame.timerBar:SetSize(460, 15)
    questionFrame.timerBar:SetPoint("BOTTOM", questionFrame, "BOTTOM", 0, 10)
    questionFrame.timerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    questionFrame.timerBar:SetStatusBarColor(0, 0.7, 0)
    questionFrame.timerBar:SetMinMaxValues(0, 100)
    questionFrame.timerBar:SetValue(100)
    
    -- Timer text
    questionFrame.timerText = questionFrame.timerBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    questionFrame.timerText:SetPoint("CENTER", questionFrame.timerBar, "CENTER")
    questionFrame.timerText:SetText("30")
    
    Riddler:Debug("Question frame created")
end

-- Display a question
function Riddler.UI:DisplayQuestion(question, questionNumber, totalQuestions)
    -- Set question text
    questionFrame.title:SetText(string.format("Question %d of %d", questionNumber, totalQuestions))
    questionFrame.questionText:SetText(question.text)
    
    -- Clear previous answer buttons
    for _, button in pairs(questionFrame.answerButtons) do
        button:Hide()
    end
    questionFrame.answerButtons = {}
    
    -- Create answer buttons for multiple choice questions
    if question.type == "multiple_choice" and question.choices then
        for i, choice in ipairs(question.choices) do
            local button = CreateFrame("Button", nil, questionFrame.optionsFrame, "UIPanelButtonTemplate")
            button:SetSize(440, 30)
            button:SetPoint("TOP", questionFrame.optionsFrame, "TOP", 0, -((i-1) * 35 + 10))
            button:SetText(choice)
            button:SetScript("OnClick", function()
                Riddler.QuizEngine:SubmitAnswer(i)
            end)
            
            table.insert(questionFrame.answerButtons, button)
        end
    else
        -- For free-form questions, show instruction text
        questionFrame.freeFormText = questionFrame.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        questionFrame.freeFormText:SetPoint("TOP", questionFrame.optionsFrame, "TOP", 0, -30)
        questionFrame.freeFormText:SetText("Type your answer in chat!")
        table.insert(questionFrame.answerButtons, questionFrame.freeFormText)
    end
    
    -- Set timer
    local duration = question.duration or RiddlerDB.settings.defaultQuizDuration
    questionFrame.timerBar:SetMinMaxValues(0, duration)
    questionFrame.timerBar:SetValue(duration)
    questionFrame.timerText:SetText(duration)
    
    -- Start timer update
    questionFrame.timerUpdate = C_Timer.NewTicker(0.1, function()
        local remaining = questionFrame.timerBar:GetValue() - 0.1
        questionFrame.timerBar:SetValue(remaining)
        questionFrame.timerText:SetText(string.format("%.1f", remaining))
        
        -- Change color as time runs out
        if remaining < 5 then
            questionFrame.timerBar:SetStatusBarColor(1, 0, 0)
        elseif remaining < 10 then
            questionFrame.timerBar:SetStatusBarColor(1, 0.7, 0)
        end
    end, duration * 10)
    
    -- Show the frame
    questionFrame:Show()
end

-- Show the answer for a question
function Riddler.UI:ShowAnswer(question)
    -- Cancel timer update
    if questionFrame.timerUpdate then
        questionFrame.timerUpdate:Cancel()
    end
    
    -- Set timer to 0
    questionFrame.timerBar:SetValue(0)
    questionFrame.timerText:SetText("0.0")
    
    -- Display correct answer
    local answerText = "The correct answer is: "
    
    if question.type == "multiple_choice" then
        answerText = answerText .. question.choices[question.correct_answer]
    else
        answerText = answerText .. question.answer
    end
    
    -- Highlight correct answer or show answer text
    if question.type == "multiple_choice" then
        for i, button in ipairs(questionFrame.answerButtons) do
            if i == question.correct_answer then
                button:SetBackdropColor(0, 1, 0, 0.3)
            else
                button:SetBackdropColor(1, 0, 0, 0.3)
            end
        end
    else
        questionFrame.freeFormText:SetText(answerText)
    end
    
    -- Show explanation if available
    if question.explanation then
        local explanation = questionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        explanation:SetPoint("BOTTOM", questionFrame.timerBar, "TOP", 0, 5)
        explanation:SetWidth(460)
        explanation:SetText(question.explanation)
    end
end

-- Display final scores at end of quiz
function Riddler.UI:DisplayFinalScores(scores)
    -- TODO: Implement final scores display
    Riddler:Debug("Final scores display")
end

-- Toggle main frame visibility
function Riddler.UI:ToggleMainFrame()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end 