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
local highscore = json.decodeFile("highscore.json") or {score = 0}
local score = 0

local sounds = {
	highscore = playdate.sound.sampleplayer.new("sounds/highscore.wav"),
	death = playdate.sound.sampleplayer.new("sounds/death.wav"),
	egg = playdate.sound.sampleplayer.new("sounds/egg.wav")
}

playdate.display.setRefreshRate(20)

local bg = playdate.graphics.image.new(400,240)

playdate.graphics.pushContext(bg)
playdate.graphics.drawRect(0,0,400,240)
playdate.graphics.popContext()

playdate.graphics.sprite.setBackgroundDrawingCallback(
	function( x, y, width, height )
		bg:draw( 0, 0 )
	end
)

function playdate.update()
	playdate.graphics.sprite.update()

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

		if score > highscore.score then
			sounds.highscore:play(1)
		else
			sounds.egg:play(1)
		end
	end

	--if colliding, start a new snake
	if not player.isInsideScreen() or player.isCollidingWithSelf() then
		sounds.death:play(1)
		
		for i, bodyPart in pairs(player.body) do
			p.addParticle(player.body[i],40,0.5,3)
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

	drawScore()
	
end

function drawScore()
	playdate.graphics.drawText("Score: "..score..", Highscore: "..highscore.score,0,0)
end
