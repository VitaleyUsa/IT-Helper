#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Comment=Нотариальная палата Свердловской области
#AutoIt3Wrapper_Res_Description=АйТи помощник от НПСО
#AutoIt3Wrapper_Res_Fileversion=2.0.0.20
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Ситников Виталий
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_File_Add=pass.bmp, 2, 200
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/SO /sf /sv /rm
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Res_HiDpi=Y
;~ #AutoIt3Wrapper_Res_Icon_Add=Ico\icon.ico
#pragma compile(UPX, False)

;~ If @OsType="WIN_10" Then
;~     DllCall("Shcore.dll","long","PROCESS_DPI_AWARENESS",1)
;~ Else
;~     If Not (@Compiled ) Then DllCall("User32.dll","bool","SetProcessDPIAware")
;~ EndIf

Opt("TrayMenuMode", 3)

#include "it-functions.au3"
#include "it-password.au3"

local $title = _update()

;~ local $title = "TEST"

; Main application

$width = 628
$height = 481

#Region ### START Koda GUI section ### Form=it-helper.kxf
$HelperForm = GUICreate($title, $width, $height, -1, -1, $GUI_SS_DEFAULT_GUI)

$menuFile = GUICtrlCreateMenu("Файл")
	$menuOffline = GUICtrlCreateMenuItem("Offline - режим", $menuFile)
	$menuDelete = GUICtrlCreateMenuItem("Удалить ПО", $menuFile)
$menuHelp = GUICtrlCreateMenu("Помощь")
	$menuChangelog = GUICtrlCreateMenuItem("Список изменений", $menuHelp)
	$menuAbout = GUICtrlCreateMenuItem("О программе", $menuHelp)
GUISetFont(12, 400, 0, "Segoe UI")
;~  GUISetBkColor(0xBFCDDB)
GUISetBkColor(0xf85252)

Global $DummyStart = GUICtrlCreateDummy() ; get start of control creation control id

$Tab1 = GUICtrlCreateTab(0, 0, 628, 401)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

#Region ### Начало - Вкладка - Нотариат ###
$TabSheet1 = GUICtrlCreateTabItem("Нотариат")
	$group_eis = GUICtrlCreateGroup("ЕИС Енот", 8, 37, 193, 337)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkEnot = GUICtrlCreateCheckbox(" Дистрибутив ЕИС", 17, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkBD = GUICtrlCreateCheckbox(" Дистрибутив MySQL", 17, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Mysql + базы данных еис")

		$checkSQLBACKUP = GUICtrlCreateCheckbox(" Бэкап баз данных ЕИС", 17, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для бэкапа MySQL БД Енота")

		$checkCleanUpdates = GUICtrlCreateCheckbox(" Очистка обновлений", 17, 154, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Удаление старых обновлений ЕИС")

		$checkLibReg = GUICtrlCreateCheckbox(" Регистрация библиотек", 17, 186, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "vstwain, activetree, capicom, enotddb2, eNotTXres + папки tx/tx23/tx25")

		$checkFindRND = GUICtrlCreateCheckbox(" Пропущ. действия РНД", 17, 218, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для поиск пропущенных значений в РНД ЕИС")
		
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_fns = GUICtrlCreateGroup("ФНС", 216, 277, 193, 97)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkFNS = GUICtrlCreateCheckbox(" ППДГР", 225, 297, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkFNS_Print = GUICtrlCreateCheckbox(" Модуль печати", 225, 330, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Восстанавливает модуль печати для ППДГР")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_express = GUICtrlCreateGroup("Триасофт - Экспресс", 216, 173, 193, 97)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkHasp = GUICtrlCreateCheckbox(" HASP Драйвер", 225, 193, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Удаляет старые драйверы для ключа hasp и устанавливает новые")

		$checkXML = GUICtrlCreateCheckbox(" MsXML", 225, 226, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_browser = GUICtrlCreateGroup("Интернет браузеры", 424, 37, 193, 161)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkFF = GUICtrlCreateCheckbox(" Firefox ESR", 433, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "+ расширения для FF + отключение обновлений")

		$checkChrome = GUICtrlCreateCheckbox(" Google Chrome", 433, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "+ расширения для Chrome")

		$checkIE = GUICtrlCreateCheckbox(" Internet Explorer", 433, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Настройка Internet Explorer")

		$checkActx_Browser = GUICtrlCreateCheckbox(" Плагины и расширения", 433, 156, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "ЕФРСБ, Госуслуги, Федресурс")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_ecp = GUICtrlCreateGroup("Электронная подпись", 216, 37, 193, 129)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkCSP = GUICtrlCreateCheckbox(" CryptoPro CSP 4.0 R4", 225, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkPKI = GUICtrlCreateCheckbox(" eToken pki client", 225, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkCerts = GUICtrlCreateCheckbox(" Сертификаты", 225, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Сертификиты + списки отзывов РР и ФЦИИТ")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_crypto = GUICtrlCreateGroup("Крипто утилиты", 424, 205, 193, 129)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkARM = GUICtrlCreateCheckbox(" Крипто ARM", 433, 225, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkPDF = GUICtrlCreateCheckbox(" Крипто PDF", 433, 258, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkLine = GUICtrlCreateCheckbox(" Крипто Лайн", 433, 291, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Бесплатный аналог КриптоАРМ (не сертифицированная)")
#EndRegion ### Конец - Вкладка - Нотариат ###

#Region ### Начало - Вкладка - Программы ###
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet2 = GUICtrlCreateTabItem("Программы")
	$group_view = GUICtrlCreateGroup("Просмотр изображений", 8, 173, 193, 97)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkIrfan = GUICtrlCreateCheckbox(" IrfanView", 17, 193, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkFastStone = GUICtrlCreateCheckbox(" FastStone Viewer", 17, 226, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$group_rdp = GUICtrlCreateGroup("Удаленный доступ", 8, 277, 193, 97)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkTM = GUICtrlCreateCheckbox(" TeamViewer QS", 17, 297, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Teamviewer Quick Support 9")

		$checkAnyDesk = GUICtrlCreateCheckbox(" AnyDesk", 17, 330, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_tools = GUICtrlCreateGroup("Начальная настройка ОС", 8, 37, 193, 129)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkAdobe = GUICtrlCreateCheckbox(" Adobe Reader", 17, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkZIP = GUICtrlCreateCheckbox(" 7-Zip", 17, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Архиватор (x32/x64)")

		$checkNet_35 = GUICtrlCreateCheckbox(" .Net Framework 3.5", 17, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")


	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$group_other = GUICtrlCreateGroup("Разное", 216, 37, 193, 337)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkTrueConf = GUICtrlCreateCheckbox(" TrueConf", 225, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Видеоконференция")

		$check_heidi = GUICtrlCreateCheckbox(" HeidiSQL", 225, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для работы с БД")

		$checkSCP = GUICtrlCreateCheckbox(" WinSCP", 225, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Фтп - клиент")

		$checkStart = GUICtrlCreateCheckbox(" StartIsBack", 225, 156, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Возвращает стандартный пуск в win10")

		$checkPunto = GUICtrlCreateCheckbox(" PuntoSwitcher", 225, 189, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Автоматическое переключение раскладки + улучшенный буфер обмена")

		$checkAccess = GUICtrlCreateCheckbox(" Microsoft Access 97 SR2", 225, 222, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для восстановление баз данных Экспресса")

		$checkWin2PDF = GUICtrlCreateCheckbox(" WinScan2PDF", 225, 255, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для сканирования в ПДФ")

		$checkIPScanner = GUICtrlCreateCheckbox(" Advanced IP Scanner", 225, 288, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Сканер локальных сетей")

		$checkXMLPad = GUICtrlCreateCheckbox(" XML Notepad", 225, 321, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		GUICtrlSetTip(-1, "Блокнот для визуализации XML-файлов")
#EndRegion ### Конец - Вкладка - Программы ###

#Region ### Начало - Вкладка - Системные настройки ###
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet3 = GUICtrlCreateTabItem("Системные настройки")
	$group_os = GUICtrlCreateGroup("Операционная система", 8, 37, 193, 193)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkWinSet = GUICtrlCreateCheckbox(" Настройка Windows", 17, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Открывает порт для . Профиль энергосбережения ОС - 'быстродействие'. Отключает выключение жестких дисков и usb. Добавляет в исключения папки Triasoft")
		
		$checkMUpdate = GUICtrlCreateCheckbox(" Обновления Win10", 17, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Отключение / включение обновлений Windows 10")
		
		$checkShare = GUICtrlCreateCheckbox(" Общий сетевой доступ", 17, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Настройка общего сетевого доступа для локальной сети")
		
		$checkECPPass= GUICtrlCreateCheckbox(" Пароль от ЭП", 17, 156, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Показывает все сохраненные ранее пароли от ЭП")
		
		$checkSysInfo = GUICtrlCreateCheckbox(" Отчет о системе", 17, 189, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Отчет о системных характеристиках и комплектующих")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$group_os_tools = GUICtrlCreateGroup("Доп. утилиты", 8, 237, 193, 137)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkProduKey = GUICtrlCreateCheckbox(" Серийные номера", 17, 257, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для сохранения серийных номеров от различных программ (криптопро, арм, офис, ос)")
		
		$check_pwd = GUICtrlCreateCheckbox(" PasswordCrack", 17, 290, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Показывает скрытый под звездочками пароль")
		
		$checkC = GUICtrlCreateCheckbox(" Visual C++ 05-17", 17, 323, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Microsoft Visual C++ 2005-2008-2010-2012-2013-2017 Redistributable Package Hybrid x86  x64")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$group_folders = GUICtrlCreateGroup("Часто используемые папки", 216, 37, 193, 337)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$L_NotaryFolder = GUICtrlCreateLabel(" Дистрибутив помощника", 227, 56, 178, 33, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_eis = GUICtrlCreateLabel(" Дистрибутив ЕИС Енот", 226, 89, 178, 33, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_profile = GUICtrlCreateLabel(" Профиль пользователя", 227, 122, 178, 33, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_hosts = GUICtrlCreateLabel(" Доменные имена Hosts", 226, 155, 178, 33, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_Logs = GUICtrlCreateLabel(" Журнал операций", 226, 188, 178, 33, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		GUICtrlSetCursor (-1, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
#EndRegion ### Конец - Вкладка - Системные настройки ###

Global $DummyEnd = GUICtrlCreateDummy()

#Region ### Начало - Кнопки ###
	$btnNewPk = GUICtrlCreateButton("Новый ПК", 2, 408, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$btnSpecialist = GUICtrlCreateButton("Тех. работник", 90, 408, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$btnDownloadOnly = GUICtrlCreateButton("Скачать", 178, 408, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	GUICtrlSetColor(-1, 0x000000)

	$btnInstall = GUICtrlCreateButton("Продолжить", 493, 404, 131, 33, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	GUICtrlSetColor(-1, 0x000000)
#EndRegion ### Конец - Кнопки ###

#Region ### Начало - Tray ###
Local $iSettings = TrayCreateMenu("Настройки") ; Создаем трей меню
Local $iOffline = TrayCreateItem("Offline - режим", $iSettings)
Local $iRemove = TrayCreateItem("Удалить ПО", $iSettings)
TrayCreateItem("")
Local $iChangelog = TrayCreateItem("Изменения")
Local $iAbout = TrayCreateItem("О программе")
TrayCreateItem("")
Local $iExit = TrayCreateItem("Выйти")

TraySetState($TRAY_ICONSTATE_SHOW) ; Показываем трей меню
#Region ### Конец - Tray ###

#Region ### Начало - Строка состояния ###
$StatusBar1 = _GUICtrlStatusBar_Create($HelperForm)
Dim $StatusBar1_PartsWidth[3] = [100, 200, -1]
_GUICtrlStatusBar_SetParts($StatusBar1, $StatusBar1_PartsWidth)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & @IPAddress1, 0)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & @ComputerName, 1)
_GUICtrlStatusBar_SetText($StatusBar1, "Готовность к установке", 2)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ; определяем статус бар
#Region ### Конец - Строка состояния ###


GUISetState(@SW_SHOW)

;~ $HelperChild = GUICreate($title, $width, $height, -1, -1, $GUI_SS_DEFAULT_GUI)
;~ 	GUISetFont(12, 400, 0, "Segoe UI")
;~ 	GUISetBkColor(0xf85252)
;~ 	GUISetState($GUI_HIDE, $HelperChild)

;~ $ListView = GUICtrlCreateList("", 0, 0, 628, 421, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOSEL), 0)


;~ $StatusBar2 = _GUICtrlStatusBar_Create($HelperChild)
;~ Dim $StatusBar2_PartsWidth[3] = [100, 200, -1]
;~ _GUICtrlStatusBar_SetParts($StatusBar2, $StatusBar2_PartsWidth)
;~ _GUICtrlStatusBar_SetText($StatusBar2, @TAB & @IPAddress1, 0)
;~ _GUICtrlStatusBar_SetText($StatusBar2, @TAB & @ComputerName, 1)
;~ _GUICtrlStatusBar_SetText($StatusBar2, "Готовность к установке", 2)
;~ GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ; определяем статус бар


#EndRegion ### END Koda GUI section ###

; _______________________Открытие формы_______________________


Global $AllCheckboxes[44] = [$checkActx_Browser, $checkARM, $checkBD, _
		$checkIE, $checkCerts, $checkCSP, _
		$checkEnot, $checkFNS, $checkFNS_Print, _
		$checkPDF, $checkPKI, $checkIrfan, $checkFastStone, _
		$checkFF, $checkC, $checkNet_35, _
		$checkHASP, $checkChrome, $checkAdobe, $checkWinSet, $checkSCP, $checkZIP, _
		$checkTM, $checkAnyDesk, $checkTrueConf, $checkMUpdate, $checkSQLBACKUP, $checkXML, _
		$checkStart, $checkLine, $check_pwd, $check_heidi, $checkShare, $checkProduKey, _
		$checkPunto, $checkAccess, $checkWin2PDF, $checkECPPass, $checkSysInfo, $checkIPScanner, _
		$checkXMLPad, $checkLibReg, $checkCleanUpdates, $checkFindRND] ; Массив из чекбоксов

If $Start_param_certs Then
	GUICtrlSetState($checkCerts, $GUI_CHECKED)
	GUISetState(@SW_HIDE)
	_Next()
	SplashTextOn("Статус", "Сертификаты успешно установлены ", 480, 45, -1, -1, 1, "", 16)
	Sleep(4000)
	Exit
EndIf

While 1
	$nMsg = GUIGetMsg()

	 If _IsPressed("01") Then ToolTip("")

	Switch $nMsg
		Case $GUI_EVENT_CLOSE ; Выход
			Exit

		; Оффлайн - режим
		Case $menuOffline
			$offline = IniRead($dir_distr & $VersionInfo, "MODE", "Offline", "0")
			Switch $offline
				Case 1
					$offline = 0
					$title = StringTrimRight($title, 16)
				Case 0
					$title = $title & " | Оффлайн режим"
					$offline = 1
			EndSwitch
			WinSetTitle($HelperForm,"",$title)
			IniWrite($dir_distr & $VersionInfo, "MODE", "Offline", $offline)

		; Самоуничтожение программы
		Case $menuDelete
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(33,"Удалить ПО","Данное действие приведёт к удалению программы, вы уверены?")
			Select
				Case $iMsgBoxAnswer = 1 ;OK
					FileDelete(@DesktopDir & "\" & $HelperName)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_enot & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_tools & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_logs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_update & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ecp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_express & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_federal & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_software & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_certs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ppdgr & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & "_main.exe" & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & $MainApp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f /Q "' & $dir_distr & $VersionInfo & '"', @TempDir, "", @SW_HIDE)
					Exit

			   Case $iMsgBoxAnswer = 2 ;Cancel
				ContinueCase
			EndSelect

		; О программе
		Case $menuAbout
			MsgBox($MB_SYSTEMMODAL, "", "" & @CRLF & _
					"Ситников Виталий" & @CRLF & _
					"Нотариальная палата Свердловской области" & @CRLF & _
					"it@npso66.ru")

		; История изменений
		Case $menuChangelog
			ShellExecute("http://" & $User & ":" &$Pass & "@" & $Server & "/Statistic/index.html")

		; Часто используемые папки
		Case $L_NotaryFolder
			Run("explorer.exe " & $dir_distr)

		Case $L_eis
			Run("explorer.exe " & $dir_enot)

		Case $L_profile
			Run("explorer.exe " & @UserProfileDir & "\AppData")

		Case $L_hosts
			Run("explorer.exe " & @WindowsDir & "\System32\drivers\etc")

		Case $L_Logs
			Run("explorer.exe " & $dir_logs)

		; Кнопки

		Case $btnDownloadOnly ; Кнопка СКАЧАТЬ
				_Next("Загрузка завершена", True)
;~ 				test()

		Case $btnInstall ; Кнопка УСТАНОВИТЬ
				_Next()

	EndSwitch

	Switch TrayGetMsg()
		Case $iOffline
			$offline = IniRead($dir_distr & $VersionInfo, "MODE", "Offline", "0")
			Switch $offline
				Case 1
					$offline = 0
					$title = StringTrimRight($title, 16)
				Case 0
					$title = $title & " | Оффлайн режим"
					$offline = 1
			EndSwitch
			WinSetTitle($HelperForm,"",$title)
			IniWrite($dir_distr & $VersionInfo, "MODE", "Offline", $offline)

		Case $iRemove
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(33,"Удалить ПО","Данное действие приведёт к удалению программы, вы уверены?")
			Select
				Case $iMsgBoxAnswer = 1 ;OK
					FileDelete(@DesktopDir & "\" & $HelperName)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_enot & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_tools & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_logs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_update & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ecp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_express & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_federal & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_software & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_certs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ppdgr & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & "_main.exe" & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & $MainApp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f /Q "' & $dir_distr & $VersionInfo & '"', @TempDir, "", @SW_HIDE)
					Exit

			   Case $iMsgBoxAnswer = 2 ;Cancel
				ContinueCase
			EndSelect

		Case $iAbout 
			MsgBox($MB_SYSTEMMODAL, "", @CRLF & _
					"Ситников Виталий" & @CRLF & _
					"Нотариальная палата Свердловской области" & @CRLF & _
					"it@npso66.ru")

		Case $iChangelog
			ShellExecute("http://" & $User & ":" &$Pass & "@" & $Server & "/Statistic/index.html")

		Case $iExit ; выход
			Exit
	EndSwitch
WEnd
GUIDelete($HelperForm)
Exit

Func test()
;~ 	Local Static $toggle = True
;~     $toggle = Not $toggle

;~ 	If $toggle Then
;~ 		GUISetState(@SW_HIDE, $HelperForm)

;~ 	Else

;~ 	For $Loop = $DummyStart + 1 To $DummyEnd - 1
;~ 		If GUICtrlRead($Loop) = $GUI_CHECKED Then GUICtrlCreateListViewItem(GUICtrlRead($Loop, $GUI_READ_EXTENDED), $ListView)
;~     Next

;~ 		GUISetState(@SW_HIDE, $HelperForm)
;~ 		GUISetState(@SW_SHOW, $HelperChild)
;~ 			While 1
;~                 Switch GUIGetMsg()
;~                     Case $GUI_EVENT_CLOSE
;~                         GUISetState(@SW_HIDE, $HelperChild)
;~                         GUISetState(@SW_SHOW, $HelperForm)
;~ 						_GUICtrlListView_DeleteAllItems($ListView)
;~                         ExitLoop
;~                 EndSwitch
;~             WEnd
;~ 	EndIf

;~ 	If Not $toggle Then
;~ 		GUICtrlSetState($ListView, $GUI_SHOW)
;~ 	EndIf
;~ 	If $toggle Then
;~ 		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))
;~ 		GUICtrlSetState($ListView, $GUI_HIDE)
;~ 	EndIf

EndFunc   ;==>Button1Click