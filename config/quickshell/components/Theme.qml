pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property color accent: "#F2CC4E"
    property color bg: "#14110e"
    property color fg: "#f5efe0"
    property color fg2: "#cdb99a"
    property color good: "#5fd068"
    property color mid: "#F2CC4E"
    property color bad: "#e05252"

    function parse(content) {
        var lines = content.split("\n")
        for (var i = 0; i < lines.length; i++) {
            var l = lines[i].trim()
            if (l === "" || l.charAt(0) === "#") continue
            var p = l.indexOf("=")
            if (p < 0) continue
            var k = l.substring(0, p).trim()
            var v = l.substring(p + 1).trim()
            if (k === "accent") root.accent = v
            if (k === "bg") root.bg = v
            if (k === "text") root.fg = v
            if (k === "text2") root.fg2 = v
            if (k === "status_good") root.good = v
            if (k === "status_mid") root.mid = v
            if (k === "status_bad") root.bad = v
        }
    }

    FileView {
        path: Quickshell.env("HOME") + "/.config/halicha/palette.conf"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.parse(text())
    }
}



