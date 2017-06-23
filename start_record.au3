#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#pragma compile(Icon, 'lib\icon\start_record.ico')

;MsgBox($MB_SYSTEMMODAL, "Test", "Start start_record" )

; 開始播放
$media_file = IniRead ( @ScriptDir & "\config.ini", "config", "media_file", "media/listening.mp4" )
$extapp_mpv = IniRead ( @ScriptDir & "\config.ini", "config", "extapp_mpv", "lib/mpv-x86_64-20170423/mpv.exe" )

; mpv.exe "..\..\media\listening_q1.mp4" --no-osc
$cmd_mpv = '"' & @ScriptDir & "\" & $extapp_mpv & '" "' & @ScriptDir & "\" & $media_file & '" --no-osc'
;MsgBox($MB_SYSTEMMODAL, "Test", $cmd_mpv )
$iPID = Run($cmd_mpv)

; 點選Record按鈕 https://docs.google.com/document/d/12ovBGDn7-ici9mLa5LH7vVcIdHAbnsZ42ZM3fDNeQI4/edit#
ControlClick("Brain Viewer", "", "lblRecord")

; 當結束播放的時候，發出通知
ProcessWaitClose($iPID)
;MsgBox($MB_SYSTEMMODAL, "Test", "Finish" )

; 點選Stop按鈕 https://docs.google.com/document/d/12ovBGDn7-ici9mLa5LH7vVcIdHAbnsZ42ZM3fDNeQI4/edit#
ControlClick("Brain Viewer", "", "lblStop")