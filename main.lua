local gameStarted = false
local gameOver = false
local camera_x = 0
local camera_y = 0
local timeUntilCameraMoves = 1.5
local last_time = 0
local delta_time = 0
local score = 0
local distanceScore = 10
local distanceThresholdToScore = 32
local timeUntilRestart = 2
local debug = false
local victory = false
local win_order = {}
local start_time = 0

poke(0x5F2D, 0x1) -- enable keyboard input

function _init()
    gameStarted = false
    gameOver = false
    camera_x = 0
    timeUntilCameraMoves = 1.5
    last_time = 0
    delta_time = 0
    score = 0
    distanceScore = 10
    distanceThresholdToScore = 32
    timeUntilRestart = 2
    --createChunks()
    last_time = time()
    victory = false
    start_time = time()
end

function _update()
    local current_time = time()  -- Get the current time
    delta_time = current_time - last_time  -- Calculate delta time
    last_time = current_time  

    if gameStarted and gameOver == false then
        local keyInput = ""
        --testh()
        if(debug) then
            DEBUG_updatePlayers()
        else
            updatePlayers()
        end
        gameOver = checkForOutOfBounds(camera_x-16)

        if stat(30) then
            keyInput = stat(31)
            bouncePlayer(keyInput)
        end

        if victory then
            timeUntilCameraMoves = 10
        end

        if timeUntilCameraMoves > 0 and victory == false then
            timeUntilCameraMoves -= delta_time
        else
            if victory==false then
                if camera_x >= 896 then
                    camera_x = 896
                else
                    camera_x = camera_x + .5
                end            

                if camera_x >= distanceThresholdToScore then
                    score = score + distanceScore
                    distanceThresholdToScore = distanceThresholdToScore + 32
                end
            else
                printh("victory status: "..tostr(victory).."\n")
                printh("sum1 victorious")
            end
        end
       
    elseif gameOver then
        if timeUntilRestart > 0 then
            timeUntilRestart -= delta_time
        else
            printh("pre-restart vals: \n")
            print_global_vals()
            timeUntilRestart = 2
            printh("RESTARTING...")
            restart()
            printh("post-restart vals: \n")
            print_global_vals()
            --_init()
        end
        --nothing
    else -- character select screen
        gameStarted = initPlayers()
    end
end

function _draw()
    


    if victory then
        cls(12)
        draw_winners(camera_x, camera_y)

    else
        cls()
        --loadChunksIntoView(camera_x) :(
        map(0, 0, 0, 0, 128, 16)
        drawPlayers(gameStarted)
        camera(camera_x, camera_y)

        if gameStarted == false then
            rectfill(0, 0, 64, 8, 0)
            print("Press any key to add a player", 0, 0, 7)
        else
            rectfill(camera_x, 0, camera_x +  32, 8, 0)
            print("Score " .. score, camera_x, 0, 7)
        end

        if gameOver then
            rectfill(camera_x, 0, camera_x +  32, 8, 0)
            print("game over", camera_x, 0, 7)
        end

        if (debug) then
            print("CPU usage: " .. stat(1) .. "%", camera_x,8)
            print("Memery usage: " .. stat(0) .. " bytes", camera_x,16)
            print("Frame rate: " .. stat(7), camera_x,24)
        end  
    end
end


function win_trigger(winner)
    --printh ("win_trigger.... triggered.")
    if playerCount == playerWonCount then
        victory = true
    end
    win_order[winner] = time() - start_time
    --printh("winning player: " .. tostr(winner) .."\ntime: "..tostr(time()-start_time))

end

-- function draw_winners()
--     win_list = "player\t\t\t\ttime..\n"
--     indent = "    "
--     for key, val in pairs(win_order) do
--         win_list = win_list..indent..key.."\t\t\t\t"..val.."\n"
--     end
--     return win_list
-- end

function sort_by_value(tbl)
    -- Create an array of key-value pairs
    local sorted_pairs = {}
    for k, v in pairs(tbl) do
        --add(sorted_pairs, {key = k, val = value})
        sorted_pairs[k] = v
    end

    -- Bubble sort algorithm
    for i = 1, #sorted_pairs do
        for j = i + 1, #sorted_pairs-1 do
            if tonum(sorted_pairs[i].value) > tonum(sorted_pairs[j].value) then
                -- Swap
                sorted_pairs[i], sorted_pairs[j] = sorted_pairs[j], sorted_pairs[i]
            end
        end
    end

    return sorted_pairs
end

function draw_winners(x, y)
    local indent = ""  -- space between sprites and text
    local line_height = 10  -- vertical space between lines
    local current_y = y
    
    -- Print header
    print("\t\t\t survivors\n", x, current_y, 10)
    current_y = current_y + line_height
    leftCounter = 0
    sorted_win_order = sort_by_value(win_order)
    printh("sorted table: ".."\n")
    print_table(sorted_win_order)
    -- Iterate through the win_order table
    for key, val in pairs(sorted_win_order) do
        -- Lookup the player sprite number using the key
        --printh("val: "..val.."\n")
        xOffset = leftCounter * 32
        spr(key, x + xOffset, current_y)
        print(tostr(flr(tonum(val) * 100) / 100)..indent.."\n", x + 12 + xOffset, current_y, 10)
        if leftCounter == 3 then
            current_y = current_y + line_height
        end
        leftCounter = (leftCounter + 1) % 4
    end
end

function print_table(tbl)
    for i = 1, #tbl do
        for k, v in pairs(tbl[i]) do
            printh ("key: "..tostr(k).." value: "..tostr(v).."\n")
        end
    --printh (tostr(tbl[i]).."\n")
    end
end

function restart()
    --cls()
    gameStarted = false
    gameOver = false
    camera_x = 0
    camera_y = 0
    timeUntilCameraMoves = 1.5
    delta_time = 0
    score = 0
    distanceScore = 10
    distanceThresholdToScore = 32
    cls()
    --resetChunks()
    --poke(0x5F2D, 0x1)
    --initPlayers()
    resetPlayers()
    last_time = time()
    start_time = time()

end

function print_global_vals()
    printh ("gameStarted: "..tostr(gameStarted).."\n")
    printh ("gameOver: "..tostr(gameOver).."\n")
    printh ("camera_x: "..tostr(camera_x).."\n")
    printh ("timeUntilCameraMoves: "..tostr(timeUntilCameraMoves).."\n")
    printh ("last_time: "..tostr(last_time).."\n")
    printh ("delta_time: "..tostr(delta_time).."\n")
    printh ("score: "..tostr(score).."\n")
    printh ("distanceScore: "..tostr(distanceScore).."\n")
    printh ("distanceThresholdToScore: "..tostr(distanceThresholdToScore).."\n")
    printh ("distanceScore: "..tostr(distanceScore).."\n") 
end