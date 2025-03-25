local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -8  -- Factor to bounce back after collision

-- game variables
players = {}
playerCount = 0
local playerWonCount = 0
local minBounceForce = -3
local maxBounceForce = -10
local bounceChargeRate = .13
local maxPlayers = 32
local maxFallVelocity = 5
local respawnQueue = Queue.new()
local activeBirdList = {}
local respawnTimer = nil
disabledPlayerCount = 0

-- start screen variables
local posx = 0
local posy = 8
local xOffset = 0
local row = 1
-- solid tiles in sprite-sheet
solid_tiles = {2, 3, 4, 31, 11}

-- lethal tiles in sprite-sheet
lethal_tiles = {29}
victory_tile = 11

poke(0x5F2D, 0x1) -- enable keyboard input

function disablePlayer(player)
    player.disabled = true
    player.disabledCount = player.disabledCount + 1
    player.totalTimeEnabled = player.totalTimeEnabled + (time() - player.totalTimeEnabled)
    player.x = -8
    player.y = -8
    player.vx = 0
    player.vy = 0
    disabledPlayerCount = disabledPlayerCount + 1
    respawnQueue:enqueue_unique({bird = {x = -8, y = -8, width = 8, height = 16, boundsOffsetX = 0, boundsOffsetY = 4, sprite = 1}, playerKey = player.key})
end

function enablePlayer(player)
    player.disabled = false
    disabledPlayerCount = disabledPlayerCount - 1
end

function initPlayers()
    local sprites = {33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64}

    if stat(30) then 
        local keyInput = stat(31)
        
        local currentPlayerCount = 1
        for _ in pairs(players) do
            currentPlayerCount = currentPlayerCount + 1
        end

        if not (keyInput == "\32") and not (keyInput == "\13") and not (keyInput == "\112") and not players[keyInput] and currentPlayerCount <= 32 then 
            local sprite = sprites[playerCount % #sprites + 1]
            players[keyInput] = {
                x = posx, 
                y = posy, 
                width = 8, 
                height = 8, 
                boundsOffsetX = 0, 
                boundsOffsetY = 0, 
                vx = 0, 
                vy = 0, 
                onGround = false, 
                bounce_force = minBounceForce, 
                key=keyInput, 
                sprite = sprite, 
                disabled = false,
                disabledCount = 0,
                totalTimeEnabled = 0,
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
        if keyInput == "\32" and get_player_count() > 0 then 
            local timeDelay = min(10, 2 + ((1-(playerCount/32)) * 10))
            respawnTimer = timer(timeDelay)
            return true
        end  

        
    end

    return false
end

function updatePlayers() 
    
    for key, player in pairs(players) do
        if player.disabled == false then

            player.vy = player.vy + GRAVITY
            player.vy = min(player.vy, maxFallVelocity) -- player still falls through the ground at high speeds

            -- Calculate potential new positions
            local new_x = player.x + player.vx
            local new_y = player.y + player.vy

            -- check for collision with lines
            local collision_y = check_ground_collision(new_x, new_y)
            if collision_y then
                if player.vy > 0 then -- if just landed
                    player.vx = 0
                end
                new_y = player.y
                player.vy = 0   
                player.bounce_force = max(player.bounce_force - bounceChargeRate, maxBounceForce)
                player.onGround = true
            else
                player.onGround = false
            end

            player.x = new_x
            player.y = new_y

            for _, respawn in ipairs(activeBirdList) do
                if check_object_collision(player, respawn.bird) then
                    -- Handle collision
                    printh("Collision detected!")
                    respawnPlayer(respawn)
                end
            end            
        end
    end
end

function check_ground_collision(px, py)

    local l = activeLines     
    for i = 1, LINE_CHAIN_LENGTH do
        if py + 8 > l.height and py < l.height and px + 8 > l.start_x and px < l.start_x + l.length then
            return l.height
        end
        l = l.next
    end
    return nil
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
    playerWonCount = 0
    respawnQueue = Queue.new()
    activeBirdList = {}
    respawnTimer = nil
    disabledPlayerCount = 0
    
    posx = 0
    posy = 8
    xOffset = 0
    row = 1
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

function addRespawnBird()
    local respawn = respawnQueue:dequeue()
    local player = players[respawn.playerKey]
    local bird = respawn.bird
    local initXPos = camera_x+128
    local initYPos = 16
    bird.x = initXPos
    bird.y = initYPos
    player.x = initXPos
    player.y = initYPos + 8

    add(activeBirdList, respawn)

end

function respawnPlayer(respawn)
    local p = players[respawn.playerKey]
    enablePlayer(p)
    del(activeBirdList, respawn)
end

function update_respawns()

    if respawnTimer() and not(respawnQueue:isempty()) then
        addRespawnBird()
    end

    local returnToQueue = nil -- move all birds across the screen
    for _, respawn in ipairs(activeBirdList) do
        local newPos = respawn.bird.x - 1      
        respawn.bird.x = newPos
        local p = players[respawn.playerKey];
        p.x = newPos

        if newPos < camera_x - 8 then
           returnToQueue = respawn
        end
    end

    if not(returnToQueue == nil) then -- remove first bird to go out of bounds
        respawnQueue:enqueue_unique(returnToQueue)
        del(activeBirdList, returnToQueue)
    end

end

function draw_players()
    for key, player in pairs(players) do
        spr(player.sprite, player.x, player.y)
    end

end

function draw_respawn_birds()
    for _, respawn in ipairs(activeBirdList) do
        spr(respawn.bird.sprite, respawn.bird.x, respawn.bird.y)
    end
end

function get_player_count()
    return playerCount
end

function get_disabled_count()
    return disabledPlayerCount
end

function checkForOutOfBounds(leftBounds)    
    for key, player in pairs(players) do
        if not(player.disabled) then 
            if player.y > 128 then
                disablePlayer(player)
            elseif player.x < leftBounds then
                disablePlayer(player)
            end
        end
    end
end



function check_object_collision(a, b)
    local a_edges = get_edges(a)
    local b_edges = get_edges(b)
    
    return a_edges.left < b_edges.right and
           a_edges.right > b_edges.left and
           a_edges.top < b_edges.bottom and
           a_edges.bottom > b_edges.top
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
    -- Calculate the tile range based on the tile coordinates
    local tile_x_start = flr(x / 8)
    local tile_y_start = flr(y / 8)
    local tile_x_end = flr((x + width - 1) / 8)
    local tile_y_end = flr((y + height - 1) / 8)

    for tile_x = tile_x_start, tile_x_end do
        for tile_y = tile_y_start, tile_y_end do
            -- Check the tile for flags
            local tile_flags = mget(tile_x, tile_y)
            for flag = 0, 7 do
                if fget(tile_flags, flag) then
                    add_unique(flags, flag)
                end
            end

            -- Check if the tile is solid
            if is_solid_tile(tile_x, tile_y) then
                add_unique(flags, 8) -- 8 flag is collision
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