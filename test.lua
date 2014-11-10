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
print('=====object=====')
_.pt(_.object({"a", "b", "c"}, {3, 2, 1}))
_.pt(_.object{{"d", 4}, {"e", 5}})
print('=====indexOf=====')
assert(_.indexOf({3, 5, 6}, 5) == 2)
assert(_.indexOf({1, 3, 4, 7, 9}, 7, true) == 4)
assert(_.indexOf({1, 3, 4, 7, 9}, 2, true) == nil)
print('=====slice=====')
local arr3 = {"a", "b", "c", "d", "e"}
print('_.pt(_.slice(arr3)')
_.pt(_.slice(arr3))
print('_.pt(_.slice(arr3, 2)')
_.pt(_.slice(arr3, 2))
print('_.pt(_.slice(arr3, 1, 4))')
_.pt(_.slice(arr3, 1, 4))
print('_.pt(_.slice(arr3, -2, -1))')
_.pt(_.slice(arr3, -2, -1))
print('=====splice=====')
local arr4 = {"a", "b", "c", "d", "e"}
print('_.pt(_.splice(arr4, 2))')
_.pt(_.splice(arr4, 2))
print('---')
_.pt(arr4)
print('_.pt(_.splice(arr4, 2, 2, "f")')
_.pt(_.splice(arr4, 2, 2, "f", "g"))
print('---')
_.pt(arr4)
_.splice(arr4)
assert(#arr4 == 0)
print('=====lastIndexOf=====')
assert(_.lastIndexOf({3, 5, 6}, 5) == 2)
assert(_.lastIndexOf({1, 3, 4, 7, 9}, 7, true) == 4)
assert(_.lastIndexOf({1, 3, 4, 7, 9}, 2, true) == nil)
print('=====range=====')
_.pt(_.range(3))
_.pt(_.range(2, 5))
_.pt(_.range(2, 10, 2))
print('=====bind=====')
local function foo(a, b, c)
	return a + b + c
end
local bar = _.bind(foo, 1, 2)
print(bar(3))
local foo2 = _.bind(arr[1].getAge, arr[1])
print('bind getage :', foo2())


