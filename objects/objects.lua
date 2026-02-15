Target = Object:extend()

function Target:new()
    self.timer = Timer()
    self.offset = BALLOON1_TEX:getWidth() / 2
    self.x = SCREEN_WIDTH / 2
    self.y = SCREEN_HEIGHT / 2
    self.timer = Timer()
    self.life_duration = TARGET_TELEPORT_COOLDOWN_DURATION
    self.tex = BALLOONS_TEX[love.math.random(1, 3)]
end

function Target:update(dt)
    self.life_duration = self.life_duration - dt
    if self.life_duration <= 0.0 then
        self:respawn()
    end
end

function Target:draw()
    love.graphics.setColor(1, 1, 1, self.life_duration / TARGET_TELEPORT_COOLDOWN_DURATION)
    love.graphics.draw(self.tex, self.x, self.y)
    love.graphics.setColor(1, 1, 1, 1)
end

function Target:set_pos(x, y)
    self.x = x - self.offset / 2
    self.y = y - self.offset / 2
end

function Target:is_hovered()
    local o = 5
    local x = self.x + 2*o
    local y = self.y + o
    local s = BALLOON1_TEX:getWidth() - o
    local mouse_x, mouse_y = love.mouse.getPosition()
    if mouse_x > x and mouse_y > y and mouse_x < x + s - o and mouse_y < y + s then
        return true
    end
    return false
end

function Target:respawn()
    self.tex = BALLOONS_TEX[love.math.random(1, 3)]
    self.life_duration = TARGET_TELEPORT_COOLDOWN_DURATION
    local x = love.math.random() * (SCREEN_WIDTH - 2 * self.offset)
    local y = love.math.random() * (SCREEN_HEIGHT - 2 * self.offset)
    self:set_pos(x, y)
end

Stats = Object:extend()

function Stats:new()
    self.left_time = STATS_FINAL_COOLDOWN_DURATION
    self.score = 0
    self.best_score = 0
    self:read_config()
end

function Stats:update(dt)
    self.left_time = self.left_time - dt
end

function Stats:draw()
    love.graphics.setFont(MAIN_FONT)
    love.graphics.setColor(STATS_SCORE_TEXT_COLOR)
    love.graphics.print('Score: '..self.score, 5, 5)

    love.graphics.setColor(STATS_FINAL_COOLDOWN_TEXT_COLOR)
    love.graphics.print('Time Left (s): '..string.format('%.2f', self.left_time), 5, 50)

    love.graphics.setColor(STATS_BEST_TIME_TEXT_COLOR)
    love.graphics.print('Best Score: '..self.best_score, 5, 95)

    love.graphics.setColor(1, 1, 1)
end

function Stats:increase_score()
    self.score = self.score + 1
end

function Stats:is_finished()
    return self.left_time < 0
end

function Stats:read_config()
    local file_content, size = love.filesystem.read(PATH_TO_CONFIG)
    print('file_content ', file_content, ' size ', size)
    if size == 0 or file_content == nil then
        self.best_score = 0
        return
    end
    local t = {}
    t = json.decode(file_content)
    local config_best_score = t.best_score
    if config_best_score > self.best_score then
        self.best_score = config_best_score
    end
end

function Stats:write_config()
    if self.score < self.best_score then
        return
    end

    self.best_score = self.score
    local content = { best_score = self.best_score}
    local success, message = love.filesystem.write(PATH_TO_CONFIG, json.encode(content))

    if not success then
        print('Not save a config file: '..message)
    else
        print('Saved', json.encode(content))
    end
end

function Stats:is_time_left_below_percent_value(percent)
    if percent * STATS_FINAL_COOLDOWN_DURATION > self.left_time then
        return true
    end

    return false
end

function Stats:map_value_for_effect_decay()
    local inMin = 0
    local inMax = 0.2 * STATS_FINAL_COOLDOWN_DURATION
    local outMin = 0.99
    local outMax = 0.8

    if inMax == inMin then
        return outMax
    end

    local result = (self.left_time - inMin) / (inMax - inMin) * (outMax - outMin) + outMin

    if result < 0.8 then result = 0.8 end
    if result > 0.99 then result = 0.99 end

    return result
end

Effect = Object:extend()

function Effect:new()
    self:switch_to_glow()
end

function Effect:switch_to_glow()
    self.effect = moonshine(moonshine.effects.glow)
end

function Effect:switch_to_godsray()
    self.effect = moonshine(moonshine.effects.godsray)
    self.effect.godsray.decay = 0.95
end

function Effect:draw(drawFn)
    self.effect(drawFn)
end

function Effect:set_godsray_decay(v)
    self.effect.godsray.decay = v
end