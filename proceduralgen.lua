poke(0x5F2D, 0x1) -- enable keyboard input

chunks = {} -- 2 or 3 chunk tables

local TERRAIN_Y_OFFSET = 0

biome_length = 64
BIOME_DIST = {
    GRASS = 0,
    DESERT = 0,
    MOUNTAIN = 0,
    SNOW = 0,
    ORELAND = 0,
    HELL = 0
}

map_x_size = 0
map_y_size = 32
local chunk_x_size = 16
local hole_width = 3
local new_chunk_threshold = 128
local chunk_start_unit = 0
local draw_hole_chance = .5

-- tile ids: air = 0; grass = 2; ground = 3; wall = 4; 

TILE = {
    NONE = 0,
    GRASS = 2,
    GROUND = 3,
    WALL = 4,
    SAND_1 = 93,
    SAND_2 = 94,
    SAND_3 = 95,
    MOUNTAIN_1 = 96,
    MOUNTAIN_2 = 97,
    MOUNTAIN_3 = 99,
    SNOW_1 = 99,
    SNOW_2 = 100,
    SNOW_3 = 101,
    ORELAND_1 = 102,
    ORELAND_2 = 103,
    ORELAND_3 = 104,
    HELL_1 = 105,
    HELL_2 = 106,
    HELL_3 = 107
}

groundlevel = 11 -- relative to tiles, not pixels

function init_terrain_gen(yOffset)
    TERRAIN_Y_OFFSET = yOffset
    chunks = {}
    set_biome_distances()
    chunk_start_unit = 0

    -- generate initial terrain
    add(chunks, generate_terrain_chunk(chunk_start_unit))
    chunk_start_unit += chunk_x_size
    add(chunks, generate_terrain_chunk(chunk_start_unit)) -- each chunk costs 20% cpu to draw!

end

-- BUG chunks stop loading after death
function update_terrain_chunks(generated_chunk_callback)
    -- if camera passes threshold, then remove oldest chunk and generate a new one.
    if camera_x >= new_chunk_threshold then
        new_chunk_threshold += 128
        chunk_start_unit += chunk_x_size
        local new_chunk = generate_terrain_chunk(chunk_start_unit)
        add(chunks, new_chunk)

        local chunk_to_remove = new_chunk
        for chunk in all(chunks) do
            if chunk.x_offset_unit < chunk_to_remove.x_offset_unit then
                chunk_to_remove = chunk
            end
        end

        del(chunks, chunk_to_remove)
        generated_chunk_callback(new_chunk)
    end
end

function generate_terrain_chunk(x_offset_unit)

    local chunk = {x_offset_unit = x_offset_unit, tiles = {}, surface_tiles = {}}

    -- Fill all cells with ground
    for x = x_offset_unit, x_offset_unit+chunk_x_size-1 do
        chunk.tiles[x] = {}
        for y = 0, map_y_size-1 do -- this creates 31 tiles FYI   
            if x < BIOME_DIST.GRASS then
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.GROUND}
            elseif x < BIOME_DIST.DESERT then
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.SAND_1}
            elseif x < BIOME_DIST.MOUNTAIN then
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.MOUNTAIN_2}
            elseif x < BIOME_DIST.SNOW then
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.SNOW_2}
            elseif x < BIOME_DIST.ORELAND then
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.ORELAND_1}
            elseif x < BIOME_DIST.HELL then
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.HELL_2}
            else
                chunk.tiles[x][y] = {x = x, y = y, tile = TILE.GROUND}
            end  
        end
    end

    --printh(#chunk.tiles[x_offset_unit])
    --printh(chunk.x_offset_unit)

    -- generate ground by removing ground tiles.
    -- Q: should I store the surface in an array? Then know which tiles I can spawn or modify on the surface.
    for x = x_offset_unit, x_offset_unit+chunk_x_size-1 do
        for y = 0, map_y_size-1 do      
            local h = get_cell_height_at_(x) + TERRAIN_Y_OFFSET -- Normalize x to [0, 1] (remember to explain why dividing by chunk_x_size fixes sin output)
            --h = 2 * sin( ((x-1) / chunk_x_size) * 2)
            if y - groundlevel < h then
                chunk.tiles[x][y].tile = TILE.NONE
            end
            
        end
    end
    
    -- draw a holes randomly
    if x_offset_unit > 0 and rnd(1) >= 1-draw_hole_chance then
        local random_x_pos = flr(rnd(chunk_x_size-hole_width))
        local hole_start = x_offset_unit + random_x_pos

        for x = hole_start , hole_start + hole_width, 1 do
            for y = 0, map_y_size-1, 1 do
                chunk.tiles[x][y].tile = TILE.NONE   
            end
            
        end
    end


    -- get all surface tiles. Update surface sprites if needed
    for x = x_offset_unit, x_offset_unit+chunk_x_size-1 do
        for y = 1, map_y_size-1 do 

            local above_tile = chunk.tiles[x][y-1]
            local target_tile = chunk.tiles[x][y]

            if above_tile.tile == TILE.NONE and target_tile.tile ~= TILE.NONE then
                add(chunk.surface_tiles, target_tile)

                if x < BIOME_DIST.GRASS then
                    target_tile.tile = TILE.GRASS
                elseif x < BIOME_DIST.DESERT then
                    --target_tile.tile = TILE.GRASS
                elseif x < BIOME_DIST.MOUNTAIN then
                    target_tile.tile = TILE.MOUNTAIN_1
                elseif x < BIOME_DIST.SNOW then
                    --target_tile.tile = TILE.GRASS
                elseif x < BIOME_DIST.ORELAND then
                    --target_tile.tile = TILE.GRASS
                elseif x < BIOME_DIST.HELL then
                    --target_tile.tile = TILE.GRASS
                else
                    --target_tile.tile = TILE.GRASS
                end
            end
            
        end
    end


    return chunk
end

function set_biome_distances()

    local cumulative_dist = 0

    BIOME_DIST.GRASS = biome_length + cumulative_dist
    cumulative_dist = BIOME_DIST.GRASS
    BIOME_DIST.DESERT = biome_length + cumulative_dist
    cumulative_dist = BIOME_DIST.DESERT
    BIOME_DIST.MOUNTAIN = biome_length + cumulative_dist
    cumulative_dist = BIOME_DIST.MOUNTAIN
    BIOME_DIST.SNOW = biome_length + cumulative_dist
    cumulative_dist = BIOME_DIST.SNOW
    BIOME_DIST.ORELAND = biome_length + cumulative_dist
    cumulative_dist = BIOME_DIST.ORELAND
    BIOME_DIST.HELL = biome_length + cumulative_dist
    cumulative_dist = BIOME_DIST.HELL

    map_x_size = BIOME_DIST.HELL
end

function get_cell_height_at_(x)

    if x <= BIOME_DIST.GRASS then
        return biome_grass_height_at_(x)
    elseif x <= BIOME_DIST.DESERT then
        return biome_desert_height_at_(x)
    elseif x <= BIOME_DIST.MOUNTAIN then
        return biome_mountain_height_at_(x)
    else
        return biome_grass_height_at_(x)
    end

end

function biome_grass_height_at_(x) -- lower ground level
    return sin( ((x-1) / 16))
end

function biome_desert_height_at_(x)
    return sin( ((x-1) / 8))
end

function biome_mountain_height_at_(x) -- raise ground level?
    return sin( ((x-1) / 16)) + 4 * sin( ((x-1) / 16) * 1.5)
end

function draw_holes()
    local hole_width = 3

    -- draw holes at the end of each biome
    for i = biome_length-hole_width, map_x_size-biome_length-hole_width, biome_length do
        for x = i, i + hole_width - 1, 1 do
            for y = 0, map_y_size - 1 do
                chunks[x][y].tile = TILE.NONE   
            end
        end
    end


    --[[
     -- every X tiles.
    local hole_distance = 5
    local last_hole_pos = 0
    for i = 0, (map_x_size-1)-hole_width, 1 do
        if i > last_hole_pos + hole_width + hole_distance then

            for x = i, i + hole_width, 1 do
                for y = 0, map_y_size-1, 1 do
                    printh( x .. " " .. y)
                    levelgen[x][y].tile = TILE.NONE   
                end
                
            end

            last_hole_pos = i
            i += hole_width

        end
    end
    ]]

end

function draw_terrain()
    --local visibleTilesX = flr(camera_x) + 16
    --local visibleTilesY = flr(camera_y) + 16

    for chunk in all(chunks) do
        for x = chunk.x_offset_unit, chunk.x_offset_unit+chunk_x_size-1 do
            for y = 0, map_y_size-1 do     
                local tile = get_tile(x,y).tile
                if tile > 0 then -- no error was returned
                    
                    spr(tile, x * 8, y * 8)
    
                    --Debug
                    --print((y - 1) * 8, (x - 1) * 8, (y - 1) * 8)
                    --print(y, (x - 1) * 8, (y - 1) * 8)
                end
            end
        end
    end

end

function get_tile(x, y)
    if x < 0 or x >= map_x_size or y < 0 or y >= map_y_size then
        printh("(" .. x .. "," .. y .. ") tile index is out of bounds")
        return {tile = -1}
    else

        local chunk = {tile = -1}

        x = flr(x)
        y = flr(y)

        -- 1. Identify which chunk to search for
        for c in all(chunks) do
            if x >= c.x_offset_unit and x < c.x_offset_unit + chunk_x_size then
                chunk = c
                break;
            end
        end

        if chunk.tile == -1 then
            printh("(" .. x .. "," .. y .. ") tile not found")
            return chunk
        end

        -- 2. Return tile from the correct chunk
        return chunk.tiles[x][y]
    end
end

function get_tile_at_pos(x, y)   
    return get_tile(flr(x / 8) , flr(y / 8))
end

function check_collision(new_x, new_y, x,y, hit_wall_callback)
    -- convert world positions to grid positions
    local new_x_unit = new_x / 8
    local new_y_unit = new_y / 8
    local x_unit = x / 8
    local y_unit = y / 8
    local onGround = false
    local hit_wall = false

    --printh(new_x)
    -- check X axis collisions
    if get_tile(new_x_unit, y_unit).tile ~= TILE.NONE or get_tile(new_x_unit, y_unit + 0.999).tile ~= TILE.NONE then
        new_x_unit = flr(new_x_unit) + 1
        hit_wall = true
    elseif get_tile(new_x_unit + 1, y_unit).tile ~= TILE.NONE or get_tile(new_x_unit + 1, y_unit + 0.999).tile ~= TILE.NONE then
        new_x_unit = flr(new_x_unit)
        hit_wall = true
    end

    -- check Y axis collisions
    if get_tile(x_unit, new_y_unit).tile ~= TILE.NONE or get_tile(x_unit+0.999, new_y_unit).tile ~= TILE.NONE then
        new_y_unit = flr(new_y_unit) + 1
    elseif get_tile(x_unit, new_y_unit + 1).tile ~= TILE.NONE or get_tile(x_unit+0.999, new_y_unit + 1).tile ~= TILE.NONE then
        new_y_unit = flr(new_y_unit)
        onGround = true
    end

    -- convert grid positions to world positions
    new_x = new_x_unit * 8
    new_y = new_y_unit * 8

    return {x = new_x, y = new_y, onGround = onGround, hit_wall = hit_wall} -- this is returning nil for some reason
end
