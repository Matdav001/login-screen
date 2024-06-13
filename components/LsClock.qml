import QtQuick 6.7

Column {
	id: container

	property date dateTime: new Date()
	property color color: "white"
	property alias timeFont: time.font
	property alias dateFont: date.font

	Timer {
		interval: 100; running: true; repeat: true;
		onTriggered: container.dateTime = new Date()
	}

	Text {
		id: time
		anchors.horizontalCenter: parent.horizontalCenter

		color: container.color
		text : Qt.formatTime(container.dateTime, "hh:mm")
		font.pointSize: 96
	}

	Text {
		id: date
		anchors.horizontalCenter: parent.horizontalCenter

		color: container.color
		text : Qt.formatDate(container.dateTime, "dddd,  dd / MMM / yyyy")
		font.pointSize: 16
	}
}
