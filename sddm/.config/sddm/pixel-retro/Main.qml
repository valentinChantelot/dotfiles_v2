import QtQuick 2.0
import SddmComponents 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.VirtualKeyboard 2.2
import "components"

Rectangle {
    id: container
    width: 640
    height: 480
    color: config.color_bg

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    Connections {
        target: sddm
    }

    FontLoader { id: mainFont; source: './assets/fonts/BigBlueTerm437NerdFont-Regular.ttf' }
    FontLoader { id: btnFont; source: './assets/fonts/TerminessNerdFont-Regular.ttf' }

    // --- Sidebar ---
    Column {
        id: sidebar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 40
        width: 200
        height: 3002
        spacing: 20

        SidebarItem {
            text: "sleep"
            iconSource: "../assets/eye-closed.svg"
            fontFamily: config.font_family
            fontSize: config.font_size
            onClicked: sddm.suspend()
        }

        SidebarItem {
            text: "hibernate"
            iconSource: "../assets/moon-star.svg"
            fontFamily: config.font_family
            fontSize: config.font_size
            onClicked: sddm.hibernate()
        }

        SidebarItem {
            text: "reboot"
            iconSource: "../assets/reload.svg"
            fontFamily: config.font_family
            fontSize: config.font_size
            onClicked: sddm.reboot()
        }

        SidebarItem {
            text: "shutdown"
            iconSource: "../assets/start.svg"
            fontFamily: config.font_family
            fontSize: config.font_size
            onClicked: sddm.powerOff()
        }
    }

    // --- Main Content ---
    // Column {
    //     id: mainContent
    //     anchors.centerIn: parent
    //     width: 400
    //     spacing: 30

    //     // -- Clock --
    //     Column {
    //         spacing: 5
    //         anchors.horizontalCenter: parent.horizontalCenter
            
    //         Text {
    //             id: timeLabel
    //             text: Qt.formatTime(new Date(), "hh:mm")
    //             color: config.color_text
    //             font.family: config.font_family
    //             font.pixelSize: config.font_size_clock
    //             font.bold: true
    //             anchors.horizontalCenter: parent.horizontalCenter
    //         }
            
    //         Text {
    //             id: dateLabel
    //             text: Qt.formatDate(new Date(), "dd.MM.yyyy")
    //             color: config.color_text
    //             font.family: config.font_family
    //             font.pixelSize: config.font_size_date
    //             anchors.horizontalCenter: parent.horizontalCenter
    //         }

    //         Timer {
    //             interval: 1000
    //             repeat: true
    //             running: true
    //             onTriggered: {
    //                 timeLabel.text = Qt.formatTime(new Date(), "hh:mm")
    //                 dateLabel.text = Qt.formatDate(new Date(), "dd.MM.yyyy")
    //             }
    //         }
    //     }

    //     // -- Welcome title --
    //     Text {
    //         text: "> Welcome back"
    //         color: config.color_text
    //         font.family: config.font_family
    //         font.pixelSize: config.font_size_title
    //         anchors.left: parent.left
    //     }

    //     // -- Login form --
    //     Column {
    //         width: parent.width
    //         spacing: 15

    //         Rectangle {
    //             width: parent.width
    //             height: 40
    //             color: config.color_bg
                
    //             RowLayout {
    //                 anchors.fill: parent
    //                 anchors.margins: 10
                    
    //                 Image {
    //                     source: "./assets/user.svg"
    //                     sourceSize: Qt.size(16, 16)
    //                     Layout.preferredWidth: 16
    //                     Layout.preferredHeight: 16
    //                 }
                    
    //                 TextField {
    //                     id: userBox
    //                     text: userModel.lastUser
    //                     font.family: config.font_family
    //                     font.pixelSize: config.font_size
    //                     color: config.color_text
    //                     background: null
    //                     Layout.fillWidth: true
                        
    //                     KeyNavigation.tab: passwordBox
    //                 }
    //             }
    //         }

    //         Rectangle {
    //             width: parent.width
    //             height: 40
    //             color: config.color_bg
                
    //             RowLayout {
    //                 anchors.fill: parent
    //                 anchors.margins: 10
                    
    //                 Image {
    //                     source: "./assets/eye.svg"
    //                     sourceSize: Qt.size(16, 16)
    //                     Layout.preferredWidth: 16
    //                     Layout.preferredHeight: 16
    //                 }
                    
    //                 TextField {
    //                     id: passwordBox
    //                     font.family: config.font_family
    //                     font.pixelSize: config.font_size
    //                     color: config.color_text
    //                     echoMode: TextInput.Password
    //                     background: null
    //                     Layout.fillWidth: true
    //                     focus: true
                        
    //                     onAccepted: sddm.login(userBox.text, passwordBox.text, session.index)
    //                     KeyNavigation.tab: loginBtn
    //                 }
    //             }
    //         }
            
    //         Rectangle {
    //             id: loginBtn
    //             width: 120
    //             height: 40
    //             radius: 6
    //             color: mouseArea.pressed ? Qt.darker(config.color_bg) : config.color_bg
    //             border.color: config.color_accent
    //             border.width: 1

    //             Text {
    //                 anchors.centerIn: parent
    //                 text: "LOGIN"
    //                 font.family: config.button_font_family
    //                 font.pixelSize: config.font_size
    //                 color: config.color_text
    //             }

    //             MouseArea {
    //                 id: mouseArea
    //                 anchors.fill: parent
    //                 hoverEnabled: true
    //                 onClicked: sddm.login(userBox.text, passwordBox.text, session.index)
    //                 cursorShape: Qt.PointingHandCursor
    //             }
    //         }
    //     }
    // }

    // // --- Footer ---
    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 40
        spacing: 20

        SidebarItem {
            text: "virtual keyboard"
            iconSource: "../assets/keyboard.svg"

            fontFamily: config.font_family
            fontSize: config.font_size
            width: 180

            onClicked: virtualKeyboard.visible = !virtualKeyboard.visible
        }
    }

    // --- Virtual keyboard ---
    InputPanel {
        id: virtualKeyboard
        z: 99
        x: 0
        y: parent.height - height
        width: parent.width
        visible: false
        
        states: State {
            name: "visible"
            when: virtualKeyboard.active
            PropertyChanges {
                target: virtualKeyboard
                y: parent.height - virtualKeyboard.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
