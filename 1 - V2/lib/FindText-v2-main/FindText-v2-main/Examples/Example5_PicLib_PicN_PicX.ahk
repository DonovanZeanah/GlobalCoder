#include ..\FindText.ahk

FindText().PicLib("|<auto>*159$40.0000k000003000000A00DVUnw7lr6371nUAMAA630FUkkkAT63330rgMAAA1kFUkkkD363330wAAAA62vkvkkQtt1v1kS8", 1) ; Adds "auto" Text into library 1 (the default library)
FindText().PicLib("|<hot>*152$29.U00010000200014000280004Hk7kzxktktVVUkX161V43A3286M24EAkA8UNUMF0lUUW1Xb1g31s1s",1,2) ; Adds "hot" Text into library 2

MsgBox("Sliced `"hot`" into characters: " FindText().PicX("|<hot>*152$29.U00010000200014000280004Hk7kzxktktVVUkX161V43A3286M24EAkA8UNUMF0lUUW1Xb1g31s1s"))

Text:="|<mycomment>[0.1,0.1]*197$15.1U8A11U8C11k8600s0700Q01U004"
info := FindText().PicInfo(Text)
MsgBox("v: " info[1] "`nw: " info[2] "`nh: " info[3] "`nlen1: " info[4] "`nlen0: " info[5] "`ne1: " info[6] "`ne0: " info[7] "`nmode: " info[8] "`ncolor: " info[9] "`nn: " info[10] "`ncomment: " info[11] "`nseterr: " info[12])