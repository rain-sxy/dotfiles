import Quickshell
import Quickshell.Io
import Quickshell.I3
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Networking
import QtQuick

import "./Bar/Modules" as Modules

//TODO audio, wallpapers, bluetooth?

PanelWindow {
  id: panelWindow
  anchors {
    top: true
    left: true
    right: true
  }
  implicitHeight: 30

  readonly property color bgColor: Colors.md3.background
  readonly property color fontColor: Colors.md3.primary
  readonly property color secondaryColor: Colors.md3.tertiary

  color: bgColor

  Row {
    id: leftRow
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height
    spacing: 0

    Modules.Workspaces {}

    Modules.MprisPlayer {}
  }


  Modules.Clock {
    anchors.centerIn: parent
  }

  Row {
    id: rightRow
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height

    Modules.WiFiIndicator {}

    Modules.BatteryIndicator {}

    Modules.PowerOptions {}
  }
}
