;Finds main directory from one level down or same level as main
Func FindDir()
   Global $dir = @ScriptDir
   Global $dir_parent = StringLeft($dir,StringInStr($dir,"\",0,-1)-1)
   $strlen1 = StringLen($dir_parent)
   $strlen2 = StringLen($dir)
   If $strlen1 > $strlen2 Then
	  $dir_parent = $dir_parent
   Else
	  $dir_parent = $dir
   EndIf
EndFunc
;Ends all scripts if they exist
Func Quit2()
   Exit
EndFunc
;Function will pause the current script
Func Pause()
   $Paused = NOT $Paused
   While $Paused
	  Sleep(100)
	  ToolTip('Script is "Paused"',10,10)
   WEnd
   ToolTip("")
EndFunc
Func Logs($ref)
   Local $file = FileOpen("log.txt",1)
   FileWrite($file,@YEAR&"/"&@MON&"/"&@MDAY&" - "&@HOUR&":"&@MIN&":"&@SEC&" - ")
   ;---EndGameM-----
   If $ref = "M" Then
	  FileWriteLine($file, "Bot detected the Dungeon was Missing!")
   ;----------------
   ;---EndGameS-----
   ElseIf $ref = "S" Then
	  FindDir()
	  $truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
	  FileWriteLine($file, "Bot sucessfully completed Run #"&$truns&"!")
   ;----------------
   ;---EndGameF-----
   ElseIf $ref = "npc" Then
	  FileWriteLine($file, "Bot failed to reach the NPC!")
   ElseIf $ref = "wp" Then
	  FileWriteLine($file, "Bot failed to reach the In-town Waypoint!")
   ElseIf $ref = "cellar" Then
	  FileWriteLine($file, "Bot failed to get inside the Cellar!")
   ElseIf $ref = "intown" Then
	  FileWriteLine($file, "Bot failed to Port back to Town!")
   ElseIf $ref = "skcp" Then
	  FileWriteLine($file, "Bot failed to reach the Sarkoth Checkpoint(Gate Entrance)!")
   ;----------------
   ;-----Misc-------
   ElseIf $ref = "crash" Then
	  FileWriteLine($file, "Bot detected a Diablo 3 Crash/Closing! Initiated a 30 minute sleep then relogging.")
   ElseIf $ref = "death" Then
	  FileWriteLine($file, "Bot died and left the game.")
   ElseIf $ref = "error" Then
	  FileWriteLine($file, "Bot detected an error message.")
   ElseIf $ref = "online" Then
	  FileWriteLine($file, "Bot initiated by the user.")
   ElseIf $ref = "offline" Then
	  FileWriteLine($file, "Bot terminated by the user.")
   ;----------------
  ; ElseIf $ref = "hotfix" Then
	;  FileWriteLine($file, "")
   ;----------------
   EndIf
   FileClose($file)
EndFunc
Func StartD3($ref)
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("Loading the game", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   Run("C:\Program Files (x86)\Diablo III\Diablo III Launcher.exe")
   WinWaitActive("Diablo III")
   ;------------------------------------------------------------------
   ;Loop check for a clickable(red tinted) PLAY button
   $timeout = 0
   $play = PixelSearch(1134, 671, 1286, 715, 0x8A1207,4,1)
   While @error = 1 ; red play button not found
	  If $timeout > 60 Then
		 ProcessClose("Blizzard Launcher.exe")
		 Sleep(200)
		 StartD3("")
	  EndIf
	  Sleep(1000)
	  $timeout = $timeout + 1
	  $play = PixelSearch(1134, 671, 1286, 715, 0x8A1207,4,1)
	  If @error = 0 Then
		 MouseClick("primary",$play[0],$play[1],1)
		 ExitLoop
	  EndIf
   WEnd
   ;Loop check for BLIZZARD logo at bottom of login screen
   WinWaitActive("Diablo III")
   $timeout = 0
   $atlogin = PixelSearch(917, 955, 998, 987, 0x8C1410,1,1)
   While @error = 1 ; no pointer found
	  If $timeout > 60 Then
		 ProcessClose("Diablo III.exe")
		 Sleep(200)
		 StartD3("")
	  EndIf
	  Sleep(1000)
	  $timeout = $timeout + 1
	  $atlogin = PixelSearch(917, 955, 998, 987, 0x8C1410,1,1)
	  If @error = 0 Then
		 MouseMove($atlogin[0],$atlogin[1])
		 ExitLoop
	  EndIf
   WEnd
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through therohe script
   ToolTip("Logging in to the game", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   MouseClick("primary",935,707,1)
   Sleep(100)
   $pwd= IniRead("userdata.ini", "Login Info", "Password", "Not Found")
   If $pwd = "Not Found" Then
	  Exit
   Else
	  Send($pwd)
   EndIf
   Sleep(300)
   MouseClick("primary",960,850,1)
   $useauth = IniRead("userdata.ini", "Login Info", "Using Authenticator","Not Found")
   If $ref = "initial" And $useauth = "True" Then
	  ;--------------------------------------------------------------
	  ;Loop check for authentication code box
	  $atauth = PixelSearch(950, 650, 1055, 673, 0x392E21,3,1)
	  While @error = 1 ; no pointer found
		 $atauth = PixelSearch(950, 650, 1055, 673, 0x392E21,3,1)
		 If @error = 0 Then
			MouseMove($atauth[0],$atauth[1])
			ExitLoop
		 EndIf
	  WEnd
	  ;--------------------------------------------------------------
	  $authcode= IniRead("userdata.ini", "Login Info", "Auth Code", "Not Found")
	  If $authcode = "Not Found" Then
		 Exit
	  Else
	    Send($authcode)
	  EndIf
	  Sleep(100)
	  MouseClick("primary",948,853,1)
   EndIf
   Sleep(1000)
   ;-----------------------------------------------------------------
   ;Loop check for hero menu
   ;-----------------------------------------------------------------
   $menu = PixelSearch(865, 945, 1035, 975, 0x121315,5,1)
   While @error = 1 ; no pointer found
	  $menu = PixelSearch(865, 945, 1035, 975, 0x121315,5,1)
	  If @error = 0 Then
		 MouseMove($menu[0],$menu[1])
		 ExitLoop
	  EndIf
   WEnd
   If Not $ref = "initial" Then
	  Prep()
   EndIf
EndFunc
;Function Logs user in game for first time
Func Login()
   Global $Paused
   Global $dir
   Global $dir_parent
   FindDir()
   If ProcessExists("Diablo III.exe") Then
	  ProcessClose("Diablo III.exe")
   EndIf
   $useauth = IniRead("userdata.ini", "Login Info", "Using Authenticator","Not Found")
   If $useauth = "True" Then
	  Local $authcode = InputBox("Authenticator Code", "Please enter the 8-digit code.(Cancel will stop the program)", "", " M8")
	  If @error = 1 Then ;User chose Cancel, terminated script.
		Exit
	  EndIf
	  IniWrite("userdata.ini", "Login Info", "Auth Code", $authcode)
   EndIf
   ;--------------------------------------------------------------
   StartD3("initial")
   ;--------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   $hero = IniRead("userdata.ini", "Hero Data", "Hero", "Barbarian")
   ToolTip("Made it to the hero menu! Selecting hero ("& $hero &")", 960, 20,"Bot Progress",0,2)
   ;--------------------------------------------------------------
   Sleep(1000)
   MouseClick("primary",960,925,1);Switch Hero button
   Sleep(1000)
   If $hero = "Barbarian" Then
	  Local $selecthero = PixelSearch(60, 200, 412, 816, 0x9A8D7C,1,1)
	  If @error = 0 Then;Found Barbarian
		 MouseClick("primary",$selecthero[0],$selecthero[1],1)
		 Sleep(1000)
	  EndIf
   ElseIf $hero = "Witch Doctor" Then
	  Local $selecthero = PixelSearch(60, 200, 412, 816, 0x6B3532,1,1)
	  If @error = 0 Then;Found Witch Doctor
		 MouseClick("primary",$selecthero[0],$selecthero[1],1)
		 Sleep(1000)
	  EndIf
   ElseIf $hero = "Monk" Then
	  Local $selecthero = PixelSearch(60, 200, 412, 816, 0x2A130A,1,1)
	  If @error = 0 Then;Found Monk
		 MouseClick("primary",$selecthero[0],$selecthero[1],1)
		 Sleep(1000)
	  EndIf
   ElseIf $hero = "Wizard" Then
	  Local $selecthero = PixelSearch(60, 200, 412, 816, 0x672012,1,1)
	  If @error = 0 Then;Found Wizard
		 MouseClick("primary",$selecthero[0],$selecthero[1],1)
		 Sleep(1000)
	  EndIf
   EndIf
   MouseClick("primary",960,960,1)
   Sleep(1000)
EndFunc
;Function ports hero back to town and checks for monsters meanwhile
Func PortCheck()
   $i = 0
   $intown = PixelSearch(665,910,840,960, 0x528183, 4, 1)
   While @error = 1
	  RunChecks()
	  Send("t")
	  Sleep(1000)
	  $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,11,1)
	  If @error = 0 Then
		 Attack()
	  EndIf
	  Sleep(1000)
	  $fireburn = PixelSearch(455, 423, 509, 461, 0xFEFE60,3,1)
	  If @error = 0 Then
		 Prep()
	  EndIf
	  $i = $i + 1
	  If $i = 100 Then
		 EndGameF("intown")
	  EndIf
	  $intown = PixelSearch(665,910,840,960, 0x528183, 4, 1)
   WEnd
EndFunc
;Function will hit "Leave Game" on the in-game menu and sleep for 11 seconds
Func EndGame($ref)
   Send("{ESC}")
   Sleep(500)
   MouseClick("primary",952,580,1)
   Sleep(11000)
   Logs($ref)
EndFunc
;Failed Game
Func EndGameF($ref)
   Global $dir
   Global $dir_parent
   PortCheck()
   Sleep(200)
   Send("{ESC}")
   Sleep(500)
   MouseClick("primary",952,580,1)
   Sleep(6000)
   RunChecks()
   ;(Also write to log)
   FindDir()
   $fruns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Failed Runs", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Failed Runs", $fruns+1)
   $truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", $truns+1)
   Logs($ref)
   Sleep(8000)
   Prep()
   Exit
EndFunc
;Successful Game
Func EndGameS()
   Global $dir
   Global $dir_parent
   PortCheck()
   Sleep(200)
   Send("{ESC}")
   Sleep(500)
   MouseClick("primary",952,580,1)
   Sleep(6000)
   RunChecks()
   ;(Also write to log)
   FindDir()
   $sruns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Successful Runs", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Successful Runs", $sruns+1)
   $truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", $truns+1)
   Logs("S")
   Sleep(8000)
   Prep()
   Exit
EndFunc
;Missing Dungeon
Func EndGameM()
   Global $dir
   Global $dir_parent
   PortCheck()
   Sleep(200)
   Send("{ESC}")
   Sleep(500)
   MouseClick("primary",952,580,1)
   Sleep(6000)
   RunChecks()
   ;(Also write to log)
   FindDir()
   $sruns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Successful Runs", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Successful Runs", $sruns+1)
   $miss = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Missing Dungeon", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Missing Dungeon", $miss+1)
   $truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
   IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", $truns+1)
   Logs("M")
   Sleep(8000)
   Prep()
   Exit
EndFunc
;Function used for looting
Func Find_Loot()
   Global $dir
   Global $dir_parent
   Send("{ALT}")
   $End =0
   FindDir()
   $i = 0
   $pickgold = "False" ; use gui later
   While $i <= 0
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("Searching for the loot!", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   $intown = PixelSearch(665,910,840,960, 0x528183, 5, 1)
   If @error <> 1 Then
	  ExitLoop
   EndIf
   $legen = PixelSearch( 200, 250, 1550, 750, 0xBF642F, 1, 5)
   While @error = 0 And $End <= 5
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("I'm detecting a legendary item..", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",$legen[0],$legen[1],1)
	  Sleep(2000)
	  $legen = PixelSearch( 200, 250, 1550, 750, 0xBF642F, 1, 5)
	  $End = $End+1
   WEnd
   $End =0
   $rare = PixelSearch( 200, 250, 1550, 750, 0xFFFF00, 1, 5)
   While @error = 0 And $End <= 5
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("I'm detecting a rare item..", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",$rare[0],$rare[1],1)
	  Sleep(2000)
	  $rare = PixelSearch( 200, 250, 1550, 750, 0xFFFF00, 1, 5)
	  $End = $End+1
   WEnd
   $End = 0
   $magic = PixelSearch( 200, 250, 1550, 750, 0x6969FF, 1, 5)
   While @error = 0 And $End <= 5
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("I'm detecting a magic item..", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",$magic[0],$magic[1],1)
	  Sleep(2000)
	  $mitems = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Magic Items", "Not Found")
	  IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Magic Items", $mitems+1)
	  $magic = PixelSearch( 150, 10, 1550, 850, 0x6969FF, 1, 5)
	  $End = $End+1
   WEnd
   $End = 0
   $set = PixelSearch( 200, 250, 1550, 750, 0x00FF00, 1, 5)
   While @error = 0 And $End <= 5
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("I'm detecting a set item..", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",$set[0],$set[1],1)
	  Sleep(2000)
	  $set = PixelSearch( 150, 10, 1550, 850, 0x00FF00, 1, 5)
	  $End = $End+1
   WEnd
   If $pickgold = "True" Then
	  $End =0
	  $gold = PixelSearch( 150, 10, 1550, 850, 0xEEF15D, 1, 2)
	  While @error = 0 And $End <= 5
		 ;------------------------------------------------------------------
		 ;Show tooltip with bot progression through the script
		 ToolTip("I'm detecting a gold pile..", 960, 20,"Bot Progress",0,2)
		 ;------------------------------------------------------------------
		 MouseClick("primary",$gold[0],$gold[1],1)
		 Sleep(2000)
		 $gold = PixelSearch( 150, 10, 1550, 850, 0xEEF15D, 1, 2)
		 $End = $End+1
	  WEnd
	  $End =0
	  $gold2 = PixelSearch( 150, 10, 1550, 850, 0xFDFD96, 1, 2)
	  While @error = 0 And $End <= 5
		 ;------------------------------------------------------------------
		 ;Show tooltip with bot progression through the script
		 ToolTip("I'm detecting a gold pile..", 960, 20,"Bot Progress",0,2)
		 ;------------------------------------------------------------------
		 MouseClick("primary",$gold2[0],$gold2[1],1)
		 Sleep(2000)
		 $gold2 = PixelSearch( 150, 10, 1550, 850, 0xFDFD96, 1, 2)
		 $End = $End+1
	  WEnd
	  $End =0
	  $gold3 = PixelSearch( 150, 10, 1550, 850, 0xD4D356, 1, 2)
	  While @error = 0 And $End <= 5
		 ;------------------------------------------------------------------
		 ;Show tooltip with bot progression through the script
		 ToolTip("I'm detecting a gold pile..", 960, 20,"Bot Progress",0,2)
		 ;------------------------------------------------------------------
		 MouseClick("primary",$gold3[0],$gold3[1],1)
		 Sleep(2000)
		 $gold3 = PixelSearch( 150, 10, 1550, 850, 0xD4d356, 2, 2)
		 $End = $End+1
	  WEnd
   EndIf
   $i = $i+1
   WEnd
EndFunc
;Function checks whether it is fighting a Rare (Yellow) Monster
Func Elite()
   $truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
   $trunsa = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs Saved", "0")
   $elite = PixelSearch( 760, 10, 1200, 50, 0xFFFF00, 1, 2)
   If @error = 0 Then
	  If $truns <> $trunsa Then
		 $elitef = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Elites Found", "0")
		 IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Elites Found", $elitef+1)
		 IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Total Runs Saved", $truns)
	  EndIf
   EndIf
EndFunc
;Function used for attacking
Func BB_ATK_SEQ()
$revenge=""
$rend=""
$done=""
$counter=""
WinActivate("[CLASS:D3 Main Window Class]")
While 1 = 1
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("I'm detecting some monsters.. It's killin' time!", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   Local $monster = PixelSearch(700, 300, 1220, 780, 0xBD0400,30,1)
   While @error = 0 ;$error = 1 means no pixel color found
	  $done="0"
	  While @error = 1 And $done < 2
		 Sleep(500)
		 Local $monster = PixelSearch(700, 300, 1540, 870, 0xBD0400,30,1)
		 $done= $done+1
	  WEnd
	  ;Make check to see if object found is moving
	  MouseClick("primary",$monster[0],$monster[1],1)
	  ;---------------------------------------------------------
	  ;Edit based on your attack

	  $revenge = PixelGetColor( 744, 1014)
	  $rend = PixelGetColor( 798, 1009)
	  If $revenge <> 0x222222 Then
		 Send("2")
		 Sleep(100)
	  EndIf
	  If $rend <> 0x262526 Then
		 Send("3")
		 Sleep(100)
	  EndIf
	  If @error = 1 And $done= 10 Then
		 ExitLoop
	  EndIf
	  If @error = 1 Then
		 $done= $done+1
		 SLeep(100)
	  EndIf
	  ;-----------------------------------------------
	  $monster = PixelSearch(700, 300, 1220, 780, 0xBD0400,30,1)
   WEnd
   ExitLoop
WEnd
EndFunc
Func WD_ATK_SEQ()
   While 1 = 1
	  Local $monster = PixelSearch(700, 300, 1540, 870, 0xBD0400,30,1)
	  $done="0"
	  While @error = 1 And $done < 2
		 Sleep(500)
		 Local $monster = PixelSearch(700, 300, 1540, 870, 0xBD0400,30,1)
		 $done= $done+1
	  WEnd
	  $done="0"
	  While @error = 0 ;$error = 1 means no pixel color found
		 ;------------------------------------------------------------------
		 ;Show tooltip with bot progression through the script
		 ToolTip("I'm detecting some monsters.. It's killin' time!", 960, 20,"Bot Progress",0,2)
		 ;------------------------------------------------------------------
		 MouseMove($monster[0],$monster[1])
		 Elite()
		 MouseDown("secondary")
		 Sleep(700)
		 $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,20,1)
		 If @error = 0 Then
			MouseMove($monster[0],$monster[1])
			Elite()
		 EndIf
		 Sleep(700)
		 MouseUp("secondary")
		 Sleep(200)
		 $skill1 = PixelGetColor( 641, 1013)
		 If $skill1 <> 0x222222 Then
			;Send("1")
			Sleep(100)
		 EndIf
		 ;MouseClick("primary",$monster[0],$monster[1],1)
		 ;Sleep(500)
		 If @error = 1 And $done= 10 Then
			ExitLoop
		 EndIf
		 If @error = 1 Then
			$done= $done+1
			Sleep(300)
		 EndIf
		 CheckDeath()
		 $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,30,1)
	  WEnd
	  ExitLoop
   WEnd
EndFunc
Func WIZ_ATK_SEQ()
   While 1 = 1
	  Local $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,30,1)
	  $done="0"
	  While @error = 1 And $done < 4
		 Sleep($done*600)
		 RunChecks()
		 Local $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,30,1)
		 $done= $done+1
	  WEnd
	  $done="0"
	  While @error = 0 ;$error = 1 means no pixel color found
		 ;------------------------------------------------------------------
		 ;Show tooltip with bot progression through the script
		 ToolTip("I'm detecting some monsters.. It's killin' time!", 960, 20,"Bot Progress",0,2)
		 ;------------------------------------------------------------------
		 RunChecks()
		 Sleep(200)
		 Send("3") ;Start Diamond Skin
		 Sleep(200)
		 Local $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,11,1)
		 If @error = 0 Then
			MouseMove($monster[0],$monster[1])
			Elite()
		 Else
			$done = $done + 1
			ExitLoop
		 EndIf
		 Elite()
		 Sleep(200)
		 Send("2") ;Call Hydra
		 Sleep(200)
		 RunChecks()
		 $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,11,1)
		 If @error = 0 Then
			MouseMove($monster[0],$monster[1])
			Elite()
		 Else
			$done = $done + 1
			ExitLoop
		 EndIf
		 $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,11,1)
		 If $done = 0 And @error = 0 Then
			Send("{SHIFTDOWN}")
			MouseClick("primary",$monster[0],$monster[1],1)
			Send("{SHIFTUP}")
		 ElseIf @error = 0 Then
			Send("{SHIFTDOWN}")
			MouseClick("primary",$monster[0],$monster[1],1)
			Send("{SHIFTUP}")
		 EndIf
		 Sleep(200)
		 RunChecks()
		 $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,11,1)
		 If @error = 0 Then
			MouseMove($monster[0],$monster[1])
			Elite()
		 Else
			$done = $done + 1
			ExitLoop
		 EndIf
		 MouseDown("secondary")
		 Sleep(Random(3000,4000))
		 RunChecks()
		 $monster = PixelSearch(400, 300, 1540, 870, 0xBD0400,11,1)
		 If @error = 0 Then
			MouseMove($monster[0],$monster[1])
			Elite()
			Sleep(Random(3000,4000))
			MouseUp("secondary")
		 Else
			MouseUp("secondary")
			$done = $done + 1
			ExitLoop
		 EndIf
		 MouseClick("primary",$monster[0],$monster[1],1)
		 Sleep(1000)
		 If @error = 1 And $done= 10 Then
			ExitLoop
		 EndIf
		 If @error = 1 Then
			$done= $done+1
			Sleep(300)
		 EndIf
		 RunChecks()
		 $monster = PixelSearch(400, 300, 1540, 870,  0xBD0400,30,1)
	  WEnd
	  ExitLoop
   WEnd
EndFunc
Func Attack()
   $hero = IniRead("userdata.ini", "Hero Data", "Hero", "Barbarian")
   $intown = PixelSearch(665,910,840,960, 0x528183, 5, 1)
   If @error = 1 Then
	  If $hero = "Wizard" Then
		 WIZ_ATK_SEQ()
	  ElseIf $hero = "Witch Doctor" Then
		 WD_ATK_SEQ()
	  ElseIf $hero = "Monk" Then
		 ;MK_ATK_SEQ()
	  ElseIf $hero = "Barbarian" Then
		 BB_ATK_SEQ()
	  Else
		 ;DH_ATK_SEQ()
	  EndIf
	  Sleep(500)
	  Find_Loot()
   EndIf
EndFunc
Func CheckHealth()
   $health = PixelSearch(530, 1000, 550, 1010, 0x482F2A, 25, 1)
   If @error <> 1 Then
	  Send("q")
   EndIf
EndFunc
Func CheckDeath()
   FindDir()
   $youdied = PixelSearch(900, 850, 1050, 872, 0x3C0300,8,1)
   If @error = 0 Then
	  $deaths = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Deaths", "0")
	  IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Deaths", $deaths+1)
	  MouseMove($youdied[0],$youdied[1])
	  ;MouseClick("primary",$youdied[0],$youdied[1],1)
	  Sleep(1000)
	  EndGame("death")
	  Sleep(5000)
	  Prep()
   EndIf
EndFunc
Func CheckError()
   FindDir()
   $errorwait = IniRead("userdata.ini", "Hero Data", "Error Wait", "5")
   ;$pwdsave = IniRead("userdata.ini", "Login Info", "Password", "Not Found")
   $useauth = IniRead("userdata.ini", "Login Info", "Using Authenticator", "Not Found")
   ;IniWrite("userdata.ini", "Login Info", "Password", " Password")
   $error = PixelSearch(910, 613, 1015, 654,0x3C0300,10,1)
   If @error = 0 Then ;found red button
	  Sleep(2000)
	  $error2 = PixelSearch(920, 420, 1000, 430,0xE18F01,8,1)
	  If @error = 0 Then ;found error title on window
		 Sleep(500)
		 MouseClick("primary",$error[0],$error[1],1)
		 Sleep(500)
		 Logs("error")
		 $findportal = PixelSearch(1100, 1000, 1150, 1050, 0x3653D6,5,1)
		 If ProcessExists("ez.exe") And @error = 0 Then
			$fruns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Failed Runs", "0")
			IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Failed Runs", $fruns+1)
			$truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
			IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", $truns+1)
		 EndIf
		 ;Add other script files to check for and close down later on..
		 ;These errors mainly occur while logging in though.
		 $s=1000*60
		 While $s > 0
			$m = Floor($s/60)
			ToolTip("Sleeping for  " & $s & " seconds or about " & $m & " minutes", 0, 0,"Bot received a Critical Error from Blizzard")
			Sleep(1000)
			$s = $s-1
		 WEnd
		 $fireburn = PixelSearch(455, 423, 509, 461, 0xFEFE60,3,1)
		 If @error = 0 Then
			Prep()
		 Else
			$findportal = PixelSearch(1100, 1000, 1150, 1050, 0x3653D6,5,1)
			If @error = 1 Then
			   ProcessClose("Diablo III.exe")
			EndIf
		 EndIf
		 Sleep(500)
		 If $useauth = "Yes" And Not ProcessExists("Diablo III.exe") Then
			Exit
		 ElseIf $useauth = "No" And Not ProcessExists("Diablo III.exe") Then
			StartD3("")
		 EndIf
	  EndIf
   EndIf
EndFunc
Func CheckD3Exists()
   If Not ProcessExists("Diablo III.exe") Then
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("Diablo III crashed/closed. Waiting 20 minutes to relog.", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  Logs("crash")
	  Sleep(20*60*1000)
	  StartD3("")
   EndIf
EndFunc
Func RunChecks()
   CheckDeath()
   CheckHealth()
   CheckError()
   CheckD3Exists()
EndFunc
;Function used for repairing and selling gear
Func Repair_Sell()
   ;------------------------------------------------------------------
   ;Check for UNID Rares
   $unid = "True"
   If $unid = "False" Then
	  Send("i")
	  Sleep(500)
	  $rare_item = PixelSearch(1405, 584, 1898, 876, 0xE3E9F9, 3, 1)
		While @error <> 1
			MouseClick("secondary", $rare_item[0], $rare_item[1], 1)
			Sleep(200)
			MouseMove(1770,560)
			Sleep(3500)
			$rare_item = PixelSearch(1405, 584, 1898, 876, 0xE3E9F9, 3, 1)
			If @error = 1 Then
			   ExitLoop
			EndIf
			Sleep(50)
		 WEnd
	  Send("i")
   EndIf
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("On my way to the stash to drop off rares and legendaries!", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   MouseClick("primary",401,598,1)
   Sleep(2000)
   $fullstash = PixelGetColor( 433, 764)
   If $fullstash = 0x130B08 Then ; Stash not full
	  If $unid = "True" Then
		 $rare_item = PixelSearch(1405, 584, 1898, 876, 0xE3E9F9, 3, 1)
		 While @error <> 1
			MouseClick("secondary", $rare_item[0], $rare_item[1], 1)
			Sleep(500)
			$ritems = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Rare Items", "Not Found")
			IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Rare Items", $ritems+1)
			$rare_item = PixelSearch(1405, 584, 1898, 876, 0xE3E9F9, 3, 1)
			If @error = 1 Then
			   ExitLoop
			EndIf
			Sleep(50)
		 WEnd
	  Else
		 $rare_item = PixelSearch(1405, 584, 1898, 876, 0x817617, 4, 1)
		 While @error <> 1
			MouseClick("secondary", $rare_item[0], $rare_item[1], 1)
			Sleep(500)
			$ritems = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Rare Items", "Not Found")
			IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Rare Items", $ritems+1)
			$rare_item = PixelSearch(1405, 584, 1898, 876, 0x817617, 4, 1)
			If @error = 1 Then
			   ExitLoop
			EndIf
			Sleep(50)
		 WEnd
	  EndIf
	  $tome = PixelSearch(1405, 584, 1898, 876, 0x895A20, 1, 1)
	  While @error = 0
		 MouseClick("secondary",$tome[0],$tome[1],1)
		 Sleep(500)
		 $tome = PixelSearch(1405, 584, 1898, 876, 0x895A20, 1, 1)
		 If @error = 1 Then
			ExitLoop
		 EndIf
	  WEnd
	  If $unid = "False" Then
		 $legen = PixelSearch(1405, 584, 1898, 876, 0x61380E, 1, 1)
		 While @error = 0
			MouseClick("secondary",$legen[0],$legen[1],1)
			Sleep(500)
			$litems = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Legendary/Set Items", "Not Found")
			IniWrite($dir_parent&"\botdata.ini", "Bot Data", "Legendary/Set Items", $litems+1)
			$legen = PixelSearch(1405, 584, 1898, 876, 0x61380E, 1, 1)
			If @error = 1 Then
			   ExitLoop
			EndIf
		 WEnd
	  EndIf
   EndIf
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("Heading to a merchant to sell items and repair my gear!", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   MouseClick("primary",1251,421,1)
   Sleep(1500)
   MouseClick("primary",1475,198,1)
   Sleep(1800)
   MouseClick("primary",724,244,1)
   Sleep(1000)
   MouseClick("primary",510,483,1)
   Sleep(800)
   MouseClick("primary",265,593,1)
   Sleep(500)
   MouseClick("primary",516,222,1)
   Sleep(800)
   ;------------------------------------------------------------------
   ;Check to make sure you made it to the merchant
   $atmerchant = PixelSearch(220, 44, 309, 96, 0x134086,4, 1)
   If @error = 1 Then
	  EndGameF("npc")
   EndIf
   ;------------------------------------------------------------------
   $magic_item = PixelSearch(1405, 584, 1898, 876, 0x191F39, 1, 1)
   While @error <> 1
	  MouseClick("secondary", $magic_item[0], $magic_item[1], 1)
	  Sleep(500)
	  $magic_item = PixelSearch(1405, 584, 1898, 876, 0x191F39, 1, 1)
	  If @error = 1 Then
		 ExitLoop
	  EndIf
	  Sleep(50)
   WEnd
   $white_item = PixelSearch(1415, 592, 1898, 818, 0x48291C, 5, 1)
   While @error <> 1
	  MouseClick("secondary", $white_item[0], $white_item[1], 1)
	  Sleep(500)
	  $white_item = PixelSearch(1415, 592, 1898, 818, 0x48291C, 5, 1)
	  If @error = 1 Then
		 ExitLoop
	  EndIf
	  Sleep(50)
   WEnd
   $white_item2 = PixelSearch(1415, 592, 1898, 818, 0x332E2F, 10, 1)
   While @error <> 1
	  MouseClick("secondary", $white_item2[0], $white_item2[1], 1)
	  Sleep(500)
	  $white_item2 = PixelSearch(1415, 592, 1898, 818, 0x332E2F, 10, 1)
	  If @error = 1 Then
		 ExitLoop
	  EndIf
	  Sleep(50)
   WEnd
   Send("{ESC}")
   Sleep(500)
   MouseClick("primary",818,872,1)
   Sleep(1800)
   MouseClick("primary",609,794,1)
   Sleep(1800)
   MouseClick("primary",474,532,1)
   Sleep(1800)
   $difficulty = IniRead("userdata.ini","Hero Data","Difficulty","Not Found")
   If $difficulty = "Inferno" Then
	  $gems = PixelSearch(1415, 592, 1898, 818, 0x080604, 1, 2)
	  While @error <> 1
		 MouseClick("secondary",$gems[0],$gems[1],1)
		 Sleep(500)
		 $gems = PixelSearch(1415, 592, 1898, 818, 0x080604, 1, 2)
		 If @error = 1 Then
			ExitLoop
		 EndIf
		 Sleep(50)
	  WEnd
	  $gems2 = PixelSearch(1465, 832, 1898, 876, 0x080604, 1, 2)
	  While @error <> 1
		 MouseClick("secondary",$gems2[0],$gems2[1],1)
		 Sleep(500)
		 $gems2 = PixelSearch(1465, 832, 1898, 876, 0x080604, 1, 2)
		 If @error = 1 Then
			ExitLoop
		 EndIf
		 Sleep(50)
	  WEnd
   EndIf
   Send("{ESC}")
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("Time to go slay some monsters! Heading to the waypoint now.", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   MouseClick("primary", 979, 908, 1)
   Sleep(1500)
   $waypoint2 = PixelSearch( 1000, 450, 1480, 822, 0x74A8F4, 10)
   If @error = 0 Then
	  MouseClick("primary",$waypoint2[0], $waypoint2[1],1)
   Else
	  EndGameF("wp")
   EndIf
EndFunc
;Discontinued function for repairing (Reference Only)
Func GoRepair()
   MouseClick("primary",1475,198,1)
   Sleep(1800)
   MouseClick("primary",764,244,1)
   Sleep(1000)
   MouseClick("primary",510,483,1)
   Sleep(800)
   MouseClick("primary",265,593,1)
   Sleep(500)
   Send("{ESC}")
   Sleep(500)
   MouseClick("primary",964,905,1)
   Sleep(1500)
   MouseClick("primary",527,827,1)
   Sleep(1200)
   MouseClick("primary",873,780,1)
   Sleep(1000)
   $waypoint2 = PixelSearch( 750, 670, 1260, 980, 0x74A8F4, 10)
   If @error = 0 Then
	  MouseClick("primary",$waypoint2[0], $waypoint2[1],1)
   Else
	  EndGameF("wp")
   EndIf
EndFunc
Func Cemetery()
   PortCheck()
   Sleep(1000)
   MouseClick("primary",1578,698,1)
   Sleep(2000)
   MouseClick("primary",Random(200,300),Random(560,590),1)
   Sleep(2500);Now at Cemetery of Forsaken
   $hero = IniRead("userdata.ini", "Hero Data", "Hero", "Barbarian")
   $guargantuan = PixelSearch(90, 8, 183, 73, 0x9635AE,2,1)
   If @error = 1 Or $hero = "Wizard" Then
	  Send("4") ;Call Guarganuan/Armor
	  Sleep(300)
   EndIf
   $i = 0
   While $i < 2
	  MouseClick("primary",Random(800,820),Random(100,200),1)
	  Attack()
	  Attack()
	  $i = $i + 1
   WEnd
   $i = 0
   While $i < 2
	  MouseClick("primary",Random(1100,1180),Random(915,950),1)
	  Attack()
	  Attack()
	  $i = $i + 1
   WEnd
   $i = 0
   While $i < 3
	  MouseClick("primary",Random(1400,1550),Random(150,330),1)
	  Attack()
	  Attack()
	  $i = $i + 1
   WEnd
   $i = 0
   While $i < 3
	  MouseClick("primary",Random(1060,1110),Random(830,890),1)
	  Attack()
	  Attack()
	  $i = $i + 1
   WEnd
   $i = 0
   While $i < 3
	  MouseClick("primary",Random(380,420),Random(620,700),1)
	  Attack()
	  Attack()
	  $i = $i + 1
   WEnd
EndFunc
Func Sarkoth()
   ;-------------------------------------------------------------
   ;Witch Doctor Exclusive
   $hero = IniRead("userdata.ini", "Hero Data", "Hero", "Barbarian")
   $guargantuan = PixelSearch(90, 8, 183, 73, 0x9635AE,2,1)
   If @error = 1 Or $hero = "Wizard" Then
	  Send("4") ;Call Guarganuan/Armor
	  Sleep(300)
   EndIf
   ;-------------------------------------------------------------
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("On my way to Sarkoth's Lair (Dank Cellar)", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   MouseClick("primary",114,189,1)
   Sleep(1300)
   RunChecks()
   If $hero = "Wizard" Then
	  Send("3")
   EndIf
   Sleep(2400)
   RunChecks()
   MouseClick("primary",60,334,1)
   Sleep(3500)
   $cemetery = IniRead("userdata.ini", "Runnable Bosses", "Cemetery", "False")
   $cellaropen = PixelSearch(50, 75, 1400, 725, 0x334C91,1,1);5275D1,4B6DC6
   If @error = 0 Then
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("Found the Lair!", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",$cellaropen[0],$cellaropen[1],1)
	  Sleep(4200)
	  RunChecks()
	  $findlight = PixelSearch(0, 400, 150, 680, 0xF4F551,15,1)
	  If @error = 1 Then ;Didn't make it to cellar, new game.
		 Sleep(1200)
		 Attack()
		 RunChecks()
		 If $cemetery =  "True" Then
			Cemetery()
		 EndIf
		 Sleep(200)
		 EndGameF("cellar")
	  Else
		 MouseClick("primary",$findlight[0],$findlight[1],1)
		 SLeep(3000)
	  EndIf
	  If $hero = "Wizard" Then
		 MouseMove(614,416)
		 Sleep(Random(50,150))
		 Send("1")
		 Sleep(200)
		 Send("{SHIFTDOWN}")
		 MouseClick("primary",906,426,1)
		 Send("{SHIFTUP}")
		 Sleep(200)
		 Send("2") ;Call Hydra
		 Attack()
		 Sleep(1000)
		 MouseClick("primary",906,426,1)
		 Attack()
		 RunChecks()
		 MouseClick("primary",906,426,1)
		 Sleep(1000)
		 Find_Loot()
		 RunChecks()
		 MouseClick("primary",1206,656,1)
		 Sleep(500)
		 Attack()
	  ElseIf $hero = "Witch Doctor" Then
		 MouseClick("primary",220,200,1) ;Moves Hero indirectly to Sarkoth
		 Sleep(200)
		 Send("1") ;Spirit Walk
		 Sleep(700)
		 Send("2") ;Spawns Fetish Army
		 Sleep(1500)
		 ;-------------------------------------------------------------
		 ;Find Sarkoth and other monsters to kill
		 Attack()
		 ;-------------------------------------------------------------
		 ;Loot the drops!
		 MouseClick("primary",892,517,1)
		 Sleep(500)
		 Find_Loot()
		 ;MouseClick("primary",690,431,1)
		 ;Sleep(500)
		 ;Find_Loot()
		 ;Sleep(500)
		 MouseClick("primary",812,602,1)
		 Sleep(1000)
		 Attack()
		 RunChecks()
	  ElseIf $hero = "Barbarian" Then
		 ;EDIT THIS!!

	  EndIf
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("Porting back to town.", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  If $cemetery =  "True" Then
		 Cemetery()
	  EndIf
	  Sleep(200)
	  EndGameS()
   Else
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("The Lair is missing! Porting back to town and leaving the game.", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  RunChecks()
	  If $cemetery =  "True" Then
		 Cemetery()
	  EndIf
	  Sleep(200)
	  EndGameM()
   EndIf
EndFunc
Func Prep()
   FindDir()
   ;-----------------------------------------------------------------
   ;Loop scan to make sure you are at main menu
   $fireburn = PixelSearch(455, 423, 509, 461, 0xFEFE60,3,1)
   While @error = 1 ; no pointer found
	  $fireburn = PixelSearch(455, 423, 509, 461, 0xFEFE60,3,1)
	  If @error = 0 Then
		 MouseMove($fireburn[0],$fireburn[1])
		 Sleep(1000)
		 ExitLoop
	  EndIf
   WEnd
   ;-----------------------------------------------------------------
   $truns = IniRead($dir_parent&"\botdata.ini", "Bot Data", "Total Runs", "0")
   $rand = Random(1,3,1)
   $num = Random(25,35,1)
   If $truns > 0 And Mod($truns,50) = 0 And $rand = 1 Then
	  ProcessClose("Diablo III.exe")
	  ToolTip("Bot is taking a "&$num&" minute break (Every 50 runs)", 960, 20,"Bot Progress",0,2)
	  Sleep($num*1000)
	  StartD3("")
   EndIf
   If $truns = "0" Then
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("Selecting the quest to go on.", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",240,480,1);Change Quest Button
	  Sleep(500)
	  $scrollbar = PixelSearch(806, 282, 830, 743, 0x5D1100,2,1)
	  If @error = 0 Then;Found the scroll bar
			MouseClickDrag("primary",$scrollbar[0],$scrollbar[1],820,290,20)
			Sleep(200)
		 EndIf
	  MouseClick("primary",580,316,1,10);Select The Fallen Star
	  Sleep(500)
	  MouseClick("primary",580,316,1,10);De-Select The Fallen Star
	  Sleep(300)
   EndIf
   ;-----------------------------------------------------------------
   ;Check which bosses/areas I want to run
   $halls = IniRead("userdata.ini", "Runnable Bosses", "Halls of Agony", "False")
   $gilgamesh = IniRead("userdata.ini", "Runnable Bosses", "Gilgamesh", "False")
   $sarkoth = IniRead("userdata.ini", "Runnable Bosses", "Sarkoth", "False")
   If $truns = "0" Then
	  If $halls = "True" Then
		 MouseClick("primary",580,757,1);Select The Imprisoned Angel
		 Sleep(300)
		 MouseClick("primary",820,760,10,10);Scroll Down
		 Sleep(300)
		 MouseClick("primary",570,740,1);Select Chamber of Suffering
		 Sleep(300)
		 MouseClick("primary",1210,865,1);Select Quest
		 Sleep(500)
	  ElseIf $gilgamesh = "True" Then
		 MouseClickDrag("primary",820,294,820,485,25)
		 Sleep(300)
		 MouseClick("primary",651,665,1);Select Blood and Sand
		 Sleep(300)
		 MouseClick("primary",570,740,1);Select Waterlogged Passage
		 Sleep(300)
		 MouseClick("primary",1210,865,1);Select Quest
		 Sleep(500)
	  ElseIf $sarkoth = "True" Then
		 ;MouseClick("primary",607,368,1);Select The Legacy of Cain
		 ;Sleep(300)
		 ;MouseClick("primary",591,453,1);Select Explore Cellar
		 ;Sleep(300)
		 MouseClick("primary",581,544,1);Select Sword of the Stranger
		 Sleep(300)
		 MouseClick("primary",591,621,1);Select Khazra Den
		 Sleep(300)
		 MouseClick("primary",1210,865,1);Select Quest
		 Sleep(500)
	  EndIf
   EndIf
   ;-----------------------------------------------------------------
   $needokay = PixelSearch(874, 605, 939,  660, 0x3C0300,5,1)
   If @error = 0 Then ;If not at checkpoint, overwrites current progress
	  MouseClick("primary",$needokay[0],$needokay[1],1)
	  Sleep(500)
   EndIf
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("Creating the game now!", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   MouseClick("primary",230,420,1);Resume/Start Game Button
   ;-----------------------------------------------------------------
   ;Loop scan to make sure you made it in game
   $findportal = PixelSearch(1100, 1000, 1150, 1050, 0x3653D6,5,1)
   While @error = 1 ; no pointer found
	  RunChecks()
	  $findportal = PixelSearch(1100, 1000, 1150, 1050, 0x3653D6,5,1)
	  If @error = 0 Then
		 MouseMove($findportal[0],$findportal[1])
		 ExitLoop
	  EndIf
   WEnd
   ;-----------------------------------------------------------------
   ;----------------hero IS----------------------
   ;--------------- IN GAME FROM HERE DOWN ---------------------
   ;------------------------------------------------------------------
   ;Show tooltip with bot progression through the script
   ToolTip("Made it into the game! Starting diagnostic scripts now.", 960, 20,"Bot Progress",0,2)
   ;------------------------------------------------------------------
   $hero = IniRead("userdata.ini", "Hero Data", "Hero", "Barbarian")
   If $hero = "Witch Doctor" Or $hero = "Wizard" Then
	  Sleep(200)
	  Send("4")
   EndIf
   ;Act 1 ONLY
   ;----When you are at 'Leah's Checkpoint in town'------
   If $halls = "True" Or $sarkoth = "True" Then
	  $findleah = PixelSearch( 700, 300, 1170, 530, 0xAC3240, 2)
	  If @error = 0 Then
		 Send("i")
		 Sleep(250)
		 $fullinv = PixelSearch( 1754, 784, 1890, 867, 0x112139, 3)
			If @error = 0 Then ;Inv must be near full
			   Send("i")
			   Sleep(250)
			   Repair_Sell()
			Else
			   Send("i")
			   $armorbroken = PixelSearch(1492,15,1533,33, 0xFFCB00, 5, 1)
			   If @error = 0 Then
				  MouseMove($armorbroken[0], $armorbroken[1])
				  Sleep(250)
				  Repair_Sell()
			   EndIf
			EndIf
	  ;-----------------------------------------------------
	  Else
	  ;-----------When you are at right of waypoint---------
		 $waypoint = PixelSearch( 200, 200, 750, 550, 0x74A8F4, 10)
		 If @error = 1 Then
			Send("i")
			Sleep(250)
			$fullinv = PixelSearch( 1754, 784, 1890, 867, 0x112139, 3)
			   If @error = 0 Then ;Inv must be near full
				  Send("i")
				  Sleep(250)
				  PortCheck()
				  Sleep(500)
				  MouseClick("primary",1424,207,1)
				  Sleep(2200)
				  Repair_Sell()
			   Else
				  Send("i")
				  $armorbroken = PixelSearch(1492,15,1533,33, 0xFFCB00, 5, 1)
				  If @error = 0 Then
					 MouseMove($armorbroken[0], $armorbroken[1])
					 Sleep(250)
					 PortCheck()
					 Sleep(500)
					 MouseClick("primary",1424,207,1)
					 Sleep(2200)
					 Repair_Sell()
				  EndIf
			   EndIf
		 Else ;(found waypoint)
			$checktown = PixelSearch( 800, 550, 1200, 800, 0x725929, 2)
			If @error = 0 Then
			   Send("i")
			   Sleep(500)
			   $fullinv = PixelSearch( 1754, 784, 1890, 867, 0x112139, 3)
				  If @error = 0 Then ;Inv must be near full
					 Send("i")
					 Sleep(250)
					 MouseClick("primary", 595, 0,1)
					 Sleep(2200)
					 Repair_Sell()
				  Else
					 Send("i")
					 $armorbroken = PixelSearch(1492,15,1533,33, 0xFFCB00, 5, 1)
					 If @error = 0 Then
						MouseMove($armorbroken[0], $armorbroken[1])
						Sleep(250)
						MouseClick("primary", 595, 0,1)
						Sleep(2200)
						Repair_Sell()
					 EndIf
				  EndIf
			Else
			   Send("i")
			   Sleep(250)
			   $fullinv = PixelSearch( 1754, 784, 1890, 867, 0x112139, 3)
				  If @error = 0 Then ;Inv must be near full
					 Send("i")
					 Sleep(250)
					 PortCheck()
					 Sleep(500)
					 Repair_Sell()
					 MouseClick("primary",1424,207,1)
					 Sleep(2200)
				  Else
					 Send("i")
					 $armorbroken = PixelSearch(1492,15,1533,33, 0xFFCB00, 5, 1)
					 If @error = 0 Then
						MouseMove($armorbroken[0], $armorbroken[1])
						Sleep(250)
						PortCheck()
						Sleep(500)
						Repair_Sell()
						MouseClick("primary",1424,207,1)
						Sleep(2200)
					 EndIf
				  EndIf
			EndIf
		 EndIf
	  ;------------------------------------------------------------------
	  EndIf
   EndIf
   ;------------------------------------------------------------------
   If $halls = "True" Then
	  MouseMove(470,215)
	  MouseClickDrag("primary",470,215,470,815,25)
	  MouseClick("primary",257,824,1)
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("Initiating the Pathing sequence!", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  Sleep(3000)
	  Run("bosses/halls.exe")
	  Sleep(1000)
   EndIf
   $atcem = PixelSearch(0, 0, 200, 150, 0x4A88DC, 3, 1)
	  If @error <> 1 Then
		 PortCheck()
		 Sleep(1000)
		 MouseClick("primary",1578,698,1)
		 Sleep(2000)
		 MouseClick("primary",284,295,1)
		 Sleep(500)
		 Send("4")
		 Sleep(1700)
		 MouseClick("primary",109,86,1)
		 Sleep(4500)
		 MouseClick("primary",455,247,1)
		 Sleep(4000)
		 $findblight = PixelSearch( 1180, 74, 1380, 235, 0x4EAFE8,7)
		 If @error = 1 Then
			EndGameF("skcp")
		 EndIf
		 Sleep(1000)
		 Sarkoth()
		 Sleep(1000)
		 $locchg = 1
	  EndIf
   $findblight = PixelSearch( 1180, 74, 1380, 235, 0x4EAFE8,9)
   If $sarkoth = "True" And @error = 1 Then
	  Sleep(2000)
	  ;------------------------------------------------------------------
	  ;Show tooltip with bot progression through the script
	  ToolTip("Heading to The Old Ruins!", 960, 20,"Bot Progress",0,2)
	  ;------------------------------------------------------------------
	  MouseClick("primary",525,353,1)
	  Sleep(1500)
	  MouseClick("primary",284,295,1)
	  Sleep(2000)
	  Send("4")
	  Sleep(200)
	  MouseClick("primary",109,86,1)
	  Sleep(4500)
	  MouseClick("primary",455,247,1)
	  Sleep(4000)
	  $findblight = PixelSearch( 1180, 74, 1380, 235, 0x4EAFE8,7)
	  If @error = 1 Then
		 EndGameF("skcp")
	  EndIf
	  Sleep(1000)
	  Sarkoth()
	  Sleep(1000)
   ElseIf $sarkoth = "True" Then
	  Sleep(1000)
	  Sarkoth()
	  Sleep(1000)
   EndIf
EndFunc