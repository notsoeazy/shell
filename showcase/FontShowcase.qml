import QtQuick
import QtQuick.Controls
import QtQuick.Window
import qs.config

Window {
    id: window

    visible: true
    width: 1040
    height: 900
    minimumWidth: 760
    minimumHeight: 600
    title: "Geist font showcase"
    color: "#111318"

    ScrollView {
        anchors.fill: parent
        anchors.margins: 32
        clip: true
        contentWidth: availableWidth

        Column {
            width: parent.width
            spacing: 20

            Text {
                text: "Geist font showcase"
                color: "#e2e2e9"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 28
            }

            Text {
                text: "Bundled variable fonts · compare families, weights and pixel sizes"
                color: "#c4c6d0"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 14
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#44474e"
            }

            Text {
                text: "Font families"
                color: "#e2e2e9"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 20
            }

            Row {
                spacing: 20

                Repeater {
                    model: [{
                        "label": "Tokens.fontFamily.sans",
                        "family": Tokens.fontFamily.sans
                    }, {
                        "label": "Tokens.fontFamily.mono",
                        "family": Tokens.fontFamily.mono
                    }]

                    delegate: Rectangle {
                        required property var modelData

                        width: (window.width - 104) / 2
                        height: 88
                        radius: 12
                        color: "#1d2024"

                        Column {
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 6

                            Text {
                                text: modelData.label + " · " + modelData.family
                                color: "#aac7ff"
                                font.family: Tokens.fontFamily.mono
                                font.pixelSize: 12
                            }

                            Text {
                                text: "The quick brown fox 0123456789"
                                color: "#e2e2e9"
                                font.family: modelData.family
                                font.pixelSize: 18
                            }

                        }

                    }

                }

            }

            Text {
                text: "Font weights"
                color: "#e2e2e9"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 20
            }

            Row {
                spacing: 20

                Repeater {
                    model: [Tokens.fontFamily.sans, Tokens.fontFamily.mono]

                    delegate: Column {
                        id: familyColumn

                        required property string modelData

                        width: (window.width - 104) / 2
                        spacing: 4

                        Text {
                            text: familyColumn.modelData
                            color: "#aac7ff"
                            font.family: Tokens.fontFamily.sans
                            font.pixelSize: 14
                        }

                        Repeater {
                            model: ["thin", "extraLight", "light", "regular", "medium", "semiBold", "bold", "extraBold", "black"]

                            delegate: Row {
                                required property string modelData

                                height: 26
                                spacing: 8

                                Text {
                                    width: 122
                                    text: parent.modelData + "  " + Tokens.fontWeight[parent.modelData]
                                    color: "#aab1bf"
                                    font.family: Tokens.fontFamily.mono
                                    font.pixelSize: 11
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: "Aa Bb 0123 · Sample text"
                                    color: "#e2e2e9"
                                    font.family: familyColumn.modelData
                                    font.pixelSize: 17
                                    font.weight: Tokens.fontWeight[parent.modelData]
                                    font.variableAxes: ({
                                        "wght": Tokens.fontWeight[parent.modelData]
                                    })
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                            }

                        }

                    }

                }

            }

            Text {
                text: "Font sizes"
                color: "#e2e2e9"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 20
            }

            Text {
                text: "Each token uses pixel size and regular weight."
                color: "#c4c6d0"
                font.family: Tokens.fontFamily.sans
                font.pixelSize: 13
            }

            Repeater {
                model: ["xxs", "xs", "sm", "md", "lg", "xl", "xxl", "xxxl"]

                delegate: Row {
                    required property string modelData

                    width: parent.width
                    height: Math.max(28, Tokens.fontSize[modelData] + 10)
                    spacing: 12

                    Text {
                        width: 100
                        text: parent.modelData + "  " + Tokens.fontSize[parent.modelData] + " px"
                        color: "#aab1bf"
                        font.family: Tokens.fontFamily.mono
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        width: (window.width - 240) / 2
                        text: "Geist · Aa 0123"
                        color: "#e2e2e9"
                        font.family: Tokens.fontFamily.sans
                        font.pixelSize: Tokens.fontSize[parent.modelData]
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Mono · Aa 0123"
                        color: "#e2e2e9"
                        font.family: Tokens.fontFamily.mono
                        font.pixelSize: Tokens.fontSize[parent.modelData]
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

            }

            Item {
                width: 1
                height: 20
            }

        }

    }

}
