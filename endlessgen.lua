local LINE_MIN_LENGTH = 50
local LINE_MAX_LENGTH = 100
local LINE_SPACING = {10, 20}
local LINE_MIN_HEIGHT = 100
local LINE_MAX_HEIGHT = 120
LINE_CHAIN_LENGTH = 3

-- init vars
local nextPositionToCreateNewLine = 0
activeLines = {}

function initLines()
    activeLines = nil
    activeLines = initLine(activeLines, 0, 120, 140)
    nextPositionToCreateNewLine = activeLines.length
    activeLines = appendLine(activeLines)
    activeLines = appendLine(activeLines)
end

-- Creates a new line and appends it to the provided line list via head
-- Should only be called in init()
function initLine(head, start_x, height, length)
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

    return initLine(head, lastLine.start_x + lastLine.length + rnd(LINE_SPACING), getRandomHeight(), LINE_MAX_LENGTH)
end

function createRandomLine(head)
    local lastLine = head
    while lastLine.next ~= nil do
        lastLine = lastLine.next
    end

    local spacing = getRandomSpacing()
    head.start_x = lastLine.start_x + lastLine.length + spacing
    local height = flr(LINE_MIN_HEIGHT + rnd(LINE_MAX_HEIGHT - LINE_MIN_HEIGHT))
    head.height = height
    return head
end

function getRandomSpacing()
    return rnd(LINE_SPACING)
end

function getRandomHeight()
    return flr(LINE_MIN_HEIGHT + rnd(LINE_MAX_HEIGHT - LINE_MIN_HEIGHT))
end

function updateLines(camera_x)
    if camera_x > nextPositionToCreateNewLine then -- a line left the screen
        activeLines = createRandomLine(activeLines)
        activeLines = shiftHeadLineToEnd(activeLines)
        nextPositionToCreateNewLine = activeLines.start_x + activeLines.length
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

--[[
unction check_collision(px, py)
    for l in all(lines) do
        if py + PLAYER_HEIGHT > l.y and py < l.y and px + PLAYER_WIDTH > l.x and px < l.x + LINE_LENGTH then
            return l.y
        end
    end
    return nil
end

-- _init function
function _init()
    init_lines()
end

-- _update function
function _update()
    -- move player with keyboard input
    if btn(0) then PLAYER_X -= 2 end -- left
    if btn(1) then PLAYER_X += 2 end -- right

    -- gravity
    PLAYER_Y_VEL += 0.2
    PLAYER_Y += PLAYER_Y_VEL
    
    -- check for collision with lines
    local collision_y = check_collision(PLAYER_X, PLAYER_Y)
    if collision_y then
        if PLAYER_Y_VEL > 0 then -- falling
            PLAYER_Y = collision_y - PLAYER_HEIGHT
            PLAYER_Y_VEL = 0
        end
    end

    -- keep player within screen bounds
    if PLAYER_X < 0 then PLAYER_X = 0 end
    if PLAYER_X > 128 - PLAYER_WIDTH then PLAYER_X = 128 - PLAYER_WIDTH end
    if PLAYER_Y > SCREEN_HEIGHT - PLAYER_HEIGHT then PLAYER_Y = SCREEN_HEIGHT - PLAYER_HEIGHT end
end
]]