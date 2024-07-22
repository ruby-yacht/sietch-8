pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- constants
local gravity = 0.5  -- gravity value
local bounce_factor = -10  -- factor to bounce back after collision

local players = {}
local playercount = 0

poke(0x5f2d, 0x1)

function _init()
    cls(1)
    initplayers()
    print("hop to survive")
end

function _update()
    local keyinput = ""
    updateplayers()

    if stat(30) then
        keyinput = stat(31)
        bounceplayer(keyinput)
    end
end

function _draw()
    cls()
    map(0, 0, 0, 0, 16, 16)
    drawplayers()
end

function drawplayers()
    for key, player in pairs(players) do
        pset(player.x, player.y, player.color)
    end
end

function updateplayers()
    for key, player in pairs(players) do
        player.vy = player.vy + gravity
        player.y = player.y + player.vy

        -- check collision with ground (assuming ground level is at y = 120)
        if player.y + player.height >= 112 then
            player.y = 112 - player.height
            player.vy = player.vy
            player.onground = true
        else
            player.onground = false
        end
    end
end

-- function to handle players' bouncing
function bounceplayer(key)
    local player = players[key]
    if not (player == nil) and player.onground then
        player.vy = bounce_factor
    end
end

function initplayers()
    local keyinput
    playercount = 0
    local posx = 8
    local colors = {8, 9, 10, 11, 12, 13, 14, 15} -- example colors

    repeat
        cls()
        print("player count: " .. playercount)

        if stat(30) then
            keyinput = stat(31)

            if not (keyinput == "\31") then
                local color = colors[playercount % #colors + 1] -- assign a color
                players[keyinput] = {
                    x = posx,
                    y = 64,
                    width = 8,
                    height = 8,
                    vx = 0,
                    vy = 0,
                    onground = false,
                    key = keyinput,
                    color = color -- add color attribute
                }
                playercount = playercount + 1
                posx = posx + 9
            end
        end
    until keyinput == "\32"
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
