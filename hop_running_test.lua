local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -10  -- Factor to bounce back after collision

-- game variables
local players = {}
local playerCount = 0
local gameStarted = false
local cameraX = 0
local cameraY = 0

-- start screen variables
playerCount = 0
local posx = 0
local posy = 0
local xOffset = 0
local row = 1
-- solid tiles in sprite-sheet
solid_tiles = {2, 3, 4}
-- lethal tiles in sprite-sheet
lethal_tiles = {}

poke(0x5F2D, 0x1) -- enable keyboard input

function _init()
    -- empty
end

function _update()
    if gameStarted then
        local keyInput = ""
        updatePlayers()

        if stat(30) then
            keyInput = stat(31)
            bouncePlayer(keyInput)
        end

        cameraX = cameraX + .5
        camera(cameraX, cameraY)
    else -- character select screen
        initPlayers()
        keyInput = ""
    end
end

function _draw()
    cls()
    map()
    drawPlayers()
end

function drawPlayers()
    for key, player in pairs(players) do
        spr(1, player.x, player.y)
    end
end

-- apply "physics" to all players
function updatePlayers()
    for key, player in pairs(players) do
        player.vy = player.vy + GRAVITY

        -- Calculate potential new positions
        local new_x = player.x + player.vx
        local new_y = player.y + player.vy

        -- Check collisions with solid tiles
        if not is_solid(new_x, player.y, player.width, player.height) then
            player.x = new_x
        else
            printh("object hit, old x velocity: "..player.vx.."\n")
            player.vx = player.vx
            printh("new x velocity: "..player.vx)
        end

        if not is_solid(player.x, new_y, player.width, player.height) then
            player.y = new_y
        else
            player.vy = 0
        end

        -- Check if player is on the ground
        if is_solid(player.x, player.y + player.height, player.width, 1) then
            player.y = flr((player.y + player.height) / 8) * 8 - player.height
            player.vy = 0
            player.onGround = true
        else
            player.onGround = false
        end
    end
end

function is_solid(x, y, width, height)
    for dx = 0, width - 1 do
        for dy = 0, height - 1 do
            if is_solid_tile(x + dx, y + dy) then
                return true
            end
        end
    end
    return false
end

function is_solid_tile(x, y)
    -- Convert pixel coordinates to tile coordinates
    local tile_x = flr(x / 8)
    local tile_y = flr(y / 8)

    -- Get the tile ID at the specified map position
    local tile_id = mget(tile_x, tile_y)

    -- Check if the tile ID is in the list of solid tiles
    for solid_tile in all(solid_tiles) do
        if tile_id == solid_tile then
            return true
        end
    end
    return false
end

-- look up key associated with player and bounce them
function bouncePlayer(key)
    local player = players[key]
    if player and player.onGround then
        player.vy = BOUNCE_FACTOR
        player.vx = 1.5 
    end
end

-- spawn players
function initPlayers()
    if stat(30) then
        local keyInput = stat(31)

        if keyInput ~= "\32" and not players[keyInput] then
            players[keyInput] = {
                x = posx, y = posy, width = 8, height = 8, vx = 0, vy = 0, onGround = false, key = keyInput
            }
            playerCount = playerCount + 1

            posx = posx + 9
            if posx >= 120 then
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
