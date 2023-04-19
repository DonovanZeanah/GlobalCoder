#include <log4ahk>
#include <imgui>
;这个库必须放到开头
;Download("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png", A_ScriptDir "/back.PNG")
_ImGui_EnableViewports(true)
main()
main()
{
    static username := "user name"
    static passwd := "paswd"
    static number := 0
    static check_state := false
    static radio_theme := 2
    static input_string := ""
    static listbox_current_item := 1
    static close := false
    static no_menu := false
    label_radio_theme := ["Light", "Dark", "Classic"]
    img := _ImGui_ImageFromURL("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png")
    arr := [1,2,3,4,5,6]
    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80)
    ;hwnd := _ImGui_GUICreate("AHK ImGui", 1000, 1000, 500, 500, 0, 0x80)
    WinShow(hwnd)
    ;WinSetAlwaysOnTop( 1,hwnd)

    _ImGui_StyleColorsClassic()

    io := _ImGui_GetIO()
    ;NumPut("Int", true, io, 204) ;io.ConfigWindowsMoveFromTitleBarOnly := True ; // Only drag window by title bar

    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    if (!no_menu)           
        window_flags |= ImGuiWindowFlags_MenuBar

    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags)

        _imgui_PushItemWidth(_imgui_GetFontSize() * -12)

        if(_ImGui_BeginMenuBar())
        {
            if(_ImGui_BeginMenu("Menu"))
            {
                if(_ImGui_MenuItem("open"))
                {
                    SelectedFile := FileSelect(3, , "Open a file", "Text Documents (*.txt; *.doc)")
                    if SelectedFile = ""
                        MsgBox "The user didn't select anything."
                    else
                        MsgBox "The user selected the following:`n" SelectedFile
                }
                if(_ImGui_MenuItem("close"))
                {
                    ExitApp()
                    _ImGui_EndMenu()
                }
                _ImGui_EndMenu()
            }
            if(_ImGui_BeginMenu("Examples"))
            {
                if(_ImGui_MenuItem("app"))
                {
                    str_status := "menu app"
                }
                _ImGui_EndMenu()
            }
            _ImGui_EndMenuBar()
        }
        old_theme := radio_theme 
        _ImGui_RadioButton("Light", &radio_theme, 0)
        _ImGui_SameLine()
        _ImGui_RadioButton("Dark", &radio_theme, 1)
        _ImGui_SameLine()
        _ImGui_RadioButton("Classic", &radio_theme, 2)
        _ImGui_SameLine()
        if(_ImGui_BeginCombo("##combo_theme", label_radio_theme[radio_theme+1]))
        {
            loop(label_radio_theme.Length)
            {
                static selected := (radio_theme + 1) == A_Index  ? true : false
                if(_ImGui_Selectable(label_radio_theme[A_Index], selected))
                {
				    radio_theme := A_Index - 1
				    _ImGui_SetItemDefaultFocus()
                }
            }
		    _ImGui_EndCombo()
        }
        if(old_theme != radio_theme)
        {
            switch radio_theme 
            {
                case 0:
				    _ImGui_StyleColorsLight()
                case 1:
				    _ImGui_StyleColorsDark()
                case 2:
				    _ImGui_StyleColorsClassic()
            }
        }
        if(_ImGui_SmallButton("close##close"))
            ExitApp()
        win_size := _ImGui_GetWindowSize()
        _ImGui_Separator()
        ;img := _ImGui_ImageFromURL("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png")
        img := _ImGui_ImageFromFile(A_ScriptDir "\back.PNG")
        if(img)
        {
		    _ImGui_ImageFit(img, win_size[1] - 10, 200)
        }
        _ImGui_ArrowButton("arrow", ImGuiDir_Left)
        _ImGui_SameLine()
        _ImGui_ArrowButton("arrow", ImGuiDir_Right)
        _ImGui_SameLine()
        _ImGui_ArrowButton("arrow", ImGuiDir_Up)
        _ImGui_SameLine()
        _ImGui_ArrowButton("arrow", ImGuiDir_Down)
        static color_get := 0

        static b_pick_color := false
        _ImGui_CheckBox("color pick", &b_pick_color)

        if(b_pick_color)
        {
            _imgui_PushItemWidth(400)
            _ImGui_ColorPicker("color_pick", &color_get)
            _ImGui_PopItemWidth()
        }


        img1 := _ImGui_ImageFromFile(A_ScriptDir "\1.jpg")
        img2 := _ImGui_ImageFromFile(A_ScriptDir "\2.jpg")
        img3 := _ImGui_ImageFromFile(A_ScriptDir "\3.jpg")
        img4 := _ImGui_ImageFromFile(A_ScriptDir "\4.jpg")
        img5 := _ImGui_ImageFromFile(A_ScriptDir "\5.jpg")
        img6 := _ImGui_ImageFromFile(A_ScriptDir "\6.jpg")
        _ImGui_ImageButton(img1, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img2, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img3, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img4, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img5, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img6, 50, 50)

        _ImGui_Text("hello imgui")
        ;if (_ImGui_Button("close##1", 40, 40)) 
            ;ExitApp()

        static b_show_demo_window := false
        _ImGui_CheckBox("Show demo window", &b_show_demo_window)
            _ImGui_EnableViewports(b_show_demo_window)
        static b_show_another_window := false
       _ImGui_CheckBox("Show another window", &b_show_another_window)
	    If(b_show_demo_window)
            _ImGui_ShowDemoWindow()
        If(b_show_another_window)
        {
            _ImGui_Begin("Another window")
            _ImGui_Text("Hello there..")
            if(_ImGui_Button("close me")) 
                b_show_another_window := False
            _ImGui_End()
        }

	    winSize := _ImGui_GetWindowSize()
        ; Seperate the window into 2 columns
        _ImGui_Columns(2)

        ; Set the width for the column 0
        _ImGui_SetColumnWidth(0, winSize[1]*0.7)

	     _ImGui_NewLine()

	    _ImGui_PushItemWidth(-1)
        _ImGui_InputTextWithHint("##username", username, &username, ImGuiInputTextFlags_CharsNoBlank)
        _ImGui_InputTextWithHint("##usernamepasswd", passwd, &passwd, ImGuiInputTextFlags_Password)
	    _ImGui_PopItemWidth()

	     _ImGui_NewLine()

        static str_status := "not login"
        _ImGui_TextColored(str_status, 0xFF33BB44)

	    _ImGui_NextColumn()
	    _ImGui_NewLine()
        if (_ImGui_Button("LOGIN", -1, 40)) 
        {
	        str_status := input_string "  " username " " passwd " " number " " check_state " "
        }
	    _ImGui_Columns(1)
	    _ImGui_NewLine()

	    _ImGui_BeginChild("##child_list_view1", winSize[1]*0.6, winSize[2] *0.3, true, ImGuiWindowFlags_ChildWindow)
        static list_view_select := false
        static list_view_select_index := false
        loop(10)
        {
            list_view_select := (list_view_select_index + 1) == A_Index  ? true : false
		    if(_ImGui_Selectable("Selectable - "  (a_index-1), list_view_select))
                list_view_select_index := A_Index - 1
        }


        _ImGui_InputText("string##1", &input_string)
        _ImGui_InputInt("##number", &number)

        static list_box_items := ["aaaa", "bbbb", "cccc"]
        _ImGui_ListBox("listbox##1", &listbox_current_item, list_box_items, 4)

        _ImGui_PlotLines("Plot##array", arr, 6, "Plot", FLT_MAX, FLT_MAX, 300, 300)
        _ImGui_SameLine()
        _ImGui_CheckBox("radio", &check_state)

	    _ImGui_EndChild()

        _ImGui_End()
        _ImGui_EndFrame()
    }
    ExitApp()
    return
}