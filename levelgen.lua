-- Constants
local CHUNK_SIZE_X = 4  -- Width of each chunk in tiles
local CHUNK_SIZE_Y = 14  -- Height of each chunk in tiles
local CHUNKS_PER_ROW = 8 -- Number of chunks to load horizontally
local CHUNKS_PER_COL = 8 -- Number of chunks to load vertically

-- Example chunk definitions (2D arrays of sprite IDs)
local chunks = {
    {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0}
    },
    {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 4},
        {0, 0, 0, 4},
        {0, 0, 0, 4}
    },

    -- Add more chunks as needed
}

-- Example map initialization
local map = {}

-- Function to randomly select a chunk
function getRandomChunk()
    local index = flr(rnd(#chunks)) + 1  -- Randomly select an index from chunks
    return chunks[index]
end

-- Function to generate map with random chunks
function generateMap(num_chunks)
    for y = 1, num_chunks do
        map[y] = {}
        for x = 1, num_chunks do
            map[y][x] = getRandomChunk()
        end
    end
end

-- Generate initial map
generateMap(CHUNKS_PER_ROW * CHUNKS_PER_COL)

-- Function to draw a chunk
function drawChunk(chunk, start_x, start_y)
    for y = 1, #chunk do
        for x = 1, #chunk[y] do
            local sprite_id = chunk[y][x]
            spr(sprite_id, start_x + (x - 1) * 8, start_y + (y - 1) * 8)
        end
    end
end

-- Function to load and draw chunks within view
function loadChunksInView(camera_x, camera_y)
    local start_chunk_x = flr(camera_x / CHUNK_SIZE_X)
    local start_chunk_y = flr(camera_y / CHUNK_SIZE_Y)

    for y = start_chunk_y, start_chunk_y + CHUNKS_PER_COL do
        for x = start_chunk_x, start_chunk_x + CHUNKS_PER_ROW do
            if map[y] and map[y][x] then
                local chunk = map[y][x]
                drawChunk(chunk, x * CHUNK_SIZE_X * 8, y * CHUNK_SIZE_Y * 8)
            end
        end
    end
end

-- Example player position (replace with actual player logic)
local player_x = 64
local player_y = 64

-- Example camera position (replace with actual camera logic)
local camera_x = 0
local camera_y = 0

function _update()
    -- Example player movement (replace with actual player movement logic)
    if btn(0) then  -- left arrow
        player_x = player_x - 1
    elseif btn(1) then  -- right arrow
        player_x = player_x + 1
    end
    
    -- Example camera following player (replace with actual camera logic)
    camera_x = player_x - 64
    camera_y = player_y - 64
end

function _draw()
    cls()

    -- Draw background, HUD, etc.

    -- Load and draw chunks within view
    loadChunksInView(camera_x, camera_y)
    
    -- Draw player (replace with actual player drawing logic)
    spr(1, player_x, player_y)  -- Player sprite ID

    -- Draw enemies, items, etc.
end
