SetBatchLines -1
#include <print>
;#include <p>
n:=35
DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)

fib2(n)
result := fib2(n)
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
msgbox % "> " . result . "`n> " . CounterBefore . "`n> " . CounterAfter . "`nTime: " . (CounterAfter - CounterBefore)
print(result)
;p(result)
m(result)

fib2(n){
    fib:=0
    fibn_1:=0
    fibn_2:=1
    Loop, % n-1
        fib:=fibn_1+fibn_2, fibn_1:=fibn_2, fibn_2:=fib
    return fib
}





n:=bigFib(1000).print(1)

bigFib(n){
    fib:=       new bigN(0)
    fibn_1:=    new bigN(0)
    fibn_2:=    new bigN(1)
    Loop, % n-1
        fib:=bigN.sum(fibn_1,fibn_2), fibn_1:=fibn_2, fibn_2:=fib
    return fib
}

class bigN{
    __new(N){
        if IsObject(N)
            this.num:=N
        else
            this.num:=StrSplit(N?N:0)
    }
    
    print(mb:=0){
        for k, n in this.num
            str.=n
        if mb
            MsgBox, % str
        return str
    }
    
    sum(a,b){
        tmp:=[]
        rp:=0
        a.num.length()>=b.num.length() ? (la:=a.num.clone(), sa:=b.num.clone()) : (la:=b.num.clone(), sa:=a.num.clone()) ; la - long array, sa, short array
        Loop, % la.length()
        {
            ln:=la.pop(), sn:=sa.pop()
            sn:=sn?sn:0
            tmp.InsertAt(1,mod(ln+sn+rp,10))
            rp:=ln+sn+rp>9
        }
        rp ? tmp.InsertAt(1,1) : ""
        return new bigN(tmp)
    }
}

;--------------------------


InputBox, n, Input n

DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
result := f(n)
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
msgbox % "> " . result . "`n> " . CounterBefore . "`n> " . CounterAfter . "`nTime: " . (CounterAfter - CounterBefore)


Start1 := A_TickCount
MsgBox, % f(n) "`n" A_TickCount - Start
Start2 := A_TickCount

MsgBox, % f2(n) "`n" A_TickCount - Start1 - start2

f(n)
{
    x:=0, xp:=1
    Loop %n%
    {
        r:=x+xp
        xp=%x%
        x=%r%
    }
    return r
}

2::
f2(n := "")
{
    static xp, x
    if n=1
    { 
        xp := 0
        return x := 1
    }
    f2(n-1)
    r:=x+xp
    xp=%x%
    x=%r%
    return x
}
return