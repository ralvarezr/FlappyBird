Pipe = Class{}

-- Allocate once the pipe image in memory.
local PIPE_IMAGE = love.graphics.newImage('assets/sprites/pipe.png')

-- Speed at wich the pipe should scroll right to left.
PIPE_SPEED = 60

-- Height and Width of the image, globally accesible.
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

-- Initialize the Pipe.
function Pipe:init(orientation, y)

    self.x = VIRTUAL_WIDTH

    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation

end

-- Updates the position of the Pipe over time.
function Pipe:update(dt)
end

-- Draws the pipe.
function Pipe:render()

    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, -- Rotation
    1,  -- X Scale
    (self.orientation == 'top' and -1 or 1)) -- Y Scale.

end