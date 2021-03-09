PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 430

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

-- First pair of pipes spawn after 2 seconds.
local WAIT_TIME = 2

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.paused = false
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- spawn a new pipe pair
    if self.timer > WAIT_TIME then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), PIPE_HEIGHT / 3))

        table.insert(self.pipePairs, {
            -- flag to store whether we've scored the point for this pair of pipes
            scored = false,
            pipes = {
                Pipe('top', y),
                Pipe('bottom', y + PIPE_HEIGHT + 90)
            }
        })

        -- reset timer
        self.timer = 0

        -- Randomize the time to spawn a new pair of pipes.
        WAIT_TIME = math.random(1.5, 2)
    end

    for k, pair in pairs(self.pipePairs) do
        local doRemove = false

        for l, pipe in pairs(pair.pipes) do
            -- score a point if the pipe has gone past the bird to the left all the way
            if not pair.scored then
                if pipe.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            -- remove the pipe from the scene if it's beyond the left edge of the screen,
            -- else move it from right to left
            if pipe.x > -72 then
                pipe.x = pipe.x - PIPE_SPEED * dt
            else
                doRemove = true
            end
        end

        if doRemove then
            table.remove(self.pipePairs, k)
        end
    end

    self.timer = self.timer + dt

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end

    
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', self)
    end

    -- simple collision between bird and all pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if (self.bird.x + 2) + (BIRD_WIDTH - 4) >= pipe.x and self.bird.x + 2 <= pipe.x + PIPE_WIDTH then
                if (self.bird.y + 2) + (BIRD_HEIGHT - 4) >= pipe.y and self.bird.y + 2 <= pipe.y + PIPE_HEIGHT then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end

    self.bird:update(dt)
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            pipe:render()
        end
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)

    if params.paused then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.score = params.score
        self.timer = params.timer
        self.lastY = params.lastY
        self.paused = false
    end
    -- if we're coming from death or pause, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end