import QtQuick
import QtQuick.Controls
import QtQuick.Window
import qs.components
import qs.config

Window {
    id: window

    visible: true
    width: 1120
    height: 760
    minimumWidth: 1080
    minimumHeight: 680
    title: "Phosphor icon showcase"
    color: "#111318"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Phosphor icon showcase"
            color: "#e2e2e9"
            font.family: Tokens.fontFamily.sans
            font.pixelSize: 26
        }

        Text {
            text: "Regular, bold and filled icons at each size"
            color: "#c4c6d0"
            font.family: Tokens.fontFamily.sans
            font.pixelSize: 14
        }

        Row {
            spacing: 0

            Item {
                width: 130
                height: 20
            }

            Repeater {
                model: [16, 20, 24, 32, 40, 48]

                delegate: Text {
                    required property int modelData

                    width: 150
                    height: 20
                    text: modelData + " px"
                    horizontalAlignment: Text.AlignHCenter
                    color: "#c4c6d0"
                    font.family: Tokens.fontFamily.mono
                    font.pixelSize: 12
                }

            }

        }

        Repeater {
            model: ["microphone", "moon", "heart"]

            delegate: Row {
                required property string modelData

                spacing: 0

                Text {
                    text: parent.modelData
                    width: 130
                    height: 56
                    verticalAlignment: Text.AlignVCenter
                    color: "#e2e2e9"
                    font.family: Tokens.fontFamily.mono
                    font.pixelSize: 13
                }

                Repeater {
                    model: [16, 20, 24, 32, 40, 48]

                    delegate: Item {
                        required property int modelData
                        property string name: parent.modelData

                        width: 150
                        height: 56

                        Row {
                            anchors.centerIn: parent
                            spacing: 2

                            Icons {
                                text: parent.parent.name
                                size: parent.parent.modelData
                                color: "#e2e2e9"
                            }

                            Icons {
                                text: parent.parent.name
                                size: parent.parent.modelData
                                bold: true
                                color: "#e2e2e9"
                            }

                            Icons {
                                text: parent.parent.name
                                size: parent.parent.modelData
                                filled: true
                                animationEnabled: false
                                color: "#aac7ff"
                            }

                        }

                    }

                }

            }

        }

        Text {
            text: "Click to toggle fill · hold to see the press animation"
            color: "#c4c6d0"
            font.family: Tokens.fontFamily.sans
            font.pixelSize: 14
        }

        Row {
            spacing: 12

            ToggleButton {
                text: checked ? "Mic on" : "Mic off"
                iconName: checked ? "microphone" : "microphone-slash"
            }

            ToggleButton {
                text: "Night light"
                iconName: "moon"
            }

            ToggleButton {
                text: "Favorite"
                iconName: "heart"
            }

        }

        CheckBox {
            id: slowMotion

            text: "Slow fill transition (800 ms)"
            palette.windowText: "#e2e2e9"
        }

    }

    component ToggleButton: Button {
        id: button

        required property string iconName
        property int iconSize: Tokens.iconSize.md

        checkable: true
        implicitHeight: 48
        implicitWidth: contentItem.implicitWidth + 36
        horizontalPadding: 18

        background: Rectangle {
            radius: height / 2
            color: button.checked ? "#aac7ff" : button.hovered ? "#455168" : "#303b4d"
            scale: button.down ? 0.95 : 1
            border.width: button.visualFocus ? 2 : 0
            border.color: "#ffffff"

            Behavior on color {
                CAnim {
                }

            }

            Behavior on scale {
                Anim {
                    duration: Tokens.animDuration.spatialFast
                    easing.bezierCurve: Tokens.animCurve.spatialFast
                }

            }

        }

        contentItem: Row {
            spacing: 10

            Icons {
                anchors.verticalCenter: parent.verticalCenter
                text: button.iconName
                size: button.iconSize
                filled: button.checked
                animationDuration: slowMotion.checked ? 800 : Tokens.animDuration.effectsFast
                color: button.checked ? "#0a305f" : "#e2e2e9"

                Behavior on color {
                    CAnim {
                    }

                }

            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: button.text
                color: button.checked ? "#0a305f" : "#e2e2e9"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 14

                Behavior on color {
                    CAnim {
                    }

                }

            }

        }

    }

}
