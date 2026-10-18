import Quickshell
import QtQuick

Item {
  id: clockRoot
  height: parent.height
  implicitWidth: clockLabel.implicitWidth

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Text {
    id: clockLabel

    font.pixelSize: 20
    color: fontColor
    font.family: "Hasklug Nerd Font"
    text: Qt.formatDateTime(clock.date, "hh:mm AP")
  }
}

