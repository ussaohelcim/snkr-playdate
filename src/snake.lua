-- The snake code, with movement, collision etc.
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

import "mathHelper"

local screen = {x = 0, y = 0, w = 400, h = 240 }

function Snake()
	local self = {}

	self.ateEgg = false
	self.angle = 0
	self.body = {
		{
			x = screen.w / 2,
			y = screen.h / 2,
			r = 3,
			withEgg = false
		}
	}

	function self.move()
		local tempHead = {
			x = self.body[1].x,
			y = self.body[1].y,
			r = self.body[1].r,
			withEgg = false
		}

		local d = AngleToNormalizedVector(
			math.rad(playdate.getCrankPosition() - 90) 
		)

		tempHead.x = tempHead.x + (d.x * (tempHead.r * 2))
		tempHead.y = tempHead.y + (d.y * (tempHead.r * 2))

		if self.ateEgg then
			tempHead.withEgg = true
			self.ateEgg = false
		else
			table.remove(self.body)
		end
		
		table.insert(self.body,1,tempHead)
			
	end

	function self.draw()
		for i, bodyPart in pairs(self.body) do
			local r = bodyPart.r
			if bodyPart.withEgg then
				r = r * 2
			end
			playdate.graphics.fillCircleAtPoint(bodyPart.x,bodyPart.y, r)
		end
	end

	function self.isCollidingWithSelf()
		local collided = false
		for i, bodyPart in pairs(self.body) do
			if i > 3 and CheckCollisionCircles(self.body[1],bodyPart) then
				collided = true
				break
			end
		end
		return collided
	end

	function self.isInsideScreen()
		return CheckCollisionCircleRect(self.body[1],screen)
	end

	return self
end

function Egg()
	local self = {}

	self.r = 10
	self.y = math.random(self.r,screen.h - self.r)
	self.x = math.random(self.r,screen.w - self.r)

	function self.draw()
		playdate.graphics.drawCircleAtPoint(self.x,self.y, self.r)
	end

	return self
end
