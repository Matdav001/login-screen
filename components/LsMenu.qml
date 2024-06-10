//
// Implements custom menu button with labels
//
// 09 Jun 2024 Mateus Vasco (mateusvascosc@gmail.com)
//

import QtQuick
import QtQuick.Controls

ComboBox {

	property int menuSize : 56
	property int labelSize : 16

	property color bgColor : "#1E1E1E"
	property color labelColor : "#D2D2D2"

	property color hoverBgColor : "#282828"
	property color hoverLabelColor : "#D2D2D2"

	property color pressedBgColor : "#323232"
	property color pressedLabelColor : "#FFFFFF"

	property color borderColor : "#D2D2D2"
	property color disableColor : "#141414"
	property alias menuState : ls_menu.state

	property bool lsModel : true
	property int lsIndex : ls_menu.currentIndex
	property string lsText : ls_menu.displayText

	id : ls_menu
	model : {if (lsModel)
	sessionModel
	else
	userModel}
	textRole : "name"
	height : menuSize
	width : menuSize*2 + menuSize/4
	z : 100

	//
	// Item that populates each model inside a box for presentation
	//
	delegate : ItemDelegate {
		id : ls_menu_item
		width : ls_menu.width
		height : menuSize/2
		//
		// Background theme
		//
		background : Rectangle {
			id : ls_menu_selected
			visible : ls_menu_item.down || 
			ls_menu_item.highlighted || 
			ls_menu_item.visualFocus
			color : ls_menu_item.down ? 
			pressedBgColor : (ls_menu_item.highlighted ? 
			hoverBgColor : bgColor)
			Rectangle {
				height : menuSize/2
				width : 5
				visible : ls_menu_item.down || 
				ls_menu_item.highlighted
				color : borderColor
			}
		}
		//
		// Text settings
		//
		contentItem : Text {
			text : model.name
			padding : 0
			leftPadding : 10
			font.pixelSize : labelSize
			color : labelColor
			elide : Text.ElideRight
			verticalAlignment : Text.AlignVCenter
		}
		highlighted : ls_menu.highlightedIndex === index
		HoverHandler {
			cursorShape : Qt.PointingHandCursor
		}
	}

	//
	// Set Canvas (arrow on the side)
	//
	indicator : Canvas {
		width : 0
		height : 0
	}

	//
	// Big text with the selected model
	//
	contentItem : Text {
		id : ls_menu_label
		leftPadding : 10
		rightPadding : ls_menu.indicator.width + ls_menu.spacing
		text : ls_menu.displayText
		font.pixelSize : labelSize * 1.5
		color : labelColor
		verticalAlignment : Text.AlignVCenter
		elide : Text.ElideRight
	}

	//
	// Background theme
	//
	background : Rectangle {
		id : ls_menu_bg
		width : menuSize*2 + menuSize/4
		height : menuSize
		color : bgColor
		Rectangle {
			id : ls_menu_border
			height : menuSize 
			width : 5
			color : bgColor
		}			
	}

	//
	// Popup to select from model
	//
	popup : Popup {
		id : ls_menu_popup
		y : ls_menu.height + menuSize/4
		height : menuSize
		width : menuSize*2 + menuSize/4
		padding : 0
		contentItem : ListView {
			height : menuSize
			clip : true
			model : ls_menu.popup.visible ? ls_menu.delegateModel : null
			currentIndex : ls_menu.highlightedIndex
		}
		background : Rectangle {
			color : bgColor
			width : ls_menu_popup.width
			height : ls_menu_popup.height
		}			
	}

	//
	// States and associated visual attributes
	//
	states : [
		State { 
			name : "disabled"
			when : (ls_menu.enabled === false)
			PropertyChanges {
				target : ls_menu_bg
				color : disableColor
			}
			PropertyChanges {
				target : ls_menu_label
				color : disableColor
			}
			PropertyChanges {
				target : ls_menu_border
				color : disableColor
			}
		},

		State {	
			name : "hover"
			when : ls_menu.hovered
			PropertyChanges {
				target : ls_menu_bg
				color : hoverBgColor
			}
			PropertyChanges {
				target : ls_menu_label
				color : hoverLabelColor
			}
			PropertyChanges {
				target : ls_menu_border
				color : borderColor
			}
		},

		State { 
			name : "pressed"
			PropertyChanges {
				target : ls_menu_label
				color : pressedLabelColor
			}
			PropertyChanges {
				target : ls_menu_bg
				color : pressedBgColor
			}
			PropertyChanges {
				target : ls_menu_border
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
			to : "enabled"
			ColorAnimation {duration : 100}
		},

		Transition {
			from : "enabled"
			to : "disabled"
			ColorAnimation {duration : 100}
		}
	]

	//
	// Handles button focus for keyboard navigation
	//
	onActiveFocusChanged : {ls_menu.state = activeFocus ? "hover" : ""}

	Keys.onPressed : 
	(event)=> { if ((event.key == Qt.Key_Enter) ||
	(event.key == Qt.Key_Return) || 
	(event.key == Qt.Key_Space) ) {
		menuState = "pressed"
	}}
	Keys.onReleased : 
	(event)=> { if ((event.key == Qt.Key_Enter) ||
	(event.key == Qt.Key_Return) || 
	(event.key == Qt.Key_Space) ) {
		menuState = activeFocus ? "hover" : ""
	}}

	//
	// Area to react to mouse actions
	//
	MouseArea {
		z : 99
		anchors.fill : ls_menu_bg

		hoverEnabled : true
		cursorShape : Qt.PointingHandCursor
		acceptedButtons : Qt.LeftButton

		onPressed : {ls_menu.state = "pressed"}
		onClicked : {ls_menu.popup.visible ^= 1}
		onReleased : {if (containsMouse) 
		ls_menu.state = "hover"
		else ls_menu.state = ""}
	}

}
