levelgen = {}
chunk_x_size = 16
chunk_y_size = 16
-- tile ids: air = 0; grass = 2; ground = 3; wall = 4; 
TILE = {
    NONE = 0,
    GRASS = 2,
    GROUND = 3,
    WALL = 4
}

groundlevel = 12 -- relative to tiles, not pixels

function _init()

    -- according to deepseek, this is "more memory-efficient and faster for large grids."
    -- Please compare the performance when you get a chance
    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do
            local index = (y - 1) * chunk_x_size + x -- Calculate 1D index
            levelgen[index] = {tile = TILE.GROUND}
        end
    end

    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do      

            local h = sin( ((x-1) / chunk_x_size)) + 4 * sin( ((x-1) / chunk_x_size) * 1.5)  -- Normalize x to [0, 1] (remember to explain why dividing by chunk_x_size fixes sin output)
            --h = 2 * sin( ((x-1) / chunk_x_size) * 2)
            if y - groundlevel < h then
                get_tile(x,y).tile = TILE.NONE
            end
            
        end
    end
    printh("------------------------")
end

function _update()

end

function _draw()
    cls()

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