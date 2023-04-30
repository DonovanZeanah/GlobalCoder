#include ..\FindText.ahk

/*
    A more advanced example implementing a search function for Notepad. 
    For this example, open Notepad and set the font (in the menubar Format -> Font...) 
        to Consolas, Regular, 11. 
    Fill Notepad with some example text. 
    Then run the following example and press F1, which brings up a search dialog. 

    Of course in Notepad Ctrl+F is far superior, because this FindText function 
    can only find text visible in the Notepad window, but something similar 
    could be used for example in games to look for text.
*/

; First some character sets for numbers, uppercase characters and lowercase characters (taken from Notepad font Consolas, Regular, 11)
numbers :="|<0>*139$10.7Uza6MD1wDnjQz3sD0q6DkS8|<1>*139$9.73sv4M30M30M30M30MzzzU|<2>*139$9.D7wlk60k61UQ71kQ70zzzU|<3>*139$8.TDu70kA6D3s30E43zjm|<4>*139$11.1k3UD0q1g6MMkVX37zzzUM0k1W|<5>*139$9.zryk60k60z7y0k70kCzbsU|<6>*139$10.3sTXUM1U5wzvVw3kBUq6DsS8|<7>*139$10.zzzk30M1UA0k60M30A1U60k8|<8>*139$10.7lza6MBVbCDkT7CMD0y7Tsz8|<9>*139$10.7Vz66kP0w3sRznv081UATVw8"
uppercase := "|<A>**50$12.000000003k3k3s7M6M6QCQCAACTyTyM7s7s30000000000U|<B>**50$10.0000003zDysvVy6svzDyszVy7sTzjw000000008|<C>**50$10.0000000TXzSDUC0s30A0s3UC0SAzly000000008|<D>**50$11.0000000DsTwkxUv0y1w3s7kDUP1q7jyTk000000000E|<E>**50$9.000000zzzk60k60zryk60k60zzz00000004|<F>**50$9.000000zzzk60k60zryk60k60k6000000004|<G>**50$11.00000000z3zC6s1k30CDwTs6sBkPknzVy000000000E|<H>**50$10.00000030w3kD0w3kDzzzkD0w3kD0w3000000008|<I>**50$9.000000zzz60k60k60k60k60kzzz00000004|<J>**50$8.00000Dzz1kQ71kQ71kQ7Xjvw0000002|<K>**50$10.0000003VyCsnbCsz3sDUz3iCQsvXi7000000008|<L>**50$9.000000s70s70s70s70s70s70zzz00000004|<M>**50$12.00000000QCQCKOSSSLPrPrPrtbs7s7s7s7s70000000000U|<N>**50$10.0000003Uz3wDsxXrDgyntjayTszXy7000000008|<O>**50$12.000000007sDwSSQ6M7s7s7s7s7M7QCSSDw7s0000000000U|<P>**50$10.0000003zDyszVy3sTXzyzXUC0s3UC0000000008|<Q>**50$12.000000007sDwSSQ6M7s7s7s7s7M7QCSSDw7s1U1n0z0S00U|<R>**50$10.0000003yDwlv3gClnyDknX7AQkv3g7000000008|<S>**50$10.0000000z7ywPUC0S0y0y0w1k7kTzbw000000008|<T>**50$10.0000003zzz30A0k30A0k30A0k30A0k000000008|<U>**50$10.00000030w3kD0w3kD0w3kD0y7sxzXw000000008|<V>**50$12.00000000s3s7M6Q6QCACCACQ6Q6M7s3s3k3k0000000000U|<W>**50$11.k7UD0y1w3tbnjjPSqxhDSSwxsu|<X>**50$11.sDktnVr3w3k7UD0z1y7CCCsRUS|<Y>**50$11.kDUTVnX7C7MDkD0C0M0k1U3062|<Z>**50$10.0000003zzz0M3UQ1UC0k60s30M3zzz000000008"
lowercase := "|<a>**50$10.000000003wTtVk7Dxzy7sTXrzDQ0000008|<b>**50$10.03UC0s3UCwzvty7sDUy3sTXzyTU0000008|<c>**50$10.000000001yDxsr0M3UC0M1knz7s0000008|<d>**50$10.001k70Q1lzTxly7sT1y7sTbrzDQ0000008|<e>**50$10.000000001wTtly3zzzy0s1k7zDw0000008|<f>**50$11.003wDss1k3UzxzsQ0s1k3U70C0Q0s00000002|<g>**50$11.0000000007zTytnVX77yDss1k3zXzi3wCzwzW|<h>**50$10.03UC0s3UCwzvtz7sTVy7sTVy7sQ0000008|<i>**50$9.71s70007sz0s70s70s70szzz000000U|<j>**50$9.1kD1k003yTk60k60k60k60k60qCzXsU|<k>**50$9.060k60k67lqQr7ky6sr6Qlq7000000U|<l>**50$9.07sz0s70s70s70s70s70szzz000000U|<m>**50$11.000000000TizxrTCyNwntbnDaTAyNk0000002|<n>**50$10.00000000Cwzvtz7sTVy7sTVy7sQ0000008|<o>**50$10.000000003wTvny7kD0w3sTnryDk0000008|<p>**50$10.00000000Cwzvty7sDUy3sTXzyzXUC0s3U8|<q>**50$10.000000001zTxly7sT1y7sTbrzDQ1k70Q1s|<r>**50$9.00000006yzzbsS0k60k60k60000000U|<s>**50$9.00000003wzr6s7UTUS0y6zrw000000U|<t>**50$11.0000A0s1kTzzyC0Q0s1k3U7070DsDk0000002|<u>**50$10.00000000C7sTVy7sTVy7sRrrzDQ0000008|<v>**50$10.00000000A3sTVq6QsnXADkO1s7U0000008|<w>**50$12.0000000000s3s7s7NbNqPqPqOKSSSSCS00000000U|<x>**50$10.00000000C7QRnXw7US1wDlnb7sQ0000008|<y>**50$12.0000000000M7QCQCAACQ6M7M7s3k3k1U3U70z0w0U|<z>**50$10.000000007zTs3UQ1UA1UC1k7zzw0000008"

characterset := lowercase . uppercase . numbers
; Add our newly created character set to PicLib library
FindText().PicLib(characterset, 1)

return

F1::
{
    searchPhrase := InputBox("Search Notepad for some text. To make the search case sensitive, put the search term in quotes.", "Search Notepad")
    If searchPhrase.Result != "OK"
        return
    searchPhrase := searchPhrase.Value
    caseSensitive := (SubStr(searchPhrase,1,1) == "`"") && (SubStr(searchPhrase,-1) == "`"")
    if caseSensitive
        searchPhrase := SubStr(searchPhrase,2,-1) ; For case-sensitive search remove double-quotes
    else
        searchPhrase:=StrLower(searchPhrase) ; For case-insensitive search, turn the search phrase into lowercase

    if FindText(&X, &Y,,,,, 0, 0, caseSensitive ? FindText().PicN(searchPhrase) : RegexReplace(characterset, "(?<=<)\p{L}(?=>)", "$L0"),1,1, caseSensitive ? 1 : [searchPhrase]).Length ; If doing a case-sensitive search, glue together the images for each character in searchphrase using PicN and use FindAll=1 to look for the resulting image. If doing case-insensitive search, replace all uppercase characters in our character set with lowercase characters (which means that FindText will use both uppercase and lowercase images in the search) and then look for the lowercase searchphrase.
    {
        FindText().MouseTip(X, Y)
        ; FindText().Click(X, Y, "L")
    }
    return
}