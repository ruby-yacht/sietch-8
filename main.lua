local gameStarted = false
local gameOver = false
local camera_x = 0
local timeUntilCameraMoves = 1.5
local last_time = 0
local delta_time = 0
local score = 0
local distanceScore = 10
local distanceThresholdToScore = 32

poke(0x5F2D, 0x1) -- enable keyboard input

function _init()
    -- Add chunks to the list
    createChunks()
    last_time = time()
end

function _update()
    local current_time = time()  -- Get the current time
    delta_time = current_time - last_time  -- Calculate delta time
    last_time = current_time  

    if gameStarted and gameOver == false then
        local keyInput = ""
        --testh()
        updatePlayers()
        gameOver = checkForOutOfBounds(camera_x-16)

        if stat(30) then
            keyInput = stat(31)
            bouncePlayer(keyInput)
        end

        if timeUntilCameraMoves > 0 then
            timeUntilCameraMoves -= delta_time
        else
            camera_x = camera_x + .5

            if camera_x >= distanceThresholdToScore then
                score = score + distanceScore
                distanceThresholdToScore = distanceThresholdToScore + 32
            end
        end
       
    elseif gameOver then
       
        --nothing
    else -- character select screen
        gameStarted = initPlayers()
    end
end

function _draw()
    cls()

   loadChunksIntoView(camera_x)
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

    
      
end