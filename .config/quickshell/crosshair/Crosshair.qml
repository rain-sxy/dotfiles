import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    mask: Region {
    }

    Item {
        id: crosshair

        anchors.centerIn: parent

        width: 14
        height: 14

        Rectangle {
            anchors.centerIn: parent
            width: 2
            height: 14
            color: "#ffffff"
            opacity: 0.5
        }

        Rectangle {
            anchors.centerIn: parent
            width: 14
            height: 2
            color: "#ffffff"
            opacity: 0.5
        }
    }
}
