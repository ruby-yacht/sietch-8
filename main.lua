local gameStarted = false
local camera_x = 0

poke(0x5F2D, 0x1) -- enable keyboard input

function _init()
    -- Add chunks to the list
    createChunks()

end

function _update()

    if gameStarted then
        local keyInput = ""
        updatePlayers()

        if stat(30) then
            keyInput = stat(31)
            bouncePlayer(keyInput)
        end

        camera_x = camera_x + .5
    else -- character select screen
        gameStarted = initPlayers()
    end
end

function _draw()
    cls()

    loadChunksIntoView(camera_x)
    drawPlayers()

    camera(camera_x, camera_y)

      
end