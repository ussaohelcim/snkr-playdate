-- The main part of snkr-playdate game
-- Copyright (C) 2022  ussaohelcim

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
local slowTime = 0
local fps = {
	normal = 20,
	slow = 10
}
local highscore = json.decodeFile("highscore.json") or {score = 0}
local score = 0

playdate.display.setRefreshRate(fps.normal)

function playdate.update()
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
		score = score + 1
	end

	--if colliding, start a new snake
	if not player.isInsideScreen() or player.isCollidingWithSelf() then
		slowTime = 10
		playdate.display.setRefreshRate(fps.slow)

		for i, bodyPart in pairs(player.body) do
			for x = 1, 10, 1 do
				p.addParticle(player.body[i],40,0.5,3)
			end
		end
		if score > highscore.score then
			local saveData = {
				score = score
			}
			playdate.datastore.write(saveData, "highscore")
			highscore.score = score
		end
		score = 0
		player = Snake()
	end

	if slowTime > 0 then
		slowTime = slowTime - 1
		if slowTime < 1 then
			slowTime = 0
			playdate.display.setRefreshRate(fps.normal)
		end
	end
	drawScore()
end

function drawScore()
	playdate.graphics.drawText("Score: "..score..", Highscore: "..highscore.score,0,0)
end
