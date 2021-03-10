Bird = Class {}

local GRAVITY = 20 -- Arbitrary number.
local ANTIGRAVITY = -4 -- Arbitrary number.

-- Initialize the Bird Class
function Bird:init()
    self.image = love.graphics.newImage('assets/sprites/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH/2 - (self.width/2)
    self.y = VIRTUAL_HEIGHT/2 - (self.height/2)

    self.dy = 0 -- Falling Velocity
end

-- Draws the Bird.
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

-- Updates the y-axis of the Bird every frame.
function Bird:update(dt)

    -- Apply gravity to velocity.
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = ANTIGRAVITY
    end

    -- Apply the current velocity to Y position.
    self.y = self.y + self.dy

end