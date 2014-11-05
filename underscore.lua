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
		ret[k] = f(v, k)
	end
	return ret
end

function _.imap (t, f)
	local ret = {}
	if checkTable(t) or checkFunc(f) then
		return ret
	end
	for k, v in ipairs(t) do
		ret[k] = f(v, k)
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

function _.find(t, f)
	if checkTable(t) or checkFunc(f) then
		return
	end
	for k, v in pairs(t) do
		if f(v, k) then
			return v, k
		end
	end
end

function _.filter(t, f)
	local ret = {}
	if checkTable(t) or checkFunc(f) then
		return ret
	end
	for k, v in pairs(t) do
		if f(v, k) then
			ret[#ret + 1] = v
		end
	end
	return ret
end

function _.reject(t, f)
	return _.filter(t, function (v, k)
		return not f(v, k)
	end)
end

function _.where(t, e)
	return _.filter(t, function (v)
		if checkTable(e) then
			return v == e
		end
		for i, j in pairs(e) do
			if v[i] ~= j then
				return false
			end
		end
		return true
	end)
end

function findWhere(t, e)
	if checkTable(t) then
		return
	end
	for k, v in pairs(t) do
		local find = true
		for i, j in pairs(e) do
			if v[i] ~= j then
				find = false
				break
			end
		end
		if find then
			return v, k
		end
	end
end

function _.any(t, f)
	if checkTable(t) or checkFunc(f) then
		return false
	end
	for k, v in pairs(t) do
		if f(v, k) then
			return true
		end
	end
	return false
end

function _.all(t, f)
	if checkTable(t) or checkFunc(f) then
		return true
	end
	for k, v in pairs(t) do
		if not f(v, k) then
			return false
		end
	end
	return true
end

function _.max(t, f)
	if checkTable(t) then
		return t
	end
	local isStr = checkFunc(f)
	local m, value
	for k, v in pairs(t) do
		local cur
		if isStr then
			cur = v[f]
		else
			cur = f(v)
		end
		if m == nil or value < cur then
			m = v
			value = cur
		end
	end
	return m
end

function _.min(t, f)
	if checkTable(t) then
		return t
	end
	local isStr = checkFunc(f)
	local m, value
	for k, v in pairs(t) do
		local cur
		if isStr then
			cur = v[f]
		else
			cur = f(v)
		end
		if m == nil or value > cur then
			m = v
			value = cur
		end
	end
	return m
end

function _.sortBy (t, f)
	local isStr = checkFunc(f)
	local array = _.map(t, function (v)
		local e
		if  isStr then
			e = v[f]
		else
			e = f(v)
		end
		return {key = e, value = v}
	end)
	table.sort(array, function (a, b) return a.key < b.key end)
	return _.map(array, _.property('value'))
end

function groupBy(t, f)
	local isStr = checkFunc(f)
	local ret = {}
	if checkTable(t) then
		return ret
	end
	_.each(t, function (v)
		local e
		if  isStr then
			e = v[f]
		else
			e = f(v)
		end
		l = ret[e] or {}
		l[#l + 1] = v
		ret[e] = l	
	end)
	return ret
end

function _.invoke(t, name, ...)
	local ret = {}
	if checkTable(t) then
		return ret
	end
	for k, v in pairs(t) do
		ret[k] = v[name](v, ...)
	end
	return ret
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
	setmetatable(o, {__index = self})
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
