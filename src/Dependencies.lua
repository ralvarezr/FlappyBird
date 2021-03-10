-- Include the Push Library
push = require 'lib/push'

-- Include the Class Library
Class = require 'lib/class'


-- Include the Bird Class
require 'src/Bird'

-- Include the Pipe Class
require 'src/Pipe'

-- Include the Libraries related to the Game State and State Machines.
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/ScoreState'
require 'src/states/CountdownState'
require 'src/states/TitleScreenState'
require 'src/states/PauseState'

