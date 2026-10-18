import Quickshell
import Quickshell.Io
import QtQuick

Item {
  height: parent.height

  readonly property int margin: 10
  implicitWidth: powerOptionsLabel.implicitWidth + margin

  Rectangle {
    id: powerOptions
    height: parent.height
    implicitWidth: powerOptionsLabel.implicitWidth + margin
    color: "#00ff0000"

    Text {
      id: powerOptionsLabel
      anchors.centerIn: parent

      font.pixelSize: 20
      color: fontColor
      font.family: "Hasklug Nerd Font"
      text: ""
    }

    Process {
      id: logOut
      command: ["i3-msg", "exit"]
    }

    MouseArea {
      id: workspaceMouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onPressed: mouse => {
        if (mouse.button === Qt.LeftButton)
          logOut.running = true
      }
    }
  }
}
