-- Just works particle system for ussaohelcim games
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

function PARTY()
	local self = {}
	self.particles = {}

	function self.addParticle(position, ttl,s,r)
		local found = false
		for i, particle in pairs(self.particles) do
			if particle.ttl <= 0 then
				found = true
				particle.x = position.x
				particle.y = position.y
				particle.ttl = ttl
				particle.s = s or math.random(0, 20)
				particle.r = r or 1
				particle.a = math.random() * (math.pi *2)
				break
			end
		end

		if not found then
			table.insert(
				self.particles,
				{
					x = position.x,
					y = position.y,
					ttl = ttl,
					a = math.random() * (math.pi *2),
					s = s or math.random(0, 20),
					r = r or 1
				}
			)
		end
	end

	function self.update()
		for i, particle in pairs(self.particles) do
			if particle.ttl > 0 then
				local d = AngleToNormalizedVector(particle.a)

				particle.x = particle.x + (d.x * particle.s )
				particle.y = particle.y + (d.y * particle.s)
				particle.ttl = particle.ttl - 1
				playdate.graphics.drawCircleAtPoint(particle.x, particle.y,particle.r)
			end
		end
	end
	return self
end