

-- Example player position (replace with actual player logic)
local player_x = 64
local player_y = 64

-- Example camera position (replace with actual camera logic)
local camera_x = 0
local camera_y = 0
local nextPositionToCreateNewChunk = 128

local chunkChain = nil

function getNextChunk(chunk)
    local chunkX = flr(rnd(8)) * 16
    local chunkY = 0

    return {
        index_x = chunkX,
        index_y = chunkY,
        pos_x = chunk.pos_x + (128 * 2),
        pos_y = chunk.pos_y + (128 * 2),
        next = chunk.next
    }


end

--local chunk = getNextChunk()





function addChunk(head, index_x, index_y, pos_x, pos_y)
    local chunk = {
        index_x = index_x,
        index_y = index_y,
        pos_x = pos_x,
        pos_y = pos_y,
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

    -- 1, 2, 3
    -- 0, 128, 256.. (n-1) * 128
    -- n is camera_x.. n = floor(camera_x / 128)

    -- if n

    if camera_x >= nextPositionToCreateNewChunk then
        chunkChain = getNextChunk(chunkChain)
        chunkChain = shiftHeadChunkToEnd(chunkChain)
        nextPositionToCreateNewChunk = nextPositionToCreateNewChunk + 128
        printh("swap")
    end

    local headChunk = chunkChain

    for i = 0, 2 do
        map(headChunk.index_x * 16, headChunk.index_y * 16, headChunk.pos_x, headChunk.pos_y, 16, 16)
        headChunk = headChunk.next
    end
        
        


    --map(chunk.x, chunk.y,0,0,16,16)

end

function _init()
    -- Create an empty list
    
    -- Add nodes to the list
    chunkChain = addChunk(chunkChain, 0, 0, 0, 0)
    chunkChain = addChunk(chunkChain, 1, 0, 128, 0)
    chunkChain = addChunk(chunkChain, 2, 0, 256, 0)

    --chunkChain = shiftHeadChunkToEnd(chunkChain)
    --printList(chunkChain)

   

end

function _update()
    -- Example player movement (replace with actual player movement logic)
    if btn(0) then  -- left arrow
        player_x = player_x - 1
    elseif btn(1) then  -- right arrow
        player_x = player_x + 1
    end
end

function _draw()
    cls()

      -- Traverse and print the list
   

    -- Draw background, HUD, etc.

    -- Load and draw chunks within view
    loadChunksIntoView(camera_x)

    camera_x = camera_x + .5
    camera(camera_x, camera_y)
    
    -- Draw player (replace with actual player drawing logic)
    spr(1, player_x, player_y)  -- Player sprite ID

    -- Draw enemies, items, etc.

      
end

function printList(list)
    printh("====")
    local current = list
    while current ~= nil do
        printh(current.pos_x)
        current = current.next
    end
end