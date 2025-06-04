-- TODO
-- add debug visual to separate chunks
-- add visual for zombie spawn point (or turn off ai and gravity?)


poke(0x5F2D, 0x1) -- enable keyboard input

local timeUntilCameraMoves = 1.5
local timeUntilRestart = 2
local debug = false
local victory = false
local win_order = {}
local delta_time
local last_time
local camera_speed = 15
local ufo_spawn_locations = {}
local victory_timer
local score_timer


ufos = {}

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
    victory_timer = 5
    score_timer = 15
    start_time = time()
    start_timer = 5 -- for initPlayers
    votesToStart = 0
    startTimerVisible = false

    voters = {}
    votesToStart = 0

    -- level generation
    init_terrain_gen(10)
    max_camera_distance = (map_x_size - 16) * 8

    ufo_spawn_locations = {
        (BIOME_DIST_UNIT.DESERT) - (biome_length / 2),
        (BIOME_DIST_UNIT.SNOW) - (biome_length/2),
        (BIOME_DIST_UNIT.ORELAND) - (biome_length/2) -- this could go wrong
    }

    load_zombie_pool(4)
    --spawn_zombie(7,20)
    ufos[1] = UFO:new()
    --ufos[1]:enable(10,12)
    --ufos[1]:disable()
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
    local min_zombies = 0
    local max_zombies = 0
    
    if biome == "GRASS" then
        -- nothing
    elseif biome == "DESERT" then
        min_zombies = 1
        max_zombies = 1
    elseif biome == "MOUNTAIN" then
        min_zombies = 2
        max_zombies = 2
    elseif biome == "SNOW" then
        min_zombies = 2
        max_zombies = 3
    elseif biome == "ORELAND" then -- oreland and hell need more difficult generation
        min_zombies = 2
        max_zombies = 3
    elseif biome == "HELL" then
        min_zombies = 3
        max_zombies = 4
    end
    
    local zombies_to_spawn = flr(rnd(max_zombies-min_zombies))+min_zombies -- should depend on the biome/distance
    --printh("spawning " .. zombies_to_spawn .. " zombie(s)")  
    for i = 1, zombies_to_spawn do
        --printh("spawning")
        -- get a random surface tile
        local random_x_pos = flr(rnd(#chunk.surface_tiles)) + 1
        local spawn_point = chunk.surface_tiles[random_x_pos]
        spawn_zombie(spawn_point.x, spawn_point.y-1)
    end
    
    for index, ufo_spawn_position in ipairs(ufo_spawn_locations) do
        if ufo_spawn_position > chunk.x_offset_unit and ufo_spawn_position <= chunk.x_offset_unit + chunk_x_size then
            printh(ufo_spawn_position)
            ufos[1]:enable(ufo_spawn_position,12)
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
            --update_players_testmode(delta_time)
            update_zombies(delta_time)
            ufos[1]:update(delta_time)
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
                    --printh(camera_x)
                    if camera_x >= max_camera_distance then -- add timer here
                    
                        if victory_timer > 0 then
                            victory_timer -= delta_time
                        else
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
        --[[
            while stat(30) do
                printh("end")
                keyInput = stat(31)
                restart()
            end
            ]]
        score_timer -= delta_time

        if score_timer <= 0 or stat(31) == "\32" and get_player_count() > 0 then 
            printh("end")
            restart()
        end
    else

        -- Handle character select screen
        gameStarted = initPlayers()

        if votesToStart > 0 and votesToStart / playerCount >= get_votes_needed_to_start() then
            start_timer = max(start_timer - delta_time, 0)
            startTimerVisible = true

           if start_timer <= 0 then 
                local timeDelay = min(10, 2 + ((1-(playerCount/32)) * 10))
                respawnTimer = timer(timeDelay)
                gameStarted = true
            end  
        else
            startTimerVisible = false
        end

        
    end
end



function _draw()
    if victory then
        cls(12)
        draw_winners(camera_x, camera_y)


        
    else
        cls()
        map(0,0,0,camera_y,128,16) -- make this repeatable
        map(0,0,1024,camera_y,128,16) -- make this repeatable
        map(0,0,2048,camera_y,128,16) -- make this repeatable
        draw_zombies()
        draw_terrain()
        map(0,0,max_camera_distance,camera_y-128,16,128) -- put this at the end of the map
        ufos[1]:draw()
        draw_players(gameStarted)
        draw_respawn_birds()
        camera(camera_x, camera_y)

        if gameStarted then

        else
            rectfill(camera_x, 0, camera_x + 128, camera_y + 8, camera_y)
            print("press any button to join", camera_x + 4, camera_y, 7)
            print("\^w\^thop" .. get_player_count(), camera_x + 46,camera_y + 56)
            if startTimerVisible then 
                print("starting in " .. flr(start_timer), camera_x + 4, camera_y + 110, 7)
            end
            print("ready: " .. votesToStart .. "/" .. playerCount, camera_x + 4, camera_y + 120, 7)
        end

        if gameOver then
            rectfill(camera_x, camera_y, camera_x + 32, camera_y + 8, 0)
            print("game over", camera_x, camera_y, 7)
        end

        if (debug) then
            print("cpu usage: " .. stat(1) * 100 .. "%", camera_x,camera_y+8)
            print("memory usage: " .. flr(stat(0)) .. "/2048 bytes bytes", camera_x,camera_y+16)
            print("frame rate: " .. stat(7), camera_x,camera_y+24)
        end  
    end      
end

function draw_winners(x, y)
    local indent = ""
    local line_height = 10
    local current_y = y
    
    -- Print header
    print("\t\t\tsurvivors\n", x, current_y, 10)
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

    print("\t\t\tcontinue in " .. flr(score_timer) .. "\n", x-2, current_y+ 110, 10)
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

function get_votes_needed_to_start() 
    if playerCount > 16 then
        return .5
    elseif playerCount > 8 then
        return .85
    else
        return 1
    end
end