zombies = {}

function load_zombie_pool(max_zombies = 5)
    for i = 1, max_zombies, 1 do
        add(zombies, {
            id = i,
            x = 0,
            y = 0,
            sprite = 108,
            active = false,
            ai_enabled = false
        })
    end
end

function get_next_zombie_in_pool()

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
        printh("no more zombie available")
        return
    end

    zombie.active = true
    zombie.x = x
    zombie.y = y

    
    -- spawn zombie over X seconds
    -- set timer and call function? Does this work with simultaneous spawns?
    yield()
    -- enable zombie AI

end



function update_zombie_ai()
    for index, zombie in ipairs(zombies) do
        if zombie.active and zombie.ai_enabled then
            -- do stuff???
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