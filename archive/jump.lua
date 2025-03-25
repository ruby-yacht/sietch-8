-- Constants
local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -10  -- Factor to bounce back after collision

local players = {}
local playerCount = 0

poke(0x5F2D, 0x1)

function _init()
    cls(1)
    initPlayers()
    print("Hop To Survive")
end

function _update()
    local keyInput = ""
    updatePlayers()

    if stat(30) then
        keyInput = stat(31)
        bouncePlayer(keyInput)
    end
end

function _draw()
    cls()
    map(0, 0, 0, 0, 16, 16)
    draw_players()
end

function draw_players()
    for key, player in pairs(players) do
        spr(player.sprite, player.x, player.y)
    end
end

function updatePlayers()
    for key, player in pairs(players) do
        player.vy = player.vy + GRAVITY
        player.y = player.y + player.vy

        -- Check collision with ground (assuming ground level is at y = 120)
        if player.y + player.height >= 112 then
            player.y = 112 - player.height
            player.vy = player.vy
            player.onGround = true
        else
            player.onGround = false
        end
    end
end

-- Function to handle players' bouncing
function bouncePlayer(key)
    local player = players[key]
    if not (player == nil) and player.onGround then
        player.vy = BOUNCE_FACTOR
    end
end

function initPlayers()
    local keyInput
    playerCount = 0
    local posx = 8
    -- local sprites = {1, 5, 6, 7, 8, 9, 10, 11} 
    local sprites = {33, 34, 35, 36, 37, 38, 10, 11} -- Example sprite indices

    repeat
        cls()
        print("Player count: " .. playerCount)

        if stat(30) then
            keyInput = stat(31)

            if not (keyInput == "\31") then
                local sprite = sprites[playerCount % #sprites + 1] -- Assign a sprite
                players[keyInput] = {
                    x = posx,
                    y = 64,
                    width = 8,
                    height = 8,
                    vx = 0,
                    vy = 0,
                    onGround = false,
                    key = keyInput,
                    sprite = sprite -- Add sprite attribute
                }
                playerCount = playerCount + 1
                posx = posx + 9
            end
        end
    until keyInput == "\32"
end