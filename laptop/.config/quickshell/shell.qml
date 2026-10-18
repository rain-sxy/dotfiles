import Quickshell
import Quickshell.Io
import Quickshell.I3
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Networking
import QtQuick

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
  readonly property color fontColor: "#a1d399"
  readonly property color secondaryColor: "#a0cfd4"

  color: bgColor
  Row {
    id: leftRow
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height
    spacing: 0

    Repeater {
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

    Rectangle {
      id: mprisPlayer
      height: parent.height
      width: 200
      clip: true
      anchors.leftMargin: 5
      anchors.rightMargin: 5
      color: "#0000ff00"

      property var player: Mpris.players.values[0] ?? null
      readonly property string trackText: player ? "  " + player.trackTitle + " - " + player.trackArtist : "Nothing Playing"

      readonly property real gapSize: 40
      readonly property real loopWidth: trackLabel1.implicitWidth + gapSize

      Item {
        id: scrollContainer
        height: parent.height
        width: trackLabel1.implicitWidth * 2
        x: 0

        Text {
          id: trackLabel1
          anchors.verticalCenter: parent.verticalCenter
          x: implicitWidth > mprisPlayer.width ? 0 : (mprisPlayer.width - implicitWidth) / 2

          font.pixelSize: 20
          color: fontColor
          font.family: "Hasklug Nerd Font"
          text: mprisPlayer.trackText
        }

        Text {
          id: trackLabel2
          anchors.verticalCenter: parent.verticalCenter
          x: mprisPlayer.loopWidth

          font.pixelSize: 20
          color: fontColor
          font.family: "Hasklug Nerd Font"
          text: mprisPlayer.trackText
          visible: trackLabel1.implicitWidth > mprisPlayer.width ? true : false
        }

        NumberAnimation on x {
          id: scrollAnimation

          from: 0
          to: -mprisPlayer.loopWidth
          duration: Math.max(2000, mprisPlayer.loopWidth * 25)
          loops: Animation.Infinite
          running: trackLabel1.implicitWidth > mprisPlayer.width ? true : false

          onRunningChanged: { if (!running) scrollContainer.x = 0; }
        }
      }
    }
  }

  Row {
    id: centerRow
    anchors.centerIn: parent

    SystemClock {
      id: clock
      precision: SystemClock.Seconds
    }

    Text {
      anchors.centerIn: parent

      font.pixelSize: 20
      color: fontColor
      font.family: "Hasklug Nerd Font"
      text: Qt.formatDateTime(clock.date, "hh:mm:ss")
    }
  }

  Row {
    id: rightRow
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height
    width: 250
    Rectangle {
      id: wifiIndicator
      height: parent.height
      width: 150
      color: "#00ffff00"

      readonly property string connectedSsid: {
        const devices = Networking.devices.values;
        for (let i = 0; i < devices.length; i++) {
          const device = devices[i];
          if (device.type === DeviceType.Wifi) {
            const networks = device.networks.values;
            for (let j = 0; j < networks.length; j++) {
              const network = networks[j];
              if (network.connected) {
                return network.name;
              }
            }
          }
        }
        return "󰤮 No Wi-Fi"
      }
      Text {
        anchors.centerIn: parent

        font.pixelSize: 20
        color: fontColor
        font.family: "Hasklug Nerd Font"
        text: "  " + wifiIndicator.connectedSsid
      }
    }

    Rectangle {
      id: batteryIndicator
      height: parent.height
      width: 50
      color: "#00cc9ccc"

      property real percentage: UPower.displayDevice.percentage * 100
      Text {
        anchors.centerIn: parent

        font.pixelSize: 20
        color: fontColor
        font.family: "Hasklug Nerd Font"
        text: Math.round(batteryIndicator.percentage) + "%"
      }
    }

    Rectangle {
      id: powerOptions
      height: parent.height
      width: 50
      color: "#00ff0000"

      Text {
        anchors.centerIn: parent

        font.pixelSize: 20
        color: fontColor
        font.family: "Hasklug Nerd Font"
        text: "  "
      }

      MouseArea {
        id: workspaceMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => {
          if (mouse.button === Qt.LeftButton)
            return;
        }
      }
    }
  }
}
