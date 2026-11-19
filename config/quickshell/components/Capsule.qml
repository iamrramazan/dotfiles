import QtQuick
import "."

Rectangle {
	id: root

	property bool expanded: false

	property int collapsedWidth: 150
	property int collapsedHeight: 35

	property int expandedWidth: 520
	property int expandedHeight: 400

	default property alias content: contentArea.data

	width: collapsedWidth
	height: collapsedHeight
	radius: collapsedHeight / 2
	color: Theme.bg
	clip: true

	states: State {
			name: "expanded"
			when: root.expanded

		PropertyChanges {
			target: root
			width: root.expandedWidth
			height: root.expandedHeight
			radius: 50
			}
		}

	transitions: Transition {
		NumberAnimation {
			properties: "width,height,radius"
			duration: 300
			easing.type: Easing.OutQuart
			}
		}

	Item {
		id: contentArea
		anchors.fill: parent
		}

	TapHandler {
		enabled: false
		onTapped: root.expanded = !root.expanded
		}
	}
