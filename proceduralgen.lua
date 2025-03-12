poke(0x5F2D, 0x1) -- enable keyboard input

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
player = {} -- for testing

function _init()

    -- according to deepseek, this is "more memory-efficient and faster for large grids."
    -- Please compare the performance when you get a chance
    -- Fill all cells with ground
    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do
            local index = (y - 1) * chunk_x_size + x -- Calculate 1D index
            

            if x <= BIOME_DIST.GRASS then -- MAKE THIS BETTER
                levelgen[index] = {x = x, y = y, tile = TILE.GRASS}
            elseif x <= BIOME_DIST.DESERT then
                levelgen[index] = {x = x, y = y, tile = TILE.SAND_1}
            elseif x <= BIOME_DIST.MOUNTAIN then
                levelgen[index] = {x = x, y = y, tile = TILE.MOUNTAIN_1}
            elseif x <= BIOME_DIST.SNOW then
                levelgen[index] = {x = x, y = y, tile = TILE.SNOW_2}
            elseif x <= BIOME_DIST.ORELAND then
                levelgen[index] = {x = x, y = y, tile = TILE.ORELAND_1}
            elseif x <= BIOME_DIST.HELL then
                levelgen[index] = {x = x, y = y, tile = TILE.HELL_2}
            else
                levelgen[index] = {x = x, y = y, tile = TILE.GROUND}
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

    player = {
        x = 20, 
        y = 50, 
        width = 8, 
        height = 8, 
        boundsOffsetX = 0, 
        boundsOffsetY = 0, 
        vx = 0, 
        vy = 0, 
        onGround = false, 
        bounce_force = minBounceForce, 
        key=70, 
        sprite = 70, 
        disabled = false,
        disabledCount = 0,
        totalTimeEnabled = 0,
        won = false
    }
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

    -- Process key input
    while player.onGround and stat(30) do
        keyInput = stat(31)
        player.vx = 1
        player.vy = -3
    end

    -- Apply gravity
    if player.onGround == false then
        player.vy += .2
    else
        if player.vy > 0 then -- if just landed
            player.vx = 0
        end
    end
    
    new_pos_x = player.x + player.vx
    new_pos_y = player.y + player.vy
    --printh("x " .. new_pos_x .. " y " .. new_pos_y .. " | vx " .. player.vx .. " vy " .. player.vy)

    -- Check for collisions
    local checked_position = check_collision(player, new_pos_x, new_pos_y)
    player.onGround = checked_position.onGround
    -- Update player position based on movement
    player.x = checked_position.x
    player.y = checked_position.y

end

function _draw()
    cls()
    camera(camera_x, camera_y)

    for y = 1, chunk_y_size do
        for x = 1, chunk_x_size do     
            local tile = get_tile(x,y).tile
            if tile > 0 then
                
                spr(tile, (x - 1) * 8, (y - 1) * 8)
                --print((y - 1) * 8, (x - 1) * 8, (y - 1) * 8)
                --print(y, (x - 1) * 8, (y - 1) * 8)
            end
        end
    end

    spr(99, new_pos_x, new_pos_y)
    spr(player.sprite, player.x, player.y)

end

function get_tile(x, y)
    if x <= 0 or x > chunk_x_size or y <= 0 or y > chunk_y_size then
        --printh("(" .. x .. "," .. y .. ") tile index is out of bounds")
        return {tile = -1}
    else
        local index = (y - 1) * chunk_x_size + x
        return levelgen[index]
    end
end

function get_tile_at_pos(x, y)   
    return get_tile(flr(x / 8) + 1, flr(y / 8) + 1)
end


function check_collision(p, new_x, new_y)
    local collision_data = {x = new_x, y = new_y, onGround = false}
    --local dumb = 0
    -- four corners of the hit box
    local top_left_point = {x = new_x, y = new_y}
    local top_right_point = {x = new_x + p.width, y = new_y}
    local bottom_left_point = {x=new_x, y=new_y+p.height}
    local bottom_right_point = {x=new_x + p.width, y=new_y+p.height}

    -- check ground tiles
    local bottom_tile_at_left_point = get_tile_at_pos(bottom_left_point.x, bottom_left_point.y)
    local bottom_tile_at_right_point = get_tile_at_pos(bottom_right_point.x, bottom_right_point.y)

    if bottom_tile_at_left_point.tile ~= TILE.NONE or bottom_tile_at_right_point.tile ~= TILE.NONE then
        collision_data.onGround = true
        --dumb = 1

        -- use the best point or the left one
        if  bottom_tile_at_left_point.tile == -1 and bottom_tile_at_right_point.tile ~= -1 then
            collision_data.y = bottom_tile_at_right_point.y*8-8 - p.height
        elseif (bottom_tile_at_left_point.tile ~= -1 and bottom_tile_at_right_point.tile == -1) or (bottom_tile_at_left_point.tile ~= -1 and bottom_tile_at_right_point.tile ~= -1) then
            collision_data.y = bottom_tile_at_left_point.y*8-8 - p.height
        end
        
    end
    
    --printh("Bottom_left is at " .. bottom_left_point.y .. " so I see " .. bottom_tile_at_left_point.y .. " at " .. bottom_tile_at_left_point.y*8-8 .. "px. onGround = " .. dumb)

    return collision_data

end