import QtQuick
import "."

Row {
	property string label: ""
	property string value: ""

	Text {
		width: 110
		text: parent.label
		color: Theme.accent
		font.bold: true
		font.family: "monospace"
		font.pixelSize: 13
	}

	Text {
		text: parent.value
		color: Theme.fg
		font.bold: true
		font.family: "monospace"
		font.pixelSize: 13
	}
}
