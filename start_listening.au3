#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#pragma compile(Icon, 'start_listening.ico')

; Read ini file
$imagemagick_cmd = IniRead ( @ScriptDir & "\config.ini", "config", "imagemagick_cmd", "1" )

; 開始播放
