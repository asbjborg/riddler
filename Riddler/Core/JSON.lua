-- Riddler - In-game trivia quiz addon
-- JSON Utility Library - based on the lua-json library with modifications for WoW environment

-- Create JSON object
Riddler = Riddler or {}
Riddler.JSON = {}

-- Local functions for JSON parsing/encoding
local encode
local decode

-- Encode a Lua table to JSON string
function Riddler.JSON:encode(obj)
    return encode(obj)
end

-- Decode a JSON string to Lua table
function Riddler.JSON:decode(json)
    return decode(json)
end

-- Local encode function implementation
encode = function(val)
    if val == nil then
        return "null"
    elseif type(val) == "table" then
        -- Check if it's an array or object
        local isArray = true
        local maxIndex = 0
        
        for k, v in pairs(val) do
            if type(k) == "number" and k > 0 and math.floor(k) == k then
                maxIndex = math.max(maxIndex, k)
            else
                isArray = false
                break
            end
        end
        
        local result = isArray and "[" or "{"
        local first = true
        
        if isArray then
            for i = 1, maxIndex do
                if not first then result = result .. "," end
                first = false
                result = result .. encode(val[i] or nil)
            end
        else
            -- Sort keys for consistent output
            local keys = {}
            for k in pairs(val) do
                table.insert(keys, k)
            end
            table.sort(keys)
            
            for _, k in ipairs(keys) do
                if not first then result = result .. "," end
                first = false
                result = result .. '"' .. tostring(k) .. '":' .. encode(val[k])
            end
        end
        
        return result .. (isArray and "]" or "}")
    elseif type(val) == "string" then
        -- Escape special characters
        local escaped = val:gsub('\\', '\\\\')
                           :gsub('"', '\\"')
                           :gsub('\n', '\\n')
                           :gsub('\r', '\\r')
                           :gsub('\t', '\\t')
        return '"' .. escaped .. '"'
    elseif type(val) == "number" or type(val) == "boolean" then
        return tostring(val)
    else
        -- For other types (function, userdata, etc.), convert to string
        return '"' .. tostring(val) .. '"'
    end
end

-- Local decode implementation
decode = function(str)
    -- Pre-process the string to handle escapes
    -- For a full implementation, we'd need a proper lexer/parser
    -- This is a simplified version for basic JSON parsing
    
    local pos = 1
    local len = #str
    
    -- Skip whitespace
    local function skipWhitespace()
        while pos <= len do
            local c = str:sub(pos, pos)
            if c == ' ' or c == '\t' or c == '\n' or c == '\r' then
                pos = pos + 1
            else
                break
            end
        end
    end
    
    -- Parse a value based on what we see
    local parseValue
    
    -- Parse a string
    local function parseString()
        pos = pos + 1  -- Skip opening quote
        local start = pos
        local escaped = false
        local result = ""
        
        while pos <= len do
            local c = str:sub(pos, pos)
            
            if escaped then
                if c == 'n' then result = result .. '\n'
                elseif c == 'r' then result = result .. '\r'
                elseif c == 't' then result = result .. '\t'
                else result = result .. c
                end
                escaped = false
            elseif c == '\\' then
                escaped = true
            elseif c == '"' then
                break
            else
                result = result .. c
            end
            
            pos = pos + 1
        end
        
        pos = pos + 1  -- Skip closing quote
        return result
    end
    
    -- Parse a number
    local function parseNumber()
        local start = pos
        
        -- Skip digits, decimal point, etc.
        while pos <= len do
            local c = str:sub(pos, pos)
            if (c >= '0' and c <= '9') or c == '.' or c == '-' or c == '+' or c == 'e' or c == 'E' then
                pos = pos + 1
            else
                break
            end
        end
        
        local numStr = str:sub(start, pos - 1)
        return tonumber(numStr)
    end
    
    -- Parse an array
    local function parseArray()
        pos = pos + 1  -- Skip opening [
        local result = {}
        local index = 1
        
        skipWhitespace()
        
        -- Empty array
        if str:sub(pos, pos) == ']' then
            pos = pos + 1
            return result
        end
        
        while pos <= len do
            result[index] = parseValue()
            index = index + 1
            skipWhitespace()
            
            local c = str:sub(pos, pos)
            if c == ']' then
                pos = pos + 1
                break
            elseif c == ',' then
                pos = pos + 1
                skipWhitespace()
            else
                error("Expected ',' or ']' in array at position " .. pos)
            end
        end
        
        return result
    end
    
    -- Parse an object
    local function parseObject()
        pos = pos + 1  -- Skip opening {
        local result = {}
        
        skipWhitespace()
        
        -- Empty object
        if str:sub(pos, pos) == '}' then
            pos = pos + 1
            return result
        end
        
        while pos <= len do
            -- Parse key
            if str:sub(pos, pos) ~= '"' then
                error("Expected string key in object at position " .. pos)
            end
            
            local key = parseString()
            skipWhitespace()
            
            -- Parse colon
            if str:sub(pos, pos) ~= ':' then
                error("Expected ':' after key in object at position " .. pos)
            end
            pos = pos + 1
            
            skipWhitespace()
            
            -- Parse value
            result[key] = parseValue()
            skipWhitespace()
            
            -- Parse comma or closing brace
            local c = str:sub(pos, pos)
            if c == '}' then
                pos = pos + 1
                break
            elseif c == ',' then
                pos = pos + 1
                skipWhitespace()
            else
                error("Expected ',' or '}' in object at position " .. pos)
            end
        end
        
        return result
    end
    
    -- Parse true, false, null
    local function parseLiteral(literal, value)
        if str:sub(pos, pos + #literal - 1) == literal then
            pos = pos + #literal
            return value
        else
            error("Expected '" .. literal .. "' at position " .. pos)
        end
    end
    
    -- Parse a value based on what we see
    parseValue = function()
        skipWhitespace()
        
        if pos > len then
            error("Unexpected end of input")
        end
        
        local c = str:sub(pos, pos)
        
        if c == '"' then
            return parseString()
        elseif c == '[' then
            return parseArray()
        elseif c == '{' then
            return parseObject()
        elseif c == 't' then
            return parseLiteral("true", true)
        elseif c == 'f' then
            return parseLiteral("false", false)
        elseif c == 'n' then
            return parseLiteral("null", nil)
        elseif c == '-' or (c >= '0' and c <= '9') then
            return parseNumber()
        else
            error("Unexpected character '" .. c .. "' at position " .. pos)
        end
    end
    
    -- Main decode function
    skipWhitespace()
    local result = parseValue()
    skipWhitespace()
    
    -- Check if there's anything left in the string
    if pos <= len then
        error("Unexpected data after JSON at position " .. pos)
    end
    
    return result
end 