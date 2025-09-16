function love.load()
	G = 1
	trailLength = 20

	bodies = {
		{xPos = 200, yPos = 200, xVel = 100, yVel = 50, size = 10, mass = 1, color = {0, 1, 0}, trail={}},
		{xPos = 300, yPos = 200, xVel = 0, yVel = -100, size = 10, mass = 1, color = {0, 0, 1}, trail={}},
		{xPos = 250, yPos = 300, xVel = -60, yVel = -60, size = 10, mass = 1, color = {1, 0, 0}, trail={}}
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

	for i, body in ipairs(bodies) do
		applyVelocity(body, dt)
		trackPosition(body)
	end
end

function love.draw()
	for _, body in ipairs(bodies) do
		drawBody(body)
		drawTrail(body)
	end
end

function drawBody(body)
	love.graphics.setColor(body.color)
	love.graphics.circle("fill", body.xPos, body.yPos, body.size)
end

function drawTrail(body)
	local color = {}
	for i, v in ipairs(body.color) do
		table.insert(color, v)
	end
	for i, pos in ipairs(body.trail) do
		color[4] = i * (1 / #body.trail)
		love.graphics.setColor(color)
		love.graphics.circle("fill", pos[1], pos[2], i * body.size / #body.trail)
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

function trackPosition(body)
	if #body.trail >= trailLength then
		table.remove(body.trail, 1)
	end
	table.insert(body.trail, {body.xPos, body.yPos})
end


