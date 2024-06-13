import QtQuick 6.7
import QtQuick.Controls 6.7

Text {
	property alias label: lsFadText.text
	property alias font: lsFadText.font
	property alias state: lsFadText.state

	id: lsFadText
	anchors.centerIn : parent
	opacity : 0
	text : ""
	font.pixelSize : 18

	states: [
		State {
			name: "active"
			PropertyChanges { target: lsFadText; opacity: 1; }
		},
		State {
			name: ""
			PropertyChanges { target: lsFadText; opacity: 0; }
		}
	]

	transitions: [
		Transition { to: "active"
			NumberAnimation { target: lsFadText; property: "opacity"; from: 0; to: 1; duration: 150; }
		},
		Transition { to: ""
			NumberAnimation { target: lsFadText; property: "opacity"; from: 1; to: 0; duration: 150; }
		}
	]
}

