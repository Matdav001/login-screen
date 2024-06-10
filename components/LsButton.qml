//
// Implements custom action button with icon
//
// 09 Jun 2024 Mateus Vasco (mateusvascosc@gmail.com)
//

import QtQuick
import Qt5Compat.GraphicalEffects

Item {
	id : ls_button

	property bool enabled : true

	property int buttonSize : 56

	property alias buttonWidth : ls_button_bg.width	
	property alias buttonHeight : ls_button_bg.height

	property alias iconWidth : ls_button_img.width	
	property alias iconHeight : ls_button_img.height

	property alias icon : ls_button_img.source
	property alias label : ls_button_label.text
	property alias font : ls_button_label.font

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
			id : ls_button_bg
			width : buttonSize
			height : buttonSize
			radius : 0
			color : bgColor

			//
			// Button Border
			//
			Rectangle {
				id : ls_button_border
				width : 5
				height : parent.height
				color : bgColor
			}

			//
			// Button Icon
			//
			Image {
				mipmap : true
				id : ls_button_img
				anchors.centerIn : parent
				width : buttonSize*0.75
				height : buttonSize*0.75
				sourceSize : Qt.size((buttonSize*0.75),(buttonSize*0.75))
				source : ""
			}

			//
			// Button Icon Color
			//
			ColorOverlay {
				id : ls_button_icon
				anchors.fill : ls_button_img
				source : ls_button_img
				color : iconColor
			}

		//
		// Button Text
		//
		Text {
			anchors.centerIn : ls_button_bg
			id : ls_button_label
			text : ""
			color : labelColor
			font.pixelSize : 24
		}
	}

	//
	// States and associated visual attributes
	//
	states : [
		State {
			name : "disabled"
			when : (ls_button.enabled === false)
			PropertyChanges {
				target : ls_button_img
				source : ""
			}
			PropertyChanges {
				target : ls_button_bg
				color : disableColor
			}
			PropertyChanges {
				target : ls_button_icon
				color : disableColor
			}
			PropertyChanges {
				target : ls_button_label
				color : disableColor
			}
			PropertyChanges {
				target : ls_button_border
				color : disableColor
			}
		},

		State {
			name : "hover"
			PropertyChanges {
				target : ls_button_bg
				color : hoverBgColor
			}
			PropertyChanges {
				target : ls_button_icon
				color : hoverIconColor
			}
			PropertyChanges {
				target : ls_button_label
				color : hoverLabelColor
			}	
			PropertyChanges {
				target : ls_button_border
				color : borderColor
			}
		},

		State {
			name : "pressed"
			PropertyChanges {
				target : ls_button_bg
				color : pressBgColor
			}
			PropertyChanges {
				target : ls_button_icon
				color : pressIconColor
			}
			PropertyChanges {
				target : ls_button_label
				color : pressLabelColor
			}
			PropertyChanges {
				target : ls_button_border
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
			ColorAnimation {duration : 50}
		},

		Transition {
			from : ""
			to : "pressed"
			ColorAnimation {duration : 25}
		},

		Transition {
			from : "disabled"
			to : ""
			ColorAnimation {duration : 100}
		},

		Transition {
			from : ""
			to : "disabled"
			ColorAnimation {duration : 100}
		}
	]

	//
	// Key navigation handler
	//
	Keys.onPressed : 
	(event)=> { if ((event.key == Qt.Key_Enter) ||
	(event.key == Qt.Key_Return) ||
	(event.key == Qt.Key_Space)) {
		ls_button.clicked()
		ls_button.state = "pressed"
	}}
	Keys.onReleased : 
	(event)=> { if ((event.key == Qt.Key_Enter) ||
	(event.key == Qt.Key_Return) ||
	(event.key == Qt.Key_Space)) {
		ls_button.state = activeFocus ? "hover" : "" 
	}}
	onActiveFocusChanged : {
		ls_button.state = activeFocus ? "hover" : "" 
	}


	//
	// Area to react to mouse actions
	//
	MouseArea {
		anchors.fill : ls_button
		hoverEnabled : true
		cursorShape : ls_button.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
		acceptedButtons : Qt.LeftButton

		onEntered : {if(ls_button.enabled) ls_button.state = "hover"}
		onExited : {if(ls_button.enabled) ls_button.state = ""}
		onPressed : {if(ls_button.enabled) ls_button.state = "pressed"}
		onClicked : {if(ls_button.enabled) ls_button.clicked()}
		onReleased : { 
		if (containsMouse && ls_button.enabled) ls_button.state = "hover" 
		else if (ls_button.enabled) ls_button.state = ""}
	}
}
