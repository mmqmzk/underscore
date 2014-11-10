local _ = {}

local function checkTable (t)
	return type(t) ~= 'table'
end

local function checkFunc (f)
	return type(f) ~= 'function'
end

function _.keys(t)
	local result = {}
	if checkTable(t) then
		return result
	end	
	for k, v in pairs(t) do
		result[#result + 1] = k
	end
	return result
end

function _.values(t)
	local result = {}
	if checkTable(t) then
		return result
	end
	for k, v in pairs(t) do
		result[#result + 1] = v
	end
	return result
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
	local result = {}
	if checkTable(t) or checkFunc(f) then
		return result
	end
	for k, v in pairs(t) do
		result[k] = f(v, k)
	end
	return result
end

function _.imap (t, f)
	local result = {}
	if checkTable(t) or checkFunc(f) then
		return result
	end
	for k, v in ipairs(t) do
		result[k] = f(v, k)
	end
	return result
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
	t = _.values(t)
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
	local result = {}
	if checkTable(t) or checkFunc(f) then
		return result
	end
	for k, v in pairs(t) do
		if f(v, k) then
			result[#result + 1] = v
		end
	end
	return result
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
			cur = f(v, k)
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
			cur = f(v, k)
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
	local array = _.map(t, function (v, k)
		local e
		if  isStr then
			e = v[f]
		else
			e = f(v, k)
		end
		return {key = e, value = v}
	end)
	table.sort(array, function (a, b) return a.key < b.key end)
	return _.map(array, _.property('value'))
end

function groupBy(t, f)
	local isStr = checkFunc(f)
	local result = {}
	if checkTable(t) then
		return result
	end
	_.each(t, function (v, k)
		local e
		if  isStr then
			e = v[f]
		else
			e = f(v, k)
		end
		l = result[e] or {}
		l[#l + 1] = v
		result[e] = l	
	end)
	return result
end

function _.pluck(t, name)
	local result = {}
	if checkTable(t) then
		return result
	end
	for k, v in pairs(t) do
		if checkTable(v) then
			result[#result + 1] = v
		else
			result[#result + 1] = v[name]
		end
	end
	return result
end

function _.invoke(t, name, ...)
	local result = {}
	if checkTable(t) then
		return result
	end
	for k, v in pairs(t) do
		result[k] = v[name](v, ...)
	end
	return result
end

function _.shuffle(t)
	local result = _.values(t)
	for i = #result, 1, -1 do
		r = math.random(1, i)
		result[i], result[r] = result[r], result[i]
	end
	return result
end

function _.sample(t, n)
	n = n or 1
	local array = _.values(t)
	local result = {}
	local m = n
	for i = #array, 1, -1 do
		r = math.random(1, i)
		if r <= m then
			m = m - 1
			result[#result + 1] = array[i]
		end
	end
	if n == 1 then
		return result[1]
	end
	return result
end

function _.unoin(...)
	local result = {}
	local set = {}
	for k, v in ipairs{...} do
		if checkTable(v) then
			if not set[v] then
				set[v] = 1
				result[#result + 1] = v
			end
		else
			for i, j in pairs(v) do
				if not set[j] then
					set[j] = 1
					result[#result + 1] = j
				end
			end
		end
	end
	return result
end

function _.intersection(...)
	local tables = {...}
	local result = {}
	local set = {}
	for k, v in ipairs(tables) do
		if checkTable(v) then
			set[v] = 1 + (set[v] or 0)
		else
			for i, j in pairs(v) do
				set[j] = 1 + (set[j] or 0)
			end
		end
	end
	local m = #tables
	for k, v in pairs(set) do
		if v == m then
			result[#result + 1] = k
		end
	end
	return result
end

function _.differece(t, ...)
	if checkTable(t) then
		return {}
	end
	local set = {}
	for k, v in pairs(t) do
		set[v] = 1	
	end
	for k, v in ipairs{...} do
		if checkTable(v) then
			set[v] = nil
		else
			for i, j in pairs(v) do
				set[j] = nil
			end
		end
	end
	return _.keys(set)
end

function _.uniq(t, f)
	if checkTable(t) then
		return t
	end
	local set = {}
	for k, v in pairs(t) do
		local value
		if not f then
			value = v
		elseif checkFunc(f) then
			if checkTable(v) then
				value = v
			else
				value = v[f]
			end
		else
			value = f(v, k)
		end
		set[value] = v
	end
	return _.values(set)
end

function _.zip(...)
	local tables = {...}
	local m = #tables
	local n = #(tables[1])
	local result = {}
	for i = 1, n do
		local t = {}
		for j = 1, m do
			t[#t + 1] = tables[j][i]
		end
		result[i] = t
	end
	return result
end

function _.object(keys, values)
	local result = {}
	if checkTable(keys) then
		result[keys] = values
		return result
	end
	if not values then
		for k, v in pairs(keys) do
			result[v[1]] = v[2]
		end
	else
		for k, v in pairs(keys) do
			result[v] = values[k]
		end
	end
	return result
end

function _.indexOf(t, e, isSorted)
	if checkTable(t) then
		return
	end
	if isSorted then
		local i = 1
		local j = #t
		while i <= j do
			local m = math.floor((i + j) / 2)
			if t[m] == e then
				return m
			elseif e < t[m] then
				j = m - 1
			else
				i = m + 1
			end
		end
	else
		for k, v in pairs(t) do
			if v == e then
				return k
			end
		end
	end
end

function _.lastIndexOf(t, e)
	if checkTable(t) then
		return
	end
	for i = #t, 1, -1 do
		if t[i] == e then
			return i
		end
	end
end

function _.range(start, stop, step)
	step = step or 1
	if not stop then
		stop = start
		start = 1
	end

	local result = {}
	for i = start, stop, step do
		result[#result + 1] = i
	end
	return result
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

function _.bind(f, ...)
	if checkFunc(f) then
		return
	end
	local args = {...}
	return function (...)
		local param = _.slice(args)
		for k, v in ipairs{...} do
			param[#param + 1] = v
		end
		return f(unpack(param))
	end
end

function _.slice(t, from, to)
	if checkTable(t) then
		return t
	end
	local len = #t
	from = from or 1
	to = to or len
	if from < 0 then
		from = from + len + 1
	end
	if to < 0 then
		to = to + len + 1
	end
	local result = {}
	for i = from, to do
		result[#result + 1] = t[i]
	end
	return result
end

function _.splice(t, from, n, ...)
	local inserts = {...}
	if checkTable(t) then
		return inserts
	end
	from = from or 1
	if from < 0 then
		from = from + #t + 1
	end
	n = n or #t - from + 1
	local result = {}
	for i = 1, n do
		result[#result + 1] = table.remove(t, from)
	end
	for k, v in ipairs(inserts) do
		table.insert(t, from + k - 1, v)
	end
	return result
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
