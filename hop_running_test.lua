local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -10  -- Factor to bounce back after collision

-- game variables
local players = {}
local playerCount = 0

-- start screen variables
playerCount = 0
local posx = 0
local posy = 0
local xOffset = 0
local row = 1
--
poke(0x5F2D, 0x1) -- enable keyboard input

function drawPlayers()
    for key, player in pairs(players) do
        spr(1, player.x, player.y)
    end
end

-- apply "physics" to all players
function updatePlayers() 
    for key, player in pairs(players) do
        player.vy = player.vy + GRAVITY

        player.x = player.x + player.vx
        player.y = player.y + player.vy

        if player.y + player.height >= 120 then
            player.y = 120 - player.height
            player.vy = player.vy
            player.vx = 0
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
        player.vx = 1
    end
end

-- spawn players
function initPlayers()
    if stat(30) then 
        local keyInput = stat(31) 

        if not (keyInput == "\32") and not players[keyInput] then 


            players[keyInput] = {x = posx, y = posy, width = 8, height = 8, vx = 0, vy = 0, onGround = false, key=keyInput}
            playerCount = playerCount + 1

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
            return true
        end

    end    
    
    return false
    
end