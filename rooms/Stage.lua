Stage = Object:extend()

function Stage:new()
    self:init()
end

function Stage:update(dt)
    self:play_pistolSFX_after_click()

    if not self.is_running and self.target:is_hovered() and input:pressed('left_button') and not AUDIO.GAME_OVER_SFX:isPlaying() then
        self.is_running = true
        self:event_balloon_destroy()
    elseif self.is_running then
        if self.target:is_hovered() and input:pressed('left_button') then
            AUDIO.POP_SFX:stop()
            AUDIO.POP_SFX:play()
            self:event_balloon_destroy()
        end

        self.target:update(dt)
        self.stats:update(dt)
        if not self.switched_effect and self.stats:is_time_left_below_percent_value(0.2) then
            self.switched_effect = true
            self.effect:switch_to_godsray()
        end

        if self.switched_effect then
            self.effect:set_godsray_decay(self.stats:map_value_for_effect_decay())
        end

        if self.stats:is_finished() then
            AUDIO.GAME_OVER_SFX:play()
            self.stats:write_config()
            self:init()
        end
    end
end

function Stage:draw()
    self.effect:draw(function()
        love.graphics.draw(BG_TEX)
        if not AUDIO.GAME_OVER_SFX:isPlaying() then
            self.target:draw()
        end
    end)
    self.stats:draw()
end

function Stage:init()
    self.target = Target()
    self.stats = Stats()
    self.effect = Effect()
    self.is_running = false
    self.switched_effect = false
end

function Stage:play_pistolSFX_after_click()
    if input:pressed('left_button') then
        AUDIO.PISTOL_SFX:stop()
        AUDIO.PISTOL_SFX:play()
    end
end

function Stage:event_balloon_destroy()
    self.target:respawn()
    self.stats:increase_score()
end