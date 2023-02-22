menuReferenceTools = 
( 
&Google Search 
http://www.google.com/search?hl=en&q=@@ 
Google Feeling Luc&ky Search
http://google.com/search?q=@@&btnI=I'm+Feeling+Lucky
Google &Images 
http://images.google.com/images?hl=en&q=@@ 
Google Feeling Lucky Images 
http://images.google.com/images?q=@@&btnI=I'm+Feeling+Lucky 
Google Large Images
http://www.google.com/images?as_q=@@&svnum=10&hl=en&btnG=Google+Search&as_epq=&as_oq=&as_eq=&imgsz=xxlarge&as_filetype=&imgc=&as_sitesearch
Google MP&3 Search
http://www.google.com/search?ie=UTF-8&sourceid=navclient&gfns=1&q=+-inurl:htm+-inurl:html+intitle:"index+of"+"Last+modified"+mp3+"@@"
A&9
http://a9.com/?q=@@
&Yahoo Image Search
http://images.search.yahoo.com/search/images?p=@@ 
&Dictionary.com 
http://www.dictionary.com/search?q=@@&db=*, , max 
The &Free Dictionary 
http://www.thefreedictionary.com/@@ 
&Merriam-Webster 
http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=@@ 
&Thesaurus
http://thesaurus.reference.com/search?q=@@
&Wikipedia 
http://en.wikipedia.org/w/wiki.phtml?search=@@ 
Wikipedia Full-Te&xt Search
http://en.wikipedia.org/wiki/Special:Search?search=@@&fulltext=Search
An&swers.com
http://www.answers.com/@@
&Columbia Encyclopedia 
http://columbia.thefreedictionary.com/@@ 
&Encarta Encyclopedia 
http://encarta.msn.com/encnet/refpages/search.aspx?q=@@ 
&AutoHotkey Commands 
http://www.autohotkey.com/docs/commands/@@.htm 
AllM&usic.com Artist Search
http://www.allmusic.com/cg/amg.dll?opt1=1&P=amg&sql=@@
TorrentS&py
http://www.torrentspy.com/search.asp?query=@@
White Pages Telephone Book
http://www.whitepages.com/search/SingleField?q=@@
Find Cou&rse Materials
C:\Program Files\AutoHotkey\Extras\Scripts\FindCourseMaterials.ahk @@
) 

^l:: 
   ClipSaved := ClipboardAll 
   Clipboard = 
   Send ^c 
   Sleep 100 
   CreateMenu("mRef", menuReferenceTools, "ReferenceTools") 
   Menu mRef, Show
   Clipboard := ClipSaved
   ClipSaved =
Return 

ReferenceTools: 
   RunMenuItem(menuReferenceTools, A_ThisMenuItemPos) 
Return 

CreateMenu(_menuName, _menuDef, _menuLabel) { 
   Loop Parse, _menuDef, `n 
   { 
      If (Mod(A_Index, 2) = 1) ; Odd 
      { 
         Menu %_menuName%, Add, %A_LoopField%, %_menuLabel% 
      } 
   } 
} 

RunMenuItem(_menuDef, _index) { 
   Loop Parse, _menuDef, `n 
   { 
      If (_index * 2 = A_Index) 
      { 
         StringReplace toRun, A_LoopField, @@, %Clipboard%, All 
         Run %toRun% 
         Break 
      } 
   } 
}