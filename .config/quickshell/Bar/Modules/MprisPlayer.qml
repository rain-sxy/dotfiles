import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Item {
  id: mprisPlayerRoot
  height: parent.height
  width: 200

  Rectangle {
    id: mprisPlayer
    height: parent.height
    width: 200
    clip: true
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

