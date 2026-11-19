import QtQuick
import "."
import Quickshell
import Quickshell.Services.UPower

Item {
	id:root

	property bool shown: true

	opacity: shown ? 1 : 0
	visible: opacity > 0
	Behavior on opacity {
		NumberAnimation { duration: 150 }
	}

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	readonly property var battery: UPower.displayDevice

	readonly property bool charging: battery.ready && battery.state === UPowerDeviceState.Charging

	readonly property bool low: battery.ready && !charging && battery.state !== UPowerDeviceState.FullyCharged && battery.percentage < 0.2

	Text {
		anchors.centerIn: parent
		text: Qt.formatDateTime(clock.date, "HH:mm")
		color: Theme.fg
		font.bold: true
		font.family: "monospace"
		font.pixelSize: 18
	}

	Rectangle {
		anchors.right: parent.right
		anchors.rightMargin: 16
		anchors.verticalCenter: parent.verticalCenter
		width: 10
		height: 10
		radius: 5
		visible: root.charging || root.low
		color: root.charging ? Theme.good : Theme.bad
	}
}
