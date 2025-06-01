UFO = {}

local SPEED = 500
local MIN_SPEED = 50
local MAX_SPEED = 65 -- camera speed is 15
local HOVER_DOWN_SPEED = 30
local debug = false
local players_can_release_others = false

function UFO:new() -- there can only be one

    local instance = {
        id = i,
        x = 0,
        y = 0,
        vx = 0,
        vy = 0,
        width = 8,
        height = 8,
        boundsOffsetX = 4,
        boundsOffsetY = 4,
        sprite = 109,
        sprite2 = 110,
        active = false,
        ai_enabled = false,
        move_dir = -1,
        state = 1,
        search_timer = 5,
        capture_tracker = {},
        capture_timer = 5,
        tracker_beam = {
            x = 0,
            y = 0,
            width = 24,
            height = 32,
            boundsOffsetX = 4,
            boundsOffsetY = 28
        },
        ignoreList = {}
    }

    

    setmetatable(instance, { __index = self })

    return instance
end

function UFO:enable(x,y)
    self.x = x * 8
    self.y = y * 8
    self.vx = 0
    self.vy = 0
    self.state = 1
    self.active = true
    self.ai_enabled = true
    self.search_timer = 5 + flr(rnd(5))

end

function UFO:disable()
    self.x = 0
    self.y = 0
    self.active = false
    self.ai_enabled = false

    for index, value in ipairs(self.capture_tracker) do
        self.releasePlayer()
    end

    self.ignoreList = {}
end

function UFO:update(dt)




    if self.active and self.ai_enabled then

        -- move left and right for 5 seconds
        -- determine attack positions
        -- drop down and grab players in the air
        -- rise up, and fly away

        -- jumping on self acts like a platform (or bounces them off?)
        -- and releases one player

        if self.x + 8 < camera_x 
        or self.x > camera_x + 200 
        or self.y < camera_y  
        or self.y > camera_y + 200 then
            --self:disable()
            printh("ufo out of bounds!") -- to handle this, it should travel to inbounds
        end

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

            if self.search_timer == 0 and self.x > camera_x + 70 then
                self.vx = 0
                self.state = 2
            end
           

        elseif self.state == 2 then
            local tile = get_surface_tile_at_pos(self.x)
            if (tile) then
                
                
                if self.y < (tile.y - 4) * 8 then
                    self.vy = HOVER_DOWN_SPEED
                else
                    self.vy = 0
                    self.state = 3
                    self.capture_timer = 5
                end
            end
        
        elseif self.state == 3 then
            
            self.capture_timer = max(self.capture_timer - dt, 0)

            self.tracker_beam.x = self.x
            self.tracker_beam.y = self.y

            if self.capture_timer == 0 then
                for key, captured in pairs(self.capture_tracker) do
                    
                    if (captured.t > .2) then
                        disablePlayer(captured.player)
                    else
                        captured.player.disabled = false
                    end
                end

                self.ignoreList = {}
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
    if contains(self.ignoreList, player.key) then
        -- ignore this player
    elseif self.capture_tracker[player.key] == nil then
       
        self.capture_tracker[player.key] = {
            player = player,
            t = 0
        }

        self.capture_tracker[player.key].player.disabled = true
    else
        local captured = self.capture_tracker[player.key] 


        player.x = player.x + (self.x - player.x) * min(captured.t,1)
        player.y = player.y + ((self.y+8) - player.y) * min(captured.t,1)

        captured.t += .1 * dt 
        -- t will increase past 1 but never in calculations
        -- t is also used to determine who gets released first

    end
    


    
end

function UFO:releasePlayer()
    local t = -1
    local key_to_release = ""

    for key, captured in pairs(self.capture_tracker) do
        if captured.t > t then
            key_to_release = key
            t = captured.t
        end
    end

    if t > -1 then 
        add(self.ignoreList, key_to_release)
        
        local player = self.capture_tracker[key_to_release].player
        player.disabled = false
        player.vx = 0
        player.vy = 0
        
        self.capture_tracker[key_to_release] = nil
    end
end

function UFO:draw()
    if self.active then
        

        if self.state == 3 or self.state == 4 then
            spr(self.sprite2, self.x, self.y+6)
        end

        spr(self.sprite, self.x, self.y)

        if debug then

            local ufo_bounds = get_edges(self)

            rect(ufo_bounds.left, ufo_bounds.top, ufo_bounds.right, ufo_bounds.bottom, 8)

            if self.state == 3 then
                local beam_bounds = get_edges(self.tracker_beam)

                rect(beam_bounds.left, beam_bounds.top, beam_bounds.right, beam_bounds.bottom, 8)
            end
        end

    end

end