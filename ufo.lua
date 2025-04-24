UFO = {}

local SPEED = 500
local MIN_SPEED = 50
local MAX_SPEED = 65 -- camera speed is 15
local HOVER_DOWN_SPEED = 30

function UFO:new() -- there can only be one

    local instance = {
        id = i,
        x = 0,
        y = 0,
        vx = 0,
        vy = 0,
        width = 24,
        height = 40,
        boundsOffsetX = 0,
        boundsOffsetY = 20,
        sprite = 109,
        sprite2 = 110,
        active = false,
        ai_enabled = false,
        move_dir = -1,
        state = 1,
        search_timer = 5,
        capture_tracker = {},
        capture_timer = 5
    }

    

    setmetatable(instance, { __index = self })

    return instance
end

function UFO:enable(x,y)
    self.x = x * 8
    self.y = y * 8
    self.active = true
    self.ai_enabled = true
    self.search_timer = 5 + flr(rnd(5))
end

function UFO:disable()
    self.x = 0
    self.y = 0
    self.active = false
    self.ai_enabled = false
end

function UFO:update(dt)

    if self.x + 8 < camera_x 
    or self.x > camera_x + 200 
    or self.y < camera_y  
    or self.y > camera_y + 200 then
        self:disable()
    end


    if self.active and self.ai_enabled then

        -- move left and right for 5 seconds
        -- determine attack positions
        -- drop down and grab players in the air
        -- rise up, and fly away

        -- jumping on self acts like a platform (or bounces them off?)
        -- and releases one player

        if self.state == 1 then

            
            if self.move_dir > 0 then
                self.vx = self.move_dir * MAX_SPEED
            else
                self.vx = self.move_dir * MIN_SPEED
            end

            if self.x < camera_x + 8 then
                self.move_dir = abs(self.move_dir)
                self.x = camera_x + 8
            elseif self.x > camera_x + 110 then
                self.move_dir = -abs(self.move_dir)
                self.x = camera_x + 110
            end

            self.search_timer = max(self.search_timer - dt, 0)

            if self.search_timer == 0 then
                self.vx = 0
                self.state = 2
            end
           

        elseif self.state == 2 then
            local tile = get_surface_tile_at_pos(self.x)

            if self.y < (tile.y - 6) * 8 then
                self.vy = HOVER_DOWN_SPEED
            else
                self.vy = 0
                self.state = 3
                self.capture_timer = 5
            end
        
        elseif self.state == 3 then
            
            self.capture_timer = max(self.capture_timer - dt, 0)

            if self.capture_timer == 0 then
                for key, captured in pairs(self.capture_tracker) do
                    
                    if (captured.t > .2) then
                        disablePlayer(captured.player)
                    else
                        captured.player.disabled = false
                    end
                end
                self.state = 4
            end
           
        elseif self.state == 4 then
            self.y -= MAX_SPEED * dt
            if self.y+8 <= camera_y then 
                self:disable()
            end            
        end

        
        local self_new_x = self.x + self.vx * dt
        local self_new_y = self.y + self.vy * dt

        -- no need for collision checks
        
        self.x = self_new_x
        self.y = self_new_y

    end
    
end

function UFO:attractPlayer(player, dt)

    -- if progress tracker does not contain player, add player
    -- keep track of ever player in the tracker
    -- this also tracks who gets freed first, and who dies.
    if self.capture_tracker[player.key] == nil then
       
        self.capture_tracker[player.key] = {
            player = player,
            t = 0
        }

        self.capture_tracker[player.key].player.disabled = true -- test
    else
        local captured = self.capture_tracker[player.key] 
        
        captured.t = min(captured.t,1)

        player.x = player.x + (self.x - player.x) * captured.t
        player.y = player.y + ((self.y+8) - player.y) * captured.t

        captured.t += .1 * dt
        
    end
    


    
end

function UFO:draw()
    if self.active then
        spr(self.sprite, self.x, self.y)
    end

end