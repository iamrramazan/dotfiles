import QtQuick

Row {
	property string label: ""
	property string value: ""

	Text {
		width: 110
		text: parent.label
		color: "#cdb99a"
		font.bold: true
		font.family: "monospace"
		font.pixelSize: 13
	}

	Text {
		text: parent.value
		color: "#ffffff"
		font.bold: true
		font.family: "monospace"
		font.pixelSize: 13
	}
}
