//
// SDDM Theme
//

import QtQuick 6.7
import QtQuick.Controls 6.7
import SddmComponents 2.0

import "./components"

Rectangle {
	id : logScr

	//
	// Colors
	//
	property color background : "#141414"
	property color gray1 : "#1E1E1E"
	property color gray2 : "#282828"
	property color gray3 : "#323232"
	property color textColor : "#D2D2D2"
	property color wrongColor : "#D25050"

	//
	// Menus states
	//
	property bool menu1 : false
	property bool menu2 : false
	property bool menu3 : false

	//
	// Indicates one unit of measure (in pixels)
	//	
	readonly property int buttonSize : 56
	readonly property int menuSize : 56

	property bool showLocks: false

	TextConstants { id : textConstants }
	
	//
	// SDDM result Handler
	//
	Connections {
		target : sddm
	
		function onLoginFailed() {
			lgWorking.visible = false;
			lgWorkingAnim.stop()

			lgFailed.visible = true			
		}
	}

	//
	// Login Handler
	//
	signal tryLogin()
	onTryLogin : {
		lgFailed.visible = false
		lgWorking.visible = true;
		lgWorkingAnim.start()
		sddm.login(userMenu.displayText, passwordIn.text, winManMenu.currentIndex);
	}
	
	//
	// Fonts Loader
	//
	FontLoader {
		id : jetBrainsMono
		source : "fonts/JetBrainsMono.ttf"
	}
	
	//
	// Screen Loader
	//
	Repeater {
		model : screenModel
		Item {
			Rectangle {
				x : geometry.x
				y : geometry.y
				width : geometry.width
				height : geometry.height
				color : background
			}
		}
	}

	//
	// Configs menu
	//
	LsButton {
		id : configButton
		onClicked : 
		if (menu1) {
			if (passwordIn.focus == false && loginButton.focus == false)
			configButton.focus = true
			menu1 = false
			menu2 = false
			menu3 = false
		} else {
			menu1 = true
		}
		x : parent.width - buttonSize - buttonSize/4
		y : buttonSize/4
		width : buttonSize
		height : buttonSize
		label: "" 
	//	icon : "../images/gear-icon.svg"
		KeyNavigation.backtab : loginButton
		KeyNavigation.tab : menu1 ? winManButton : passwordIn
	}

	//
	// Window Manager button
	//
	LsButton {
		id : winManButton
		enabled : menu1
		onClicked : 
		if (menu2) {
			if (winManMenu.focus == true)
			winManButton.focus = true
			menu2 = false
		} else {
			menu3 = false
			menu2 = true
		}
		x : parent.width - buttonSize - buttonSize/4
		y : (buttonSize/4)*2 + buttonSize
		width : buttonSize
		height : buttonSize
		label : "󰹑"
		KeyNavigation.backtab : configButton
		KeyNavigation.tab : menu2 ? winManMenu : userButton
	}

	//
	// Window Manager menu
	//
	LsMenu {
		enabled : menu2 & menu1
		id : winManMenu
		x : parent.width - buttonSize*3 - (buttonSize/4)*3
		y : (buttonSize/4)*2 + buttonSize
		width : (buttonSize*2) + (buttonSize/4)
		height : buttonSize
		lsModel : true
		lsIndex : sessionModel.lastIndex		
		KeyNavigation.backtab : winManButton
		KeyNavigation.tab : userButton
	}

	//
	// User change button
	//
	LsButton {
		id : userButton
		enabled : menu1
		onClicked : 
		if (menu3) {
			if (userMenu.focus==true)
			userButton.focus = true
			menu3 = false
		} else {
			menu2 = false
			menu3 = true
		}
		x : parent.width - buttonSize - buttonSize/4
		y : (buttonSize/4)*3 + buttonSize*2
		width : buttonSize
		height : buttonSize
		label: ""
		font.pixelSize: 36
		KeyNavigation.backtab : menu2 ? winManMenu : winManButton
		KeyNavigation.tab : menu3 ? userMenu : rebootButton
	}

	//
	// User Manager menu
	//
	LsMenu {
		enabled : menu3 & menu1
		id : userMenu
		x : parent.width - buttonSize*3 - (buttonSize/4)*3
		y : (buttonSize/4)*3 + buttonSize*2
		width : (buttonSize*2) + (buttonSize/4)
		height : buttonSize
		lsModel : false
		lsIndex : sessionModel.lastIndex		
		KeyNavigation.backtab : userButton
		KeyNavigation.tab : rebootButton
	}

	//
	// Reboot button layout
	//
	LsButton {
		id : rebootButton
		enabled : menu1
		onClicked : sddm.reboot()
		x : parent.width - buttonSize - buttonSize/4
		y : (buttonSize/4)*4 + buttonSize*3
		width : buttonSize
		height : buttonSize
		label : ""
		KeyNavigation.backtab : menu3 ? userMenu : userButton
		KeyNavigation.tab : shutdownButton
	}

	//
	// Shutdown button layout
	//
	LsButton {
		id : shutdownButton 
		enabled : menu1
		onClicked : sddm.powerOff()
		x : parent.width - buttonSize - buttonSize/4
		y : (buttonSize/4)*5 + buttonSize*4
		width : buttonSize
		height : buttonSize
		label : ""
		KeyNavigation.backtab : rebootButton
		KeyNavigation.tab : passwordIn
	}

	//
	// Main Menu
	//
	Rectangle {
		x : (parent.width/2) - (4 * menuSize)
		y : (parent.height/2) - (4 * menuSize)
		width : (menuSize*8)
		height : (menuSize*8)
		color : gray1

		//
		// Clock
		//
		Rectangle {
			x : menuSize/4
			y : menuSize/4
			width : (parent.width - (menuSize/2))
			height : menuSize*3.75
			color : gray2
			LsClock {
				anchors.centerIn : parent
				color : textColor
			}
		}

		//
		// Display username text
		//
		Rectangle{
			x : menuSize/4 
			y : menuSize*4.25 
			width : (parent.width - (menuSize / 2))
			height : menuSize
			color : gray2
			Text {
				anchors.centerIn : parent
				text : userMenu.displayText
				color : textColor
				font.pixelSize : 40
			}
		}

		//
		// Box to write password
		//
		PasswordBox {
			id : passwordIn
			x : menuSize/4 + 5
			y : menuSize*5.5
			width : (parent.width - (menuSize / 2) - 5)
			height : menuSize
			color : activeFocus ? gray3 : gray2
			borderColor : activeFocus ? gray3 : gray2
			focusColor : activeFocus ? gray3 : gray2
			hoverColor : activeFocus ? gray3 : gray2
			textColor : "#D2D2D2"
			font.pixelSize : 24
			image : ""
			tooltipEnabled : false
			KeyNavigation.tab : loginButton
			KeyNavigation.backtab : menu1 ? shutdownButton : configButton 
			Keys.onReleased : (event)=> { if (
				(event.key == Qt.Key_Return) || 
				(event.key == Qt.Key_Enter)) {
					logScr.tryLogin()
					event.accepted = true
				}
			}
			Text {
				id : pass_holder
				x : 10
				y : (parent.height/2) -16
				text : (passwordIn.text == "") ? 
				textConstants.password : ""
				color : textColor
				font.pixelSize : 24
			}
		}
		Rectangle{
			x : passwordIn.x-5
			y : passwordIn.y
			width : 5
			height : menuSize
			color : passwordIn.activeFocus ? textColor : gray2
		}

		//
		// Login button
		//
		LsButton {
			id : loginButton
			x : showLocks ? menuSize*1.5 : menuSize/4 
			y : parent.height - menuSize*1.25
			width : showLocks ? menuSize*5 : menuSize*7.5
			height : menuSize
			buttonWidth : showLocks ? menuSize*5 : menuSize*7.5
			label : textConstants.login
			font.pixelSize : 32
			bgColor : gray2
			hoverBgColor : gray3
			KeyNavigation.tab : configButton
			KeyNavigation.backtab : passwordIn
			onClicked : logScr.tryLogin()
			Keys.onPressed : (event)=> { if (
				(event.key === Qt.Key_Return) || 
				(event.key === Qt.Key_Enter)) {
					logScr.tryLogin()
					event.accepted = true;
				}
			}
		}

		//
		// Shows if CapsLock is on
		//
		Rectangle {
			visible: showLocks
			x : menuSize/4
			y : parent.height - menuSize*1.25			
			width : menuSize
			height : menuSize
			color: gray2
			LsFadText{
				state : keyboard.capsLock ? "active" : ""
				color : textColor
				label : "󰪛"
				font.pixelSize: menuSize*0.9
			}
		}

		//
		// Shows if NumLock is on
		//
		Rectangle {
			visible: showLocks
			x : menuSize*6.75 
			y : parent.height - menuSize*1.25			
			width : menuSize
			height : menuSize
			color: gray2
			LsFadText{
				state : keyboard.numLock ? "active" : ""
				color : textColor
				label : "󰎣"
				font.pixelSize: menuSize*0.9
			}
		}
	}

	//
	// Loading animation
	//
	Rectangle {
		id : lgWorking
		x : (parent.width - menuSize)/2
		y : (parent.height - (menuSize*2)) 
		width : menuSize
		height : menuSize
		visible : false
		color : gray1
		Text {
			id : lgWorkingIndicator
			anchors.centerIn : parent
			text : "󰸴"
			font.pixelSize : 48
			color : textColor
		}
		SequentialAnimation {
			id : lgWorkingAnim
			running : false
			loops : Animation.Infinite
			RotationAnimation {
				target : lgWorkingIndicator
				from : 0
				to : 360
				duration : 1000
			}
		}
	}

	//
	// Login Failed icon
	//
	Rectangle {
		id : lgFailed
		x : (parent.width - menuSize)/2 - menuSize/4
		y : (parent.height - (menuSize*2) - menuSize/4)
		width : menuSize*1.5
		height : menuSize*1.5
		visible : false
		color : gray1
		Rectangle {
			x : menuSize/4
			y : menuSize/4
			width: menuSize
			height: menuSize
			color : gray2
			Text {
				id : wrongText
				anchors.centerIn : parent
				text : ""
				color : wrongColor
				font.pixelSize : 40
			}
		}
	}

	//
	// Focus password box on init
	//
	Component.onCompleted : {
		passwordIn.focus = true
	}
}
