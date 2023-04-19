#include <log4ahk>
#include cv2.ah2
#include <Gdip_All>
SetWorkingDir A_ScriptDir
CoordMode "ToolTip", "Screen"
CoordMode("Mouse", "Screen")
dllcall("SetDllDirectory", "Str", A_ScriptDir)
hOpencv := DllCall("LoadLibrary", "str", "opencv_world455.dll", "ptr")
hOpencvCom := DllCall("LoadLibrary", "str", "autoit_opencv_com455.dll", "ptr")
DllCall("autoit_opencv_com455.dll\DllInstall", "int", 1, "wstr", A_IsAdmin = 0 ? "user" : "", "cdecl")
changeArrayIndexToZeroBased()
log.is_out_console := true
log.is_out_file := false
log.info("f3 开始， f5退出")
MsgBox("F3 开始， F5 重启")
;游戏配置信息
;图片左上角坐标
left_x := 13
left_y :=  180
;图片长宽
pic_w :=  590
pic_h :=  386
;每个小方块长宽
block_x := 31
block_y := 35
cv := ComObject("OpenCV.cv")
mat := ComObject("OpenCV.cv.Mat")
; 将图片转化为数字矩阵，方便处理
picturemap := make_2d_array(20, 20)
;统计每种图片有多少个（最多的即为空白部分）
blank := []
loop(300)
    blank.Push(0)
;搜索的标记及其方向，不懂的可以查一查BFS（广度优先搜索）
bfsflag := 0
dirary := [[1, 0], [-1, 0], [0, 1], [0, -1]]
searchmap := make_2d_array(20, 20)
ifok := false
f3::
{
	main()
}
f5::
{
    Reload
}
main()
{
	global mat, cv
	;因为我这里切片处理不太好，小方块比对不一定完全匹配，所以就将这个过程设置了五次
	;欢迎大佬们来优化
	times := 5
	while (times--)
	{
		;找到游戏窗口，将游戏放在左上角方便定位，然后截图
        hq := WinExist("QQ游戏 - 连连看角色版")
        WinGetClientPos(&X, &Y, &W, &H, hq)
        WinMove(0, 0,,, hq)
		Sleep(1000)
        wid := A_ScreenWidth
        hei := A_ScreenHeight
        pBits:=0x00000000
        pToken := Gdip_StartUp()
        chdc := CreateCompatibleDC(GetDC(0))
        hbm := CreateDIBSection(wid, hei, chdc, 24, &pBits)
        obm := SelectObject(chdc, hbm)
        hhdc := GetDC(0)
        BitBlt(chdc, 0, 0, wid, hei, hhdc, 0, 0, 0xCC0020)
        val:= (wid * 3 + 3) & -4
        src := mat.create(hei, wid, 16, pBits, val) 
        src := cv.flip(src, 0)
        imgROI := ComObject("OpenCV.cv.Mat").create(src, ComArrayMake([left_x, left_y, pic_w, pic_h]))
		;cv.imshow("src", imgROI)
		picture_process(src)
		;进行500次匹配，防止出错
		temp := 500
		while (temp--)
		{
			log.info(a_index)
			match()
		}
		Sleep(3000)
		cnt := 0
		;如果这时检测到还有出了空白之外的图片，就用道具重置，继续完成上面步骤
        i := 0
        loop(300)
		{
			if (blank[i] != 0)
			{
				cnt++
			}
            i++
		}
		if (cnt == 1)
			break
        MouseMove 653, 199
        MouseClick("left")
		Sleep(1000)
		cv.destroyAllWindows()
		SelectObject(chdc, obm)
		ReleaseDC(hhdc)    
		DeleteObject(hbm)
		DeleteDC(chdc)
		Gdip_Shutdown(pToken)
	}
	return 0
}
picture_process(src)
{
	;用vector储存每个小方块
	log.in()
	vec := make_2d_array(11, 19)
	img := []
	x_pos := left_x, y_pos := left_y
    i := 0
    loop(11)
	{
        j := 0
        loop(19)
		{
            pic := ComObject("OpenCV.cv.Mat").create(src, ComArrayMake([x_pos, y_pos, block_x, block_y]))
			vec[i][j] := ComObject("OpenCV.cv.Mat").create(pic, ComArrayMake([3, 3, block_x - 6, block_y - 6]))
			x_pos += block_x
			if (img.Length == 0)
			{
				img.push(vec[i][j])
				picturemap[i][j] := 1
				blank[0]++
			}
			else
			{
				flag := 0
                k := 0
                loop(img.Length)
				{
					if (imgcompare(img[k], vec[i][j]) > 0.99)
					{
						picturemap[i][j] := k + 1
						flag := 1
						blank[k]++
						break
					}
                    k++
				}
				if (flag == 0)
				{
					img.push(vec[i][j])
					picturemap[i][j] := img.Length
					blank[img.Length - 1]++
				}
			}
            j++
		}
		x_pos := left_x
		y_pos += block_y
        i++
	}
	pos := 0, num := 0
    i := 0
    loop(img.Length)
	{
		if (blank[i] > num)
		{
			num := blank[i]
			pos := i + 1
		}
        i++
	}
    i := 0
    loop(11)
	{
        j := 0
        loop(19)
		{
			if (picturemap[i][j] == pos)
			{
				picturemap[i][j] := 0
			}
            j++
		}
        i++
	}
	log.out()
}
;直方图比较，结果为0到1的一个数，越大越准确
imgcompare(img1, img2)
{
	hsv_img1 := ComObject("OpenCV.cv.Mat")
    hsv_img2 := ComObject("OpenCV.cv.Mat")
	hsv_img1 := cv.cvtColor(img1, cv2.CV_COLOR_BGR2HSV)
	hsv_img2 := cv.cvtColor(img2, cv2.CV_COLOR_BGR2HSV)
	;cv.imshow("1", hsv_img1)
	;cv.imshow("2", hsv_img2)
	cv.waitKey()
 
	h_bins := 50, s_bins := 60
	histSize := [h_bins, s_bins]
	h_ranges := [0, 256]
	s_ranges := [0, 180]
 
	ranges := [h_ranges[0], h_ranges[1], s_ranges[0], s_ranges[1]]
	channels := ComArrayMake([0, 1])
	hist_test1 := cv.calcHist(ComArrayMake([hsv_img1]), channels, ComObject("OpenCV.cv.Mat"), ComArrayMake(histSize), ComArrayMake(ranges))
	cv.normalize(hist_test1, hist_test1, 0, 1, cv2.CV_NORM_MINMAX)
 
	hist_test2 := cv.calcHist(ComArrayMake([hsv_img2]), channels, ComObject("OpenCV.cv.Mat"), ComArrayMake(histSize), ComArrayMake(ranges))
	cv.normalize(hist_test2, hist_test2, 0, 1, cv2.CV_NORM_MINMAX)
 
	ans := cv.compareHist(hist_test1, hist_test2, 0)
	return ans
}
match()
{
	global ifok
	global bfsflag
	global searchmap
    i := 0
    loop(11)
	{
        j := 0
        loop(19)
		{
			if (picturemap[i][j] == 0)
			{
				j++
				continue
			}
            m := i
            loop(11)
            {
                if(m >= 11)
                    break
                n := 0
                loop(19)
				{
					if (picturemap[m][n] == 0)
					{
						n++
						continue
					}
					if (m == i && n == j)
					{
						n++
						continue
					}
					if (picturemap[i][j] == picturemap[m][n])
					{
                        array2d_clean(searchmap)
						searchmap[i][j] := 1
						bfsflag := 0
						ifok := false
						;用广度优先搜索检测两个相同的块能不能连通，能就true不能false
						bfs(i, j, m, n, searchmap, 0, 0)
						if (ifok)
						{
							;鼠标操作
                            MouseMove((left_x + j * block_x) + 10, (left_y + i * block_y) + 10)
                            MouseClick("left")
                            Sleep(200)
							MouseMove((left_x + n * block_x) + 10, (left_y + m * block_y) + 10)
                            MouseClick("left")
							picturemap[i][j] := 0
							picturemap[m][n] := 0
						}
					}
                    n++
				}
                m++
			}
            j++
		}
        i++
	}
}
bfs(i, j, m, n, searchmap, dir, temp)
{
	global bfsflag
	global ifok
	if (bfsflag == 1)
		return
	if (temp > 2)
		return
	if ((i == m) && (j == n))
	{
		bfsflag := 1
		ifok := true
		return
	}
    ii := 0
    loop(4)
	{
		xx := i + dirary[ii][0]
		yy := j + dirary[ii][1]
		if (xx < 0 || xx > 10 || yy < 0 || yy > 18 || searchmap[xx][yy] == 1)
		{
			ii++
			continue
		}
		searchmap[xx][yy] := 1
		if ((picturemap[xx][yy] == 0) || (picturemap[xx][yy] == picturemap[m][n]))
		{
			if (dir == 0)
			{
				bfs(xx, yy, m, n, searchmap, ii + 1, temp)
			}
			else
			{
				if (ii + 1 != dir)
					bfs(xx, yy, m, n, searchmap, ii + 1, temp + 1)
				else
					bfs(xx, yy, m, n, searchmap, ii + 1, temp)
			}
			searchmap[xx][yy] := 0
		}
        ii++
	}
	return
}
;r rows
;c cols
make_2d_array(r, c)
{
    arr := []
    arr.Length := r
    for k, v in arr
    {
        arr[k] := []
        arr[k].Length := c
        for i, j in arr
            arr[k][i] := 0
    }
    return arr
}
array2d_clean(in_array)
{
    for k,v in in_array
        for i,j in v
            in_array[k][i] := 0
}
ComArrayMake(inputArray)
{
	arr := ComObjArray(VT_VARIANT:=12, inputArray.Length)
	Loop inputArray.Length
	{
		arr[A_Index - 1] := inputArray[A_Index - 1]
	}
	return arr
}
/************************************************************************
 * @file: array_zero_based_index.ah2
 * @description: 使Array数组对象以0为第一个元素
 * @author thqby
 * @date 11/23/2020
 * @version 1.0
 ***********************************************************************/
changeArrayIndexToZeroBased() {
    static init := (() => (
        __enum := Array.Prototype.GetOwnPropDesc("__Enum").call,
        __item := Array.Prototype.GetOwnPropDesc("__Item"),
        __set := __item.set, __get := __item.get,
        Array.Prototype.DefineProp("__Item", {
            get: (s, i) => __get(s, i + 1),
                set: (s, v, i) => __set(s, v, i + 1)
        }),
        Array.Prototype.DefineProp("__Enum", { call:
                (s, n := 1) => (n != 2 ? __enum(s, n) :
                        (n := s.Length, i := 0, (&k, &v) => (
                            i < n ? (k := i++, v := __get(s, i), true) : false
                        ))
                ) })
    ))()
}
changeComArrayIndexToOneBased() {
    static init := (() => (
        __enum := (Object.GetOwnPropDesc)(ComObjArray.Prototype, "__Enum").call,
        __item := (Object.GetOwnPropDesc)(ComObjArray.Prototype, "__Item"),
        __set := __item.set, __get := __item.get,
        (Object.DefineProp)(ComObjArray.Prototype, "__Item", {
            get: (s, i) => __get(s, i - 1),
                set: (s, v, i) => __set(s, v, i - 1)
        }),
        (Object.DefineProp)(ComObjArray.Prototype, "__Enum", { call:
                (s, n := 1) => (n != 2 ? __enum(s, n) :
                        (n := s.MaxIndex(), i := 0, (&k, &v) => (
                            i <= n ? (v := __get(s, i), k := ++i, true) : false
                        ))
                ) })
    ))()
}