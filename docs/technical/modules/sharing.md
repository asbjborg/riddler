# Sharing Module

## Overview

Handles peer-to-peer sharing of quiz content between players using private chat channels.

## Related Documentation

- For data formats, see [[/docs/technical/data_formats|Data Formats]]
- For quiz engine integration, see [[/docs/technical/modules/quiz_engine|Quiz Engine]]
- For UI integration, see [[/docs/technical/modules/ui|UI Module]]
- For storage integration, see [[/docs/technical/modules/storage|Storage Module]]
- For WoW API usage, see [[/docs/technical/api#chat-channels|Chat Channel API]]

## Protocol

### Message Types

```lua
local RiddlerHandshake = {
    MSG = {
        VERSION   = "R:VERSION",   -- First message: addon version
        READY     = "R:READY",     -- Ready to receive
        START     = "R:START",     -- Begin transfer
        ERROR     = "R:ERROR"      -- Something went wrong
    }
}

local RiddlerTransfer = {
    MSG = {
        CHUNK     = "R:CHUNK",     -- Content data chunk
        ACK       = "R:ACK",       -- Chunk received successfully
        COMPLETE  = "R:COMPLETE",  -- All chunks sent
        ERROR     = "R:ERROR"      -- Transfer error
    }
}
```

### Transfer Flow

```diagram
Sender                          Receiver
  |                                |
  |     [Generates share ID]       |
  |     [Joins private channel]    |
  |                                |
  |                    [Joins channel]
  |                                |
  |                   VERSION 1.0  |
  |                                |
  |  READY TheRookery size=150KB   |
  |                                |
  |                      START     |
  |                                |
  |        CHUNK 1/10 {...}        |
  |                                |
  |                     ACK 1/10   |
```

## Channel Management

### Channel Creation

```lua
local function createShareChannel()
    local shareID = GenerateUniqueID()
    local channelName = "riddler-" .. shareID
    JoinChannelByName(channelName)
    return shareID
end
```

### Error Handling

```lua
local errorTypes = {
    VERSION_MISMATCH = "R:ERROR:VERSION:Requires 1.0 or higher",
    TIMEOUT = "R:ERROR:TIMEOUT:No response in 30s",
    CHUNK_MISSING = "R:ERROR:CHUNK_MISSING:5",
    CHECKSUM_MISMATCH = "R:ERROR:CHECKSUM:expected=abc,got=xyz"
}
```

## Data Chunking

### Chunk Format

```lua
local chunkFormat = {
    header = {
        sequence = 1,
        total = 10,
        size = 1024,
        checksum = "abc123"
    },
    data = "..." -- JSON string segment
}
```

### Reassembly

- Chunks are collected and ordered by sequence
- Checksums verified for each chunk
- Complete data validated before saving
- Automatic retry for missing chunks

## Security

- Private channels prevent eavesdropping
- Checksums ensure data integrity
- Version checking prevents incompatibility
- Automatic channel cleanup after transfer
