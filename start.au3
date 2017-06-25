#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstantS.au3>
#include <FontConstants.au3>
#pragma compile(Icon, 'lib\icon\start.ico')

$debug = True

; Read ini file: Brainwave Viewer Path
$extapp_brain_viewer = IniRead ( @ScriptDir & "\config.ini", "brain_viewer", "extapp_brain_viewer", "false" )
$extapp_brain_viewer = set_full_path($extapp_brain_viewer)

If FileExists($extapp_brain_viewer) == False Then
   MsgBox($MB_SYSTEMMODAL, "Error", "Brainwave Viewer not found: " & $extapp_brain_viewer)
   If $debug == False Then
	  Exit
   EndIf
EndIf

; 播放背景
$bgPID = Run("black_bg.exe")
WinWait("[CLASS:mpv]")
Sleep(1)

If FileExists($extapp_brain_viewer) Then
   Run($extapp_brain_viewer)
Else
   MsgBox($MB_SYSTEMMODAL, "start.au3", "Open Brain Viewer: " &  $extapp_brain_viewer)
EndIf

; ----------------------------------------------------

; 冒出一個按鈕，這個按鈕要放在最上層，按下去就開始錄
$start_dialog_title = IniRead ( @ScriptDir & "\config.ini", "brain_viewer", "start_dialog_title", "English Listening Test" )
$start_dialog_button = IniRead ( @ScriptDir & "\config.ini", "brain_viewer", "start_dialog_button", "Test Start" )
$icon = @ScriptDir &  "\lib\icon\start.ico"
$icon_record = @ScriptDir &  "\lib\icon\start_record.ico"
$button_click_event="start_record.exe"

; Create a GUI with various controls.
Local $hGUI = GUICreate($start_dialog_title, 250, 50,-1,-1,-1,$WS_EX_TOPMOST)
GUISetIcon($icon)
; Create a button control.
Local $idButton = GUICtrlCreateButton(" " & $start_dialog_button, 0, 0, 250, 50,  BitOR($BS_MULTILINE, $BS_CENTER, $BS_VCENTER, $WS_EX_WINDOWEDGE))
GUICtrlSetFont($idButton, 14, $FW_BOLD )
; GUICtrlSetImage(-1, "shell32.dll", 22)
GUICtrlSetImage(-1, $icon_record, 22)

; Display the GUI.
GUISetState(@SW_SHOW, $hGUI)

 Local $iPID = 0

 ; Loop until the user exits.
 While 1
	 Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			close_bg()
			Exit
		 Case $idButton
			; Run Notepad with the window maximized.
			;$iPID = Run("notepad.exe", "", @SW_SHOWMAXIMIZED)
			;MsgBox($MB_SYSTEMMODAL, "Error", "Brainwave Viewer not found: " )
			GUIDelete($hGUI)
			If FileExists($extapp_brain_viewer) == False Then
			   MsgBox($MB_SYSTEMMODAL, "start.au3", "Brain Viewer start recording")
			EndIf
			RunWait($button_click_event)
			If FileExists($extapp_brain_viewer) == False Then
			   MsgBox($MB_SYSTEMMODAL, "start.au3", "Brain Viewer stop recording")
			EndIf
			ExitLoop
	 EndSwitch
WEnd

; -----------------------------------------------------------

; 呼叫Matlab
$extapp_matlab = IniRead ( @ScriptDir & "\config.ini", "matlab", "extapp_matlab", "D:\Program\bin\matlab.exe" )
$extapp_matlab = set_full_path($extapp_matlab)
$mfile = IniRead ( @ScriptDir & "\config.ini", "matlab", "matlab_mfile", ".\lib\matlab\mfile.m" )
$mfile = set_full_path($mfile)
If FileExists($extapp_brain_viewer) == False Then
   ; https://www.mathworks.com/help/matlab/ref/matlabwindows.html
   ; https://stackoverflow.com/questions/6657005/matlab-running-an-m-file-from-command-line
   ; "C:\<a long path here>\matlab.exe" -nodisplay -nosplash -nodesktop -r "run('C:\<a long path here>\mfile.m');"
   Local $matlab_cmd = $extapp_matlab & " -nodisplay -nosplash -nodesktop -r 'run(" & $mfile & ")'"
   RunWait($matlab_cmd)
Else
   MsgBox($MB_SYSTEMMODAL, "start.au3", "Next: call matlab to convert brainwave data:" & @CRLF & $extapp_matlab & @CRLF & $mfile)
EndIf

; -----------------------------------------------------------

; 呼叫Weka
;MsgBox($MB_SYSTEMMODAL, "start.au3", "Next: call weka" )
RunWait("weka_predict.exe")

; -----------------------------------------------------------
; 完成，關閉背景
close_bg()

; -----------------------------------------------------------

Func close_bg()
   ; 關閉背景
   ProcessClose($bgPID)
   WinClose("[CLASS:mpv]")
EndFunc


; ------------------------
Func set_full_path($path)
   If StringInStr($path, ".\") == 1 Then
	  $path = @ScriptDir & StringMid($path,2)
   EndIf
   $path = '"' & $path & '"'
   return $path
EndFunc