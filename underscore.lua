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

return _
