/*
/*
;------------------------------------
;  json转码纯AHK实现 v1.5  By FeiYue
;------------------------------------
*/

; Json字符串转AHK对象
json2obj(s){
  static rep:={"\""":"""", "\r":"`r", "\n":"`n", "\t":"`t"}
  if !(p:=RegExMatch(s, "[\{\[]", r))
    return
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  obj:=[], stack:=[], arr:=obj, flag:=r, key:="", keyok:=0
  While p:=RegExMatch(s, "\S", r, p+StrLen(r))
  {
    if (r="{" or r="[")       ; 如果是 左括号
    {
      v:=[], (flag="{" ? (arr[key]:=v) : arr.Push(v))
      , stack.Push(arr, flag), arr:=v, flag:=r
      , key:="", keyok:=0, v:=""
    }
    else if (r="}" or r="]")  ; 如果是 右括号
    {
      if !stack.MaxIndex()
        Break
      flag:=stack.Pop(), arr:=stack.Pop(), key:="", keyok:=0
    }
    else if (r=",")           ; 如果是 逗号
    {
      key:="", keyok:=0
    }
    else if (flag="{" and keyok=0)  ; 如果是 键名
    {
      if !(RegExMatch(s, "([^\s:]*)\s*:", r, p)=p)
        Break
      key:=Trim(r1,""""), keyok:=1
    }               ; 如果是 数字、true、false、null
    else if RegExMatch(s, "[\w\+\-\.]+", r, p)=p
    {
      (flag="{" ? (arr[key]:=r) : arr.Push(r))
    }
    else            ; 如果是 字符串
    {
      v:=""
      Loop
      {
        if !(RegExMatch(s, """([^""]*)""", r, p)=p)
          Break, 2
        if !(SubStr(StrReplace(r1,"\\"),0)="\")
          Break
        p+=StrLen(r)-1, v.=r1 . """"
      }
      if InStr(r1:=v . r1, "\")
      {
        r1:=StrReplace(r1, "\\", "\0")
        For k,v in rep
          r1:=StrReplace(r1, k, v)
        r1:=StrReplace(r1, "\0", "\")
      }
      (flag="{" ? (arr[key]:=r1) : arr.Push(r1))
    }
  }
  SetBatchLines, %bch%
  return obj
}


; AHK对象转Json字符串
obj2json(obj){
  static rep:={"\""":"""", "\r":"`r", "\n":"`n", "\t":"`t"}
  if !IsObject(obj)
  {
    if obj is Number
      return obj
    if (obj="true" or obj="false" or obj="null")
      return obj
    obj:=StrReplace(obj, "\", "\\")
    For k,v in rep
      obj:=StrReplace(obj, v, k)
    return """" obj """"
  }
  s:="", arr:=1  ; 是简单数组
  For k,v in obj
    if (k!=A_Index) and !(arr:=0)
      Break
  For k,v in obj
    s.=(arr ? " " : " """ k """ : ") %A_ThisFunc%(v) ",`r`n"
  return (arr ? "[`r`n":"{`r`n")
    . SubStr(s,1,-3) . (arr ? "`r`n]":"`r`n}")
}
s=
(
{
    "name": "BeJson",
    "url": "http://www.bejson.com",
    "page": 88,
    "isNonProfit": true,
    "address":
    {
        "street": "科技园路.",
        "city": "江苏苏州",
        "country": "中国"
    },
    "links":
    [
        {
            "name": "Google",
            "url": "http://www.google.com"
        },
        {
            "name": "Baidu",
            "url": "http://www.baidu.com"
        },
        {
            "name": "SoSo",
            "url": "http://www.SoSo.com"
        }
    ]
}
)
Goto, F1

F1::
t1:=A_TickCount
s:=obj2json(json2obj(s))
t1:=A_TickCount-t1
MsgBox, 4096, %t1% ms, % SubStr(s,1,1000)
return