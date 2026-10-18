import Quickshell
import Quickshell.Services.UPower
import QtQuick

Item {
  id: batteryIndicatorRoot
  height: parent.height

  readonly property int margin: 10
  implicitWidth: UPower.displayDevice.isLaptopBattery ? batteryIndicatorLabel.implicitWidth + margin : 0

  Rectangle {
    id: batteryIndicator
    height: parent.height
    implicitWidth: batteryIndicatorLabel.implicitWidth + margin
    color: "#00cc9ccc"

    property real percentage: UPower.displayDevice.percentage * 100

    Text {
      id: batteryIndicatorLabel
      anchors.centerIn: parent

      font.pixelSize: 20
      color: fontColor
      font.family: "Hasklug Nerd Font"
      text: Math.round(batteryIndicator.percentage) + "%"
    }
  }
}
