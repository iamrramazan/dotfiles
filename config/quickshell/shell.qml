import QtQuick
import Quickshell
import Quickshell.Wayland
import "components"
import Quickshell.Io

PanelWindow {
	id: panel

	property int gap: 8
	property bool shotFlash: false

	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: capsule.expandedHeight + gap

	color: "transparent"

	exclusionMode: ExclusionMode.Normal

	exclusiveZone: gap + capsule.collapsedHeight

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
			color: "#ffffff"
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
}
