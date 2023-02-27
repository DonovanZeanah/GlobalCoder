#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#include d:/lib/mcode.ahk


;mcode("2,x86:uCoAAADD")
MCode(mcode)
{
  static e := {1:4, 2:1}, c := (A_PtrSize=8) ? "x64" : "x86"
  if (!regexmatch(mcode, "^([0-9]+),(" c ":|.*?," c ":)([^,]+)", m))
    return
  if (!DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", 0, "uint*", s, "ptr", 0, "ptr", 0))
    return
  p := DllCall("GlobalAlloc", "uint", 0, "ptr", s, "ptr")
  if (c="x64")
    DllCall("VirtualProtect", "ptr", p, "ptr", s, "uint", 0x40, "uint*", op)
  if (DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", p, "uint*", s, "ptr", 0, "ptr", 0))
    return p
  DllCall("GlobalFree", "ptr", p)
}

MyFunction := MCode("2,x86:uCoAAADD,x64:uCoAAADD")
Msgbox % DllCall(MyFunction,"cdecl")

MCode(MSb32,"5589E58B45085D0FBDC0C3")
MCode(LSb32,"5589E58B45085D0FBCC0C3")
MCode(SHR32,"8B4424048B4C2408D3F8C3")
MCode(SRL64,"8B4C240C83E13F83F92073108B4424048B5424080FADD0D3EAC20C00") ; 64-bit Shift-Right-Logical (unsigned,standard call)
MCode(ROL32,"5589E58B45088B4D0C5DD3C0C3") ; Rotate Left  32 bits (unsigned)
MCode(ROR32,"5589E58B45088B4D0C5DD3C8C3") ; Rotate Right 32 bits (unsigned)
MCode(ROL64,"5589E583EC0C891C248B5D08897424048B750C89D8897C24088B7D1089F289F9D3E00FA5DAF6C120740489C231C0B94"
. "000000029F90FADF3D3EEF6C120740489F331F609D809F28B1C248B7424048B7C240889EC5DC3")
MCode(ROR64,"5589E583EC0C891C248B5D08897424048B750C89D8897C24088B7D1089F289F9D3EA0FADF0F6C120740489D031D2B94"
. "000000029F90FA5DED3E3F6C120740489DE31DB09D809F28B1C248B7424048B7C240889EC5DC3")
MCode(BSwap16,"8AE18AC5C3")
MCode(BSwap32,"8BC10FC8C3") ; Byte Swap (little <--> big endian)
MCode(BSwap64,"8B5424088B4424040FCA0FC88BC88BC28BD1C3")
MCode(Parity64,"8B4C2408334C24048BC1D1E833C88BC1C1E80233C88BC1C1E80433C88BC1C1E80833C88BC1C1E81033C183E001C3")
MCode(Parity32,"8B4C24048BC1D1E833C88BC1C1E80233C88BC1C1E80433C88BC1C1E80833C88BC1C1E81033C183E001C3")
MCode(Parity16,"5589E50FB755085D89D0D1E831D089C1C1E90231C189C8C1E80431C889C2C1EA0831D083E001C3")
MCode(Parity8,"8A4424048AC8D0E932C18AC8C0E90232C10FB6C88BC1C1E80433C183E001C3")
MCode(BitRev32,"5589E58B4D085D89C8255555555581E1AAAAAAAA01C0D1E909C889C281E23333333325CCCCCCCCC1E202C1E80209"
. "C289D0250F0F0F0F81E2F0F0F0F0C1E004C1EA0409D00FC8C3")
MCode(BitCnt32,"8B4C24048BC1D1E825555555552BC88BC1C1E802BA3333333323C223CA03C18BC8C1E90403C881E10F0F0F0F8BC1"
. "C1E80803C88BC1C1E81003C125FF000000C3")
MCode(BitZip32,"8B44240433C98A6C24068BD025FF0000FF81E200FF000056C1E2080BCA0BC88BC18BF1C1E804BAF000F00023F223"
. "C2C1E6040BC681E10FF00FF00BC18BC88BF0BA0C0C0C0C23F2C1E902C1E60223CA0BCE25C3C3C3C30BC88BC1BA222222228BF1D1E823F223C203F60BC681E1999999990BC15EC3")
MCode(BitUnZip32,"8B4C2404568BC18BF1D1E881E199999999BA2222222223C223F203F60BC60BC18BC88BF0C1E902BA0C0C0C0C23"
. "F223CA25C3C3C3C3C1E6020BCE0BC88BC18BF1C1E804BAF000F00023C223F2C1E6040BC681E10FF00FF00BC18944240833C98A6C240A8BD081E200FF0000C1E20825FF0000FF5E0BCA0BC1C3")
MCode(I2Gray32,"8B442404D1E833442404C3")
MCode(Gray2I32,"8B4C24048BC1D1E833C88BC1C1E80233C88BC1C1E80433C88BC1C1E80833C88BC1C1E81033C1C3")
MCode(NextGray32,"5589E58B4D085389C88D1C09D1E831C889C2C1EA0231C289D0C1E80431D089C2C1EA0831C289D0C1E81031D031"
. "D2A8010F94C209DA5B89D0F7D821D031C85DC3")



/*
MSb32: finds the index of the most significant bit in a 32-bit unsigned integer
LSb32: finds the index of the least significant bit in a 32-bit unsigned integer
SHR32: arithmetic shift-right of a 32-bit signed integer (keeping negative results)
SRL64: 64-bit Shift-Right-Logical (unsigned), which shifts in 0's from the left
ROL32: Rotate Left 32 bits (unsigned)
ROR32: Rotate Right 32 bits (unsigned)
ROL64: Rotate Left 64 bits (unsigned)
ROR64: Rotate Right 64 bits (unsigned)
BSwap16: Swaps the two bytes of a 16-bit number
BSwap32: Reverse the byte order of 32-bit numbers (little <--> big endian)
BSwap64: Reverse the byte order of 64-bit numbers
Parity8/16/32/64: Computes the parity (0 if there is an even number of 1-bits, 1 is otherwise)
BitRev32: Reverses the sequence of bits in a 32-bit number
BitCnt32: Counts the number of 1-bits in a 32-bit number
BitZip32/BitUnZip32: UnZip: Moves the odd indexed bits to the MS bytes, the even indexed bits to the LS bytes / Zip: reverses this
I2Gray32/ Gray2I32: converts a 32-bit integer to the corresponding Gray code or back
NextGray32: gives the next Gray code (Gray counter)



*/

MCode(LI8,"8B4424048A008B4C24088A0933D23AC1530F9FC233DB3AC10F9CC32BD38BC25BC3")
MCode(GI8,"8B4424048A008B4C24088A0933D23AC1530F9CC233DB3AC10F9FC32BD38BC25BC3")
MCode(LU8,"8B4424040FB6088B4424088A103AD11BC0F7D83ACA1BC9F7D92BC1C3")
MCode(GU8,"8B4424040FB6088B4424088A103ACA1BC0F7D83AD11BC9F7D92BC1C3")

MCode(LI16,"5589E58B55088B450C5D0FB70A0FB71031C06639D10F9FC06639D10F9CC10FB6D129D0C3")
MCode(GI16,"5589E58B55088B450C5D0FB70A0FB71031C06639D10F9CC06639D10F9FC10FB6D129D0C3")
MCode(LU16,"8B4424040FB7088B4424080FB710663BD11BC0F7D8663BCA1BC9F7D92BC1C3")
MCode(GU16,"8B4424040FB7088B4424080FB710663BCA1BC0F7D8663BD11BC9F7D92BC1C3")

MCode(LI32,"5589E58B55088B450C5D8B0A8B1031C039D10F9FC039D10F9CC10FB6D129D0C3")
MCode(GI32,"5589E58B55088B450C5D8B0A8B1031C039D10F9CC039D10F9FC10FB6D129D0C3")
MCode(LU32,"8B4424048B088B4424088B103BD11BC0F7D83BCA1BC9F7D92BC1C3")
MCode(GU32,"8B4424048B088B4424088B103BCA1BC0F7D83BD11BC9F7D92BC1C3")

MCode(LI64,"8B4424048B4C24088B108B4004568B318B49043BC1577C0B7F043BD6760533FF47EB0233FF3BC17F0B7C043BD6730533"
. "C941EB0233C98BC75F2BC15EC3")
MCode(GI64,"8B4424048B4C24088B108B4004568B318B49043BC1577F0B7C043BD6730533FF47EB0233FF3BC17C0B7F043BD6760533"
. "C941EB0233C98BC75F2BC15EC3")
MCode(LU64,"8B4424048B4C24088B108B4004568B318B49043BC157720B77043BD6760533FF47EB0233FF3BC1770B72043BD6730533"
. "C941EB0233C98BC75F2BC15EC3")
MCode(GU64,"8B4424048B4C24088B108B4004568B318B49043BC157770B72043BD6730533FF47EB0233FF3BC1720B77043BD6760533"
. "C941EB0233C98BC75F2BC15EC3")


/*void Bin2Hex0(UInt8 *hex, UInt8 *bin, UInt32 len) { // in hex room for 2*len+1 bytes 
    UInt8 c, d, *end = bin+len; 
    while (bin < end) { 
        c = *(bin++); 
        d = c >> 4; 
        *(hex++) = d + (d>9 ? 55 : 48); 
        d = c & 15; 
        *(hex++) = d + (d>9 ? 55 : 48); 
    } 
    *hex = 0; 
}
*/
;The resulting machine code function with the calling example:

MCode(Bin2Hex,"8B44240C568B742408578B7C24108D14073BFA7332538A07478AC8C0E904B3093AD91ADB80E30780C3"
. "3002D9240F881E46B1093AC81AC980E10780C13002C8880E463BFA72D05B5FC606005EC3")

bin := "123", VarSetCapacity(hex,9)
dllcall(&Bin2Hex, "uint",&hex, "uint",&bin, "uint",4, "cdecl")
VarSetCapacity(hex,-1) ; update StrLen
MsgBox %hex%           ; 31323300



a0 := 0, NumPut( 0,a0,0,"Char")
a5 := 0, NumPut( 5,a5,0,"Char")
af := 0, NumPut(-1,af,0,"Char")
MsgBox % dllcall(&LU8, "uint",&a0, "uint",&a5, "cdecl int") ; -1
MsgBox % dllcall(&LU8, "uint",&a5, "uint",&af, "cdecl int") ; -1
MsgBox % dllcall(&LU8, "uint",&a5, "uint",&a5, "cdecl int") ;  0

MsgBox % dllcall(&LI8, "uint",&a0, "uint",&a5, "cdecl int") ; -1
MsgBox % dllcall(&LI8, "uint",&a5, "uint",&af, "cdecl int") ;  1
MsgBox % dllcall(&LI8, "uint",&a5, "uint",&a5, "cdecl int") ;  0

MsgBox % dllcall(&GI8, "uint",&a0, "uint",&a5, "cdecl int") ;  1
MsgBox % dllcall(&GI8, "uint",&a5, "uint",&af, "cdecl int") ; -1
MsgBox % dllcall(&GI8, "uint",&a5, "uint",&a5, "cdecl int") ;  0

VarSetCapacity(a0,8,0), NumPut( 0,a0,0,"Int64")
VarSetCapacity(a5,8,0), NumPut(55,a5,0,"Int64")
VarSetCapacity(af,8,0), NumPut(-1,af,0,"Int64")
MsgBox % dllcall(&GI64, "uint",&a0, "uint",&a5, "cdecl int") ;  1
MsgBox % dllcall(&GI64, "uint",&a5, "uint",&a0, "cdecl int") ; -1
MsgBox % dllcall(&GI64, "uint",&a0, "uint",&a0, "cdecl int") ;  0
MsgBox % dllcall(&GU64, "uint",&a5, "uint",&af, "cdecl int") ;  1

VarSetCapacity(Array,10,0)
Loop 8
   NumPut(88-9*A_Index,Array,A_Index,"Char")
NumPut(-1,Array,5,"Char")

dllcall("msvcrt\qsort", "UInt",&Array, "UInt",10, "UInt",1, "UInt",&GI8) ; decending-signed order

s := NumGet(Array,0,"Char")
Loop 9
   s .= ", " . NumGet(Array,A_Index,"Char")
MsgBox %s%     ; 79, 70, 61, 52, 34, 25, 16, 0, 0, -1

VarSetCapacity(Array,80,0)
Loop 9
   NumPut(100000000000-10000000000*A_Index,Array,8*A_Index,"Int64")
NumPut(-1,Array,5*8,"Int64")

dllcall("msvcrt\qsort", "UInt",&Array, "UInt",10, "UInt",8, "UInt",&LU64) ; ascending-unsigned order

s := NumGet(Array,0,"Int64")
Loop 9
   s .= "," . NumGet(Array,8*A_Index,"Int64")
MsgBox %s% ;0,10000000000,20000000000,30000000000,40000000000,60000000000,70000000000,80000000000,90000000000,-1



SetFormat Integer, HEX

MsgBox % x:=dllcall(&NextGray32, "uint", 8, "cdecl uint") ; 0x18
MsgBox % x:=dllcall(&NextGray32, "uint", x, "cdecl uint") ; 0x19
MsgBox % x:=dllcall(&NextGray32, "uint", x, "cdecl uint") ; 0x1B
MsgBox % x:=dllcall(&NextGray32, "uint", x, "cdecl uint") ; 0x1A

MsgBox % dllcall(&Gray2I32, "uint", 0x08, "cdecl uint") ; 0x0f
MsgBox % dllcall(&Gray2I32, "uint", 0x18, "cdecl uint") ; 0x10
MsgBox % dllcall(&Gray2I32, "uint", 0x19, "cdecl uint") ; 0x11
MsgBox % dllcall(&Gray2I32, "uint", 0x1B, "cdecl uint") ; 0x12

MsgBox % dllcall(&I2Gray32, "uint", 0x0f, "cdecl uint") ; 0x08
MsgBox % dllcall(&I2Gray32, "uint", 0x10, "cdecl uint") ; 0x18
MsgBox % dllcall(&I2Gray32, "uint", 0x11, "cdecl uint") ; 0x19
MsgBox % dllcall(&I2Gray32, "uint", 0x12, "cdecl uint") ; 0x1B

MsgBox % dllcall(&BitZip32, "uint", 0x0000ffff, "cdecl uint") ; 0x55555555 Merge MS and LS half words (bit0 stays)
MsgBox % dllcall(&BitUnZip32,"uint",0xaaaaaaaa, "cdecl uint") ; 0xffff0000 Odd index bits . Even index bits

MsgBox % dllcall(&BitCnt32, "uint", 0, "cdecl uint")          ; 0
MsgBox % dllcall(&BitCnt32, "uint", 0x01010101, "cdecl uint") ; 4
MsgBox % dllcall(&BitCnt32, "uint", 0xffffffff, "cdecl uint") ; 32

MsgBox % dllcall(&BitRev32, "uint", 0x12345678, "cdecl uint") ; 0x1E6A2C48

MsgBox % dllcall(&Parity64, "int64", 0x0800000010001234, "cdecl uint") ; 1
MsgBox % dllcall(&Parity64, "int64", 0x0200000010001235, "cdecl uint") ; 0

MsgBox % dllcall(&Parity32, "uint", 0x10001234, "cdecl uint") ; 0
MsgBox % dllcall(&Parity32, "uint", 0x10001235, "cdecl uint") ; 1

MsgBox % dllcall(&Parity16, "ushort", 0x1234, "cdecl uint") ; 1
MsgBox % dllcall(&Parity16, "ushort", 0x1235, "cdecl uint") ; 0

MsgBox % dllcall(&Parity8, "uchar", 0, "cdecl uint")    ; 0
MsgBox % dllcall(&Parity8, "uchar", 1, "cdecl uint")    ; 1
MsgBox % dllcall(&Parity8, "uchar", 7, "cdecl uint")    ; 1
MsgBox % dllcall(&Parity8, "uchar", 0x12, "cdecl uint") ; 0

MsgBox % dllcall(&ROL32, "uint", 0x12345678, "UInt",4, "cdecl uint") ; 0x23456781
MsgBox % dllcall(&ROR32, "uint", 0x12345678, "UInt",4, "cdecl uint") ; 0x81234567

MsgBox % dllcall(&ROL64, "int64", 0x2000000000000020, "UInt",1, "cdecl int64") ; 0x400..0040
MsgBox % dllcall(&ROL64, "int64",-4, "UInt",2, "cdecl int64")                  ; -13 = -0xD (-4*4 + 3(MS))
MsgBox % dllcall(&ROL64, "int64", 0x34567890abcdef12, "UInt",4, "cdecl int64") ; 0x4567890abcdef123

MsgBox % dllcall(&ROR64, "int64", 0x4000000000000020, "UInt",1, "cdecl int64") ; 0x200..0010
MsgBox % dllcall(&ROR64, "int64",-4, "UInt",2, "cdecl int64")                  ; 0x3fffffffffffffff
MsgBox % dllcall(&ROR64, "int64", 0x34567890abcdef12, "UInt",4, "cdecl int64") ; 0x234567890abcdef1

MsgBox % dllcall(&LSb32, "Int",0x81234567, "cdecl UInt") ; 0
MsgBox % dllcall(&LSb32, "Int",0x01234560, "cdecl UInt") ; 5
MsgBox % dllcall(&LSb32, "Int",16, "cdecl UInt")         ; 4
MsgBox % dllcall(&LSb32, "Int",0, "cdecl UInt")          ; 0

MsgBox % dllcall(&MSb32, "Int",0x81234567, "cdecl UInt") ; 31 (0x1f)
MsgBox % dllcall(&MSb32, "Int",0x01234567, "cdecl UInt") ; 24 (0x18)
MsgBox % dllcall(&MSb32, "Int",1, "cdecl UInt")          ; 0
MsgBox % dllcall(&MSb32, "Int",0, "cdecl UInt")          ; 0

MsgBox % dllcall(&SHR32, "Int",0x81234567, "UInt",1, "cdecl UInt")    ; 0xC091a2b3

MsgBox % dllcall(&BSwap16, "short",0x1234, "cdecl ushort")            ; 0x3412
MsgBox % dllcall(&BSwap32, "int",  0x12345678, "cdecl uint")          ; 0x78563412
MsgBox % dllcall(&BSwap64, "int64",0x34567890abcdef12, "cdecl int64") ; 0x12efcdab90785634

MsgBox % dllcall(&SRL64, "int64", 0x34567890abcdef12, "UInt",4, "int64") ; 0x034567890abcdef1 (standard call)
MsgBox % dllcall(&SRL64, "int64",-0x8000000000000000, "UInt",2, "int64") ; 0x2000000000000000