poke(0x5F2D, 0x1) -- enable keyboard input

local timeUntilCameraMoves = 1.5
local timeUntilRestart = 2
local debug = false
local victory = false
local win_order = {}

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
    generate_terrain(10)
    max_camera_distance = (BIOME_DIST.HELL + biome_length - 32) * 8
end

function restart()
    --cls()
    gameStarted = false
    gameOver = false
    camera_x = start_position
    timeUntilCameraMoves = 1.5
    delta_time = 0
    cls()
    resetPlayers()
    last_time = time()
    start_time = time()
    win_order = {}
    victory = false

end

function _update()
    local current_time = time()  -- Get the current time
    delta_time = current_time - last_time  -- Calculate delta time
    last_time = current_time  


    if gameStarted then
        if not gameOver then
            
            local keyInput = ""
            updatePlayers()
  
            update_respawns()
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
                    camera_x = min(camera_x + 0.5, max_camera_distance)
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
            print("cpu usage: " .. stat(1) .. "%", camera_x,8)
            print("memory usage: " .. stat(0) .. " bytes", camera_x,16)
            print("frame rate: " .. stat(7), camera_x,24)
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