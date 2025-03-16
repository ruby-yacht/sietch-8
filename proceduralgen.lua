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

map_x_size = BIOME_DIST.HELL
map_y_size = 16
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

groundlevel = 11 -- relative to tiles, not pixels
player = {} -- for testing

function _init()
    -- Fill all cells with ground
    for x = 0, map_x_size-1 do
        levelgen[x] = {}
        for y = 0, map_y_size-1 do         
            if x <= BIOME_DIST.GRASS then -- MAKE THIS BETTER
                levelgen[x][y] = {x = x, y = y, tile = TILE.GRASS}
            elseif x <= BIOME_DIST.DESERT then
                levelgen[x][y] = {x = x, y = y, tile = TILE.SAND_1}
            elseif x <= BIOME_DIST.MOUNTAIN then
                levelgen[x][y] = {x = x, y = y, tile = TILE.MOUNTAIN_1}
            elseif x <= BIOME_DIST.SNOW then
                levelgen[x][y] = {x = x, y = y, tile = TILE.SNOW_2}
            elseif x <= BIOME_DIST.ORELAND then
                levelgen[x][y] = {x = x, y = y, tile = TILE.ORELAND_1}
            elseif x <= BIOME_DIST.HELL then
                levelgen[x][y] = {x = x, y = y, tile = TILE.HELL_2}
            else
                levelgen[x][y] = {x = x, y = y, tile = TILE.GROUND}
            end  
        end
    end

    -- generate ground by removing ground tiles.
    for x = 0, map_x_size-1 do
        for y = 0, map_y_size-1 do      
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

    hop_mode()
    --test_mode()
end

function _draw()
    cls()
    camera(camera_x, camera_y)

    local visibleTilesX = flr(camera_x) + 16
    local visibleTilesY = flr(camera_y) + 16

    for x = 0, map_x_size-1 do
        for y = 0, map_y_size-1 do     
            local tile = get_tile(x,y).tile
            if tile > 0 then
                
                spr(tile, x * 8, y * 8)

                --Debug
                --print((y - 1) * 8, (x - 1) * 8, (y - 1) * 8)
                --print(y, (x - 1) * 8, (y - 1) * 8)
            end
        end
    end

    --spr(99, new_pos_x, new_pos_y)
    spr(player.sprite, player.x, player.y)

end

function get_tile(x, y)
    if x < 0 or x >= map_x_size or y < 0 or y >= map_y_size then
        printh("(" .. x .. "," .. y .. ") tile index is out of bounds")
        return {tile = -1}
    else
        return levelgen[flr(x)][flr(y)]
    end
end

function get_tile_at_pos(x, y)   
    return get_tile(flr(x / 8) , flr(y / 8))
end

function test_mode()
    camera_x = player.x - 56
    --camera_y = player.y + 64

    player.vx = 0
    player.vy = 0

    if btn(0) then
        player.vx -= 2
     end
     
     if btn(1) then
        player.vx += 2
     end
     
     if btn(2) then
        player.vy -= 2
     end
     
     if btn(3) then
        player.vy += 2
     end

     local player_new_x = player.x + player.vx
     local player_new_y = player.y + player.vy

     checked_position = check_collision(player_new_x, player_new_y, player.x, player.y)

     player.x = checked_position.x
     player.y = checked_position.y
    
end

function hop_mode()
    camera_x += .5
    camera_x = min(camera_x, (map_x_size-16) * 8)

    -- Process key input
    while player.onGround and stat(30) do
        keyInput = stat(31)
        player.vx = 1
        player.vy = -3
    end

    -- Apply gravity
    if player.onGround == false then
        player.vy += .3
    else
        if player.vy >= 0 then -- if just landed
            player.vx = 0
        end
    end
    
    local player_new_x = player.x + player.vx
    local player_new_y = player.y + player.vy

    -- Check for collisions
    local checked_position = check_collision(player_new_x, player_new_y, player.x, player.y)
    player.onGround = checked_position.onGround

    player.x = checked_position.x
    player.y = checked_position.y
end

function check_collision(new_x, new_y, x,y)
    local new_x_unit = new_x / 8
    local new_y_unit = new_y / 8
    local x_unit = player.x / 8
    local y_unit = player.y / 8
    local onGround = false

    if get_tile(new_x_unit, y_unit).tile ~= TILE.NONE or get_tile(new_x_unit, y_unit + 0.999).tile ~= TILE.NONE then
        new_x_unit = flr(new_x_unit) + 1
    elseif get_tile(new_x_unit + 1, y_unit).tile ~= TILE.NONE or get_tile(new_x_unit + 1, y_unit + 0.999).tile ~= TILE.NONE then
        new_x_unit = flr(new_x_unit)
    end

    if get_tile(x_unit, new_y_unit).tile ~= TILE.NONE or get_tile(x_unit+0.999, new_y_unit).tile ~= TILE.NONE then
        new_y_unit = flr(new_y_unit) + 1
    elseif get_tile(x_unit, new_y_unit + 1).tile ~= TILE.NONE or get_tile(x_unit+0.999, new_y_unit + 1).tile ~= TILE.NONE then
        new_y_unit = flr(new_y_unit)
        onGround = true
    end

    new_x = new_x_unit * 8
    new_y = new_y_unit * 8

    return {x = new_x, y = new_y, onGround = onGround} -- this is returning nil for some reason
end
