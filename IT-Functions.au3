;~ #AutoIt3Wrapper_UseUPX=n
;~ #pragma compile(UPX, False)

#include <File.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ListViewConstants.au3>
#include <Misc.au3>
#include <Crc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StringEncrypt.au3>

#include <ListboxConstants.au3>
#include <GuiListView.au3>
#include <GuiTab.au3>

; For password form
#Include <WinAPIEx.au3>
#Include <Icons.au3>

;#include <IE.au3>
;#include "INET.au3"
;#include <FTPEx.au3>
;#include <Array.au3>
;#include <ProgressConstants.au3>
;#include <Security.au3>

Dim $StatusBar1, $StatusBar2
Global $Start_param_certs = 0

; ---------------------------------------------------------------------------------------------------------- ;
; ----------------------------------------------- Variables ------------------------------------------------ ;
; ---------------------------------------------------------------------------------------------------------- ;

; Пути к рабочим директориям
Global $dir_distr = "C:\Distr\Notary\" ; Папка, где будем хранить дистрибутивы нотариальных программ

Global $dir_tools  = $dir_distr & "Tools\"
Global $dir_logs   = $dir_distr & "Logs\"
Global $dir_update = $dir_distr & "Update\"

Global $dir_ecp       = $dir_tools & "ecp\"
Global $dir_enot      = $dir_tools & "enot\"
Global $dir_express   = $dir_tools & "express\"
Global $dir_federal   = $dir_tools & "federal\"
Global $dir_software  = $dir_tools & "software\"
Global $dir_certs     = $dir_tools & "certs\"

Global $dir_ppdgr = $dir_federal & "ppdgr\"
Global $ds_ppdgr  = "Setup_PPDGR_full.exe" ; Архив с базой и дистром
Global $ds_extracted_ppdgr = "Setup_PPDGR.msi" ; Дистр после извлечения

; Откуда скачиваем дистрибутивы

Global $_netFramework40 = "dotNetFx40_Full_x86_x64.exe" ; NetFramework v4
Global $_netFramework47 = "NDP471-KB4033342-x86-x64-AllOS-ENU.exe" ; NetFramework v4.7
Global $_netFramework35 = "dotnetfx35.exe" ; NetFramework v3.5

Global $win7patch_x32 = "Windows6.1-KB4019990-x86.msu" ; Патч для 7ки для работы с ППДГР
Global $win7patch_x64 = "Windows6.1-KB4019990-x64.msu"


Global $Enot_ds = "http://download.triasoft.com/enot/50/Setup.exe" ; Расположение дистрибутива еНот

Global $MysqlSetup32 = "http://download.triasoft.com/enot/50/SetupDB.exe" ; Mysql 32bit
Global $MysqlSetup64 = "http://download.triasoft.com/enot/50/SetupDBx64.exe" ; Mysql 64bit

Global $Data = "http://download.triasoft.com/enot/50/Data.zip" ; Расположение БД еНот
Global $Data_tables = "http://download.triasoft.com/enot/50/Data_tables.zip" ; Расположение таблиц БД еНот

Global $xml_ds = "msxml6_x86.msi" ; MS XML for Express

; Файлы на нашей фтпшке

Global $Server = '217.24.185.53:8080'
Global $User = 'ftp-user'
Global $Pass = 'Ftp-User'

Global $sZip = "7za.exe" ; 7za
Global $wRar = "UnRAR.exe" ; UnRar for PPDGR
Global $wget = "wget.exe" ; "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" ; wget

Global $irfanview = "irfanview.zip" ; IrfanView
Global $certs_ds = "certs.zip" ; Сертификаты
Global $ieSetup = "internet_explorer.reg" ; Internet Explorer settings
Global $pkiSetup32 = "PKIClient_x32_5.1_SP1.msi" ; Etoken Pki Client x86bit
Global $pkiSetup64 = "PKIClient_x64_5.1_SP1.msi" ; Etoken Pki Client x64bit

Global $cspSetup = "CryptoProCSP.exe" ; CryptoPro CSP
Global $armSetup = "CryptoARM.zip" ; CryptoARM
Global $arm_settings = "arm_settings.reg" ; CryptoARM settings
Global $actxSetup = "cspcomsetup.msi" ; ActiveX Component + Firefox Plugin
Global $pdfSetup = "cppdfsetup.exe" ; CryptoPro PDF
Global $adobeSetup = "acrobate.exe" ; Adobe Reader DC
Global $cbpSetup = "cadesplugin.exe" ; CryptoPro Browser Plugin
Global $cades = "cades.reg" ; CryptoPro Trusted Sites
Global $gosSetup32 = "IFCPlugin.msi" ; Gosuslugi browser plugin x86bit
Global $gosSetup64 = "IFCPlugin-x64.msi" ; Gosuslugi browser plugin x64bit
Global $fedResurs = "FedresursDSPlugin.msi" ; Плагин для Федресурса http://se.fedresurs.ru/Helps/FedresursDSPlugin-1.13.0.0.msi
Global $cryptoFF = "ru.cryptopro.nmcades@cryptopro.ru.xpi" ; КриптоПро плагин для FF
Global $blitzFF = "pomekhchngaooffdadfjnghfkaeipoba@reaxoft.ru.xpi" ; Блитц плагин для FF
Global $crypto_reg = "crypto.reg" ; Файл настроек для ГОСТ 2001

;~ Global $java_update = "/Utils/Update-Java.exe"
;~ Global $java_settings = "/Utils/JavaSettings.exe"

Global $firefox = "Firefox.exe" ; Firefox ESR distr
Global $ff_sets = "ff-settings.zip" ; Firefox settings
Global $chrome_sets = "chrome-settings.zip" ; Chrome settings
Global $ie_links = "ie_links.zip" ; Internet Explorer links

Global $c_ds = "MicrosoftVisualC.exe" ; visual c++
Global $hasp_ds = "hasp.exe" ; hasp drivers
Global $scp_ds = "WinSCP.exe" ; WinSCP
Global $zip32_ds = "7z.msi" ; 7-zip
Global $zip64_ds = "7z_64.msi" ; 7-zip х64
Global $zip32_assoc	 = "7z.reg" ; Assoc for 7zip x32
Global $zip64_assoc	 = "7z_64.reg" ; Assoc for 7zip x64
Global $heidi_ds	 = "HeidiSQL.zip" ; HeidiSQL
Global $punto_ds = "PuntoSwitcher.zip" ; PuntoSwitcher with config
Global $access97_ds = "Microsoft_Access_97_SR2.zip" ; Microsoft Access 97 SR2
Global $win2pdf_ds = "WinScan2PDF.exe" ; Tool to scan 2 PDF
Global $cpuz32_ds = "cpuz_x32.exe" ; CPU _ Z для отчетов о системе
Global $cpuz64_ds = "cpuz_x64.exe"
Global $ipscanner_ds = "Advanced_IP_Scanner.exe"
Global $xmlpad_ds = "XmlNotepad.msi"

Global $LibReg = "LibReg.bat"
Global $ActiveTree = "ActiveTree.ocx"

Global $chromeSetup32 = "GoogleChromeStandaloneEnterprise.msi" ; Chrome x32 distr
Global $chromeSetup64 = "GoogleChromeStandaloneEnterprise64.msi" ; Chrome x64 distr

Global $tm_ds 		= "TeamViewerQS.exe" ; Teamviewer QS 9
Global $anydesk_ds  = "AnyDesk.exe" ; AnyDesk
Global $trueconf_ds = "TrueConf.zip" ; TrueConf
Global $mupdate_ds  = "mupdate.reg" ; Minus Windows 10 Update
Global $start_ds	= "Startisback.zip" ; Startisback for Win10
Global $line_ds		= "CryptoLine.msi" ; КриптоЛайн
Global $pwd_ds		= "pwdcrack.zip" ; PwdCrack
Global $produkey_ds = "ProduKey.exe" ; ProduKey
Global $share_ds 	= "net_share.bat" ; Network Share Parameters
Global $pass_ds  = "crypto_pass.bat" ; Получение сохраненных данных с ключа ЭП
Global $faststone_ds = "FSViewerSetup66.exe" ; Faststone image viewer

Global $sqlBackup_ds = "MysqlBackup.exe" ; утилита для бэкапа баз данных

; Системные

Global $_sleepforlink = 9000 ; Задеркжа для получения прямой ссылки с media-fire
Global $_sleepforwindow = 800 ; Сколько ждать окно (на случай ошибок)

; Автообновление
Global $HelperName = "АйТи помощник.lnk"
Global $MainApp = "IT-Helper.exe"
Global $VersionInfo = "version.ini"

; Создаем переменные статуса
Global  $HelperForm, $checkActx_Browser, $checkARM, $checkBD, _
		$checkIE, $checkCerts, $checkCSP, _
		$checkEnot, $checkFNS, $checkFNS_Print, _
		$checkPDF, $checkPKI, $checkIrfan, $checkFastStone, _
		$checkFF, $checkC, $checkNet_35, _
		$checkHASP, $checkChrome, $checkAdobe, $checkWinSet, $checkSCP, $checkZIP, _
		$checkTM, $checkAnyDesk, $checkTrueConf, $checkMUpdate, $checkSQLBACKUP, _
		$checkXML, $checkStart, $checkLine, $check_pwd, $check_heidi, $checkShare, _
		$checkProduKey, $checkPunto, $checkAccess, $checkWin2PDF, $checkECPPass, $checkSysInfo, _
		$checkIPScanner, $checkXMLPad, $AllCheckboxes, $btnDownloadOnly, $btnInstall, $menuHelp, _
		$sPass, $Download_only, $checkCleanUpdates, $checkLibReg

; ---------------------------------------------------------------------------------------------------------- ;
; ----------------------------------------------- Functions ------------------------------------------------ ;
; ---------------------------------------------------------------------------------------------------------- ;

If WinExists("[TITLE:АйТи помощник; CLASS:AutoIt v3 GUI]") Then
    WinActivate("[TITLE:АйТи помощник; CLASS:AutoIt v3 GUI]")
    Exit
EndIf

Func _install($dwnload_only = False)
	Global $Download_only = $dwnload_only
	_FileWriteLog($dir_logs & "Install.log",  " ===================================================")

	Enot() ; Енот
	Certificates() ; Сертификаты
	ESign() ; ЭЦП
	WinSetup() ; Настройки Windows
	FederalResources() ; Федеральные ресурсы
	Programs() ; Различный софт
	Express() ; Экспресс
	FNS()

	_FileWriteLog($dir_logs & "Install.log", " ===================================================" & @CRLF & @CRLF )

EndFunc   ;==>_install

; ----------------------------------------------- Enot FUNC;

Func Enot()
	If Checked($checkEnot) Then ; Дистрибутив Енота

		Status('Производится скачивание дистрибутива Енот')

		; Скачиваем дистрибутив
 		If SoftDownload($dir_enot, $Enot_ds, "wext") Then
			If Not WinExists("eNot") Then Run('explorer ' & $dir_enot) ; открыть папку с установочным файлом
		EndIf
	EndIf

	If Checked($checkBD) Then ; Скачиваем дистрибутив Mysql + БД ЕИС
		Status("Скачиваем базы данных Енот + Mysql - сервер")

		SoftDownload($dir_enot, $Data, "wext")
		SoftDownload($dir_enot, $Data_tables, "wext")

		Local $MysqlSetup = $MysqlSetup32
		If @OSArch = "X64" Then $MysqlSetup = $MysqlSetup64
		SoftDownload($dir_enot, $MysqlSetup, "wext")

		If Not WinExists("eNot") Then Run('explorer ' & $dir_enot) ; открыть папку с установочным файлом
	EndIf

	If Checked($checkLibReg) Then ; Регистрируем библиотеки
		Status("Идет регистрация библиотек ЕИС")

		Local $WinLib = @WindowsDir & "\system32" ; переменные для винды и реестра (х86 или х64)
		Local $WinReg = ""
		If @OSArch = "X64" Then 
			$WinLib = @WindowsDir & "\SysWow64"
			$WinReg = "WOW6432Node\"
		EndIf

		Local $sEnotPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\" & $WinReg & "Microsoft\Windows\CurrentVersion\Uninstall\eNot_is1", "Inno Setup: App Path")
		If $sEnotPath = "" Then $sEnotPath = "C:\Triasoft\eNot"

		
		If SoftDownload($dir_enot, $LibReg) Then ; скачиваем ActiveTree.ocx и скрипт для реги енотовских библиотек
			If SoftDownload($dir_enot, $ActiveTree) Then FileCopy($dir_enot & $ActiveTree, $WinLib & "\" & $ActiveTree, 1)

			_FileWriteToLine($dir_enot & $LibReg, 2, "set WinLibDir=" & $WinLib, 1) ; добавляем пути окружения в скрипт
			_FileWriteToLine($dir_enot & $LibReg, 3, "set eNotPath=" & $sEnotPath, 1)

			ShellExecuteWait($dir_enot & $LibReg, "", "", "")
		EndIf
	EndIf
EndFunc   ;==>Enot

; ----------------------------------------------- CERTS FUNC;

Func Certificates()
	If Checked($checkCerts) Then
		Status("Установка сертификатов")

		If SoftDownload($dir_tools, $certs_ds) Then ; Скачиваем новые, распаковываем и устанавливаем
			DirRemove($dir_certs, 1) ; удаляем старые сертификаты
			SoftUnzip($dir_tools, $certs_ds)
			FileDelete($certs_ds)
			ShellExecuteWait($dir_certs & "install.bat", "", $dir_certs) ; Устанавливаем сертификаты
		EndIf
	EndIf
EndFunc   ;==>Certificates

; ----------------------------------------------- ECP FUNC;

Func ESign()
	If Checked($checkPKI) Then
		Status("Установка etoken pki client")

		Local $pkiSetup = $pkiSetup32
		If @OSArch = "X64" Then $pkiSetup = $pkiSetup64

		If SoftDownload($dir_ecp, $pkiSetup) Then SoftInstall($dir_ecp, $pkiSetup, "ET_LANG_NAME=Russian /norestart /qb")
		; ('msiexec /i "' & $dir_tools & 'ecp\PKIClient_x64_5.1_SP1.msi" ET_LANG_NAME=Russian /norestart /qb-')
	EndIf

	If Checked($checkCSP) Then
		Status("Установка CryptoPro CSP")

		If SoftDownload($dir_ecp, $cspSetup) Then SoftInstall($dir_ecp, $cspSetup, "-gm2 -lang rus -kc kc1 -silent -noreboot -nodlg -args ""/qb /L*v " & $dir_logs & $cspSetup & ".log""" )

		Status("Настройка КриптоПро для работы с ГОСТ 2001")

		If SoftDownload($dir_ecp, $crypto_reg) Then ; Гост 2011
			Local $hCryptoImport = FileOpen($dir_ecp & "crypto_import.reg", 2)

			Local $hCryptoSites = FileOpen($dir_ecp & $crypto_reg, 0)
			Local $sCryptoRead = FileRead($hCryptoSites)
			FileClose($hCryptoSites)

			FileWrite($hCryptoImport, "Windows Registry Editor Version 5.00")
			Switch @OSArch ; Проверяем разрядность ОС
				Case "X64"
					FileWrite($hCryptoImport, @CRLF & "[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Crypto Pro\Cryptography\CurrentVersion\Parameters]")
	 			Case "X86"
	 				FileWrite($hCryptoImport, @CRLF & "[HKEY_LOCAL_MACHINE\SOFTWARE\Crypto Pro\Cryptography\CurrentVersion\Parameters]")
			EndSwitch

			FileWrite($hCryptoImport, @CRLF & $sCryptoRead)
			FileClose($hCryptoImport)
			RunWait("reg.exe IMPORT " & $dir_ecp & "crypto_import.reg")
		EndIf
	EndIf

EndFunc   ;==>ESign


; ----------------------------------------------- Windows Settings Func;

Func WinSetup()
	If Checked($checkWinSet) Then ; Настройка Windows
		; Открываем порт для mysql
		Local $CMD = "netsh advfirewall firewall add rule name=MySQL dir=in action=allow protocol=TCP localport=3306"
		RunWait(@ComSpec & " /c " & $CMD)

		; Включаем схему электропитания на быстродействие
		$CMD = "powercfg -SETACTIVE SCHEME_MIN"
		RunWait(@ComSpec & " /c " & $CMD)

		; Отключаем выключение usb при простое
		$CMD = "powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0"
		RunWait(@ComSpec & " /c " & $CMD)

		; Отключаем выключение hdd при простое
		$CMD = "powercfg /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0"
		RunWait(@ComSpec & " /c " & $CMD)

		; Включаем показ расширений
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", "REG_DWORD", "0")
	EndIf

	If Checked($checkMUpdate) Then ; Отключение обновлений win10
		RunWait(@ComSpec & " /c " & "sc config wuauserv start=disabled & sc stop wuauserv & sc config bits start=disabled & sc stop bits & sc config dosvc start=disabled & sc stop dosvc") ; отключаем службы обновления

		DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1) ; перенаправление отключаем
		RunWait(@ComSpec & " /c " & 'TAKEOWN /F ' & @WindowsDir & '\System32\UsoClient.exe /a') ; даем себе права на файл автосканирования центра обновлений windows
		RunWait(@ComSpec & " /c " & 'icacls ' & @WindowsDir & "\System32\UsoClient.exe /inheritance:r /remove ''Администраторы'' ''Прошедшие проверку'' ''Пользователи'' ''Система''") ; забираем права у всех (чтобы не производителось сканирование на наличии обновлений

		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR", "AppCaptureEnabled", "REG_DWORD", "0")
		RegWrite("HKEY_CURRENT_USER\System\GameConfigStore", "GameDVR_Enabled", "REG_DWORD", "0")

		RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\UpdateOrchestrator") ; отключаем задачи обновления
		RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\WindowsUpdate")
	EndIf

	; ProduKey
	If Checked($checkProduKey) Then
		Status("Запуск ProduKey")

		If SoftDownload($dir_software, $produkey_ds) Then
			FileChangeDir($dir_software)
				RunWait($produkey_ds & " /stext ProduKey.txt")
			FileChangeDir($dir_distr)

			Local $HKLM = "HKLM\"
			If @OSArch = "X64" Then $HKLM = "HKLM64\"

			$hFile = FileOpen($dir_software & "ProduKey.txt", 1) ; Добавляем лицензии от криптопро, криптоарм

				Local $sCrypto36 = RegRead($HKLM & "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\05480A45343B0B0429E4860F13549069\InstallProperties", "ProductID")
				If Not $sCrypto36 Then $sCrypto36 = "Не установлен"
				FileWriteLine($hFile, "КриптоПро 3.6 = " & $sCrypto36)

				Local $sCrypto39 = RegRead($HKLM & "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\68A52D936E5ACF24C9F8FE4A1C830BC8\InstallProperties", "ProductID")
				If Not $sCrypto39 Then $sCrypto39 = "Не установлен"
				FileWriteLine($hFile, "КриптоПро 3.9 = " & $sCrypto39)

				Local $sCrypto40 = RegRead($HKLM & "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\7AB5E7046046FB044ACD63458B5F481C\InstallProperties", "ProductID")
				If Not $sCrypto40 Then $sCrypto40 = "Не установлен"
				FileWriteLine($hFile, "КриптоПро 4.0 = " & $sCrypto40)

				Local $sCryptoArm = RegRead($HKLM & "SOFTWARE\WOW6432Node\Digt\Trusted Desktop\License", "SerialNumber")
				If Not $sCryptoArm Then $sCryptoArm = "Не установлен"
				FileWriteLine($hFile, "КриптоАрм = " & $sCryptoArm)

			FileClose($hFile)

			Run("notepad.exe " &  $dir_software & "ProduKey.txt")
		EndIf
	EndIf

	; Network Share
	If Checked($checkShare) Then
		Status("Настройка общего доступа, подождите")

		If SoftDownload($dir_software, $share_ds) Then
			Local $cmdPath = Chr(34) & $dir_software & $share_ds & Chr(34)
			RunWait(@ComSpec & " /c " & $cmdPath, "")
		EndIf
	EndIf

	; Пароль от ЭЦП
	If Checked($checkECPPass) Then
		Status("Получение пароля от ЭП")

		If SoftDownload($dir_software, $pass_ds) Then
			Local $cmdPath = 'cd ' & $dir_software & " && " & $dir_software & $pass_ds
			RunWait(@ComSpec & " /c " & $cmdPath, "")
			Run($dir_tools & "software\CryptoPass.txt")
			If @error Then MsgBox("","Ошибка","Сохраненных ключей не найдено")
		EndIf
	EndIf

	; Отчет о системе
	If Checked($checkSysInfo) Then
		Status("Формирование отчета о системе")

		Local $cpuz = $cpuz32_ds
		If @OSArch = "X64" Then $cpuz = $cpuz64_ds

		If SoftDownload($dir_software, $cpuz) Then
			FileDelete($dir_logs & $cpuz & ".htm")
			SoftInstall($dir_software, $cpuz, "-html=" & $dir_logs & $cpuz)
			ShellExecute($dir_logs & $cpuz & ".htm")
		EndIf
	EndIf

EndFunc   ;==>WinSetup

; ----------------------------------------------- FEDERAL FUNC;

Func FederalResources()
	; ActiveX + Browser Plugins
	If Checked($checkActx_Browser) Then
		; ActiveX
		Status("Удаление старых компонентов ActiveX")

		$sName = "ЕФРСБ - компонент подписи ЭЦП"
		$oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & @ComputerName & "\root\cimv2")
		$aProducts = $oWMI.ExecQuery("Select * from Win32_Product Where Name LIKE '%" & $sName & "%'")

		For $app in $aProducts
			$app.Uninstall()
		Next

		If FileExists("C:\Program Files\Firefox ActiveX Plugin\") Then RunWait(" ""C:\Program Files\Firefox ActiveX Plugin\unins000.exe"" /SILENT")
		If FileExists("C:\Program Files (x86)\Firefox ActiveX Plugin\") Then RunWait(" ""C:\Program Files (x86)\Firefox ActiveX Plugin\unins000.exe"" /SILENT")

		Status("Установка и настройка CryptoPRO и Blitz для Google Chrome")

		; Расширение CryptoPro и Blitz
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist", "1", "REG_SZ", "iifchhfnnmpdbibifmljnfjhpififfog;https://clients2.google.com/service/update2/crx")
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist", "2", "REG_SZ", "pomekhchngaooffdadfjnghfkaeipoba;https://clients2.google.com/service/update2/crx")
			RunWait(@ComSpec & " /c " & "gpupdate /force", "", @SW_HIDE) ; Применяем политику

		; Browser Plugins
		Status("Установка и настройка CryptoPro Browser plugin")

			; Криптопро Браузер Плагин
			If SoftDownload($dir_federal, $cbpSetup) Then
				SoftInstall($dir_federal, $cbpSetup, "cades")

				; Настраиваем доверенные сайты для криптопро браузер плагина
				If SoftDownload($dir_federal, $cades) Then
					Local $hCadesImport = FileOpen($dir_federal & "cades_import.reg", 2)
					Local $hCadesSites = FileOpen($dir_federal & $cades, 0)
					Local $sCadesRead = FileRead($hCadesSites)
					FileClose($hCadesSites)

					FileWrite($hCadesImport, "Windows Registry Editor Version 5.00")
					FileWrite($hCadesImport, @CRLF & "[HKEY_USERS\" & _GetCurrentUserSID() & "\SOFTWARE\Crypto Pro\CAdESplugin]")
					FileWrite($hCadesImport, @CRLF & $sCadesRead)
					FileClose($hCadesImport)
					RunWait("reg.exe IMPORT " & $dir_federal & "cades_import.reg") ; Настройка доверенных сайтов для КриптоПро
				EndIf
				; /= > Доверенные сайты
			EndIf

		; Плагин для Госуслуг
		Status("Установка и настройка плагина для Госуслуг")

			Local $gosSetup = $gosSetup32
			If @OSArch = "X64" Then $gosSetup = $gosSetup64
			If SoftDownload($dir_federal, $gosSetup) Then SoftInstall($dir_federal, $gosSetup, "msi")

		; Федресурс плагин
		Status("Установка и настройка плагина для Федресурса")

			If SoftDownload($dir_federal, $fedResurs) Then SoftInstall($dir_federal, $fedResurs, "msi")
	EndIf

	; CryptoArm
	If Checked($checkARM) Then
		Status("Установка и настройка CryptoARM")

		If SoftDownload($dir_federal, $armSetup) Then ; Закачка и установка КриптоАРМ
			If SoftUnzip($dir_federal, $armSetup) Then SoftInstall($dir_federal & "CryptoARM", "setup.exe", "arm")
		EndIf

		If SoftDownload($dir_federal, $arm_settings) Then RunWait("reg.exe IMPORT " & $dir_federal & $arm_settings) ; Настройка КриптоАРМ
	EndIf

	; Adobe Reader DC
	If Checked($checkAdobe) Then
		Status("Установка и настройка Adobe Reader DC")

		If SoftDownload($dir_software, $adobeSetup) Then SoftInstall($dir_software, $adobeSetup, "/sALL")
	EndIf

	; CryptoPro PDF
	If Checked($checkPDF) Then
		Status("Установка и настройка CryptoPro PDF")

		If SoftDownload($dir_federal, $pdfSetup) Then SoftInstall($dir_federal, $pdfSetup, "pdf")
	EndIf

		; КриптоЛайн
	If Checked($checkLine) Then
		Status("Установка и настройка КриптоЛайн")

		If SoftDownload($dir_federal, $line_ds) Then SoftInstall($dir_federal, $line_ds, "msi")
	EndIf

	; Internet Explorer settings
	If Checked($checkIE) Then
		Status("Настройка Internet Explorer")

		If SoftDownload($dir_federal, $ieSetup) Then RunWait("reg.exe IMPORT " & $dir_federal & $ieSetup) ; Настройка IE
		If SoftDownload($dir_federal, $ie_links) Then SoftUnzip($dir_federal, $ie_links, @UserProfileDir & '\favorites\links\') ; Избранное для ИЕ
	EndIf


	; Firefox ESR
	If Checked($checkFF) Then
		Status("Установка и настройка Mozilla Firefox")

		If SoftDownload($dir_federal, $firefox) Then ; Скачиваем FF
			ProcessClose("firefox.exe")
			Sleep(1000)

			; Удаляем предыдущие копии с Firefox
			$CMD = "cd ""C:\Program Files\"" && ren ""Mozilla Firefox"" Firefox && rmdir Firefox /s /q"
			RunWait('"' & @ComSpec & '" /c ' & $CMD)

			$CMD = "cd ""C:\Program Files (x86)\"" && ren ""Mozilla Firefox"" Firefox && rmdir Firefox /s /q"
			RunWait('"' & @ComSpec & '" /c ' & $CMD)

			SoftInstall($dir_federal, $firefox, "-ms")

			Local $FFPath = "C:\Program Files (x86)\Mozilla Firefox\"
			If FileExists("C:\Program Files\Mozilla Firefox") Then $FFPath = "C:\Program Files\Mozilla Firefox\"

			Local $java_comp = 'user_pref("plugin.state.java", 2);'
			Local $npcades_comp = @CRLF & 'user_pref("plugin.state.npcades", 2);'
			Local $npffax_comp = @CRLF & 'user_pref("plugin.state.npffax", 2);'
			Local $npif_comp = @CRLF & 'user_pref("plugin.state.npifcplugin", 2);'
			Local $ff_components = $java_comp & $npcades_comp & $npffax_comp & $npif_comp

			Local $path = @AppDataDir & '\Mozilla\Firefox\Profiles\'
			Local $path_ext = @AppDataDir & '\Mozilla\Extensions\'


			; Удаления старого профиля
			Local $randomStr = ""
			Local $aSpace[3]
			Local $digits = 4
			For $i = 1 To $digits
				$aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
				$aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
				$aSpace[2] = Chr(Random(48, 57, 1)) ;0-9
				$randomStr &= $aSpace[Random(0, 2, 1)]
			Next

			DirMove($path, @AppDataDir & '\Mozilla\Firefox\Profiles.' & $randomStr & '.backup') ; резервная копия

			; Создаем профиль FF
			Local $handle_search = FileFindFirstFile($path & '*.default')
			If $handle_search = -1 Then RunWait($FFPath & "firefox.exe -CreateProfile default")

			; Отключаем автообновление

			Local $ff_updates = FileOpen($FFPath & "defaults\pref\channel-prefs.js", 2)

			FileWrite($ff_updates, "pref(""app.update.channel"", ""no"");")
			FileClose($ff_updates)

			Run("sc delete MozillaMaintenance") ; отключаем службу обновления

			; Настраивем FF

			$handle_search = FileFindFirstFile($path & '*.default')
			$folder = FileFindNextFile($handle_search)
			FileClose($handle_search)

			If Not @error Then
				Local $ff_profile_path = $path & $folder ; %appdata%\Roaming\Mozilla\Firefox\Profiles\*.default
				Local $FFPlugins = $ff_profile_path & '\prefs.js'
				Local $file = FileOpen($FFPlugins, 2)
				If @error = -1 Then
					MsgBox(0, "Error", "Не найден prefs.js, настройки для FF не установлены")
				Else
					; Включаем activex + java компоненты
					FileWrite($file, $ff_components)
				EndIf
				FileClose($file)
			EndIf

			DirCreate($ff_profile_path & "\extensions") ; создаем папку с расширениями в профиле
		EndIf

		; Закачка и CryptoPro extension для FF
		If SoftDownload($dir_federal, $cryptoFF) Then FileCopy($dir_federal & $cryptoFF, $ff_profile_path & "\extensions\" & $cryptoFF, 1) ; Расширение КриптоПро
		;RegWrite("HKEY_CURRENT_USER\SOFTWARE\Mozilla\Firefox\extensions", "ru.cryptopro.nmcades@cryptopro.ru", "REG_SZ", $path_ext & "ru.cryptopro.nmcades@cryptopro.ru.xpi")

		; Закачка и установка blitz extension для FF
		If SoftDownload($dir_federal, $blitzFF) Then FileCopy($dir_federal & $blitzFF, $ff_profile_path & "\extensions\" & $blitzFF, 1) ; Расширение blitz smart card for FF

		If SoftDownload($dir_federal & "ff-settings\", $ff_sets) Then ; Скачиваем настройки для FF
			FileDelete($dir_federal & "ff-settings\places.sqlite") ; Удаляем старое избранное
			FileDelete($dir_federal & "ff-settings\xulstore.json") ; и настройки браузера
			FileDelete($dir_federal & "ff-settings\prefs.js") ;
			FileDelete($dir_federal & "ff-settings\extensions.json") ; настройки расширений

			If SoftUnzip($dir_federal & "ff-settings\", $ff_sets, $dir_federal & "ff-settings\") Then ; Извлекаем настройки firefox
				FileCopy($dir_federal & "ff-settings\places.sqlite", $ff_profile_path & "\places.sqlite", 1) ; Закладки (ЕИС 2.0)
				FileCopy($dir_federal & "ff-settings\xulstore.json", $ff_profile_path & "\xulstore.json", 1) ; Видимость панели закладок
				FileCopy($dir_federal & "ff-settings\prefs.js", $ff_profile_path & "\prefs.js", 1) ; общие настройки
				FileCopy($dir_federal & "ff-settings\extensions.json", $ff_profile_path & "\extensions.json", 1) ; расширения (включаем)
			EndIf
		EndIf
	EndIf

	If Checked($checkChrome) Then
		Status("Установка и настройка Google Chrome")

		Local $chromeSetup = $chromeSetup32
		Local $Registry64 = ""
		ProcessClose("chrome.exe") ; закрываем Chrome
		If @OSArch = "X64" Then 
			$chromeSetup = $chromeSetup64 ; Определяем разрядность Хрома
			$Registry64 = "Wow6432Node\"
		EndIf

		If SoftDownload($dir_federal, $chromeSetup) Then
			RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\" $ $Registry64 $ "google\update") ; исключаем ошибки от предыдущих установок

			SoftInstall($dir_federal, $chromeSetup, "msi") ; Скачиваем и устанавливаем хром

			; Расширение CryptoPro и Blitz
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist", "1", "REG_SZ", "iifchhfnnmpdbibifmljnfjhpififfog;https://clients2.google.com/service/update2/crx")
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist", "2", "REG_SZ", "pomekhchngaooffdadfjnghfkaeipoba;https://clients2.google.com/service/update2/crx")
			RunWait(@ComSpec & " /c " & "gpupdate /force", "", @SW_HIDE) ; Применяем политику
		EndIf

		If SoftDownload($dir_federal, $chrome_sets) Then  ; скачиваем новые настройки
			FileMove(@LocalAppDataDir & "\Google\Chrome\User Data\Default\Preferences", @LocalAppDataDir & "\Google\Chrome\User Data\Default\Preferences.backup", 8) ; Удаляем старые настройки
			FileMove(@LocalAppDataDir & "\Google\Chrome\User Data\Default\Bookmarks", @LocalAppDataDir & "\Google\Chrome\User Data\Default\Boomarks.backup", 8) ; Удаляем старые закладки

			SoftUnzip($dir_federal, $chrome_sets, @LocalAppDataDir & """\Google\Chrome\User Data\Default\""")
		EndIf

	EndIf

;~ 	; Java
;~ 	If Checked($checkJAVA) Then
;~ 		; Установка и обновление Java
;~ 		Status("Java")

;~ 		_JavaUpdate()


;~ 		; Настройка Java
;~ 		Status("Настройка Java")
;~ 		If SoftDownload($dir_federal, $java_settings) Then SoftInstall($dir_federal, $java_settings)
;~ 	EndIf
EndFunc   ;==>FederalResources

; ----------------------------------------------- SOFTWARE FUNC;

Func Programs()
	; IrfanView
	If Checked($checkIrfan) Then
		Status("Установка и настройка IrfanView")

		If DirGetSize($dir_software & "irfanview") = -1 Then
			If SoftDownload($dir_software, $irfanview) Then
				SoftUnzip($dir_software, $irfanview)
				FileCreateShortcut($dir_software & 'irfanview\i_view32.exe', @DesktopDir & "\IrfanView.lnk", $dir_software & "irfanview")
				_UpdateScreen()
			EndIf
		EndIf
	EndIf

	; FastStone Image viewer
	If Checked($checkFastStone) Then
		Status("Установка и настройка FastStone Image Viewer")

		If SoftDownload($dir_software, $faststone_ds) Then SoftInstall($dir_software, $faststone_ds, "/S")
	EndIf

	; TeamViewer QS 9
	If Checked($checkTM) Then
		Status("Установка и настройка Teamviewer QS 9")

		If SoftDownload($dir_software, $tm_ds) Then
	 		FileCreateShortcut($dir_software & $tm_ds, @DesktopDir & "\TeamViewer.lnk", $dir_software)
	 		_UpdateScreen()

			SoftInstall($dir_software, $tm_ds, "run", "0") ; Запускаем ТМ
		EndIf
	EndIf

	; AnyDesk
	If Checked($checkAnyDesk) Then
		Status("Установка и настройка AnyDesk")

		If SoftDownload($dir_software, $anydesk_ds) Then SoftInstall($dir_software, $anydesk_ds, "run", "0") ; Запускаем AnyDesk
	EndIf

	; Trueconf
	If Checked($checkTrueConf) Then
		Status("Установка и настройка TrueConf")

		If SoftDownload($dir_software, $trueconf_ds) Then
			DirCreate($dir_software & "TrueConf") ; создаем папку для труконфа

			SoftUnzip($dir_software, $trueconf_ds, $dir_software & "TrueConf\") ; Извлекаем труконф
			SoftInstall($dir_software & "TrueConf\", "Setup.exe", "/Silent /NoReboot") ; устанавливаем

			ProcessClose("trueconf.exe") ; Закрываем труконф
			RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "TrueConf Client") ; Удаляем из автозагрузки
		EndIf
	EndIf

	; Startisback
	If Checked($checkStart) Then
		Status("Установка и настройка StartIsBack для Windows 10")

		If SoftDownload($dir_software, $start_ds) Then
			DirCreate($dir_software & "StartIsBack") ; создаем папку для Startisback

			SoftUnzip($dir_software, $start_ds, $dir_software & "StartIsBack\")
			SoftInstall($dir_software, "StartIsBack\Install.cmd", "run")
		EndIf
	EndIf

	; MySql Backup
	If Checked($checkSQLBACKUP) Then
		Status("Закачка и запуск MySQL Backup")

		If SoftDownload($dir_software, $sqlBackup_ds) Then SoftInstall($dir_software, $sqlBackup_ds, "run", 0)
	EndIf

	; PwdCrack
	If Checked($check_pwd) Then
		Status("Запуск pwdCrack")

		If SoftDownload($dir_software, $pwd_ds) Then
			SoftUnzip($dir_software, $pwd_ds)
			SoftInstall($dir_software & "pwdcrack\", "pwdcrack.exe", "run", 0)
		EndIf
	EndIf

	; HeidiSQL
	If Checked($check_heidi) Then
		Status("Запуск HeidiSQL")

		If SoftDownload($dir_software, $heidi_ds) Then
			SoftUnzip($dir_software, $heidi_ds)
			SoftInstall($dir_software, "HeidiSQL\heidisql.exe", "run", 0)
		EndIf
	EndIf

	; WinSCP FTP prog
	If Checked($checkSCP) Then
		Status("Установка и настройка WinSCP")

		If SoftDownload($dir_software, $scp_ds) Then SoftInstall($dir_software, $scp_ds, "/SILENT")
	EndIf

	; 7-Zip
	If Checked($checkZIP) Then
		Status("Установка и настройка 7-Zip")

		Local $zip_ds = $zip32_ds
		Local $zip_assoc = $zip32_assoc

		If @OSArch = "X64" Then
			$zip_ds = $zip64_ds
			$zip_assoc = $zip64_assoc
		EndIf

		If SoftDownload($dir_software, $zip_ds) Then SoftInstall($dir_software, $zip_ds, "msi") ; закачка и установка 7zip
		If SoftDownload($dir_software, $zip_assoc) Then RunWait("reg.exe IMPORT " & $dir_software & $zip_assoc) ; Ассоциации для зипа
	EndIf

	; PuntoSwitcher with config
	If Checked($checkPunto) Then
		Status("Установка и настройка PuntoSwitcher")

		If SoftDownload($dir_software, $punto_ds) Then
			SoftUnzip($dir_software, $punto_ds)
			SoftInstall($dir_software, "PuntoSwitcher.exe", "/Silent")
		EndIf
	EndIf

	; MS Access 97
	If Checked($checkAccess) Then
		Status("Установка и настройка Microsoft Access 97")

		If SoftDownload($dir_software, $access97_ds) Then
			SoftUnzip($dir_software, $access97_ds)
			If Not WinExists("software") Then Run('explorer ' & $dir_software)
		EndIf
	EndIf

	; WinScan2PDF
	If Checked($checkWin2PDF) Then
		Status("Подготовка WinScan2PDF к работе")

		If SoftDownload($dir_software, $win2pdf_ds) Then
			FileCreateShortcut($dir_software & $win2pdf_ds, @DesktopDir & "\WinScan2PDF.lnk", $dir_software)
			SoftInstall($dir_software, $win2pdf_ds, "run", 0)
		EndIf
	EndIf

	; .Net Framework 3.5
	If Checked($checkNet_35) Then
		_InstallDotNet("35")
	EndIf

	; Advanced IP Scanner
	If Checked($checkIPScanner) Then
		Status("Установка и настройка IP Scanner")

		If SoftDownload($dir_software, $ipscanner_ds) Then
			SoftInstall($dir_software, $ipscanner_ds, "/silent /norestart /log " & $dir_logs & $ipscanner_ds)
			ProcessClose("advanced_ip_scanner.exe")
		EndIf
	EndIf

	; XML Notepad
	If Checked($checkXMLPad) Then
		Status("Установка и настройка XML Notepad")

		If SoftDownload($dir_software, $xmlpad_ds) Then	SoftInstall($dir_software, $xmlpad_ds, "msi")
	EndIf
EndFunc   ;==>Programs

; ----------------------------------------------- EXPRESS FUNC;

Func Express()

	; Visual C++
	If Checked($checkC) Then
		Status("Устанавливаем Microsoft Visual C++")

		If SoftDownload($dir_express, $c_ds) Then SoftInstall($dir_express, $c_ds, "/s")
	EndIf

	; MS XML
	If Checked($checkXML) Then
		Status("Установка и настройка MS Xml")

		If SoftDownload($dir_express, $xml_ds) Then SoftInstall($dir_express, $xml_ds, "msi")
	EndIf

	; Hasp Driver
	If Checked($checkHASP) Then
		Status("Скачиваем Hasp драйвер")

		If SoftDownload($dir_express, $hasp_ds) Then
			Status("Удаляем старые hasp драйверы")
				RunWait($dir_express & $hasp_ds & " -fr -kp -purge -nomsg")

			Status("Устанавливаем новый hasp драйвер")
				RunWait($dir_express & $hasp_ds &  " -i -kp -nomsg")
		EndIf
	EndIf
EndFunc   ;==>Express


; ----------------------------------------------- FNS FUNC;

Func FNS()
	Local $prog_files = "C:\Program Files\АО ГНИВЦ\ППДГР"
	If @OSArch = "X64" Then $prog_files = "C:\Program Files (x86)\АО ГНИВЦ\ППДГР"

	; FNS Program
	If Checked($checkFNS) Then
		; Пакет электронных документов
		Status("Установка и настройка програм для ФНС")
			Local $msiErr = ""
			Local $FnsLink = IniRead($dir_distr & "version.ini", "ФНС", "Ссылка", "")

			If SoftDownload($dir_ppdgr, $FnsLink, "wext") Then
				SoftUnzip($dir_ppdgr, $ds_ppdgr, $dir_ppdgr, "rar") ; Распаковываем ППДГР

				_InstallDotNet("47") ; Ставим фреймворк 4.7

				$msiErr = RunWait("msiexec /fa " & $dir_ppdgr & $ds_extracted_ppdgr & " /qb /passive /norestart REBOOT=ReallySuppress /L*V " & $dir_logs & $ds_extracted_ppdgr & ".log") ; Обновляем ППДГР
				If $msiErr = "1605" Then ; ставим ППДГР, если обновить не сумели
					SoftInstall($dir_ppdgr, $ds_extracted_ppdgr, "msi")
				Else
					_FileWriteLog($dir_logs & "Install.log", $ds_extracted_ppdgr & ": Updated")
				EndIf

				$BPrint = WinWait("Печать НД", "", 5) ; Установка модуля печати
				If WinExists($BPrint) Then
					Local $PidActwin = WinGetProcess($BPrint)
					ProcessClose($PidActwin)

					If DirGetSize($prog_files) <> -1 Then ; Проверяем, что ППДГР установлен
						FileChangeDir($prog_files)
							Local $hSearch = FileFindFirstFile("*.msi")
							$sFileName = FileFindNextFile($hSearch)
							FileClose($hSearch)

							Status("Установка и настройка модуля печати ППДГР")
							RunWait("msiexec /i """ & $sFileName & """ /qb REBOOT=ReallySuppress /passive")
						FileChangeDir($dir_distr)
					EndIf
				EndIf
			EndIf
	EndIf

	; Модуль печати ППДГР
	If Checked($checkFNS_Print) Then
		Status("Проверка наличия установленного ПО ППДГР")

		If DirGetSize($prog_files) <> -1 Then ; Проверяем, что ППДГР установлен
			FileChangeDir($prog_files)
				Local $hSearch = FileFindFirstFile("*.msi")
				$sFileName = FileFindNextFile($hSearch)
				FileClose($hSearch)

				Status("Удаление сбойного модуля печати ППДГР")
				RunWait("msiexec /x """ & $sFileName & """ /qb")

				Status("Установка модуля печати ППДГР")
				RunWait("msiexec /i """ & $sFileName & """ /qb REBOOT=ReallySuppress /passive")
			FileChangeDir($dir_distr)
		EndIf
	EndIf
EndFunc

; ----------------------------------------------- JAVA FUNC;

;~ Func _JavaUpdate() ; Закачка и установка Java
;~ 	Local $_JavaURL = "https://java.com/ru/download/manual.jsp"
;~ 	Local $_Args = "/s REMOVEOUTOFDATEJRES=1"

;~ 	$oIE = _INetGetSource($_JavaURL)
;~ 	$_tmpLink = _StringBetween2($oIE, 'https://javadl.oracle.com', '"')
;~ 	$_Link = '"' & "https://javadl.oracle.com" & $_tmpLink & '"'

;~ 	FileChangeDir($dir_tools)
;~ 		RunWait("wget.exe -O Java.exe -c --tries=0 --read-timeout=5 --no-check-certificate --header " & "Cookie: oraclelicense=accept-securebackup-cookie " & $_Link)
;~ 		RunWait("Java.exe " & $_Args)
;~ 	FileChangeDir($dir_distr)
;~ EndFunc   ;==>_JavaUpdate

; ------------------------------------------------- BACKEND  ----------------------------------------------------------------------------------------------------------->

; Функции не относящиеся к установке основных компонентов ПО

; ------------------------------------------------- BACKEND  ----------------------------------------------------------------------------------------------------------->


Func Status($Msg) ; Статус
	If GUICtrlGetState($StatusBar1) Then
		_GUICtrlStatusBar_SetText($StatusBar1, $Msg, 2)
		_GUICtrlStatusBar_SetText($StatusBar2, $Msg, 2)
	EndIf
EndFunc   ;==>_Status

Func Checked($Checkbox) ; Проверяет, выбран ли чекбокс
	If GUICtrlGetState($Checkbox) Then
		If GUICtrlRead($Checkbox) = $GUI_CHECKED Then
			Return(True)
		Else
			Return(False)
		EndIf
	EndIf
EndFunc   ;==>_Checked

Func SoftDownload($Place, $Soft_ds, $dwnloader = "wget") ; Закачка софта (проверка на существование и проверка на переносимость сборки) /  Возвращает True, если файл успешно скачан
														 ; $dwnloader = "wget" или "raw" - закачка средствами autoit с сервера, "wext" - wget с внешнего сервера, "ext" - закачка с внешнего сервера
	Local $FileDownloaded = False
	Local $repeat_number = 3
	Local $Portable = IniRead($dir_distr & $VersionInfo, "MODE", "Offline", "0")

	Local $FilePath = $Place & $Soft_ds ; Переменная для приведения пути к файлу в нужный вид
	If $Place <> $dir_tools Then $FilePath = $Place & "\" & $Soft_ds

	If $Download_only Then _FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Marked for download only")

	If $Portable = 0 Then
		_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Downloading") ; записываем в лог время запуска загрузки определенного пункта

		Local $tempPath = $FilePath
		If $dwnloader = "wext" Or $dwnloader = "ext" Then
			$file_name = StringRegExp($Soft_ds, "(?=\w+\.\w{3,4}$).+", 1)
			$tempPath = $Place & $file_name[0]
		EndIf

		$checkCrc = _CheckCRC($tempPath) ; Получаем CRC сумму файла

		If Not $checkCrc Then ; Если CRC сумма неверна, то удаляем файл (если есть), скачиваем новый, записываем в лог об успешной загрузке файла
			Switch $dwnloader
				Case "wget"
					For $i = 0 to $repeat_number Step 1
						FileDelete($FilePath)
						_Wget($Soft_ds, $Place)
						$checkCrc = _CheckCRC($FilePath)
						If $checkCrc Then
							$FileDownloaded = True
							_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Done")
							ExitLoop
						EndIf
						Sleep(2000)
					Next

				Case "raw"
					FileDelete($FilePath)
					_DownloadRawBar("http://" & $User & ":" & $Pass & "@" & $Server & "/" & $Soft_ds, $Place & $Soft_ds)
					$checkCrc = _CheckCRC($FilePath)
					If $checkCrc Or $Soft_ds = $VersionInfo Then
						$FileDownloaded = True
						_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Done")
					EndIf

				Case "wext"
					FileDelete($FilePath)
					$file_name = StringRegExp($Soft_ds, "(?=\w+\.\w{3,4}$).+", 1)
					_Wget($Soft_ds, $Place, "ext")
					$FileDownloaded = True
					_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Done")

				Case "ext"
					FileDelete($FilePath)
					$file_name = StringRegExp($Soft_ds, "(?=\w+\.\w{3,4}$).+", 1)
					_DownloadRawBar($Soft_ds, $Place & $file_name[0])
					$FileDownloaded = True
					_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Done")
			EndSwitch
		Else ; Если сумма совпала, продолжаем установку
			$FileDownloaded = True
			_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Already exists")
		EndIf
	ElseIf $Portable = 1 Then ; переносимая сборка
		$checkCrc = _CheckCRC($FilePath) ; Получаем CRC сумму файла
		If $checkCrc Or $Soft_ds = $VersionInfo And FileExists($dir_distr & $VersionInfo) Then $FileDownloaded = True
	EndIf

	If Not $FileDownloaded And $Soft_ds <> $VersionInfo Then _FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Download failed")

	If $Download_only Then $FileDownloaded = False ; Отмечаем, чтобы не продолжать установку

	Return $FileDownloaded
EndFunc   ;==>_SoftDownload

Func SoftUnzip($Place, $Soft_ds, $Place_to = $Place, $Option = "zip") ; Извлечение файлов
	Local $FileUnzip = False

	$FilePath = $Place & $Soft_ds ; Переменная для приведения пути к файлу в нужный вид
	If $Place <> $dir_tools Then $FilePath = $Place & "\" & $Soft_ds

	_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Unpacking") ; записываем в лог время запуска распаковки

	Switch $Option
		Case "zip"
			RunWait($dir_tools & $sZip & ' x -y ' & $FilePath & ' -o' & $Place_to) ; Распаковываем файл с помощью 7Zip
		Case "rar"
			RunWait($dir_tools & $wRar & " e -y  " & $FilePath & " " & $Place_to) ; Распаковываем файл с помощью UnRAR.exe
	EndSwitch

	If @error = False Then $FileUnzip = True

	If $FileUnzip Then
		_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Unpacked")
	Else
		_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Failed to unpack")
	EndIf

	Return $FileUnzip
EndFunc   ;==>_SoftUnzip

Func SoftInstall($Place, $Soft_ds, $Option, $Wait = "1") ; Установка софта
	; (Место, Название, Вариант установки: 				   run = Только запуск
														;  msi = Тихая установка MSI пакетов
														;  cades = Тихая установка пакетов криптоПРО плагин
														;  pdf = Тихая установка пакетов КриптоПДФ
														;  arm = Тихая установка криптоАРМ
														;  , Ждать окончания установки?)

	Local $FileInstall = False
	Local $arg = " /qb REBOOT=REALLYSUPPRESS /L*V " & $dir_logs & $Soft_ds & ".log"

	$FilePath = $Place & $Soft_ds ; Переменная для приведения пути к файлу в нужный вид
	If $Place <> $dir_tools Then $FilePath = $Place & "\" & $Soft_ds

	_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Installing") ; записываем в лог время запуска установки определенного пункта

	Switch $Option ; Опция выбора установки
		Case "run" ; Обычный запуск программы
			$arg = $FilePath

		Case "msi" ; Установка MSI пакетов
			$arg = "msiexec /i " & $FilePath & $arg

		Case "cades" ; КриптоПРО плагин
			$arg = $FilePath & " -norestart -silent -cadesargs ""/qn REBOOT=REALLYSUPPRESS"" "

		Case "arm" ; КриптоАРМ
			$arg = $FilePath & " /V """ & StringStripWS($arg,1) & """"

		Case "pdf" ; КриптоПДФ
			$arg = $FilePath & " -silent -args """ & StringStripWS($arg,1) & """"

		Case Else
			$arg = $FilePath & " " & $Option
	EndSwitch

	If $Wait = "1" Then ; Ждем завершения программы или нет?
		RunWait($arg)
	Else
		Run($arg)
	EndIf

	If @error = False Then $FileInstall = True

	If $FileInstall Then
		_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Installed")
	Else
		_FileWriteLog($dir_logs & "Install.log", $Soft_ds & ": Not installed (check logs folder)")
	EndIf

	Return $FileInstall
EndFunc   ;==>_SoftInstall

; ------------------------------------------------- INITIALIZATION FUNC ------------------------------------------------------------->

Func _update() ; Обновление программы и подготовка для установки
	Local $title = "АйТи помощник "  & FileGetVersion(@ScriptFullPath)
	Local $CurPath = StringTrimRight(@ScriptFullPath, StringLen($MainApp))
	Local $Portable = IniRead($CurPath & "\" & $VersionInfo, "MODE", "Offline", "0")
	Local $oldVersion = IniRead($CurPath & "\" & $VersionInfo, "Version", "Version", "")

	FileDelete(@DesktopDir & "\Нотариальный помощник.lnk") ; Временное решение для удаления версии хелпера 2.х
	FileDelete($dir_distr & "_main.exe") ; Временное решение для удаления версии хелпера 2.х
	FileDelete($dir_update & "_main.exe") ; Временное решение для удаления версии хелпера 2.х


	If $Portable = 1 Then
		$title = $title & " | Оффлайн режим"

		$dir_distr = @WorkingDir & "\"
		$dir_tools  = $dir_distr & "Tools\"
		$dir_logs   = $dir_distr & "Logs\"
		$dir_update = $dir_distr & "Update\"

		$dir_ecp       = $dir_tools & "ecp\"
		$dir_enot      = $dir_tools & "enot\"
		$dir_express   = $dir_tools & "express\"
		$dir_federal   = $dir_tools & "federal\"
		$dir_software  = $dir_tools & "software\"
		$dir_certs     = $dir_tools & "certs\"

		$dir_ppdgr = $dir_federal & "ppdgr\"
	EndIf

	If $Portable = 0 Then
		; Подготовка дистра
		DirCreate($dir_tools) ; Создаем папки для работы программы
			DirCreate($dir_ecp)
			DirCreate($dir_enot)
			DirCreate($dir_express)
			DirCreate($dir_federal)
			DirCreate($dir_software)
		DirCreate($dir_update)
		DirCreate($dir_logs)
	EndIf

	FileCopy($dir_logs & "Install.log", $dir_logs & "Install.previous.log", 1)
	FileDelete($dir_logs & "Install.log")

	If Not SoftDownload($dir_update, $VersionInfo, "raw") Then
		MsgBox("","Ошибка", "Не удалось загрузить Version.ini")
		Exit
	EndIf

	FileMove($dir_update & $VersionInfo, $dir_distr & $VersionInfo, 1)

	If Not SoftDownload($dir_tools, $wget, "raw") Then _DownloadPortable($dir_tools, $wget, "raw") ; Скачиваем wget

	If Not SoftDownload($dir_tools, $sZip) Then ; Скачиваем 7Zip
		MsgBox("","Ошибка", "Не найден 7za.exe в папке Tools.")
		Exit
	EndIf

	SoftDownload($dir_tools, $wRar) ; Скачиваем UnRAR.exe

	; Компоненты для дальнейшей работы
;~ 		_InstallDotNet("40")

	If $Portable = 0 Then ; Для обычной сборки
		Local $newVersion = IniRead($dir_distr & $VersionInfo, "Version", "Version", "0") ; берем номер версии из version.ini

		If @ScriptDir <> $dir_distr Then ; если скрипт не в той папке, то переносим в Distr
			DirMove("Tools", $dir_distr, 1)
			DirMove("Update", $dir_distr, 1)
			DirMove("Logs", $dir_distr, 1)

			FileMove($MainApp, $dir_distr, 9)
			FileMove($VersionInfo, $dir_distr, 9)
			FileMove($sZip, $dir_distr, 9)
			FileMove($wRar, $dir_distr, 9)

			FileCreateShortcut($dir_distr & $MainApp, @DesktopDir & "\" & $HelperName, $dir_distr)

			_UpdateScreen() ; убрать лишние значки с рабочего стола
		EndIf

		If $newVersion <> $oldVersion Then ; проверка версии программы
			FileDelete($dir_update & $MainApp)
				If SoftDownload($dir_update, $MainApp) Then ; скачиваем программу
					FileMove($dir_update & $MainApp, $dir_update & $MainApp & ".tmp", 1)
					IniWrite($dir_distr & $VersionInfo, "Version", "Version", $newVersion) ; записываем новую версию в version.ini
					_ScriptRestart() ; перезапускаем скрипт
				EndIf
		EndIf
	EndIf

	Return($title)
EndFunc   ;==>_update

Func _ScriptRestart() ; перезапуск скрипта
	_RegSettings("Write", $sPass)

	$sVbs = _TempFile(@TempDir, '~', '.vbs')
	$hFile = FileOpen($sVbs, 2)
	FileWriteLine($hFile, 'Set objService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\CIMV2")')
	FileWriteLine($hFile, 'Set objRefresher = CreateObject("WbemScripting.SWbemRefresher")')
	FileWriteLine($hFile, 'Set colItems = objRefresher.AddEnum(objService, "Win32_Process").objectSet')
	FileWriteLine($hFile, 'Set obj = CreateObject("Scripting.FileSystemObject")')
	FileWriteLine($hFile, 'Do Until False')
	FileWriteLine($hFile, '    WScript.Sleep 500')
	FileWriteLine($hFile, '    objRefresher.Refresh')
	FileWriteLine($hFile, '    Flag = True')
	FileWriteLine($hFile, '    For Each objItem in colItems')
	FileWriteLine($hFile, '        If objItem.ProcessID = ' & @AutoItPID & ' Then')
	FileWriteLine($hFile, '            Flag = False')
	FileWriteLine($hFile, '        End If')
	FileWriteLine($hFile, '    Next')
	FileWriteLine($hFile, '    If Flag = True Then')
	FileWriteLine($hFile, '        Exit Do')
	FileWriteLine($hFile, '    End If')
	FileWriteLine($hFile, 'Loop')
	;FileWriteLine($hFile, '    WScript.Sleep 2000')
	FileWriteLine($hFile, '		If (obj.FileExists("' & $MainApp & '")) Then')
	FileWriteLine($hFile, '			obj.DeleteFile("' & $MainApp & '")')
	FileWriteLine($hFile, '		ElseIf (obj.FileExists("' & $dir_distr & $MainApp & '")) Then')
	FileWriteLine($hFile, '			obj.DeleteFile("' & $dir_distr & $MainApp & '")')
	FileWriteLine($hFile, '		End If')

	FileWriteLine($hFile, 'Set f = obj.GetFile("' & $dir_update & $MainApp & '.tmp")')

	FileWriteLine($hFile, 'Set objFSO = CreateObject("Scripting.FileSystemObject")') ; Копируем и заменяем новую версию проги
	FileWriteLine($hFile, 'objFSO.CopyFile f, "' & $dir_distr & $MainApp & '", TRUE')
	FileWriteLine($hFile, 'objFSO.DeleteFile f')

	;FileWriteLine($hFile, 'f.Move ("' & $dir_distr & @ScriptName & '")')
	FileWriteLine($hFile, 'Set objShell = CreateObject("WScript.Shell")')
	FileWriteLine($hFile, 'objShell.Run("' & $dir_distr & $MainApp & ' ' & $CmdLineRaw & '")')
	FileWriteLine($hFile, 'Set objFSO = CreateObject("Scripting.FileSystemObject")')
	FileWriteLine($hFile, 'Set File = objFSO.GetFile("' & FileGetShortName($sVbs) & '")')
	FileWriteLine($hFile, 'File.Delete')
	FileClose($hFile)
	ShellExecute($sVbs)
	Exit
EndFunc   ;==>_ScriptRestart

Func _Next($msg = "Установка завершена", $dwnload_only = False) ; Закачка, установка и настройка
	Local $continue = False

	For $i = 0 To UBound($AllCheckboxes) - 1 Step 1 ; Проверяем, выбран ли какой-либо пункт меню
		If GUICtrlRead($AllCheckboxes[$i]) = $GUI_CHECKED Then $continue = True
	Next

	If $continue Then
		GUICtrlSetState($btnDownloadOnly, $GUI_DISABLE)
		GUICtrlSetState($btnInstall, $GUI_DISABLE)
		GUICtrlSetState($menuHelp, $GUI_DISABLE)

		For $i = 0 To UBound($AllCheckboxes) - 1 Step 1 ; Делаем чекбоксы неактивными
			GUICtrlSetState($AllCheckboxes[$i], $GUI_DISABLE)
		Next

		_install($dwnload_only)

		For $i = 0 To UBound($AllCheckboxes) - 1 Step 1 ; Сбрасываем все чекбоксы и делаем их активными
			GUICtrlSetState($AllCheckboxes[$i], $GUI_UNCHECKED)
			GUICtrlSetState($AllCheckboxes[$i], $GUI_ENABLE)
		Next

		GUICtrlSetState($btnDownloadOnly, $GUI_ENABLE)
		GUICtrlSetState($btnInstall, $GUI_ENABLE)
		GUICtrlSetState($menuHelp, $GUI_ENABLE)
		Status($msg)
	EndIf
EndFunc   ;==>_Next

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam) ; копирование инфы из статус бара
    #forceref $hWnd, $iMsg, $wParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $aPos

    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
	Local $tInfo
    Switch $hWndFrom
        Case $StatusBar1
            Switch $iCode
				Case $NM_CLICK
					$tInfo = DllStructCreate($tagNMMOUSE, $lParam)
					If DllStructGetData($tInfo, "X") > 0 And DllStructGetData($tInfo, "X") < 100 Then  ; Копируем первую часть статус-бара (айпишник)
						$aPos = MouseGetPos()
						ClipPut(StringStripWS (_GUICtrlStatusBar_GetText($StatusBar1, 0),1))
						ToolTip("IP - адрес скопирован", $aPos[0], $aPos[1],"","",2)
					EndIf

					If DllStructGetData($tInfo, "X") > 100  And DllStructGetData($tInfo, "X") < 200 Then ; Копируем вторую часть статус-бара (имя компа)
						$aPos = MouseGetPos()
						ClipPut(StringStripWS (_GUICtrlStatusBar_GetText($StatusBar1, 1),1))
						ToolTip("Имя компьютера скопировано", $aPos[0], $aPos[1],"","",2)
					EndIf

                    Return True
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

; ------------------------------------------------- DOWNLOAD FUNC ------------------------------------------------------------->

Func _Wget($file_url, $folder_to, $ext = "npso") ; Процедура загрузки файлов с помощью WGET ($ext = npso / ext)
	If $ext = "ext" Then
		RunWait($dir_tools & "wget.exe -q --show-progress -c --tries=5 --read-timeout=5 --no-check-certificate " & $file_url & " -P " & $folder_to)
	ElseIf $ext = "npso" Then
		RunWait($dir_tools & "wget.exe -q --show-progress -c --tries=5 --read-timeout=5 --no-check-certificate --user=" & $User & " --password=" & $Pass & " http://" & $Server & "/" & $file_url & " -P " & $folder_to)
	EndIf
EndFunc   ;==>_Wget

Func _DownloadPortable($Place, $Soft_ds, $Option)
	If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(33,"Не найден " & $Soft_ds & " в папке " & $Place, "Переключиться в онлайн режим и скачать его?")
		Select
			Case $iMsgBoxAnswer = 1 ;OK
				IniWrite($dir_distr & $VersionInfo, "MODE", "Offline", 0)
				SoftDownload($Place, $Soft_ds, $Option)
				IniWrite($dir_distr & $VersionInfo, "MODE", "Offline", 1)

			Case $iMsgBoxAnswer = 2 ;Cancel
				Exit
		EndSelect
EndFunc

Func _Download($url, $folder) ; Процедура загрузки файлов (http) с отображением хода прогресса
	Local $ParentWin_Pos = WinGetPos($HelperForm, "")
	Local $Form1 = GUICreate("Загрузка файла", 400, 100, $ParentWin_Pos[0] + 100, $ParentWin_Pos[1] + 200, -1, -1, $HelperForm)
	Local $pb_File = GUICtrlCreateProgress(30, 30, 300, 20, '')
	Local $lbl_FilePercent = GUICtrlCreateLabel("0 %", 335, 32, 35, 16, '')
	Local $x = 0

	; Показываем, какой файл скачиваем
	Local $sTemp = StringRegExpReplace($folder, '[^\\]*\z', '', 1)
	Local $sFilename = StringReplace($folder, $sTemp, "")
	Local $lbl_Info = GUICtrlCreateLabel('' & $sFilename, 30, 62, 300, 16, '')

	GUISetState(@SW_SHOW, $Form1)

	$hInet = InetGet($url, $folder, 1, 16)
	$FileSize = InetGetSize($url)
	While Not InetGetInfo($hInet, 2)
		Sleep(500)
		$BytesReceived = InetGetInfo($hInet, 0)
		$Pct = Int($BytesReceived / $FileSize * 100)
		GUICtrlSetData($pb_File, $Pct)
		GUICtrlSetData($lbl_FilePercent, $Pct & " %")
	WEnd
	InetClose($hInet)
	GUIDelete($Form1)

	If FileGetSize($folder) Then $x = 1

	Return $x
EndFunc   ;==>_Download

Func _DownloadRaw($from, $to) ; Правильная загрузка файлов
	Local $hDownload = InetGet($from, $to, 1, 16)
	Do
		Sleep(250)
	Until InetGetInfo($hDownload, 2) ; Проверка завершения загрузки
	InetClose($hDownload) ; Закрываем закачку, чтобы избежать утечки ресурсов
	Return $hDownload
EndFunc   ;==>_DownloadRaw

Func _DownloadRawBar($from, $to) ; Загрузка с http с прогресс баром
	ProgressOn("Загрузка", $to, "0%")
	Local $url = $from ; Wget URL
	$folder = $to
	$hInet = InetGet($url, $folder, 1, 1)
	$FileSize = InetGetSize($url)
	While Not InetGetInfo($hInet, 2)
		Sleep(500)
		$BytesReceived = InetGetInfo($hInet, 0)
		$Pct = Int($BytesReceived / $FileSize * 100)
		ProgressSet($Pct, $Pct & "%")
	WEnd
	ProgressOff()
	InetClose($hInet)
EndFunc   ;==>_DownloadRawBar

; ------------------------------------------------- SYSTEM FUNC ------------------------------------------------------------->

Func _CheckCRC($sFile) ; Проверка CRC суммы файла (возвращает True, если найдено совпадение CRC)
	Local $crc_found = False ; Переменная для определения нахождения CRC
	Local $sha1 = _SHA1ForFile($sFile) ; Получаем CRC нашего файла
	Local $crcArray = IniReadSection($dir_distr & $VersionInfo, "CRC") ; Получаем массив CRC из version.ini

	for $i = 1 to UBound($crcArray) -1 ; Перебираем массив из всех CRC
		If $sha1 = $crcArray[$i][1] Then ; При нахождении нужного CRC меняем переменную на True
			$crc_found = True
			ExitLoop
		EndIf
	Next

	Return $crc_found ; В случае, если у нас найдено CRC, значит скачался файл полностью и докачка не требуется
EndFunc   ;==>_checkCRC

Func _IsWin7Above() ; Это windows 7 или выше?
	If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentVersion") > 6.2 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_IsWin7Above

Func _InstallDotNet($version) ; Устанавливаем netframework, если не установлен
	Local $arg = False
	Local $status_bits, $status_updates

	Switch $version
		Case "35"
			Status("Устанавливаем .Net Framework 3.5")

			; Проверяем, что включены службы обновления винды
			If _RetrieveServiceState("bits") <> "Running" Then ; Включаем службу обновления bits
				$status_bits = "1"
				RunWait(@ComSpec & ' /c sc config bits start=demand', '', @SW_HIDE)
				RunWait(@ComSpec & ' /c net start bits', '', @SW_HIDE)
			EndIf
			If _RetrieveServiceState("wuauserv") <> "Running" Then ; Включаем службу обновления windows
				$status_updates = "1"
				RunWait(@ComSpec & ' /c sc config wuauserv start=demand', '', @SW_HIDE)
				RunWait(@ComSpec & ' /c net start wuauserv', '', @SW_HIDE)
			EndIf

			If @OSVersion = "Win_7" Then
				If SoftDownload($dir_software, $_netFramework35) Then
					SoftInstall($dir_software, $_netFramework35, "/passive /norestart")
					$arg = True
				EndIf
			Else
				RunWait(@ComSpec & " /c " & "DISM /Online /Enable-Feature /FeatureName:NetFx3 /All")
				$arg = True
			EndIf

		Case "40"
			Status("Устанавливаем .Net Framework 4.0")

			RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', '')
			If Not @error > 0 Then
				; Проверяем, что включены службы обновления винды
			If _RetrieveServiceState("bits") <> "Running" Then ; Включаем службу обновления bits
				$status_bits = "1"
				RunWait(@ComSpec & ' /c sc config bits start=demand', '', @SW_HIDE)
				RunWait(@ComSpec & ' /c net start bits', '', @SW_HIDE)
			EndIf
			If _RetrieveServiceState("wuauserv") <> "Running" Then ; Включаем службу обновления windows
				$status_updates = "1"
				RunWait(@ComSpec & ' /c sc config wuauserv start=demand', '', @SW_HIDE)
				RunWait(@ComSpec & ' /c net start wuauserv', '', @SW_HIDE)
			EndIf

				If SoftDownload($dir_software, $_netFramework40) Then
					SoftInstall($dir_software, $_netFramework40, "/q /norestart")
					$arg = True
				EndIf
			EndIf

		Case "47"
			Status("Устанавливаем .Net Framework 4.7")

			Local $s = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release')
			If Not $s < 460805 Then
				; Проверяем, что включены службы обновления винды
				If _RetrieveServiceState("bits") <> "Running" Then ; Включаем службу обновления bits
					$status_bits = "1"
					RunWait(@ComSpec & ' /c sc config bits start=demand', '', @SW_HIDE)
					RunWait(@ComSpec & ' /c net start bits', '', @SW_HIDE)
				EndIf
				If _RetrieveServiceState("wuauserv") <> "Running" Then ; Включаем службу обновления windows
					$status_updates = "1"
					RunWait(@ComSpec & ' /c sc config wuauserv start=demand', '', @SW_HIDE)
					RunWait(@ComSpec & ' /c net start wuauserv', '', @SW_HIDE)
				EndIf

				If @OSVersion = "Win_7" Then
					Local $iRET = RunWait(@ComSpec & ' /c WMIC qfe get hotfixid | FIND "' & "4019990" & '"', @TempDir, @SW_HIDE)
					If Not $iRET Then ; Проверяем, установлено ли обновление
						Local $win7patch = $win7patch_x32
						If @OSArch = "X64" Then $win7patch = $win7patch_x64
						If SoftDownload($dir_software, $win7patch) Then SoftInstall($dir_software, $win7patch, "/passive /norestart") ; Ставим патч на 7ку
					EndIf
				EndIf

				If SoftDownload($dir_software, $_netFramework47) Then
					SoftInstall($dir_software, $_netFramework47, "/passive /norestart")
					$arg = True
				EndIf
			EndIf
	EndSwitch

	; Выключаем включенные службы обновления винды
	If $status_bits Then ; Выключаем службу обновления bits
		$status_bits = "0"
		RunWait(@ComSpec & ' /c sc config bits start=disabled', '', @SW_HIDE)
		RunWait(@ComSpec & ' /c net stop bits', '', @SW_HIDE)
	EndIf
	If $status_updates Then ; Выключаем службу обновления windows
		$status_updates = "0"
		RunWait(@ComSpec & ' /c sc config wuauserv start=disabled', '', @SW_HIDE)
		RunWait(@ComSpec & ' /c net stop wuauserv', '', @SW_HIDE)
	EndIf

	Return $arg
EndFunc   ;==>_InstallDotNet

Func _RetrieveServiceState($s_ServiceName) ; получение статуса службы
	Local Const $wbemFlagReturnImmediately = 0x10
	Local Const $wbemFlagForwardOnly = 0x20
	Local $s_Machine = @ComputerName
	Local $colItems = "", $objItem
	Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
	If @error Then
		MsgBox(16, "_RetrieveServiceState", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service WHERE Name = '" & $s_ServiceName & "'", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		MsgBox(16, "_RetrieveServiceState", "ExecQuery Error: SELECT * FROM Win32_Service")
		Return
	EndIf
	If IsObj($colItems) Then
		For $objItem In $colItems
			Return $objItem.State
		Next
	EndIf
EndFunc   ;==>_RetrieveServiceState

Func _UpdateScreen() ; обновить рабочий стол
	Local $Opt = Opt('WinSearchChildren', 1)
	Local $List = WinList('[CLASS:SHELLDLL_DefView]')
	For $i = 1 To UBound($List) - 1
		DllCall('user32.dll', 'long', 'SendMessage', 'hwnd', $List[$i][1], 'int', 0x0111, "int", 0x7103, 'int', 0)
	Next
	Opt('WinSearchChildren', $Opt)
EndFunc   ;==>_UpdateScreen

Func _StringBetween2($s, $from, $to)
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>_StringBetween2

Func _GetCurrentUser()
    Local $result = DllCall("Wtsapi32.dll","int", "WTSQuerySessionInformationW", "Ptr", 0, "int", -1, "int", 5, "ptr*", 0, "dword*", 0)
    If @error Or $result[0] = 0 Then Return SetError(1,0,"")
    Local $User = DllStructGetData(DllStructCreate("wchar[" & $result[5] & "]" , $result[4]),1)
    DllCall("Wtsapi32.dll", "int", "WTSFreeMemory", "ptr", $result[4])
    Return $User
EndFunc   ;==>_GetCurrentUser

Func _GetCurrentUserSID()
    Local $User = _Security__LookupAccountName(_GetCurrentUser(),@ComputerName)
    If @error Then Return SetError(1,0,"")
    Return $User[0]
EndFunc   ;==>_GetCurrentUserSID

Func base64($vCode, $bEncode = True, $bUrl = False)

    Local $oDM = ObjCreate("Microsoft.XMLDOM")
    If Not IsObj($oDM) Then Return SetError(1, 0, 1)

    Local $oEL = $oDM.createElement("Tmp")
    $oEL.DataType = "bin.base64"

    If $bEncode then
        $oEL.NodeTypedValue = Binary($vCode)
        If Not $bUrl Then Return $oEL.Text
        Return StringReplace(StringReplace(StringReplace($oEL.Text, "+", "-"),"/", "_"), @LF, "")
    Else
        If $bUrl Then $vCode = StringReplace(StringReplace($vCode, "-", "+"), "_", "/")
        $oEL.Text = $vCode
        Return $oEL.NodeTypedValue
    EndIf

EndFunc ;==>base64

Func _RegSettings($Option = "Read", $Hash = "")
	Local $Date = RegRead("HKCU\Software\Helper", "Date")
	Local $CurDate = @Mon & StringTrimLeft(@YEAR, 2) & @MDAY & @HOUR
	Local $Init = RegRead("HKCU\Software\Helper", "Init")
	Local $arg = False

	Switch $Option
		Case "Read"
			If $CurDate = $Date Then
				If $Init <> "" Then
					$arg = BinaryToString(base64($Init, False))
					RegDelete("HKCU\Software\Helper", "Date")
					RegDelete("HKCU\Software\Helper", "Init")
				EndIf
			EndIf

		Case "Write"
			If $Hash <> "" Then
				RegWrite("HKCU\Software\Helper", "Date", "REG_SZ", $CurDate)
				RegWrite("HKCU\Software\Helper", "Init", "REG_SZ", base64($Hash))
			EndIf
	EndSwitch

	Return $arg
EndFunc   ;==>_Settings