zombies = {}

local GRAVITY = 10  -- Gravity value
local SPEED = 5
 
function load_zombie_pool(max_zombies)

    zombies = {}

    for i = 0, max_zombies, 1 do
        add(zombies, {
            id = i,
            x = 0,
            y = 0,
            vx = 0,
            vy = 0,
            width = 1,
            height = 1,
            boundsOffsetX = 0,
            boundsOffsetY = 0,
            sprite = 108,
            active = false,
            ai_enabled = false,
            move_dir = -1
        })
    end
end

function spawn_zombie(x,y)
    local zombie = nil
    for index, z in ipairs(zombies) do
        if z.active == false then
            zombie = z
            break; -- does this work?
        end
    end

    if zombie == nil then
        printh("no more zombies available")
        return
    end

    zombie.active = true
    zombie.x = x * 8
    zombie.y = y * 8

    
    -- spawn zombie over X seconds
    -- set timer and call function? Does this work with simultaneous spawns?
    --yield()
    -- enable zombie AI
    zombie.ai_enabled = true

end

function disable_zombie(zombie)
    zombie.x = 0
    zombie.y = 0
    zombie.active = false
    zombie.ai_enabled = false
end

function update_zombies(dt)
    for index, zombie in ipairs(zombies) do

        if zombie.x + 8 < camera_x 
        or zombie.x > camera_x + 200 
        or zombie.y < camera_y  
        or zombie.y > camera_y + 200 then
            disable_zombie(zombie)
            break
        end


        if zombie.active and zombie.ai_enabled then
            
            zombie.vx = zombie.move_dir * SPEED
            zombie.vy += GRAVITY

            local zombie_new_x = zombie.x + zombie.vx * dt
            local zombie_new_y = zombie.y + zombie.vy * dt

            -- Check new positions for collisions
            local checked_position = check_collision(zombie_new_x, zombie_new_y, zombie.x, zombie.y, respond_to_wall_collision)
            zombie.onGround = checked_position.onGround

            if checked_position.onGround then
                zombie.vy = 0
            end

            if checked_position.hit_wall then
                zombie.move_dir = -zombie.move_dir
                zombie.vx = 0
            end
            
            zombie.x = checked_position.x
            zombie.y = checked_position.y
            
        end
    end
end

function draw_zombies()
    for index, zombie in ipairs(zombies) do
        if zombie.active then
            spr(zombie.sprite, zombie.x, zombie.y)
        end
    end
end