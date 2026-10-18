import Quickshell
import Quickshell.Networking
import Quickshell.Widgets
import QtQuick

WrapperItem {
  id: wifiIndicatorRoot
  height: parent.height

  readonly property int margin: 10
  implicitWidth: wifiIndicatorLabel.implicitWidth + margin

  Rectangle {
    id: wifiIndicator
    height: parent.height
    implicitWidth: wifiIndicatorLabel.implicitWidth + margin
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
              return " " + network.name;
            }
          }
        } else {
          return " Ethernet"
        }
      }
      return "󰤮 No Wi-Fi"
    }
    Text {
      id: wifiIndicatorLabel
      anchors.centerIn: parent

      font.pixelSize: 20
      color: fontColor
      font.family: "Hasklug Nerd Font"
      text: wifiIndicator.connectedSsid
    }
  }
}

