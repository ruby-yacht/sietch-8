levelgen = {}

BIOME_DIST = {
    GRASS = 16,
    DESERT = 32,
    MOUNTAIN = 48,
    SNOW = 64,
    ORELAND = 80,
    HELL = 96
}

chunk_x_size = BIOME_DIST.HELL
chunk_y_size = 16
camera_x = 0
camera_y = 0
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

groundlevel = 12 -- relative to tiles, not pixels


function _init()

    -- according to deepseek, this is "more memory-efficient and faster for large grids."
    -- Please compare the performance when you get a chance
    -- Fill all cells with ground
    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do
            local index = (y - 1) * chunk_x_size + x -- Calculate 1D index
            

            if x <= BIOME_DIST.GRASS then -- MAKE THIS BETTER
                levelgen[index] = {tile = TILE.GRASS}
            elseif x <= BIOME_DIST.DESERT then
                levelgen[index] = {tile = TILE.SAND_1}
            elseif x <= BIOME_DIST.MOUNTAIN then
                levelgen[index] = {tile = TILE.MOUNTAIN_1}
            elseif x <= BIOME_DIST.SNOW then
                levelgen[index] = {tile = TILE.SNOW_2}
            elseif x <= BIOME_DIST.ORELAND then
                levelgen[index] = {tile = TILE.ORELAND_1}
            elseif x <= BIOME_DIST.HELL then
                levelgen[index] = {tile = TILE.HELL_2}
            else
                levelgen[index] = {tile = TILE.GROUND}
            end  
        end
    end

    -- generate ground by removing ground tiles.
    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do      




            local h = get_cell_height_at_(x)  -- Normalize x to [0, 1] (remember to explain why dividing by chunk_x_size fixes sin output)
            --h = 2 * sin( ((x-1) / chunk_x_size) * 2)
            if y - groundlevel < h then
                get_tile(x,y).tile = TILE.NONE
            end
            
        end
    end
    --printh("------------------------")
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

function _update()
    camera_x += .5
    camera_x = min(camera_x, (chunk_x_size-16) * 8)
end

function _draw()
    cls()
    camera(camera_x, camera_y)
    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do     
            local tile = get_tile(x,y).tile
            if tile > 0 then
                spr(tile, (x - 1) * 8, (y - 1) * 8)
            end
        end
    end

end

function get_tile(x, y)
    local index = (y - 1) * chunk_x_size + x
    return levelgen[index]
end