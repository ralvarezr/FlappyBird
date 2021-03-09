-- Include the Push Library
push = require 'push'

-- Include the Class Library
Class = require 'class'


-- Include the Bird Class
require 'Bird'

-- Include the Pipe Class
require 'Pipe'

-- Include the Libraries related to the Game State and State Machines.
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'
require 'states/PauseState'


-- Window Size
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


-- Load Images to memory
local background = love.graphics.newImage('assets/sprites/background.png')
local backgroundScroll = 0  -- To get the Parallax Scrolling.
local BACKGROUND_SCROLL_SPEED = 30  -- Arbitray movement speed.
local BACKGROUND_LOOPING_POINT  = 568 -- The point 0 and the point 568 of the texture is the same.

local ground = love.graphics.newImage('assets/sprites/ground.png')
local groundScroll = 0 -- To get the Parallax Scrolling.
local GROUND_SCROLL_SPEED = 60 -- Ground moves faster than the background. 
-- Ground does not need a Looping Point, it is consistent enough for getting the parallax effect.

-- Global Variable to pause the game.
scrolling = true

-- Load Function
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest') -- Set the OpenGL Filter
    love.window.setTitle('Flappy Bird') -- Set the Window Title.

    math.randomseed(os.time())  -- Set the random seed.

    -- Initialize new fonts.
    smallFont = love.graphics.newFont('assets/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('assets/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('assets/fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


    -- Initialize the table of sounds.
    sounds = {
        ['jump'] = love.audio.newSource('assets/sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('assets/sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('assets/sounds/mario-s-way.mp3', 'static')
    }

    -- Start the music.
    sounds['music']:setLooping(true)
    sounds['music']:play()  
    
    -- Setup the Screen.
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true, 
        resizable = true, 
        fullscreen = false})  
        
        
    -- Intialize the State Machine.
    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['score'] = function() return ScoreState() end

    }

    gStateMachine:change('title')

    love.keyboard.keysPressed = {} -- Create an empty Table to store the Keys Pressed.


end

-- Resize function used by Push.
function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)

    love.keyboard.keysPressed[key] = true -- Store the key pressed and set it to true.

    if key == 'escape' then     -- Close the window if esc was pressed.
        love.event.quit()
    end

end

-- Checks if a key was pressed. It can be used by any file outside of the main file.
function love.keyboard.wasPressed(key)

    if love.keyboard.keysPressed[key] then
        return true
    else 
        return false
    end
end


function love.update(dt)

    if scrolling then

        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    end

    gStateMachine:update(dt)
    
    love.keyboard.keysPressed = {} -- Reinitialize the keysPressed Table.


end

function love.draw()

    push:start()

    -- Draw the background
    love.graphics.draw(background, -backgroundScroll, 0) 

    -- Draw the State Machine
    gStateMachine:render()
    
    -- Draw the ground.
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16) -- 16 is the height of the sprite.
    
    push:finish()

end