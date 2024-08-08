local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -8  -- Factor to bounce back after collision

-- game variables
local players = {}
local playerCount = 0
local playerWonCount = 0
local minBounceForce = -6
local maxBounceForce = -10
local maxPlayers = 32
local maxFallVelocity = 10

-- start screen variables
local posx = 0
local posy = 8
local xOffset = 0
local row = 1
-- solid tiles in sprite-sheet
solid_tiles = {2, 3, 4, 27, 28, 29, 31, 11}

-- lethal tiles in sprite-sheet
lethal_tiles = {29}
victory_tile = 11

poke(0x5F2D, 0x1) -- enable keyboard input

function drawPlayers()
    for key, player in pairs(players) do
        spr(player.sprite, player.x, player.y)
    end

end

function checkForOutOfBounds(leftBounds)
    local disabledCount = 0
    
    for key, player in pairs(players) do
        if player.disabled == true then
            disabledCount = disabledCount + 1        
        elseif player.y > 128 then
            player.disabled = true
            player.x = -8
            player.y = -8

        elseif player.x < leftBounds then
            player.disabled = true
            player.x = -8
            player.y = -8
        end
    end

    if disabledCount >= playerCount then
        return true
    end

    return false

end

-- apply "physics" to all players
function updatePlayers() 
    
    for key, player in pairs(players) do
        if player.disabled == false then

            -- Calculate potential new positions
            local new_x = player.x + player.vx
            local new_y = player.y + player.vy

            -- Check collisions with solid tiles

            local flags = get_tile_flags(new_x, player.y, player.width, player.height)
            if not has_flag(flags, 8) then
                player.x = new_x
            else
                player.vx = player.vx
            end
            
            -- prevent players from falling off the edge of the map
            player.x = min(1024-8, player.x)

            -- @shahbaz collision checking range needs to be consistent, otherwise, jitter can occur
            flags = get_tile_flags(player.x, new_y, player.width, 1)
            if not has_flag(flags, 8) then
                player.y = new_y
            else
                player.vy = 0
            end
            
            -- Check if player is on the ground
            flags = get_tile_flags(player.x, player.y + player.height, player.width, 1)
            if has_flag(flags, 8) then
                player.y = flr((player.y + player.height) / 8) * 8 - player.height

                player.bounce_force = max(player.bounce_force - .08, maxBounceForce)
                player.vx = 0
                player.onGround = true
                --printh("player at\nx: "..player.x..", y: "..player.y)

                if has_flag(flags, 7) then
                    if not(player.won) then
                        printh("victory!")
                        player.won = true
                        playerWonCount += 1
                        win_trigger(player.sprite)
                    end
                end
            else
                player.onGround = false

                player.vy = player.vy + GRAVITY
                player.vy = min(player.vy, maxFallVelocity)
            end
            

            
        end
    end
end



function has_flag(flags, flag)
    for _, f in ipairs(flags) do 
        if f == flag then
            return true
        end
    end
    return false
end


function get_tile_flags(x, y, width, height)
    local flags = {}
    for dx = 0, width - 1 do
        for dy = 0, height - 1 do

            --Convert pixel coordinates to tile coordinates
            local tile_x = flr((x + dx) / 8)
            local tile_y = flr((y + dy) / 8)

            if is_solid_tile(tile_x,tile_y) then
                add_unique(flags, 8) -- 8 flag is collision
            end

            for flag = 0, 7 do
                local flagFound = fget(mget(tile_x, tile_y), flag)
                if flagFound then
                    add_unique(flags, flag)
                end
            end
            
        end
    end
    return flags
end



function is_solid_tile(tile_x, tile_y)

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
    if not (player == nil) and player.onGround and not(player.won) then
        player.vy = player.bounce_force
        player.vx = 1
        player.bounce_force = minBounceForce
    end
end

function resetPlayers()
    players = {}
    playerCount = 0
    minBounceForce = -6
    maxBounceForce = -10
    maxPlayers = 32
    maxFallVelocity = 10


end
    
    -- spawn players
function initPlayers()
    local sprites = {33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64}

    if stat(30) then 
        local keyInput = stat(31)
        
        local currentPlayerCount = 1
        for _ in pairs(players) do
            currentPlayerCount = currentPlayerCount + 1
        end

        if not (keyInput == "\32") and not players[keyInput] and currentPlayerCount <= 32 then 
            local sprite = sprites[playerCount % #sprites + 1]
            players[keyInput] = {
                x = posx, 
                y = posy, 
                width = 8, 
                height = 8, 
                vx = 0, 
                vy = 0, 
                onGround = false, 
                bounce_force = minBounceForce, 
                key=keyInput, 
                sprite = sprite, 
                disabled = false,
                won = false
            }
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

function DEBUG_updatePlayers()
    for key, player in pairs(players) do
        if player.disabled == false then
            
            local new_x = player.x
            local new_y = player.y

            local player_speed = 1
            if (btn(0)) then
                new_x -= player_speed
            end
            
            -- Check if the right arrow key is pressed
            if (btn(1)) then
                new_x += player_speed
            end
            
            -- Check if the up arrow key is pressed
            if (btn(2)) then
                new_y -= player_speed
            end
            
            -- Check if the down arrow key is pressed
            if (btn(3)) then
                new_y += player_speed
            end

            if not get_tile_flags(new_x, player.y, player.width, player.height) then
                player.x = new_x
            else
                player.vx = player.vx
            end

            -- @shahbaz collision checking range needs to be consistent, otherwise, jitter can occur
            if not get_tile_flags(player.x, new_y, player.width, 1) then
                player.y = new_y
            else
                player.vy = 0
            end

            
        end
    end
end