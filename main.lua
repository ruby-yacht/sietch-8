gameStarted = false
gameOver = false
camera_x = 0
local timeUntilCameraMoves = 1.5
last_time = 0
delta_time = 0
local score = 0
local distanceScore = 10
local distanceThresholdToScore = 32
local timeUntilRestart = 2
local debug = false

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
        updateRespawns()

        -- gameover only checks for out of bound deaths. Add support for death in bounds
        gameOver = checkForOutOfBounds(camera_x-16)

        if stat(30) then
            keyInput = stat(31)
            bouncePlayer(keyInput)
        end

        if timeUntilCameraMoves > 0 then
            timeUntilCameraMoves -= delta_time
        else
            if camera_x >= 896 then
                camera_x = 896
            else
                camera_x = camera_x + .5
            end            

            if camera_x >= distanceThresholdToScore then
                score = score + distanceScore
                distanceThresholdToScore = distanceThresholdToScore + 32
            end

        end
       
    elseif gameOver then
        if timeUntilRestart > 0 then
            timeUntilRestart -= delta_time
        else
            timeUntilRestart = 2
            restart()

            -- shahbaz you can clean this up. 
            if (debug) then
                printh("pre-restart vals: \n")
                print_global_vals()
                
                printh("RESTARTING...")
                
                printh("post-restart vals: \n")
                print_global_vals()
            end
        end
        --nothing
    else -- character select screen
        gameStarted = initPlayers()
    end
end

function _draw()
    cls()

    --loadChunksIntoView(camera_x) :(
    map(0, 0, 0, 0, 128, 16)
    drawPlayers(gameStarted)
    drawRespawnBirds()
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