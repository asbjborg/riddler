-- Riddler - In-game trivia quiz addon
-- Sharing Module

Riddler = Riddler or {}
Riddler.Sharing = Riddler.Sharing or {}

-- Local constants
local CHANNEL_PREFIX = "RiddlerShare"
local MAX_MESSAGE_SIZE = 240
local TIMEOUT_SECONDS = 30

-- Local variables
local activeTransfers = {}
local pendingTransfers = {}
local channelId = nil

-- Initialize sharing module
function Riddler.Sharing:Init()
    Riddler:Debug("Sharing initialized")
    
    -- Register communication channel
    C_ChatInfo.RegisterAddonMessagePrefix(CHANNEL_PREFIX)
    
    -- Register event handler
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CHAT_MSG_ADDON")
    frame:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
        if prefix == CHANNEL_PREFIX then
            Riddler.Sharing:ProcessMessage(message, channel, sender)
        end
    end)
end

-- Process incoming message
function Riddler.Sharing:ProcessMessage(message, channel, sender)
    local msgType, data = strsplit(":", message, 2)
    
    if msgType == "OFFER" then
        -- Received an offer to share a quiz
        self:HandleShareOffer(data, sender)
    elseif msgType == "ACCEPT" then
        -- Receiver accepted the share
        self:HandleShareAccept(data, sender)
    elseif msgType == "REJECT" then
        -- Receiver rejected the share
        self:HandleShareReject(data, sender)
    elseif msgType == "DATA" then
        -- Received quiz data chunk
        self:HandleDataChunk(data, sender)
    elseif msgType == "END" then
        -- End of quiz data
        self:HandleTransferEnd(data, sender)
    elseif msgType == "ERROR" then
        -- Error during transfer
        self:HandleTransferError(data, sender)
    end
end

-- Share a quiz with another player
function Riddler.Sharing:ShareQuiz(quizId, target)
    local quiz = Riddler.Storage:GetQuiz(quizId)
    
    if not quiz then
        Riddler:Print("Quiz not found: " .. quizId)
        return false
    end
    
    -- Create JSON string of quiz
    local quizJson = Riddler.Storage:ExportQuiz(quizId)
    if not quizJson then
        Riddler:Print("Failed to export quiz")
        return false
    end
    
    -- Create transfer record
    local transferId = quizId .. "_" .. time()
    activeTransfers[transferId] = {
        quiz = quiz,
        target = target,
        data = quizJson,
        chunks = {},
        status = "pending",
        startTime = time()
    }
    
    -- Split data into chunks
    self:SplitIntoChunks(transferId)
    
    -- Send offer to target
    local offerMsg = string.format("OFFER:%s:%s:%d", 
        transferId, 
        quiz.name, 
        #activeTransfers[transferId].chunks)
    
    -- Send via appropriate channel
    self:SendMessage(offerMsg, "WHISPER", target)
    
    Riddler:Print("Offered to share quiz '" .. quiz.name .. "' with " .. target)
    
    -- Set timeout
    C_Timer.After(TIMEOUT_SECONDS, function()
        if activeTransfers[transferId] and activeTransfers[transferId].status == "pending" then
            Riddler:Print("Share offer to " .. target .. " timed out")
            activeTransfers[transferId] = nil
        end
    end)
    
    return true
end

-- Split quiz data into chunks
function Riddler.Sharing:SplitIntoChunks(transferId)
    local transfer = activeTransfers[transferId]
    local data = transfer.data
    
    local pos = 1
    local chunkNum = 1
    
    while pos <= #data do
        local endPos = math.min(pos + MAX_MESSAGE_SIZE - 1, #data)
        local chunk = string.sub(data, pos, endPos)
        
        transfer.chunks[chunkNum] = chunk
        chunkNum = chunkNum + 1
        pos = endPos + 1
    end
    
    Riddler:Debug("Split quiz into " .. #transfer.chunks .. " chunks")
end

-- Handle a share offer from another player
function Riddler.Sharing:HandleShareOffer(data, sender)
    local transferId, quizName, numChunks = strsplit(":", data, 3)
    numChunks = tonumber(numChunks)
    
    -- Create pending transfer record
    pendingTransfers[transferId] = {
        sender = sender,
        quizName = quizName,
        numChunks = numChunks,
        receivedChunks = {},
        data = "",
        status = "offered"
    }
    
    -- Show confirmation dialog
    StaticPopupDialogs["RIDDLER_SHARE_CONFIRM"] = {
        text = sender .. " wants to share quiz '" .. quizName .. "' with you. Accept?",
        button1 = "Accept",
        button2 = "Decline",
        OnAccept = function()
            Riddler.Sharing:AcceptShare(transferId)
        end,
        OnCancel = function()
            Riddler.Sharing:RejectShare(transferId)
        end,
        timeout = TIMEOUT_SECONDS,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("RIDDLER_SHARE_CONFIRM")
end

-- Accept a share offer
function Riddler.Sharing:AcceptShare(transferId)
    local transfer = pendingTransfers[transferId]
    
    if not transfer then
        return
    end
    
    transfer.status = "receiving"
    
    -- Send accept message
    local acceptMsg = "ACCEPT:" .. transferId
    self:SendMessage(acceptMsg, "WHISPER", transfer.sender)
    
    Riddler:Print("Accepted quiz '" .. transfer.quizName .. "' from " .. transfer.sender)
end

-- Reject a share offer
function Riddler.Sharing:RejectShare(transferId)
    local transfer = pendingTransfers[transferId]
    
    if not transfer then
        return
    end
    
    -- Send reject message
    local rejectMsg = "REJECT:" .. transferId
    self:SendMessage(rejectMsg, "WHISPER", transfer.sender)
    
    -- Clean up
    pendingTransfers[transferId] = nil
    
    Riddler:Print("Rejected quiz from " .. transfer.sender)
end

-- Handle acceptance of a share
function Riddler.Sharing:HandleShareAccept(transferId, sender)
    local transfer = activeTransfers[transferId]
    
    if not transfer or transfer.target ~= sender then
        return
    end
    
    transfer.status = "sending"
    
    -- Start sending chunks
    Riddler:Debug("Share accepted, sending chunks...")
    self:SendNextChunk(transferId, 1)
end

-- Handle rejection of a share
function Riddler.Sharing:HandleShareReject(transferId, sender)
    local transfer = activeTransfers[transferId]
    
    if not transfer or transfer.target ~= sender then
        return
    end
    
    Riddler:Print(sender .. " rejected quiz share")
    
    -- Clean up
    activeTransfers[transferId] = nil
end

-- Send the next chunk of data
function Riddler.Sharing:SendNextChunk(transferId, chunkNum)
    local transfer = activeTransfers[transferId]
    
    if not transfer or transfer.status ~= "sending" then
        return
    end
    
    if chunkNum > #transfer.chunks then
        -- All chunks sent, send END message
        local endMsg = "END:" .. transferId
        self:SendMessage(endMsg, "WHISPER", transfer.target)
        
        Riddler:Print("Quiz '" .. transfer.quiz.name .. "' sent to " .. transfer.target)
        
        -- Clean up
        activeTransfers[transferId] = nil
        return
    end
    
    -- Send this chunk
    local chunk = transfer.chunks[chunkNum]
    local dataMsg = string.format("DATA:%s:%d:%s", transferId, chunkNum, chunk)
    
    self:SendMessage(dataMsg, "WHISPER", transfer.target)
    
    -- Schedule sending next chunk
    C_Timer.After(0.5, function()
        self:SendNextChunk(transferId, chunkNum + 1)
    end)
end

-- Handle received data chunk
function Riddler.Sharing:HandleDataChunk(data, sender)
    local transferId, chunkNum, chunk = strsplit(":", data, 3)
    chunkNum = tonumber(chunkNum)
    
    local transfer = pendingTransfers[transferId]
    
    if not transfer or transfer.sender ~= sender or transfer.status ~= "receiving" then
        return
    end
    
    -- Store the chunk
    transfer.receivedChunks[chunkNum] = chunk
    
    -- Update progress
    local progress = 0
    for i = 1, transfer.numChunks do
        if transfer.receivedChunks[i] then
            progress = progress + 1
        end
    end
    
    Riddler:Debug(string.format("Received chunk %d of %d for quiz '%s'", 
        chunkNum, transfer.numChunks, transfer.quizName))
end

-- Handle end of transfer
function Riddler.Sharing:HandleTransferEnd(transferId, sender)
    local transfer = pendingTransfers[transferId]
    
    if not transfer or transfer.sender ~= sender or transfer.status ~= "receiving" then
        return
    end
    
    -- Concatenate chunks in order
    local data = ""
    for i = 1, transfer.numChunks do
        if transfer.receivedChunks[i] then
            data = data .. transfer.receivedChunks[i]
        else
            -- Missing chunk, report error
            local errorMsg = "ERROR:" .. transferId .. ":Missing chunk " .. i
            self:SendMessage(errorMsg, "WHISPER", sender)
            
            Riddler:Print("Error receiving quiz: Missing data chunk")
            pendingTransfers[transferId] = nil
            return
        end
    end
    
    -- Import the quiz
    local quizId = Riddler.Storage:ImportQuiz(data)
    
    if quizId then
        Riddler:Print("Successfully received and saved quiz '" .. transfer.quizName .. "' from " .. sender)
    else
        Riddler:Print("Error importing received quiz")
        
        -- Report error to sender
        local errorMsg = "ERROR:" .. transferId .. ":Import failed"
        self:SendMessage(errorMsg, "WHISPER", sender)
    end
    
    -- Clean up
    pendingTransfers[transferId] = nil
end

-- Handle transfer error
function Riddler.Sharing:HandleTransferError(data, sender)
    local transferId, errorMsg = strsplit(":", data, 2)
    
    local transfer = activeTransfers[transferId]
    
    if transfer and transfer.target == sender then
        Riddler:Print("Error sharing quiz with " .. sender .. ": " .. errorMsg)
        activeTransfers[transferId] = nil
    end
end

-- Send message wrapper
function Riddler.Sharing:SendMessage(message, messageType, target)
    C_ChatInfo.SendAddonMessage(CHANNEL_PREFIX, message, messageType, target)
end 