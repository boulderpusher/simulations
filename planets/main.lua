function love.load()
	G = 1

	bodies = {
		{xPos = 200, yPos = 200, xVel = 100, yVel = 0, size = 10, mass = 1, color = {0, 1, 0}},
		{xPos = 300, yPos = 200, xVel = 0, yVel = -100, size = 10, mass = 1, color = {0, 0, 1}},
		{xPos = 250, yPos = 300, xVel = -60, yVel = -60, size = 10, mass = 1, color = {1, 0, 0}}
	}
end

function love.update(dt)
	for i = 1, #bodies do
		u = bodies[i]
		for j = i + 1, #bodies do
			v = bodies[j]
			f = force(u, v)
			d = dir(u, v)
			applyForce(u, f, d)
			applyForce(v, f, {-d[1], -d[2]})
		end
	end

	for i = 1, #bodies do
		applyVelocity(bodies[i], dt)
	end
end

function love.draw()
	for i = 1, #bodies do
		body = bodies[i]
		love.graphics.setColor(body.color)
		love.graphics.circle("fill", body.xPos, body.yPos, body.size)
	end
end

function dist(u, v)
	return math.sqrt((u.xPos - v.xPos)^2 + (u.yPos - v.yPos)^2)
end

function dir(u, v)
	return {v.xPos - u.xPos, v.yPos - u.yPos}
end

function force(u, v)
	return G * u.mass * v.mass / dist(u, v)
end

function applyForce(body, f, d)
	body.xVel = body.xVel + d[1] * f / body.mass
	body.yVel = body.yVel + d[2] * f / body.mass
end

function applyVelocity(body, dt)
	body.xPos = body.xPos + body.xVel * dt
	body.yPos = body.yPos + body.yVel * dt
end

