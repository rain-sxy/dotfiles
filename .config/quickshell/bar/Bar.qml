import Quickshell 
import Quickshell.Io 
import QtQuick 
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Services.Mpris

Variants {
  model: Quickshell.screens

  delegate: Component {
    PanelWindow {
    required property var modelData
    screen: modelData
      id: panelWindow
      anchors {
        top: true
        left: true
        right: true
      }
      color: "transparent"
      implicitHeight: 35

      property var activePlayer: {
        const players = Mpris.players.values;
        if (!players || players.length === 0) return null;
        for (const p of players) {
          if (p.playbackState === MprisPlaybackState.Playing) return p;
        }
        return players[0];
      }

      property var walColors: ({})

      Process {
        id: walLoader
        command: ["cat", "/home/emily/.cache/wal/colors.json"]
        running: true

        stdout: StdioCollector {
          onStreamFinished: {
            try {
              panelWindow.walColors = JSON.parse(this.text)
            }
            catch (e) {
              console.log("wal parse failed", e)
            }
          }
        }
      }
            //Workspaces + Media Player
            Row {
              id: leftSection
              anchors.verticalCenter: parent.verticalCenter
              anchors.left: parent.left
              spacing: 4


              //Workspaces
              //TODO: FIX WORKSPACES
              Rectangle {
                id: workspaces
                height: 35
                color: panelWindow.walColors.special.background
                radius: 15
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                property int wsCount: Hyprland.workspaces.values.filter(w => w.monitor?.name === panelWindow.screen.name).length
                width: wsCount * 28

                Row {
                  anchors.fill: parent
                  spacing: 0

                  Repeater {
                    model: Hyprland.workspaces.values.filter(w => w.monitor?.name === panelWindow.screen.name)
                    Rectangle {
                      id: workspaceTab
                      required property var modelData
                      width: 28
                      height: parent.height
                      radius: 15
                      color: "transparent"
                      clip: true


                      Text {
                        id: workspaceText
                        anchors.centerIn: parent
                        text: modelData.id
                        font.family: 'SF Pro Text'
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        color: workspaceTab.modelData.focused ? panelWindow.walColors.colors.color6 : panelWindow.walColors.colors.color3
                      }

                      MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: workspaceTab.modelData.activate()

                        onEntered: workspaceText.color = panelWindow.walColors.colors.color6
                        onExited: workspaceText.color = workspaceTab.modelData.focused ? panelWindow.walColors.colors.color6 : panelWindow.walColors.colors.color3
                      }
                    }
                  }
                }
              }

              //Media Player
              Rectangle {
                id: mediaPlayer
                height: 35
                width: nowPlayingContent.width + 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: workspaces.right
                anchors.leftMargin: 4
                radius: 15
                color: panelWindow.walColors.special.background
                visible: panelWindow.activePlayer !== null

                Accessible.role: Accessible.Button
                Accessible.name: {
                  if (!panelWindow.activePlayer) return "No media";
                  const artist = panelWindow.activePlayer.trackArtist || "";
                  const title = panelWindow.activePlayer.trackTitle || "";
                  return "Now playing: " + (artist ? artist + " - " : "") + title;
                }

                Row {
                  id: nowPlayingContent
                  anchors.verticalCenter: parent.verticalCenter
                  anchors.left: parent.left
                  anchors.leftMargin: 8
                  spacing: 6

                  Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: panelWindow.activePlayer && panelWindow.activePlayer.isPlaying ? "󰏤" : "▶"
                    color: panelWindow.walColors.colors.color3
                    font.pixelSize: 15
                    font.family: "SF Pro Font"
                    font.weight: Font.Medium
                  }

                  Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                      if (!panelWindow.activePlayer) return "";
                      const artist = panelWindow.activePlayer.trackArtist || "";
                      const title = panelWindow.activePlayer.trackTitle || "";
                      return title ? title + " - " + artist : artist;
                    }
                    color: panelWindow.walColors.colors.color3
                    font.pixelSize: 15
                    font.family: "SF Pro Font"
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, 500)
                  }
                }

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: panelWindow.activePlayer.togglePlaying()
                }
              }
            }

            //Time
            Row {
              id: middleSection
              anchors.centerIn: parent
              spacing: 8

              //Time
              Rectangle {
                height: 35
                width: timeDate.width + 16
                radius: 12
                color: panelWindow.walColors.special.background

                Row {
                  id: timeDate
                  anchors.centerIn: parent
                  spacing: 8

                  Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Time.timeString
                    color: panelWindow.walColors.colors.color3
                    font.pixelSize: 15
                    font.family: "SF Pro Text"
                    font.weight: Font.Medium
                  }
                }
              }
            }

          //Volume Control
          Row {
            id: rightSection
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            height: 35
            width: volumeControl.width + 12
            radius: 15
            color: panelWindow.walColors.special.background

            Accessible.role: Accessible.StaticText
            Accessible.name: {
              const sink = "@DEFAULT_SINK@";
              if (!sink || !sink.audio) return "Volume";
              return "Volume: " + Math.round(sink.audio.volume * 100) + "%";
            }

            Row {
              id: volumeControl
              anchors.centerIn: parent
              spacing: 6

              Text {
                id: volumeText
                anchors.verticalCenter: parent.verticalCenter

                font.family: "SF Pro Text"
                font.pixelSize: 15
                font.weight: Font.Medium

                property int volume: 0
                property bool muted: false

                text: {
                  const sink = "@DEFAULT_SINK@";
                  if (!sink || volume <= 0 || muted) return "󰖁 ";
                  if (volume < 33) return "󰕿 " + volume + "%";
                  if (volume < 66) return "󰖀 " + volume + "%";
                  return "󰕾 " + volume + "%";
                }
                color: panelWindow.walColors.colors.color3;

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  acceptedButtons: Qt.LeftButton

                  onClicked: {
                    openPavucontrol.running = true
                  }

                  onWheel: (wheel) => {
                    const sink = "@DEFAULT_SINK@";
                    if (!sink) return;
                    const delta = wheel.angleDelta.y > 0 ? "+5%" : "-5%";
                    changeVolume.command = ["pactl", "set-sink-volume", sink, delta];
                    changeVolume.running = true;
                  }
                }

                Process {
                  id: changeVolume

                  onExited: {
                    getVolume.running = true
                  }
                }

                Process {
                  id: getVolume
                  command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\\+%' | head -1"]
                  running: true

                  stdout: StdioCollector {
                    onStreamFinished: {
                      volumeText.volume = parseInt(this.text.trim())
                    }
                  }
                }

                Process {
                  id: getMuted
                  command: ["sh", "-c", "pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'"]
                  running: true

                  stdout: StdioCollector {
                    onStreamFinished: {
                      volumeText.muted = (this.text.trim() === "yes")
                    }
                  }
                }

                Process {
                  id: volumeSubscribe
                  command: ["sh", "-c", "pactl subscribe"]

                  running: true

                  stdout: SplitParser {
                    onRead: data => {
                      getVolume.running = true
                      getMuted.running = true
                    }
                  }
                }
                Process {
                  id: openPavucontrol
                  command: ["pavucontrol"]
                }
              }
            }
          }
        }
      }
    }
  }

