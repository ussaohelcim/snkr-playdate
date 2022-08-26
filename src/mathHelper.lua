---Get a normalized vector pointing to an angle
---@param angle number in radians
function AngleToNormalizedVector(angle)
	return { 
		x = math.cos(angle),
		y = math.sin(angle)
	}
end
---Get the angle from the origin to a point
---@param x number x property of a vector2
---@param y number y property of a vector2
---@return number
function Vec2angle(x,y)
	return math.atan(y,x)
end

function DistanceFromPoints(v1, v2)
	return math.sqrt((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y))
end

function CheckCollisionCircles(circle1,circle2)
	local dx = circle2.x - circle1.x
	local dy = circle2.y - circle1.y
	local distance = math.sqrt(dx*dx + dy*dy)

	return distance <= (circle1.r + circle2.r)
end

function CheckCollisionCircleRect(center,rec)
	local collision = false

	local recCenterX = (rec.x + rec.w/2.0);
	local recCenterY = (rec.y + rec.h/2.0);

	local dx = math.abs(center.x - recCenterX);
	local dy = math.abs(center.y - recCenterY);

	if (dx > (rec.w/2.0 + center.r)) then
		return false
	end 

	if (dy > (rec.h/2.0 + center.r)) then
		return false
	end 

	if (dx <= (rec.w/2.0)) then
		return true
	end 
	if (dy <= (rec.h/2.0)) then
		return true
	end 

	local cornerDistanceSq = (dx - rec.w/2.0)*(dx - rec.w/2.0) +
														(dy - rec.h/2.0)*(dy - rec.h/2.0);

	collision = (cornerDistanceSq <= (center.r*center.r));

	return collision;
end