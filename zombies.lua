zombies = {}
 
function load_zombie_pool(max_zombies)
    for i = 0, max_zombies, 1 do
        add(zombies, {
            id = i,
            x = 0,
            y = 0,
            width = 1,
            height = 1,
            boundsOffsetX = 0,
            boundsOffsetY = 0,
            sprite = 108,
            active = false,
            ai_enabled = false
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

end

function disable_zombie(zombie)
    zombie.x = 0
    zombie.y = 0
    zombie.active = false
    zombie.ai_enabled = false
end

function update_zombies(dt)
    for index, zombie in ipairs(zombies) do

        if zombie.x + 8 < camera_x then
            disable_zombie(zombie)
            break
        end

        if zombie.active and zombie.ai_enabled then
            
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