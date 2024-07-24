

-- Example player position (replace with actual player logic)
local player_x = 64
local player_y = 64

-- Example camera position (replace with actual camera logic)
local camera_x = 0
local camera_y = 0

function getNextChunk()
    local chunkX = flr(rnd(8)) * 16
    local chunkY = 0

    return {x = chunkX, y = chunkY}

end

local chunk = getNextChunk()

function loadChunksIntoView(camera_x)

    map(chunk.x, chunk.y,0,0,16,16)
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

    -- Draw background, HUD, etc.

    -- Load and draw chunks within view
    loadChunksIntoView(camera_x)

    --camera_x = camera_x + .5
    --camera(camera_x, camera_y)
    
    -- Draw player (replace with actual player drawing logic)
    spr(1, player_x, player_y)  -- Player sprite ID

    -- Draw enemies, items, etc.
end
