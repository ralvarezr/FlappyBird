--[[
    Pause State
    Author: Ricardo Alvarez
    ralvarezr@fi.uba.ar

]]

PauseState = Class{__includes = BaseState}


function PauseState:enter(params)

        self.bird = params.bird
        self.score = params.score
        self.pipePairs = params.pipePairs
        self.timer = params.timer
        self.lastY = params.lastY
        self.paused = true

        sounds['music']:pause() 


end


function PauseState:update(dt)

    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', self)
        sounds['music']:play() 

    end
end


function PauseState:render()

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            pipe:render()
        end
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    love.graphics.setFont(hugeFont)
    love.graphics.printf('PAUSED', 0, 120, VIRTUAL_WIDTH, 'center')
end


