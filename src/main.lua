import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "particles"
import "mathHelper"
import "snake"

local player = Snake()
local egg = Egg()
local p = PARTY()

playdate.display.setRefreshRate(20)

-- playdate.ui.crankIndicator:start()

function playdate.update()
	-- if playdate.isCrankDocked() then
	-- 	playdate.ui.crankIndicator:update()
	-- end

	playdate.graphics.clear()

	--update particles positions and draw them
	p.update()

	player.move()
	
	egg.draw()
	player.draw()

	--if colliding with egg, create a new egg
	if CheckCollisionCircles(player.body[1], egg) then
		for i = 1, 10, 1 do
			p.addParticle(player.body[1],30)
		end
		egg = Egg()
		player.ateEgg = true
	end

	--if colliding, start a new snake
	if not player.isInsideScreen() or player.isCollidingWithSelf() then
		for i, bodyPart in pairs(player.body) do
			for x = 1, 10, 1 do
				p.addParticle(player.body[i],30,0.1)
			end
		end
		player = Snake()
	end

	playdate.timer.updateTimers()
end
