poke(0x5F2D, 0x1) -- enable keyboard input

-- game variables
local GRAVITY = 0.5  -- Gravity value
local BOUNCE_FACTOR = -8  -- Factor to bounce back after collision
players = {}
playerCount = 0
local playerWonCount = 0
local minBounceForce = -3
local maxBounceForce = -10
local bounceChargeRate = .13
local maxPlayers = 32
local maxFallVelocity = 5
disabledPlayerCount = 0

-- start screen variables
local posx = 0 -- not using this
local posy = 0
local xOffset = 0
local row = 1


function disablePlayer(player)
    player.disabled = true
    player.disabledCount = player.disabledCount + 1
    player.totalTimeEnabled = player.totalTimeEnabled + (time() - player.totalTimeEnabled)
    player.x = -8
    player.y = -8
    player.vx = 0
    player.vy = 0
    disabledPlayerCount = disabledPlayerCount + 1
    queue_respawn_bird(player.key)
    
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
                x = 8 + posx + start_position, 
                y = 8 + posy + camera_y, 
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
            if (posx >= 100) then
                
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

            -- Apply grounded or ungrounded updates
            if player.onGround == false then
                player.vy += GRAVITY
                player.vy = min(player.vy, maxFallVelocity)
            else
                
                player.bounce_force = max(player.bounce_force - bounceChargeRate, maxBounceForce)
                if player.vy >= 0 then -- if just landed
                    player.vx = 0
                end
            end
            
            -- Calculate the new player position
            local player_new_x = player.x + player.vx
            local player_new_y = player.y + player.vy

            -- Check new positions for collisions
            local checked_position = check_collision(player_new_x, player_new_y, player.x, player.y)
            player.onGround = checked_position.onGround

            -- Apply final position updates, if any
            player.x = checked_position.x
            player.y = checked_position.y

            -- Check for respawn bird collisions
            for _, respawn in ipairs(activeBirdList) do
                if check_object_collision(player, respawn.bird) then
                    -- Handle collision
                    --printh("Collision detected!")
                    respawnPlayer(respawn)
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
    init_respawn_birds()
    disabledPlayerCount = 0
    posx = 0
    posy = 8
    xOffset = 0
    row = 1
end

function DEBUG_updatePlayers()
    for key, player in pairs(players) do
        if player.disabled == false then
            
            -- do debug stuff
            
        end
    end
end

function respawnPlayer(respawn)
    local p = players[respawn.playerKey]
    enablePlayer(p)
    del(activeBirdList, respawn)
end

function draw_players()
    for key, player in pairs(players) do
        spr(player.sprite, player.x, player.y)
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
            if player.y >= (map_y_size - 1) * 8 then
                disablePlayer(player)
            elseif player.x < leftBounds then
                disablePlayer(player)
            end
        end
    end
end

-- actor collision
function check_object_collision(a, b)
    local a_edges = get_edges(a)
    local b_edges = get_edges(b)
    
    return a_edges.left < b_edges.right and
           a_edges.right > b_edges.left and
           a_edges.top < b_edges.bottom and
           a_edges.bottom > b_edges.top
end

function get_edges(obj)
    -- Calculate reference point
    local center_x = obj.x + obj.boundsOffsetX
    local center_y = obj.y + obj.boundsOffsetY
    
    local half_w = obj.width / 2
    local half_h = obj.height / 2
    
    return {
        left = center_x - half_w,
        right = center_x + half_w,
        top = center_y - half_h,
        bottom = center_y + half_h
    }
end

