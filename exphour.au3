#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\Pictures\TeeyoTV\Team 55 - Logo\Main - BlueWhite.ico
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


Global $GUI_NAME = "Ragnarok X | EXP / Hour | by: Raff"

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($GUI_NAME, 371, 187, 406, 324)
$Button1 = GUICtrlCreateButton("Load Sample Data", 264, 117, 99, 20, 0)
$Button2 = GUICtrlCreateButton("Exp Calc", 288, 145, 75, 19, 0)

$Label1 = GUICtrlCreateLabel("Initial Exp:", 4, 15, 96, 17)
$Label2 = GUICtrlCreateLabel("After Exp:", 4, 40, 87, 17)

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
$Input3_playing_hours = GUICtrlCreateInput("", 100, 136, 49, 21)
;$Input4_exp_per_mob = GUICtrlCreateInput("", 101, 72, 49, 21)
;$Input5_1_mobkilltime_sec = GUICtrlCreateLabel("Time to Kill (TTK):", 4, 108, 96, 17)
;$Input5_mobkilltime_sec = GUICtrlCreateInput("", 100, 104, 49, 21)

$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

WinSetOnTop($GUI_NAME, "", 1)

AdlibRegister("_perform_calc_exphour",600)

While 1
	$nMsg = GUIGetMsg()
	Sleep(20)
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
		AdlibUnregister()
		Exit
	
		Case $Button2
			Run("expcalc.exe")
		
		Case $Button1
			GUICtrlSetData($Input1_exp_current,'1567912')
			GUICtrlSetData($Input2_exp_need,'1596312')			
			GUICtrlSetData($Input3_playing_hours,'3')
			;GUICtrlSetData($Input4_exp_per_mob,'83')
			;GUICtrlSetData($Input5_mobkilltime_sec,'1')
EndSwitch
WEnd

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
	$playing_hours = GUICtrlRead($Input3_playing_hours)
	$exp_gained = ($exp_need - $exp_current) * $playing_hours
	;$mobs_killed = ($exp_need - $exp_current) / $exp_per_mob
	$exp_per_hour = $exp_gained / $playing_hours
	;$exp_per_hour = ($exp_per_mob * $mobs_killed) / $playing_hours
	
	
	;GUICtrlSetData($Label9_2,$days & ' Days ' & $hours & ' Hours ' & $minutes & ' Min' ) ; 
;~ 	------------------------------------------------------------

	GUICtrlSetData($Label7_2,Round($exp_gained,0)) ; mobs to kill
	
	;GUICtrlSetData($Label8_2,Round($exp_needed_to_level,3) & ' %') ; exp per mob, but we need to round it up
	;$exp_needed_to_level	= Number(StringReplace($exp_needed_to_level,',','.'))
	;GUICtrlSetData($Label8_2,$exp_per_hour)
	GUICtrlSetData($Label8_2,Round($exp_per_hour,0))

	
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

Func _update_Check2()
	
	$URL = 'http://www.autoitscript.com/forum/index.php?showtopic=93713'

	$HTMLSource = _INetGetSource($URL)

	$_Arrayline = StringSplit($HTMLSource, @LF) ; this is the Array $_Arrayline
;~ 	
		for $i = 1 to $_Arrayline[0] 
			If StringInStr($_Arrayline[$i],'/Latest Ver') Then 
				
				If StringInStr($_Arrayline[$i],'Latest Ver') And StringInStr($_Arrayline[$i], $GUI_NAME) Then
					
					_GUICtrlStatusBar_SetText ($StatusBar1, "You are using the latest Version!")			
				Else
					
					$msgbox = MsgBox(1,'Update','New Version is Avalible Go get it?')
						If $msgbox = 1 Then
							ShellExecute($URL) ; yes get it
						EndIf
				EndIf
				
				ExitLoop
			EndIf
			
		Next

EndFunc
















