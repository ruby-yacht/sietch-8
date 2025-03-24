-- player consts
local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -10  -- Factor to bounce back after collision

-- game variables
local players = {}
local playerCount = 0
local gameStarted = false

-- start screen variables
playerCount = 0
local posx = 0
local posy = 0
local xOffset = 0
local row = 1
--

poke(0x5F2D, 0x1) -- enable keyboard input


function _init()
    -- empty
end

function _update()

    if gameStarted then -- main game loop
        local keyInput = ""
        updatePlayers()

        if stat(30) then -- if key press was detected
            keyInput = stat(31)
            bouncePlayer(keyInput)
        end
    else -- character select screen
        initPlayers()

        keyInput = ""
    end
end

function _draw()
    cls()
    map(0,0,0,0,16,16)
    draw_players()
end

function draw_players()
    for key, player in pairs(players) do
        spr(1, player.x, player.y)
    end
end

-- apply "physics" to all players
function updatePlayers() 
    for key, player in pairs(players) do
        player.vy = player.vy + GRAVITY

        player.y = player.y + player.vy

        -- Check collision with ground (assuming ground level is at y = 112)
        if player.y + player.height >= 112 then
            player.y = 112 - player.height
            player.vy = player.vy
            player.onGround = true
        else
            player.onGround = false
        end
    end
end

-- look up key associated with player and bounce them
function bouncePlayer(key)
    local player = players[key]
    if not (player == nil) and player.onGround then
        player.vy = BOUNCE_FACTOR
    end
end

-- spawn players
function initPlayers()
    if stat(30) then -- was a key pressed?
        local keyInput = stat(31) -- which key was pressed

        -- if the key isn't the space button 
        -- and if the key wasn't already pressed, add it to the player list
        if not (keyInput == "\32") and not players[keyInput] then 

            -- create a player
            players[keyInput] = {x = posx, y = posy, width = 8, height = 8, vx = 0, vy = 0, onGround = false, key=keyInput}
            playerCount = playerCount + 1

            -- edit the offset so not all players spawn in the same position
            posx = posx + 9
            if (posx >= 120) then
                
                if xOffset >= 8 then
                    xOffset = 0
                else
                    xOffset = xOffset + 2
                end

                posx = xOffset

                posy = posy + 9
            end
        end

        -- exit player selection and start the game
        if keyInput == "\32" then 
            gameStarted = true
        end

    end     
    
end