-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local Flipbook = require 'flipbook'

local myFirstFlipbook = Flipbook:newFlipbook("background_back.png", "mainshadow.png", "newshadow.png", "curlshadow.png" )
myFirstFlipbook:addPage( "backgroundA.png" )
myFirstFlipbook:addPage( "backgroundB.png" )
myFirstFlipbook:addPage( "backgroundC.png" )

