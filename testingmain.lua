local debug = true

function _init()
    player = {} -- for testing
    testmode = false
    start_position = 0
    camera_x = start_position
    camera_y = 80
    
    last_time = 0
    delta_time = 0
    timeUntilRestart = 2
    last_time = time()
    start_time = time()

    -- level generation
    init_terrain_gen(10)
    max_camera_distance = (BIOME_DIST_UNIT.HELL + biome_length - 32) * 8

    player = {
        x = 20, 
        y = 90, 
        width = 8, 
        height = 8, 
        boundsOffsetX = 0, 
        boundsOffsetY = 0, 
        vx = 0, 
        vy = 0, 
        onGround = false, 
        bounce_force = minBounceForce, 
        key=70, 
        sprite = 70, 
        disabled = false,
        disabledCount = 0,
        totalTimeEnabled = 0,
        won = false
    }
end

function _update()
    local current_time = time()  -- Get the current time
    delta_time = current_time - last_time  -- Calculate delta time
    last_time = current_time  

    update_terrain_chunks()

    if testmode then
        test_mode()
    else
        hop_mode()
    end

end

function _draw()
    cls()
    draw_terrain()
    camera(camera_x, camera_y)
    spr(34, player.x, player.y)

    if (debug) then
        print("cpu usage: " .. stat(1) * 100 .. "%", camera_x,camera_y+8)
        print("memory usage: " .. stat(0) .. "/2048 bytes", camera_x,camera_y+16)
        print("frame rate: " .. stat(7), camera_x,camera_y+24)
    end  

end

function test_mode()
    
    camera_x = player.x - 56
    --camera_y = player.y + 64

    player.vx = 0
    player.vy = 0

    if btn(0) then
        player.vx -= 2
     end
     
     if btn(1) then
        player.vx += 2
     end
     
     if btn(2) then
        player.vy -= 2
     end
     
     if btn(3) then
        player.vy += 2
     end

    while stat(30) do
        keyInput = stat(31)
        if keyInput == "t" then
            testmode = false
        end        
    end

     local player_new_x = player.x + player.vx
     local player_new_y = player.y + player.vy

     checked_position = check_collision(player_new_x, player_new_y, player.x, player.y)

     player.x = checked_position.x
     player.y = checked_position.y
    
end

function hop_mode()
    camera_x += .5
    camera_x = min(camera_x, (map_x_size-16) * 8)

    -- Process key input
    while stat(30) do
        keyInput = stat(31)
        if keyInput == "t" then
            testmode = true
        elseif player.onGround then
            player.vx = 1
            player.vy = -3
        end
        
    end

    -- Apply gravity
    if player.onGround == false then
        player.vy += .3
    else
        if player.vy >= 0 then -- if just landed
            player.vx = 0
        end
    end
    
    local player_new_x = player.x + player.vx
    local player_new_y = player.y + player.vy

    -- Check for collisions
    local checked_position = check_collision(player_new_x, player_new_y, player.x, player.y)
    player.onGround = checked_position.onGround

    player.x = checked_position.x
    player.y = checked_position.y
end