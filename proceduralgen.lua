poke(0x5F2D, 0x1) -- enable keyboard input

levelgen = {}
surface_tiles = {}

biome_length = 64
BIOME_DIST = {
    GRASS = 0,
    DESERT = 0,
    MOUNTAIN = 0,
    SNOW = 0,
    ORELAND = 0,
    HELL = 0
}

map_x_size = -1
map_y_size = 32
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
testmode = false




function generate_terrain(yOffset)

    set_biome_distances()

    -- Fill all cells with ground
    for x = 0, map_x_size-1 do
        levelgen[x] = {}
        for y = 0, map_y_size-1 do         
            if x < BIOME_DIST.GRASS then
                levelgen[x][y] = {x = x, y = y, tile = TILE.GROUND}
            elseif x < BIOME_DIST.DESERT then
                levelgen[x][y] = {x = x, y = y, tile = TILE.SAND_1}
            elseif x < BIOME_DIST.MOUNTAIN then
                levelgen[x][y] = {x = x, y = y, tile = TILE.MOUNTAIN_2}
            elseif x < BIOME_DIST.SNOW then
                levelgen[x][y] = {x = x, y = y, tile = TILE.SNOW_2}
            elseif x < BIOME_DIST.ORELAND then
                levelgen[x][y] = {x = x, y = y, tile = TILE.ORELAND_1}
            elseif x < BIOME_DIST.HELL then
                levelgen[x][y] = {x = x, y = y, tile = TILE.HELL_2}
            else
                levelgen[x][y] = {x = x, y = y, tile = TILE.GROUND}
            end  
        end
    end

    -- generate ground by removing ground tiles.
    -- Q: should I store the surface in an array? Then know which tiles I can spawn or modify on the surface.
    for x = 0, map_x_size-1 do
        for y = 0, map_y_size-1 do      
            local h = get_cell_height_at_(x) + yOffset -- Normalize x to [0, 1] (remember to explain why dividing by chunk_x_size fixes sin output)
            --h = 2 * sin( ((x-1) / chunk_x_size) * 2)
            if y - groundlevel < h then
                get_tile(x,y).tile = TILE.NONE
            end
            
        end
    end
    
    draw_holes()

    -- get all surface tiles. Update surface sprites if needed
    for x = 0, map_x_size-1 do
        for y = 1, map_y_size-1 do 

            local above_tile = get_tile(x, y-1)
            local target_tile = get_tile(x,y)

            if above_tile.tile == TILE.NONE and target_tile.tile ~= TILE.NONE then
                add(surface_tiles, target_tile)

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
                levelgen[x][y].tile = TILE.NONE   
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

function _update()
    if testmode then
        test_mode()
    end
end

function draw_terrain()
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

--[[    -- draw surface tiles (useful for debugging)
    for index, tile in ipairs(surface_tiles) do
        spr(tile.tile, tile.x * 8, tile.y * 8)
    end
]]

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

function get_surface_tile_at(x)

     -- get all surface tiles. Update surface sprites if needed

    for y = 1, map_y_size-1 do 

        local above_tile = get_tile(x, y-1)
        local target_tile = get_tile(x,y)

        if above_tile.tile == TILE.NONE and target_tile.tile ~= TILE.NONE then
            return target_tile
        end
        
    end
  

    return nil
    
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

    while stat(30) do
        keyInput = stat(31)
        if keyInput == "t" then
            testmode = false
        end        
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
    while stat(30) do
        keyInput = stat(31)
        if keyInput == "t" then
            testmode = true
        elseif player.onGround then
            player.vx = 1
            player.vy = -3
        end
        
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
    -- convert world positions to grid positions
    local new_x_unit = new_x / 8
    local new_y_unit = new_y / 8
    local x_unit = x / 8
    local y_unit = y / 8
    local onGround = false

    -- check X axis collisions
    if get_tile(new_x_unit, y_unit).tile ~= TILE.NONE or get_tile(new_x_unit, y_unit + 0.999).tile ~= TILE.NONE then
        new_x_unit = flr(new_x_unit) + 1
    elseif get_tile(new_x_unit + 1, y_unit).tile ~= TILE.NONE or get_tile(new_x_unit + 1, y_unit + 0.999).tile ~= TILE.NONE then
        new_x_unit = flr(new_x_unit)
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

    return {x = new_x, y = new_y, onGround = onGround} -- this is returning nil for some reason
end
