//
// Implements custom action button with icon
//
// 09 Jun 2024 Mateus Vasco (mateusvascosc@gmail.com)
//

import QtQuick 6.7
import QtQuick.Controls 6.7

Item {
	id : lsButton

	property bool enabled : true

	property int buttonSize : 56

	property alias buttonWidth : lsButtonBg.width	
	property alias buttonHeight : lsButtonBg.height

	property alias iconWidth : lsButtonIcon.width	
	property alias iconHeight : lsButtonIcon.height

	property alias icon : lsButtonIcon.source
	property alias label : lsButtonLabel.text
	property alias font : lsButtonLabel.font

	property color bgColor : "#1E1E1E"
	property color iconColor : "#D2D2D2"
	property color labelColor : "#D2D2D2"

	property color hoverBgColor : "#282828"
	property color hoverIconColor : "#D2D2D2"
	property color hoverLabelColor : "#D2D2D2"

	property color pressBgColor : "#323232"
	property color pressIconColor : "#FFFFFF"
	property color pressLabelColor : "#FFFFFF"

	property color borderColor : "#D2D2D2"
	property color disableColor : "#141414"

	signal pressed()
	signal released()
	signal clicked()

	//
	// Button box
	//
	Rectangle {
		id : lsButtonBg
		width : buttonSize
		height : buttonSize
		radius : 0
		color : bgColor

		//
		// Button Border
		//
		Rectangle {
			id : lsButtonBorder
			width : 5
			height : parent.height
			color : bgColor
		}

		//
		// Button Icon
		//
		Item{
			anchors.centerIn : parent
			IconImage {
				id : lsButtonIcon
				color : labelColor
				mipmap : true
				anchors.centerIn : parent
				width : buttonSize*0.75
				height : buttonSize*0.75
				sourceSize : Qt.size((buttonSize*0.75),(buttonSize*0.75))
				source : ""
			}
		}

		//
		// Button Text
		//
		Text {
			anchors.centerIn : lsButtonBg
			id : lsButtonLabel
			text : ""
			color : labelColor
			font.pixelSize : 40
		}
	}

	//
	// States and associated visual attributes
	//
	states : [
		State {
			name : "disabled"
			when : (lsButton.enabled === false)
			PropertyChanges {
				target : lsButton
				opacity : 0
			}
			PropertyChanges {
				target : mouseInput
				enabled : false
			}
		},

		State {
			name : "hover"
			PropertyChanges {
				target : lsButtonBg
				color : hoverBgColor
			}
			PropertyChanges {
				target : lsButtonIcon
				color : hoverIconColor
			}
			PropertyChanges {
				target : lsButtonLabel
				color : hoverLabelColor
			}	
			PropertyChanges {
				target : lsButtonBorder
				color : borderColor
			}
		},

		State {
			name : "pressed"
			PropertyChanges {
				target : lsButtonBg
				color : pressBgColor
			}
			PropertyChanges {
				target : lsButtonIcon
				color : pressIconColor
			}
			PropertyChanges {
				target : lsButtonLabel
				color : pressLabelColor
			}
			PropertyChanges {
				target : lsButtonBorder
				color : borderColor
			}
		}
	]

	//
	// Behavior on state transitions
	//
	transitions : [
		Transition {
			from : ""
			to : "hover"
			ColorAnimation {duration : 200}
		},

		Transition {
			from : ""
			to : "pressed"
			ColorAnimation {duration : 100}
		},

		Transition {
			from : "disabled"
			to : ""
			NumberAnimation {
				target : lsButton
				property : "opacity"
				from : 0
				to : 1
				duration : 150
			}
		},

		Transition {
			from : ""
			to : "disabled"
			NumberAnimation {
				target : lsButton
				property : "opacity"
				from : 1
				to : 0
				duration : 150
			}
		}
	]

	//
	// Key navigation handler
	//
	Keys.onPressed : 
	(event)=> { if ((event.key == Qt.Key_Enter) ||
	(event.key == Qt.Key_Return) ||
	(event.key == Qt.Key_Space)) {
		lsButton.clicked()
		lsButton.state = "pressed"
	}}
	Keys.onReleased : 
	(event)=> { if ((event.key == Qt.Key_Enter) ||
	(event.key == Qt.Key_Return) ||
	(event.key == Qt.Key_Space)) {
		lsButton.state = activeFocus ? "hover" : "" 
	}}
	onActiveFocusChanged : {
		lsButton.state = activeFocus ? "hover" : "" 
	}


	//
	// Area to react to mouse actions
	//
	MouseArea {
		id : mouseInput
		enabled : true
		anchors.fill : lsButton
		hoverEnabled : true
		cursorShape : Qt.PointingHandCursor
		acceptedButtons : Qt.LeftButton

		onEntered : {lsButton.state = "hover"}
		onExited : {lsButton.state = parent.activeFocus ? "hover" : ""}
		onPressed : {lsButton.state = "pressed"}
		onClicked : {lsButton.clicked()}
		onReleased : {lsButton.state = 
		(containsMouse || parent.activeFocus) ?
		"hover" : 
		""}
	}
}
