local _ = {}

local function checkTable (t)
	return type(t) ~= 'table'
end

local function checkFunc (f)
	return type(f) ~= 'function'
end

function _.each (t, f)
	if checkTable(t) or checkFunc(f) then
		return
	end
	for k, v in pairs(t) do
		f(v, k)
	end
end

function _.forEach (t, f)
	if checkTable(t) or checkFunc(f) then
		return
	end
	for k, v in pairs(t) do
		f(k, v)
	end
end

function _.pt (t)
	_.forEach(t, print)
end

function _.map (t, f)
	local ret = {}
	if checkTable(t) or checkFunc(f) then
		return ret
	end
	for k, v in pairs(t) do
		ret[k] = f(k , v)
	end
	return ret
end

function _.reduce (t, f, m)
	if checkTable(t) or checkFunc(f) then
		return m
	end
	for k, v in pairs(t) do
		m = f(m, v, k)
	end
	return m
end

function _.reduceRight (t, f, m)
	if checkTable(t) or checkFunc(f) then
		return m
	end
	for i = #t, 1, -1 do
		m = f(m, t[i], i)
	end
	return m
end
--[[
--
--]]

function _.property(name)
	return function (t)
		return t[name]
	end
end

function _.result(name, ...)
	local args = {...}
	return function (t)
		if checkTable(t) then
			return t
		end
		if checkFunc(t[name]) then
			return t[name]
		end
		return t[name](t, unpack(args))
	end
end

local Chain = {}
function Chain:new(t, o)
	o = o or {}
	self.chained = t
	setmetatable(o, self)
	self.__index = self
	return o
end

function Chain:tap(f)
	_.forEach(self.chained, f)
	return self
end

function Chain:value()
	return self.chained
end

_.forEach(_, function (k, f)
	Chain[k] = function (self, ...)
		self.chained = f(self.chained, ...)
		return self
	end
end)

function _.chain(t)
	return Chain:new(t)
end
return _
