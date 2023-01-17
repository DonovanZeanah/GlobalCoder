assert.label("sort")
StringCaseSense, On


; test subgroup 1: basic arrays
string_array := ["Delta","alpha","delta","Beta","Charlie","beta","Alpha","charlie"]
number_array := [11,9,5,10,1,6,3,4,7,8,2]
assert_strings := ["Alpha","Beta","Charlie","Delta","alpha","beta","charlie","delta"]

assert.label("sort - String array")
assert.test(string_array.sort(), assert_strings)

assert.label("sort - Number array")
assert.test(number_array.sort(), [1,2,3,4,5,6,7,8,9,10,11])


; test group 2: complex arrays (objects)
complex_array := [{"symbol": "Delta", "morse": "-***"}
    , {"symbol": "alpha", "morse": "*-"}
    , {"symbol": "delta", "morse": "-**"}
    , {"symbol": "Beta", "morse": "-***"}
    , {"symbol": "Charlie", "morse": "-*-*"}
    , {"symbol": "beta", "morse": "-***"}
    , {"symbol": "Alpha", "morse": "*-"}
    , {"symbol": "charlie", "morse": "-*-*"}]

accessor_fn := func("objProp_get").bind("symbol")
sorting_fn := func("complex_sort").bind(accessor_fn)
complex_array.sort(sorting_fn)

assert.label("sort - Using accessor function with complex arrays: key='symbol'")
assert.test(complex_array.map(accessor_fn), assert_strings)

accessor_fn := func("objProp_get").bind("morse")
assert_morse := ["*-","-***","-*-*","-***","*-","-***","-*-*","-**"]

assert.label("sort - Using accessor function with complex arrays: key='morse'")
assert.test(complex_array.map(accessor_fn), assert_morse)
