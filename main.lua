poke(0x5F2D, 0x1) -- enable keyboard input

local timeUntilCameraMoves = 1.5
local timeUntilRestart = 2
local debug = false
local victory = false
local win_order = {}
local delta_time
local last_time

local camera_speed = 15

function _init()
    -- reset variables
    gameStarted = false
    gameOver = false
    start_position = 0
    camera_x = start_position
    camera_y = 80
    timeUntilCameraMoves = 1.5
    
    last_time = 0
    delta_time = 0
    timeUntilRestart = 2
    last_time = time()
    victory = false
    start_time = time()

    -- level generation
    init_terrain_gen(10)
    max_camera_distance = (map_x_size - 16) * 8

    load_zombie_pool(2)
    --spawn_zombie(7,20)
end

function restart()
    cls()
    resetPlayers() -- input is being read after game over state but before proper reset
    win_order = {}
    _init()
end

chunk_generated_callback = function(chunk)


    -- if chance succeeds, spawn 1-4 zombies. Chance and max zombie count depends on biome 
    -- get biome
    local biome = get_biome_at_unit(chunk.x_offset_unit+2) -- +2 because why not
    local chance = 0
    local min_zombies = 0
    local max_zombies = 0
    if biome == "GRASS" then
        -- nothing
    elseif biome == "DESERT" then
        chance = .8
        min_zombies = 1
        max_zombies = 1
    elseif biome == "MOUNTAIN" then
        chance = .5
        min_zombies = 1
        max_zombies = 2
    elseif biome == "SNOW" then
        chance = .6
        min_zombies = 2
        max_zombies = 3
    elseif biome == "ORELAND" then -- oreland and hell need more difficult generation
        chance = .7
        min_zombies = 2
        max_zombies = 3
    elseif biome == "HELL" then
        chance = 1
        min_zombies = 3
        max_zombies = 4
    end

    -- get chance and determine zombie count

    -- spawn zombies
    if chance >= rnd(1) then
        local zombies_to_spawn = flr(rnd(max_zombies-min_zombies))+min_zombies -- should depend on the biome/distance
        --printh("spawning " .. zombies_to_spawn .. " zombie(s)")  
        for i = 1, zombies_to_spawn do
            -- get a random surface tile
            local random_x_pos = flr(rnd(#chunk.surface_tiles)) + 1
            local spawn_point = chunk.surface_tiles[random_x_pos]
            spawn_zombie(spawn_point.x, spawn_point.y-1)
        end
    end
        
end


function _update()
    local current_time = time()  -- Get the current time
    delta_time = current_time - last_time  -- Calculate delta time
    last_time = current_time  

    -- WARNING: You're about to see a horrendous logic loop that hasn't changed much 
    -- since its conception during a 1 week game jam. Because if isn't broke, why fix it?
    if gameStarted then
        if not gameOver then
            
            -- Main loop functions go here
            local keyInput = ""
            update_players(delta_time)
            update_zombies(delta_time)
            update_respawns(delta_time)
            update_terrain_chunks(chunk_generated_callback)
            checkForOutOfBounds(camera_x - 16)
            gameOver = (get_disabled_count() == get_player_count())


            -- Process key input
            while stat(30) do
                keyInput = stat(31)
                bouncePlayer(keyInput)       
            end

            -- Handle victory conditions
            if victory then
                timeUntilCameraMoves = 10
            end

            if timeUntilCameraMoves > 0 then
                timeUntilCameraMoves -= delta_time
            else
                if not victory then
                    -- Update camera position 
                    camera_x = min(camera_x + camera_speed * delta_time, max_camera_distance)
                    if camera_x >= max_camera_distance then
                        victory = true

                        for key, player in pairs(players) do
                            if player.disabled == false then
                                add(win_order, {player.sprite, player.disabledCount, player.totalTimeEnabled})
                            end
                        end

                        appendLosersToWinOrder()

                        gameStarted = false

                    end
                end
            end
        else
            -- Handle game over state
            if timeUntilRestart > 0 then
                timeUntilRestart -= delta_time
            else
                timeUntilRestart = 2
                restart()
            end
        end
    elseif victory then -- super hacky
        -- Process key input
        while stat(30) do
            keyInput = stat(31)
            restart()
        end
    else
        -- Handle character select screen
        gameStarted = initPlayers()
    end
end

function _draw()
    if victory then
        cls(12)
        draw_winners(camera_x, camera_y)


        
    else
        cls()
        draw_zombies()
        draw_players(gameStarted)
        draw_respawn_birds()
        draw_terrain()
        camera(camera_x, camera_y)

        if gameStarted then

        else
            rectfill(camera_x, 0, 64, camera_x + 8, camera_y)
            print("press any key to add a player", camera_x, camera_y, 7)
            print("\^w\^thop" .. get_player_count(), camera_x + 46,camera_y + 56)
        end

        if gameOver then
            rectfill(camera_x, camera_y, camera_x + 32, camera_y + 8, 0)
            print("game over", camera_x, camera_y, 7)
        end

        if (debug) then
            print("cpu usage: " .. stat(1) * 100 .. "%", camera_x,camera_y+8)
            print("memory usage: " .. stat(0) .. "/2048 bytes bytes", camera_x,camera_y+16)
            print("frame rate: " .. stat(7), camera_x,camera_y+24)
        end  
    end      
end

function draw_winners(x, y)
    local indent = ""
    local line_height = 10
    local current_y = y


    
    -- Print header
    print("\t\t\t  survivors\n", x, current_y, 10)
    current_y = current_y + line_height
    leftCounter = 0
    for i = 1, #win_order do
        xOffset = leftCounter * 32
        spr(win_order[i][1], x + 12 + xOffset, current_y)
        print(tostr(i)..indent.."\n", x + 4 + xOffset, current_y, 10)
        if leftCounter == 3 then
            current_y = current_y + line_height
        end
        leftCounter = (leftCounter + 1) % 4
        --end
    end
end

function appendLosersToWinOrder()
    local lose_order = {}

    -- add disabled players to lose_order
    for key, player in pairs(players) do
        if player.disabled then
            add(lose_order, {player.sprite, player.disabledCount, player.totalTimeEnabled})
        end
    end

    -- sort lost_order
    local n = #lose_order
    for i = 1, n - 1 do
        for j = 1, n - i do
            local a = lose_order[j]
            local b = lose_order[j + 1]
            -- Compare by disabledCount (ascending)
            -- If disabledCount is the same, compare by totalTimeEnabled (descending)
            if a[2] > b[2] or (a[2] == b[2] and a[3] < b[3]) then
                -- Swap elements if necessary
                lose_order[j], lose_order[j + 1] = lose_order[j + 1], lose_order[j]
            end
            
        end
    end

    -- append lose order to win_order
    for i = 1, #lose_order do 
        add(win_order, lose_order[i])
        -- for debug printh("Player " .. lose_order[i][1] .. " | Disabled count: " .. lose_order[i][2] .. " | TotalTimeEnabled: " .. lose_order[i][3])
    end

end