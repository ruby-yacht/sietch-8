--[[
CURRENT LEVEL GEN METHOD

Chunks are stored in a linked list data structure. ChunkChain references to the head of the linked list.
The list has a length of 3.

]]

local camera_x = 0
local camera_y = 0
local nextPositionToCreateNewChunk = 128 -- used to check when the next chunk needs to be loaded
local chunkChain = nil -- head of the chunk list

-- Creates a new chunk and appends it to the provided chunk list via head
-- Should only be called in init()
function addChunk(head, index_x, index_y, pos_x)
    local chunk = {
        index_x = index_x,
        index_y = index_y,
        pos_x = pos_x,
        next = nil
    }

    if head == nil then
        return chunk
    end
    
    local current = head
    while current.next ~= nil do
        current = current.next
    end

    current.next = chunk
    return head

end

-- Get a random chunk from the map
function getNextChunk(chunk)
    local chunkX = flr(rnd(8))
    local chunkY = flr(rnd(4))

    return {
        index_x = chunkX,
        index_y = chunkY,
        pos_x = chunk.pos_x,
        next = chunk.next
    }
end

-- Shift the head of the chunk list to the end of the list
function shiftHeadChunkToEnd(head)
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

function loadChunksIntoView(camera_x)
    if camera_x >= nextPositionToCreateNewChunk then -- a chunk left the screen, load the next one
        chunkChain = getNextChunk(chunkChain) -- load the new chunk
        chunkChain.pos_x = chunkChain.pos_x + (128 * 3) -- move chunk
        chunkChain = shiftHeadChunkToEnd(chunkChain) -- shift first chunk to the end of the list
        nextPositionToCreateNewChunk = nextPositionToCreateNewChunk + 128
        --printh("swap")
        -- printList(chunkChain)
    end
    
    local headChunk = chunkChain -- get the first chunk in list

    for i = 0, 2 do -- iterate through the chunk list, rendering each one
        map(headChunk.index_x * 16, headChunk.index_y * 16, headChunk.pos_x, 0, 16, 16)
        headChunk = headChunk.next
    end

end

function _init()
    -- Add chunks to the list
    chunkChain = addChunk(chunkChain, 0, 0, 0)
    chunkChain = addChunk(chunkChain, 1, 0, 128)
    chunkChain = addChunk(chunkChain, 2, 0, 256)
   

end

function _draw()
    cls()

    loadChunksIntoView(camera_x)

    camera_x = camera_x + .5
    camera(camera_x, camera_y)

      
end

-- for testing
function printList(list)
    printh("====")
    local current = list
    while current ~= nil do
        printh(current.pos_x)
        current = current.next
    end
end