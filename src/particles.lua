import "mathHelper"

function PARTY()
	local self = {}
	self.particles = {}

	function self.addParticle(position, ttl,s)
		local found = false
		for i, particle in pairs(self.particles) do
			if particle.ttl <= 0 then
				found = true
				particle.x = position.x
				particle.y = position.y
				particle.ttl = ttl
				particle.s = s or math.random(0,20)
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
					s = s or math.random(0,20)
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

				playdate.graphics.drawPixel(particle.x, particle.y)
			end
		end
	end
	return self
end