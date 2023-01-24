;#include 
#include LIB/OnMouseEvent.AHK
; #include <Flags>
; Pretty-print an integer as a |-separated string of flag names
; warning: assumes each flag is only a single bit
class Flags
{
	; construct from pairs of (string, integer)
	__New(args*)
	{
		this.flags := args
		; Loop args.Length
			; this.%args[A_Index]% := ++A_Index ; use A_Index, increment, use A_Index
	}
	
	Call(value)
	{
		out := ""
		Loop this.flags.Length
			if (value & this.flags[++A_Index])
				value ^= this.flags[A_Index], out && out .= " | ", out .= this.flags[A_Index - 1]
		if value
			(out && out .= " | ", out .= value)
		return out ? out : "0"
	}
}


MouseStateFlags := Flags(
	; "MOUSE_MOVE_RELATIVE", 0x00,
	"MOUSE_MOVE_ABSOLUTE", 0x01,
	"MOUSE_VIRTUAL_DESKTOP", 0x02,
	"MOUSE_ATTRIBUTES_CHANGED", 0x04,
	"MOUSE_MOVE_NOCOALESCE", 0x08)

TransitionStateFlags := Flags(
	"RI_MOUSE_BUTTON_1_DOWN", 0x0001,
	"RI_MOUSE_BUTTON_1_UP", 0x0002,
	"RI_MOUSE_BUTTON_2_DOWN", 0x0004,
	"RI_MOUSE_BUTTON_2_UP", 0x0008,
	"RI_MOUSE_BUTTON_3_DOWN", 0x0010,
	"RI_MOUSE_BUTTON_3_UP", 0x0020,
	"RI_MOUSE_BUTTON_4_DOWN", 0x0040,
	"RI_MOUSE_BUTTON_4_UP", 0x0080,
	"RI_MOUSE_BUTTON_5_DOWN", 0x0100,
	"RI_MOUSE_BUTTON_5_UP", 0x0200,
	"RI_MOUSE_WHEEL", 0x0400,
	"RI_MOUSE_HWHEEL", 0x0800)

Persistent
OnMouseEvent(MouseTest)

MouseTest(RawInputWrapper)
{
	ToolTip(
		"ThisMouse " RawInputWrapper.ThisMouse
		"`nusFlags " MouseStateFlags(RawInputWrapper.Flags)
		; "`npadding " RawInputWrapper.Padding
		"`nusButtonFlags " TransitionStateFlags(RawInputWrapper.ButtonFlags)
		"`nusButtonData " RawInputWrapper.ButtonData
		; "`nulRawButtons " RawInputWrapper.RawButtons
		"`nlLastX " RawInputWrapper.LastX
		"`nlLastY " RawInputWrapper.LastY
		"`nulExtraInformation " RawInputWrapper.ExtraInformation
		; "`nlParam " RawInputWrapper.lParam
		
		"`nIsRelativeMovement " RawInputWrapper.IsRelativeMovement
		"`nIsAbsoluteMovement " RawInputWrapper.IsAbsoluteMovement
		"`nIsMovement " RawInputWrapper.IsMovement
		"`nIIsButtons " RawInputWrapper.IsButtons
		"`nIsWheel " RawInputWrapper.IsWheel
		"`nIsHWheel " RawInputWrapper.IsHWheel
		"`nGetAbsolutePosition " (RawInputWrapper.GetAbsolutePosition(&x, &y), x " " y)
	)
}
