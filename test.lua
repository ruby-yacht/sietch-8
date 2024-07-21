-- Constants
local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -0.8  -- Factor to bounce back after collision

local players = {}
local playerCount = 0

function _init()
    cls(1)
    print("Hop To Survive");
    initPlayers(1)
   end

function _update()
    updatePlayers()

    if btnp(4) then  -- 'Z' key
        bouncePlayers()
    end
end

function _draw()
    cls()
    map(0,0,0,0,16,16)
    drawPlayers()
end

function drawPlayers()
    for _, player in ipairs(players) do
        spr(1, player.x, player.y)
    end
end

function updatePlayers()
    for _, player in ipairs(players) do
        player.vy = player.vy + GRAVITY

        player.y = player.y + player.vy

               -- Check collision with ground (assuming ground level is at y = 120)
        if player.y + player.height >= 112 then
            player.y = 112 - player.height
            player.vy = player.vy * BOUNCE_FACTOR
            player.onGround = true
        else
            player.onGround = false
        end
    end
end

-- Function to handle players' bouncing
function bouncePlayers()
    for _, player in ipairs(players) do
        if player.onGround then
            player.vy = player.vy * BOUNCE_FACTOR + 5
        end
    end
end

function initPlayers(count)
    playerCount = count
    for i = 1, count do
        players[i] = {x = 64, y = 64, width = 8, height = 8, vx = 0, vy = 0, onGround = false}
    end
end