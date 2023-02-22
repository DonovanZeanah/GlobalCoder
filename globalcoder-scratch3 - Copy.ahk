;DllCall("MessageBox","Uint",0,"Str","This Message is poped through DLLcall","Str","I typed that title")
DllCall("MessageBox","Uint",0,"Str","This Message is poped through DLLcall","Str","I typed that title","Uint","0x00000006L")
ReturnValue := DllCall("MessageBox","Uint",0,"Str","This Message is poped through DLLcall","Str","I typed that title","Uint","0x00000036L")
msgbox,%ReturnValue%



int WINAPI MessageBox( 
_In_opt_ HWND hWnd,
_In_opt_ LPCTSTR lpText, 
_In_opt_ LPCTSTR lpCaption, 
_In_ UINT uType 
);

char-->Str
short int-->Short
int-->int
long int-->int
bool-->int (Its in helpfile-->)