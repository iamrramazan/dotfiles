import QtQuick
import "."
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Item {
    id: root

    property bool active: false
    signal closeRequested()

    anchors.fill: parent
    visible: active
    focus: true
    Keys.onEscapePressed: root.closeRequested()


    property string userHost: "…"
    property string hostText: "…"
    property string uptimeText: "…"
    property string cpuText: "…"
    property string memText: "…"
    property string diskText: "…"
    property string brightText: "…"
    property string volText: "…"

    readonly property var battery: UPower.displayDevice
    readonly property int batteryPercent: Math.round(battery.percentage * 100)
    readonly property bool charging: battery.state === UPowerDeviceState.Charging || battery.state === UPowerDeviceState.FullyCharged
    readonly property bool low: batteryPercent < 20 && !charging


    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }


    FileView {
        id: logoFile
        path: Quickshell.shellPath("assets/arch.txt")
        blockLoading: true
    }


    Process {
        id: userProc
        command: ["sh", "-c", "echo \"$USER@$(cat /etc/hostname)\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.userHost = text.trim()
        }
    }

    Process {
        id: hostProc
        command: ["cat", "/sys/class/dmi/id/product_name"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.hostText = text.trim()
        }
    }

    Process {
        id: uptimeProc
        command: ["cat", "/proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: {
                const secs = Number(text.trim().split(" ")[0])
                const h = Math.floor(secs / 3600)
                const m = Math.floor((secs % 3600) / 60)
                root.uptimeText = h + " ч " + m + " мин"
            }
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -n1 /proc/stat; sleep 1; head -n1 /proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const a = lines[0].trim().split(/\s+/).slice(1, 9).map(Number)
                const b = lines[1].trim().split(/\s+/).slice(1, 9).map(Number)
                const totalA = a.reduce((x, y) => x + y, 0)
                const totalB = b.reduce((x, y) => x + y, 0)
                const idleA = a[3] + a[4]
                const idleB = b[3] + b[4]
                const dTotal = totalB - totalA
                const dIdle = idleB - idleA
                const usage = dTotal > 0 ? (dTotal - dIdle) / dTotal : 0
                root.cpuText = Math.round(usage * 100) + "%"
            }
        }
    }

    Process {
        id: memProc
        command: ["free", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.split("\n").find(l => l.startsWith("Mem:")).trim().split(/\s+/)
                const total = Number(parts[1])
                const used = total - Number(parts[6])
                root.memText = (used / 1024).toFixed(1) + " / " + Math.round(total / 1024) + " GiB"
            }
        }
    }

    Process {
        id: diskProc
        command: ["df", "-h", "--output=avail", "/home"]
        stdout: StdioCollector {
            onStreamFinished: root.diskText = text.trim().split("\n")[1].trim() + " свободно"
        }
    }

    Process {
        id: brightProc
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const p = text.trim().split(",")[3]
                root.brightText = p ? p : "—"
            }
        }
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const v = Number(text.trim().split(" ")[1])
                root.volText = isNaN(v) ? "—" : Math.round(v * 100) + "%" + (text.includes("MUTED") ? " (muted)" : "")
            }
        }
    }


    Timer {
        interval: 1000
        repeat: true
        running: root.active
        triggeredOnStart: true
        onTriggered: {
            uptimeProc.running = true
            memProc.running = true
            diskProc.running = true
            brightProc.running = true
            volProc.running = true
            if (!cpuProc.running) cpuProc.running = true
        }
    }


    Text {
        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: Theme.fg
	font.bold: true
	font.family: "monospace"
        font.pixelSize: 18
    }

    Row {
        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.right: parent.right
        anchors.rightMargin: 30
        spacing: 6

        Rectangle {
            width: 6
            height: 6
            radius: 3
            visible: root.charging || root.low
            color: root.charging ? Theme.good : Theme.bad
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.batteryPercent + "%"
            color: Theme.fg
	    font.bold: true
	    font.family: "monospace"
            font.pixelSize: 18
        }
    }


    Item {
        anchors.left: parent.left
        anchors.leftMargin: 78
        anchors.verticalCenter: parent.verticalCenter
        width: 120
	anchors.verticalCenterOffset: 14
        height: 168

        Image {
            id: emblem
            anchors.fill: parent
            source: Qt.resolvedUrl("../assets/logo.svg")
            sourceSize: Qt.size(120, 168)
            visible: false
        }

        MultiEffect {
            anchors.fill: parent
            source: emblem
            colorization: 1.0
            colorizationColor: Theme.accent
        }
    }


    Column {
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
	anchors.verticalCenterOffset: 14
        spacing: 6

        Text {
            text: root.userHost
            color: Theme.accent
	    font.bold: true
            font.family: "monospace"
            font.pixelSize: 13
        }

        Item { width: 1; height: 8 }

        InfoRow { label: "Host"; value: root.hostText }
        InfoRow { label: "Uptime"; value: root.uptimeText }

        Item { width: 1; height: 10 }

        InfoRow { label: "CPU"; value: root.cpuText }
        InfoRow { label: "Memory"; value: root.memText }
        InfoRow { label: "Disk"; value: root.diskText }

        Item { width: 1; height: 10 }

        InfoRow { label: "Brightness"; value: root.brightText }
        InfoRow { label: "Volume"; value: root.volText }
    }
}


