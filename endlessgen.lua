local LINE_MIN_LENGTH = 50
local LINE_MAX_LENGTH = 50
local LINE_MIN_SPACING = 10
local LINE_MAX_SPACING = 20
local LINE_MIN_HEIGHT = 100
local LINE_MAX_HEIGHT = 120
local LINE_CHAIN_LENGTH = 3

-- init vars
local nextPositionToCreateNewLine = 0
local activeLines = {}

function initLines()
    activeLines = nil
    nextPositionToCreateNewLine = 128
    activeLines = createLine(activeLines, 0, LINE_MIN_HEIGHT, LINE_MAX_LENGTH)
    activeLines = appendLine(activeLines)
    activeLines = appendLine(activeLines)
end

-- Creates a new line and appends it to the provided line list via head
-- Should only be called in init()
function createLine(head, start_x, height, length)
    local line = {
        start_x = start_x,
        height = height,
        length = length,
        next = nil
    }

    if head == nil then
        return line
    end
    
    local current = head
    while current.next ~= nil do
        current = current.next
    end

    current.next = line
    return head

end

-- Shift the head of the chunk list to the end of the list
function shiftHeadLineToEnd(head)
    if head == nil or head.next == nil then
        return head  -- If the list has 0 or 1 node, no change needed
    end

    local newHead = head.next

    local current = head
    while current.next ~= nil do
        current = current.next
    end

    current.next = head
    head.next = nil
    return newHead
end

function appendLine(head)
    local lastLine = head
    while lastLine.next ~= nil do
        lastLine = lastLine.next
    end

    return createLine(head, lastLine.start_x + lastLine.length + LINE_MIN_SPACING, LINE_MIN_HEIGHT, LINE_MAX_LENGTH)
end

function updateLines(camera_x)
    if camera_x >= nextPositionToCreateNewLine then -- a chunk left the screen, load the next one
        --chunkChain = getNextChunk(chunkChain) -- load the new chunk
        --chunkChain.pos_x = chunkChain.pos_x + (128 * 3) -- move chunk
        --chunkChain = shiftHeadChunkToEnd(chunkChain) -- shift first chunk to the end of the list
        --nextPositionToCreateNewChunk = nextPositionToCreateNewChunk + 128
        --printh("swap")
        -- printList(chunkChain)
    end
    
    --local headChunk = chunkChain -- get the first chunk in list

end

function drawLines()
    local l = activeLines          -- get the head line in the chain
    for i = 1, LINE_CHAIN_LENGTH do -- iterate through the chunk list, rendering each one

        line(l.start_x, l.height, l.start_x + l.length, l.height)
        l = l.next
        --loadChunkData(headChunk)
       -- map(headChunk.index_x * 16, headChunk.index_y * 16, headChunk.pos_x, 0, 16, 16)
       -- headChunk = headChunk.next
    end

end