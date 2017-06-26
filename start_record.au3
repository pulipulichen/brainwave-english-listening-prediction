#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#pragma compile(Icon, 'lib\icon\start_record.ico')

;MsgBox($MB_SYSTEMMODAL, "Test", "Start start_record" )

$config = ".\config.ini"
If $CmdLine[0] > 0 Then
   $config = $CmdLine[1]
EndIf
$config = set_full_path($config)

; 開始播放
$media_file = IniRead ( $config, "media", "media_file", "media/listening.mp4" )
$media_file = set_full_path($media_file)
$extapp_mpv = IniRead ( $config, "brain_viewer", "extapp_mpv", "lib/mpv-x86_64-20170423/mpv.exe" )
$extapp_mpv = set_full_path($extapp_mpv)

; mpv.exe "..\..\media\listening_q1.mp4" --no-osc
$cmd_mpv = $extapp_mpv & ' ' & $media_file
;MsgBox($MB_SYSTEMMODAL, "Test", $cmd_mpv )
$iPID = Run($cmd_mpv)

; 點選Record按鈕 https://docs.google.com/document/d/12ovBGDn7-ici9mLa5LH7vVcIdHAbnsZ42ZM3fDNeQI4/edit#
ControlClick("Brain Viewer", "", "lblRecord")

; 當結束播放的時候，發出通知
ProcessWaitClose($iPID)
;MsgBox($MB_SYSTEMMODAL, "Test", "Finish" )

; 點選Stop按鈕 https://docs.google.com/document/d/12ovBGDn7-ici9mLa5LH7vVcIdHAbnsZ42ZM3fDNeQI4/edit#
ControlClick("Brain Viewer", "", "lblStop")


; ------------------------
Func set_full_path($path)
   If StringInStr($path, ".\") == 1 Then
	  $path = @ScriptDir & StringMid($path,2)
   EndIf
   $path = '"' & $path & '"'
   return $path
EndFunc