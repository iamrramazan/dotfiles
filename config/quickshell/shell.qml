import QtQuick
import Quickshell
import Quickshell.Wayland
import "components"
import Quickshell.Io
import Quickshell.Services.UPower

PanelWindow {
	id: panel

	property int gap: 8
	property bool shotFlash: false
	property color flashColor: Theme.fg

	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: capsule.expandedHeight + gap

	color: "transparent"

	exclusionMode: ExclusionMode.Normal

	exclusiveZone: gap + capsule.collapsedHeight - 12

	WlrLayershell.layer: WlrLayer.Top

	mask: Region { item: capsule }

	Capsule {
		id: capsule

		expandedWidth: 520
		expandedHeight: 320

		anchors.top: parent.top
		anchors.topMargin: panel.gap
		anchors.horizontalCenter: parent.horizontalCenter

		StatusPill {
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			height: capsule.collapsedHeight
			shown: !capsule.expanded
		}
		
		InfoPanel {
			active: capsule.expanded
		}
		Rectangle {
			width: 10
			height: 10
			radius: 5
			color: panel.flashColor
			anchors.left: parent.left
			anchors.leftMargin: 16
			anchors.top: parent.top
			anchors.topMargin: (capsule.collapsedHeight - height) / 2
			opacity: (panel.shotFlash && !capsule.expanded) ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 200} }
		}
	}

	IpcHandler {
		target: "island"

		function screenshot(): void {
			panel.flashColor = Theme.fg
			panel.shotFlash = true
			shotTimer.restart()
		}
	
		function toggle(): void {
			capsule.expanded = !capsule.expanded
		}
	}

	Timer {
		id: shotTimer
		interval: 1500
		onTriggered: panel.shotFlash = false
	}

	// следим за сменой профиля питания
	Connections {
		// источник сигналов: сервис профилей питания
		target: PowerProfiles
		// эта функция срабатывает, когда профиль сменился
		function onProfileChanged() {
			// power-saver зелёный, balanced жёлтый, performance красный
			panel.flashColor = PowerProfiles.profile === PowerProfile.PowerSaver ? Theme.good : (PowerProfiles.profile === PowerProfile.Balanced ? Theme.mid : Theme.bad)
			// включаем вспышку точки
			panel.shotFlash = true
			// запускаем таймер погасания (1,5 с)
			shotTimer.restart()
		}
	}
}
