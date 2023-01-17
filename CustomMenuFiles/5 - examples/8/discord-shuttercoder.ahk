data := "key1,valuea`nkey1,valueb`nkey2,valuea`nkey1,valuec"
afile := {}
loop, parse, data, `n
{
   temparr := strsplit(A_LoopField, ",")
   if (afile[temparr [1]] = "")
      afile[temparr [1]] := temparr[2]
   else
   {
      if afile[temparr [1]].count() < 1
         afile[temparr [1]] := [afile[temparr [1]], temparr[2]]
      else
         afile[temparr [1]].push(temparr[2])
   }
}


for k,v in afile
{
data.push(v)  
for k,v in v
data.push(v)
MsgBox, % k ".." v
}

