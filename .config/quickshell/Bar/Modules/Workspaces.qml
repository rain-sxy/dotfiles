import Quickshell
import Quickshell.I3
import QtQuick

Repeater {
  id: workspacesRoot
  model: 5

  delegate: Item {
    id: workspaces
    height: parent.height
    width: 40

    required property int index
    readonly property int wsNum: index + 1
    readonly property var ws: I3.workspaces.values.find(w => w.number === wsNum)
    readonly property bool occupied: ws !== undefined
    readonly property bool focused: I3.focusedWorkspace !== null
    && I3.focusedWorkspace !== undefined
    && I3.focusedWorkspace.number === wsNum

    Rectangle {
      anchors.fill: parent
      color: "#00000000"

      Rectangle {
        anchors.bottom: parent.bottom
        height: 2
        width: parent.width
        color: secondaryColor
        visible: workspaces.focused
      }
    }

    Text {
      anchors.centerIn: parent
      text: workspaces.wsNum
      font.pixelSize: 20
      color: focused ? secondaryColor : fontColor
      font.family: "Hasklug Nerd Font"
    }

    MouseArea {
      id: workspaceMouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onPressed: mouse => {
        if (mouse.button === Qt.LeftButton)
        I3.dispatch("workspace number " + workspaces.wsNum)
      }
    }
  }
}
