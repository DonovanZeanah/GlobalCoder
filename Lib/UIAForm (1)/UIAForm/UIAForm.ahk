#SingleInstance force
#include <UIA-v2\Lib\UIA>
#include <UIA-v2\Lib\UIA_Browser>

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
		'full(\s+)?name'                                                  , 'My full name',
		'(post(al)?|zip)(\s+)?(code|zone)?'                               , 'My ZIP Code',
		'user(\s+)?name'                                                  , 'My_username',
		'(re-enter|confirm)\s+e-?mail'                                    , 'email@email.com',
		'((re-enter|confirm)\s+)?password'                                , 'Password123',
		'city'                                                            , 'City Name',
		'((tele)?(phone|fono)|mobile|cellulare|contact\s+(no\.?|number))' , 'My phone number',
		'street\s+address|indirizzo'                                      , 'My Street address',
		'company|organi(s|z)ation'                                        , 'My company name',
		'(your\s+)?e-?mail(\s+address)?'                                  , 'email@email.com',
	)

	for regex,value in elements
		try cache.FindCachedElement({matchmode:'RegEx',
		                             name: 'i)' regex,
		                             Type:'edit'}).SetValue(value)
		catch Error as e
			OutputDebug e.What '(' e.Extra '):`n' e.Message '`n'
}