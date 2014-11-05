local _ = require 'underscore'

local function gen (name, age)
	return {
		name = name,
		age = age or math.random(1, 9),
		getAge = function (self)
			return self.age
		end
	}
end

local arr = {}
for i = 1, 10 do
	arr[#arr + 1] = gen('Bob' .. i)
end

_.pt(_.max(arr, _.property('age')))
assert(_.min(arr, 'name').name == 'Bob1')
print('=====')
_.pt(_.invoke(arr, 'getAge'))
print('=====')
print(_.reduce(arr, function (m, v) return m + v.age end, 0))
print('=====')
_.pt(_.map(arr, _.result('getAge')))
print('=====')
local arr2 = _.chain(arr):map(_.property('name')):tap(print):reduceRight(function (m, v) return m .. v end, ''):value()
print(arr2)

