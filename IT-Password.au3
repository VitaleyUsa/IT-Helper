;~ #AutoIt3Wrapper_UseUPX=n
;~ #pragma compile(UPX, False)

#Region ### START Koda GUI section ### Form=
Opt("TrayMenuMode", 3)
$Form_pass = GUICreate("Form_pass", 298, 120, -1, -1, BitOR($WS_SYSMENU,$WS_POPUP, $WS_Border))
GUISetBkColor(0xFFFFFF)
	$Pic = GUICtrlCreatePic("", 190, 0, 100, 33)
	$hInstance = _WinAPI_GetModuleHandle(0)
	$hBitmap = _WinAPI_LoadBitmap($hInstance, 200)
	_SetHImage($Pic, $hBitmap)
	_WinAPI_DeleteObject($hBitmap)
GUICtrlSetState(-1, $GUI_DISABLE)

$Input_pass = GUICtrlCreateInput("", 8, 32, 281, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$check_show_pass = GUICtrlCreateCheckbox("Отображать пароль", 8, 56, 145, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$but_continue = GUICtrlCreateButton("Продолжить", 152, 88, 139, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xf85252)
$but_cancel = GUICtrlCreateButton("Отмена", 8, 88, 139, 25)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xf85252)
$label_input_pass = GUICtrlCreateLabel("Введите пароль", 8, 8, 100, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

Local $idExit = TrayCreateItem("Выйти")
TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Local $sPass = "BFFE59BE546EBAF58E67D2C504D06925F5368F3F916F7FEDD23C8AD87F68A0BAF54D948671CC04F8451452505EC8AB558A172824128CB8880553D16857DE9BFC54DFFC4A76B252BCFB96AC114B0BFB55C31CC0E190A155B25CE39BB11F746C39D2050627C6EE6A2D8ED6C6B1A2D006A2393B5E081C44118765CFEA5DDE0FA7D1B69D457420979985892CA9D67DEFFDF0A5650008741B369BF02D7386B43658F49F2B38EA99D926CC027F7FAD639B43C259B8EFE19772FBB395A659A7BFEE77FC"
Local $sPassCerts = "BFFE59BE546EBAF58E67D2C504D06925F5368F3F916F7FEDD23C8AD87F68A0BAF54D948671CC04F8451452505EC8AB558A172824128CB8880553D16857DE9BFC54DFFC4A76B252BCFB96AC114B0BFB55C31CC0E190A155B25CE39BB11F746C39D2050627C6EE6A2D8ED6C6B1A2D006A2393B5E081C44118765CFEA5DDE0FA7D1B69D457420979985892CA9D67DEFFDF0A5650008741B369BF02D7386B43658F49F2B38EA99D926CC027F7FAD639B43C259B8EFE19772FBB395A659A7BFEE77FC09D0CAEFE3E1EECFAB95485F0F577360AA0D13B672ED5B823852F394E078DE36F02FA45A9ABC52354A0AD282C1B12867C8C90284ED96A20D1BCDF599C78AEB75"
Local $DefaultPassChar = GUICtrlSendMsg($Input_pass, $EM_GETPASSWORDCHAR, 0, 0)
Local $i = 0
Local $err_count = 4 ; Количество неправильных попыток ввода пароля

While 1
	; Автозапуск установки сертификатов
	If $CmdLine[0] > 0 Then
		If $CmdLine[1] = "IDDQD" Then
			TrayItemDelete($idExit)
			GUIDelete($Form_pass)
			$sPass = $sPassCerts
			$Start_param_certs = 1
			ExitLoop
		EndIf
	EndIf

	If $i == $err_count Then
		DirRemove($dir_ecp, 1)
		DirRemove($dir_express, 1)
		DirRemove($dir_federal, 1)
		DirRemove($dir_software, 1)
		DirRemove($dir_certs, 1)
		DirRemove($dir_update, 1)
		DirRemove($dir_logs, 1)
		Exit
	EndIf
    $nMsg = GUIGetMsg()

	If $sPass = _RegSettings("Read") Then ; Реестровые настройки
		TrayItemDelete($idExit)
		GUIDelete($Form_pass)
		ExitLoop
	EndIf

	If _IsPressed("11") And _IsPressed("12") And _IsPressed("6B") Then ; Комбинация заветная
		TrayItemDelete($idExit)
		GUIDelete($Form_pass)
		ExitLoop
	EndIf

    Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($Form_pass)
            Exit

		Case $but_cancel
			GUIDelete($Form_pass)
			Exit

		Case $but_continue
			$i += 1
			$sPass_tmp = GUICtrlRead($Input_pass)
			$sPass_tmp = _StringEncrypt(1, $sPass_tmp, "Нотариальный помощник", 5)
			If $sPass_tmp = $sPass Then
				TrayItemDelete($idExit)
				GUIDelete($Form_pass)
				ExitLoop
			ElseIf $sPass_tmp = $sPassCerts Then
				TrayItemDelete($idExit)
				GUIDelete($Form_pass)
				$sPass = $sPassCerts
				$Start_param_certs = 1
				ExitLoop
			Else

				Switch $i
					Case 3
						$try_count = " попытка"
					Case 4
						$try_count = " попыток"
					Case Else
						$try_count = " попытки"
				EndSwitch

				$hErr = MsgBox(0,"Неверный пароль", "Вы неверно ввели пароль. У вас осталось " & $err_count - $i & $try_count)
				WinActivate($hErr)
			EndIf

        Case $check_show_pass
            If (GUICtrlRead($check_show_pass) = $GUI_CHECKED) Then
                GUICtrlSendMsg($Input_pass, $EM_SETPASSWORDCHAR, 0, 0)
            Else
                GUICtrlSendMsg($Input_pass, $EM_SETPASSWORDCHAR, $DefaultPassChar, 0)
            EndIf
            GUICtrlSetState($Input_pass, $GUI_FOCUS)
	EndSwitch

	Switch TrayGetMsg()
		Case $idExit ; выход
			Exit
	EndSwitch
WEnd