#SingleInstance force
#include d:/lib/UIA2.ahk
#include d:/lib/UIA_Browser.ahk

^6::
{
	browser := UIA_Browser('A')
	
	cashRequest := UIA.CreateCacheRequest(['name', 'type'], unset, 'descendants')
	cache := browser.BuildUpdatedCache(cashRequest)

	; ToolTip browser.GetCurrentURL()

	if browser.ElementExist({matchmode:'RegEx',name:'i)\b(first\s)?name|nome\b',Type:'edit'})
	{
		browser.FindElement({matchmode:'RegEx',
		                     name:'i)(first\s+)?name|nome',
		                     Type:'edit'}).SetValue('My first name')
		browser.FindElement({matchmode:'RegEx',
		                     name:'i)(last|family|sur)(\s+)?name|cognome',
		                     Type:'edit'}).SetValue('My surname')
	}

	elements := Map(
		'full(\s+)?name'                                                  , 'Donovan Zeanah',
		'user(\s+)?name'                                                  , 'donovan.zeanah@outlook.com',
		'(post(al)?|zip)(\s+)?(code|zone)?'                               , '35475',
		'(re-enter|confirm)\s+e-?mail'                                    , 'donovan.Zeanah@outlook.com',
		'((re-enter|confirm)\s+)?password'                                , '3de32882D!',
		'city'                                                            , 'Northport',
		'((tele)?(phone|fono)|mobile|cellulare|contact\s+(no\.?|number))' , '2057991734',
		'street\s+address|indirizzo'                                      , '17038 finnell rd',
		'company|organi(s|z)ation'                                        , '',
		'(your\s+)?e-?mail(\s+address)?'                                  , 'donovan.Zeanah@outlook.com',
	)

	for regex,value in elements
		try cache.FindCachedElement({matchmode:'RegEx',
		name: 'i)' regex,
			Type:'edit'}).SetValue(value)
			catch Error as e
	OutputDebug e.What '(' e.Extra '):`n' e.Message '`n'
}