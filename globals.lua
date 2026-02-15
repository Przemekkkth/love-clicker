TARGET_TELEPORT_COOLDOWN_DURATION = 1.25
STATS_FINAL_COOLDOWN_DURATION = 30

STATS_TEXT_SIZE = 25
TARGET_COLOR = {1, 1, 1}
STATS_SCORE_TEXT_COLOR = {0, 1, 0}
STATS_FINAL_COOLDOWN_TEXT_COLOR = {1, 0, 0}
STATS_BEST_TIME_TEXT_COLOR = {1, 1, 0}

CROSSHAIR_TEXTURE = love.graphics.newImage('assets/crosshair.png')
MAIN_FONT = love.graphics.newFont('assets/arcadepi.ttf', STATS_TEXT_SIZE)
CURSOR = love.mouse.newCursor('assets/crosshair.png', CROSSHAIR_TEXTURE:getWidth()/2, CROSSHAIR_TEXTURE:getHeight()/2)
BALLOON1_TEX = love.graphics.newImage('assets/balloon1.png')
BALLOON2_TEX = love.graphics.newImage('assets/balloon2.png')
BALLOON3_TEX = love.graphics.newImage('assets/balloon3.png')
BALLOONS_TEX = {BALLOON1_TEX, BALLOON2_TEX, BALLOON3_TEX}
BG_TEX = love.graphics.newImage('assets/bg.png')
PATH_TO_CONFIG = 'clicker_config.json'

AUDIO = {
    PISTOL_SFX = love.audio.newSource("assets/pistol.wav", "static"),
    POP_SFX = love.audio.newSource("assets/pop.wav", "static"),
    GAME_OVER_SFX = love.audio.newSource("assets/game_over.wav", "static"),
}
AUDIO.PISTOL_SFX:setVolume(0.2)
AUDIO.POP_SFX:setVolume(1)
AUDIO.GAME_OVER_SFX:setVolume(1)