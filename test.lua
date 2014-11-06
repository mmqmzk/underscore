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
print('=====invoke=====')
_.pt(_.invoke(arr, 'getAge'))
print('=====reduce=====')
print(_.reduce(arr, function (m, v) return m + v.age end, 0))
print('=====map result=====')
_.pt(_.map(arr, _.result('getAge')))
print('=====chain=====')
local arr2 = _.chain(arr):map(_.property('name')):tap(print):reduceRight(function (m, v) return m .. v end, ''):value()
print(arr2)
print('=====shuffle=====')
_.pt(_.shuffle(arr)[1])
print('=====sample=====')
_.pt(_.sample(arr))
print('=====unoin=====')
_.pt(_.unoin({1, 3, 5}, 2, {1, 2, 4}))
print('=====intersection=====')
_.pt(_.intersection({1, 3, 5}, {3, 5, 7}, {5, 7}))
print('=====differece=====')
_.pt(_.differece({1, 2, 3, 4, 5}, {1, 2}, 5))
print('=====uniq=====')
_.pt(_.uniq({1, 1, 2, 3, 3, 4, 5, 5}))
print('=====zip=====')
_.pt(_.zip({"a", 1, "A"}, {"b", 2, "B"})[1])
