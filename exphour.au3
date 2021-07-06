#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\ralph\Pictures\TeeyoTV\Team 55 - Logo\Main - BlueWhite.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===============================================================================
; Name...........: Ragnarok X - EXP PER HOUR
; Description ...: Tool to calculate:

;					1) Exp per hour

; Coded By: Raff - Odin Valhalla
;===============================================================================

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <StatusBarConstants.au3>
#include <WindowsConstants.au3>
#include <INet.au3>
#include <NumCR.au3>
#include <Clipboard.au3>


Global $GUI_NAME = "rHelper - Exp Per Hour"

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($GUI_NAME, 500, 187, 152, 680)
$b_update = GUICtrlCreateButton("Update", 410, 117, 75, 19, 0)
$b_donate = GUICtrlCreateButton("Donate", 410, 140, 75, 19, 0)
$b_start = GUICtrlCreateButton("Start", 5, 70, 79, 21)
$b_pause = GUICtrlCreateButton("Pause", 5, 90, 79, 21)
$b_reset = GUICtrlCreateButton("Reset", 5, 110, 79, 21)
$b_real_time_eph = GUICtrlCreateButton("RT", 65, 12.5, 30, 21)
$b_off_real_time_eph = GUICtrlCreateButton("Off", 65, 37.5, 30, 21)

$l_timer = GUICtrlCreateLabel("00:00:00", 100, 113.5, 79, 21)

$Label1 = GUICtrlCreateLabel("Initial Exp:", 4, 15, 50, 17)
$Label2 = GUICtrlCreateLabel("After Exp:", 4, 40, 50, 17)

;$Label4_1 = GUICtrlCreateLabel("EXP Per Mob:", 4, 75, 92, 17)
$Label3 = GUICtrlCreateLabel("Grind Time (Hrs):", 4, 139, 79, 17)

$Label7_1 = GUICtrlCreateLabel("Exp Gain:", 207, 15, 74, 17)
$Label7_2 = GUICtrlCreateLabel("0", 290, 15, 74, 17)
$Label8_1 = GUICtrlCreateLabel("Avg Exp/hr:", 207, 40, 67, 17) 
$Label8_2 = GUICtrlCreateLabel("0", 290, 40, 74, 17)
;$Label9_1 = GUICtrlCreateLabel("Next Level Up:", 207, 64, 71, 17)
;$Label9_2 = GUICtrlCreateLabel("0", 207, 88, 162, 17)

$Input1_exp_current = GUICtrlCreateInput("", 100, 12, 97, 21)
$Input2_exp_need = GUICtrlCreateInput("", 100, 38, 97, 21)
$Input3_playing_hours = GUICtrlCreateInput("", 100, 136, 97, 21)
;$Input4_exp_per_mob = GUICtrlCreateInput("", 101, 72, 49, 21)
;$Input5_1_mobkilltime_sec = GUICtrlCreateLabel("Time to Kill (TTK):", 4, 108, 96, 17)
;$Input5_mobkilltime_sec = GUICtrlCreateInput("", 100, 104, 49, 21)

$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
; ===============================SETUP=========================================================
;Local $hWnd = WinWait("[CLASS:subWin; INSTANCE:1]", "", 10)
; =============================================================================================
GUISetState(@SW_SHOW, $Form1)
;WinSetTrans($Form1, "", 200)
#EndRegion ### END Koda GUI section ###

WinSetOnTop($GUI_NAME, "", 1)

AdlibRegister("_perform_calc_exphour",600)
Global $state = "Idle", $timer, $render_timer, $saved_time = 0

While 1
	$nMsg = GUIGetMsg()
	Sleep(20)
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
		AdlibUnregister()
		Exit
			
		Case $b_donate
			ShellExecute("https://www.buymeacoffee.com/racbd")
		
		Case $b_update
			_update_Check2()
			
		Case $b_start
			start_timer()
			_getcurrentexp()
		Case $b_pause
            pause_timer()
			_getafterexp()
		Case $b_reset
			reset_timer()
			GUICtrlSetData($Input1_exp_current,'')
			GUICtrlSetData($Input2_exp_need,'')
			GUICtrlSetData($Input3_playing_hours,'')			
		Case $b_real_time_eph
			AdlibRegister(_real_time_eph, 5000)
		Case $b_off_real_time_eph
			AdlibUnregister()
EndSwitch
If $state == "Running" And TimerDiff($render_timer) >= 40 Then renderTime()
WEnd

Func start_timer()
    If $state == "Idle" Then
        Global $timer = TimerInit(), $state = "Running", $render_timer = TimerInit()
    EndIf
EndFunc

Func stop_timer()
    If $state == "Running" Then
        $state = "Stopped"
        $saved_time = TimerDiff($timer) + $saved_time
        GUICtrlSetData($b_pause, "Resume")
    ElseIf $state == "Paused" Then
        $state = "Running"
        $timer = TimerInit()
        GUICtrlSetData($b_pause, "Pause")
    EndIf
EndFunc

Func pause_timer()
    If $state == "Running" Then
        $state = "Paused"
        $saved_time = TimerDiff($timer) + $saved_time
        GUICtrlSetData($b_pause, "Resume")
    ElseIf $state == "Paused" Then
        $state = "Running"
        $timer = TimerInit()
        GUICtrlSetData($b_pause, "Pause")
    EndIf
EndFunc

Func reset_timer()
    Global $timer = "", $state = "Idle", $render_timer = "", $saved_time = 0
    GUICtrlSetData($l_timer, "00:00:00")
    GUICtrlSetData($b_pause, "Pause")
EndFunc

Func renderTime()
    Global $diff = TimerDiff($timer) + $saved_time
    Global $sec_time = Int(Mod($diff/1000, 60))
    Global $min_time = Int(Mod($diff/60000, 60))
    Global $hour_time = Int($diff/3600000)
    If $sec_time < 10 Then $sec_time = "0"&$sec_time
    If $min_time < 10 Then $min_time = "0"&$min_time
    If $hour_time < 10 Then $hour_time = "0"&$hour_time
    GUICtrlSetData($l_timer, $hour_time&":"&$min_time&":"&$sec_time)
    $render_timer = TimerInit()
	;Global $convert_time = ($hour_time + $min_time) * (1 / 60) + $sec_time (1 / 3600)
	Global $convert_time = Round($hour_time + $min_time * (1/60) + $sec_time * (1/3600),3)
	GUICtrlSetData($Input3_playing_hours,$convert_time)
EndFunc

Func _getcurrentexp()
		If WinExists("LDPlayer") Then
			WinActivate("LDPlayer")
			WinWaitActive("LDPlayer")
		EndIf
		ControlSend("[TITLE:LDPlayer]", "", "", "{L}")
		Sleep (2000)
		RunWait("C:\WINDOWS\system32\cmd.exe" & " /c " & 'Capture2Text_CLI.exe --clipboard --language English --screen-rect "1900 424 2051 453" ', "C:\Capture2Text", @SW_HIDE)
		$text_current_exp=_ClipBoard_GetData($CF_UNICODETEXT)
		GUICtrlSetData($Input1_exp_current,$text_current_exp)
EndFunc

Func _getafterexp()
		If WinExists("LDPlayer") Then
			WinActivate("LDPlayer")
			WinWaitActive("LDPlayer")
		EndIf
		ControlSend("[TITLE:LDPlayer]", "", "", "{L}")
		Sleep (2000)
		;RunWait("C:\WINDOWS\system32\cmd.exe" & " /c " & 'Capture2Text_CLI.exe --clipboard --language English --screen-rect "2065 428 2211 452" ', "C:\Capture2Text", @SW_HIDE) ; Checks EXP TO LEVEL
		RunWait("C:\WINDOWS\system32\cmd.exe" & " /c " & 'Capture2Text_CLI.exe --clipboard --language English --screen-rect "1900 424 2051 453" ', "C:\Capture2Text", @SW_HIDE)
		$text_after_exp=_ClipBoard_GetData($CF_UNICODETEXT)
		GUICtrlSetData($Input2_exp_need,$text_after_exp)
EndFunc

Func _real_time_eph()
		If WinExists("LDPlayer") Then
		WinActivate("LDPlayer")
		WinWaitActive("LDPlayer")
		EndIf
		ControlSend("[TITLE:LDPlayer]", "", "", "{L}")
		Sleep (2000)
		RunWait("C:\WINDOWS\system32\cmd.exe" & " /c " & 'Capture2Text_CLI.exe --clipboard --language English --screen-rect "1900 424 2051 453" ', "C:\Capture2Text", @SW_HIDE)
		$text_rt_eph=_ClipBoard_GetData($CF_UNICODETEXT)
		GUICtrlSetData($Input2_exp_need,$text_rt_eph)
EndFunc

Func _perform_calc_exphour()
	
	$days		= 0
	$hours		= 0
	$minutes	= 0	
	
	$exp_current = GUICtrlRead($Input1_exp_current)
		;$exp_current	= StringReplace($exp_current,',',',')
		;$exp_current	= Number(StringReplace($exp_current,',','.'))
		$exp_current	= Number($exp_current)
	
	$exp_need	= GUICtrlRead($Input2_exp_need)
		;$exp_need	= StringReplace($exp_need,',',',')
		;$exp_need	= Number(StringReplace($exp_need,',','.'))
		$exp_need	= Number($exp_need)

	;## return if before & after fields are blank
	If $exp_current = '' then Return
	If $exp_need = '' then Return
		
	;## how many Exp to gain more:
;~ 	------------------------------------------------------------
	$exp_to_gain	= 100 - $exp_need
;~ 	------------------------------------------------------------

	;## how many mobbs to kill
;~ 	------------------------------------------------------------
	;$exp_needed_to_level_orig	= $exp_need - $exp_current
	$exp_needed_to_level	= $exp_need - $exp_current
	;$exp_per_mob = GUICtrlRead($Input4_exp_per_mob) 
		
	;$Mobs_to_kill	= $exp_needed_to_level / $exp_per_mob
	
	; exp per hour
	GUICtrlSetData($Input3_playing_hours,$convert_time)
	$playing_hours = GUICtrlRead($Input3_playing_hours)
	$exp_gained = $exp_need - $exp_current
	;$mobs_killed = ($exp_need - $exp_current) / $exp_per_mob
	$exp_per_hour = $exp_gained / $playing_hours
	;$exp_per_hour = ($exp_per_mob * $mobs_killed) / $playing_hours
	
	
	;GUICtrlSetData($Label9_2,$days & ' Days ' & $hours & ' Hours ' & $minutes & ' Min' ) ; 
;~ 	------------------------------------------------------------
	$exp_gained_to_convert = $exp_gained
	$result_exp_gained = _StringAddThousandsSep($exp_gained_to_convert)
	$round_exp_gained = Round($exp_gained,0)
	GUICtrlSetData($Label7_2,_StringAddThousandsSep($round_exp_gained))
	
	
	;GUICtrlSetData($Label7_2,Round($exp_gained,0)) ; exp gained during session
	
	;GUICtrlSetData($Label8_2,Round($exp_needed_to_level,3) & ' %') ; exp per mob, but we need to round it up
	;$exp_needed_to_level	= Number(StringReplace($exp_needed_to_level,',','.'))
	;GUICtrlSetData($Label8_2,$exp_per_hour)
	$exp_per_hour_to_convert = $exp_per_hour
	$result_eph = _StringAddThousandsSep($exp_per_hour_to_convert)
	$round_eph = Round($exp_per_hour,0)
	GUICtrlSetData($Label8_2,_StringAddThousandsSep($round_eph))
	;GUICtrlSetData($Label8_2,Round($exp_per_hour,0))

	
	;## how many time to spend nonstop in seconds
;~ 	------------------------------------------------------------
	;$playing_hours = GUICtrlRead($Input3_playing_hours)
	;$mobkilltime_sec	= GUICtrlRead($Input5_mobkilltime_sec)
	;$mobkilltime_sec	= StringReplace($mobkilltime_sec,",",".")
	
	;convert all to seconds
	;$timetospend_in_sec = $playing_hours * 60
	;$timetospend_in_sec = 0 * 60 + 1
	;$timetospend_in_sec = 0 * 60 + $mobkilltime_sec
	;$timetospend_in_sec = $timetospend_in_sec * $Mobs_to_kill
	
	;~ convert to Days
	;$timetospend_in_days	= $timetospend_in_sec / 86400
	
	;~ convert to hours ; we need this lather
	;$timetospend_in_hours	= $timetospend_in_sec / 3600
	
;~ 	------------------------------------------------------
	; time nonstop playing required is:
	;$playing_hours = GUICtrlRead($Input3_playing_hours)
	
	If $playing_hours <> '' Then ; progression formula An=a1+(n-1)*d    n=(An-a1/d) +1 
		
		$a1 = $playing_hours
		$d 	= $playing_hours
		;$An = $timetospend_in_days
;~ 		
		;$n = $An - $a1
		;$n = $n / $d
		;$n = $n	+1 ; value in hours 

		;$days = $n * 24 ; value in hours
		
		_playinghours($days)
		
;~ 		GUICtrlSetData($Label9_2,$days & ' Days ' & $hours & ' Hours ' & $minutes & ' Min' ) ; mobs to kill		


	Else
		;_playinghours($timetospend_in_days); if field is empty display non stop playing time
	EndIf

		
;~ 	Global $days	= $timetospend_in_days
;~ 	Global $hours	= 0
;~ 	Global $minutes	= 0
	
;~ 	------------------------------------------------------------



EndFunc

Func _playinghours($days)
	
	$days		= $days
	$hours		= 0
	$minutes	= 0	
	
	If StringInStr($days,'.') Then ; if we have decimal values first
		$split = StringSplit($days,'.')
		$days = $split[1]								; <---- Days final value
		
;~ 		_ArrayDisplay($split,'')

		$split_d_2 	=  '0.' & $split[2] 
		$hours		=  $split_d_2 * 24 					; hours 0,* or full value
			
		If StringInStr($hours,'.') Then 				; if we have decimal values in hours
			$split = StringSplit($hours,'.')
			$hours = $split[1]							; <---- hours final value
			
;~ 			_ArrayDisplay($split,'')

			$minutes 	=  '0.' & $split[2] 
			$minutes	=  $minutes * 60				; get minutes 0,*	
			
			If StringInStr($minutes,'.') Then
				$split = StringSplit($minutes,'.')
				$minutes = $split[1]					; <---- minutes final value
			EndIf		
		EndIf
	EndIf
	
	;GUICtrlSetData($Label9_2,$days & ' Days ' & $hours & ' Hours ' & $minutes & ' Min' ) ; mobs to kill		

EndFunc

ConsoleWrite(_StringAddThousandsSep("61234567890.54321") & @CRLF)
ConsoleWrite(_StringAddThousandsSep("-$123123.50") & @CRLF)
ConsoleWrite(_StringAddThousandsSep("-8123.45") & @CRLF)
ConsoleWrite(_StringAddThousandsSep("-123.45") & @CRLF)
ConsoleWrite(_StringAddThousandsSep("-$25") & @CRLF)
ConsoleWrite(_StringAddThousandsSep("-$hello") & @CRLF)

; Instead of :-
; "Local $rKey = "HKCU\Control Panel\International"
;   If $sDecimal = -1 Then $sDecimal = RegRead($rKey, "sDecimal")
;   If $sThousands = -1 Then $sThousands = RegRead($rKey, "sThousand") ",
;
; $sThousands = ",", $sDecimal = "." are function parameters.
;
Func _StringAddThousandsSep($sString, $sThousands = ",", $sDecimal = ".")
    Local $aNumber, $sLeft, $sResult = "", $iNegSign = "", $DolSgn = ""
    If Number(StringRegExpReplace($sString, "[^0-9\-.+]", "\1")) < 0 Then $iNegSign = "-" ; Allows for a negative value
    If StringRegExp($sString, "\$") And StringRegExpReplace($sString, "[^0-9]", "\1") <> "" Then $DolSgn = "$" ; Allow for Dollar sign
    $aNumber = StringRegExp($sString, "(\d+)\D?(\d*)", 1)
    If UBound($aNumber) = 2 Then
        $sLeft = $aNumber[0]
        While StringLen($sLeft)
            $sResult = $sThousands & StringRight($sLeft, 3) & $sResult
            $sLeft = StringTrimRight($sLeft, 3)
        WEnd
        $sResult = StringTrimLeft($sResult, 1); Strip leading thousands separator
        If $aNumber[1] <> "" Then $sResult &= $sDecimal & $aNumber[1] ; Add decimal
    EndIf
    Return $iNegSign & $DolSgn & $sResult ; Adds minus or "" (nothing)and Adds $ or ""
EndFunc ;==>_StringAddThousandsSep

Func _update_Check2()
	
	$URL = 'https://raw.githubusercontent.com/RAcbd/ROXTools/main/exphour.au3'

	$HTMLSource = _INetGetSource($URL)

	$_Arrayline = StringSplit($HTMLSource, @LF) ; this is the Array $_Arrayline
;~ 	
		for $i = 1 to $_Arrayline[0] 
			If StringInStr($_Arrayline[$i],'/Latest Ver') Then 
				
				If StringInStr($_Arrayline[$i],'Latest Ver') And StringInStr($_Arrayline[$i], $GUI_NAME) Then
					
					_GUICtrlStatusBar_SetText ($StatusBar1, "You are using the latest Version!")			
				Else
					
					$msgbox = MsgBox(1,'Update','Update to the latest version?')
						If $msgbox = 1 Then
							ShellExecute($URL) ; yes get it
						EndIf
				EndIf
				
				ExitLoop
			EndIf
			
		Next

EndFunc