
; 返回所有匹配项的RegExMatch对象数组
m:=RegExMatchAll('312gs43gt536bfg5', '\d+')
; [{0:'312'},{0:'43'},{0:'536'},{0:'5'}]
; 字符串中的整数部分*2
msgbox RegExReplaceEx('312gs43gt536bfg5', '\d+', (m)=>m[0]*2)
; 624gs86gt1072bfg10
; 单词首字母大写
msgbox RegExReplaceEx('The_quick_brown_fox_jumps_over_the_lazy_dog', 'i)[a-z]+' (m)=>StrUpper(m[0]))
; The_Quick_Brown_Fox_Jumps_Over_The_Lazy_Dog
; 简单字符串计算
msgbox RegExReplaceEx('87*324=', '(\d+)\*(\d+)=', (m)=>m[0] (m[1]*m[2]))
; 87*324=28188




/************************************************************************
 * @file: RegEx.ah2
 * @description: 正则函数扩展，RegExReplaceEx、RegExMatchAll
 * @author thqby
 * @date 11/23/2020
 * @version 1.0
 ***********************************************************************/
/**
 * @description 正则替换加强版，支持匹配项计算
 * @param Haystack: string 需要替换的字符串
 * @param NeedleRegEx: string 正则表达式
 * @param CallBack: funcobj 回调函数，参数Match对象，返回值计算后的字符串
 * @param Limit: integer 允许替换的最大次数
 * @param StartingPosition: integer
 * @return string 返回 Haystack 被替换之后的值
 */
RegExReplaceEx(Haystack, NeedleRegEx, CallBack, Limit := -1, StartingPosition := 1) {
    LastFoundPos := 1, Ret := '', RegExReplace(Haystack, NeedleRegEx '(?CCallout)', '', , Limit, StartingPosition)
    return Ret SubStr(Haystack, LastFoundPos)
    Callout(Match, CalloutNumber, FoundPos, *) => (Ret .= SubStr(Haystack, LastFoundPos, FoundPos - LastFoundPos) CallBack.Call(Match), LastFoundPos := FoundPos + StrLen(Match[0]), 0)
}
/**
 * @description 正则全局模式，返回所有匹配项
 * @param Haystack: string 需要替换的字符串
 * @param NeedleRegEx: string 正则表达式
 * @param StartingPosition: integer
 * @return array | 0 返回所有匹配项数组，无匹配项时返回0
 */
RegExMatchAll(Haystack, NeedleRegEx, StartingPosition:=1){
    Matchs := [], RegExReplace(Haystack, NeedleRegEx '(?CCallout)', , , , StartingPosition)
    return Matchs.Length ? Matchs : 0
    Callout(Match, *) => (Matchs.Push(Match), 0)
}