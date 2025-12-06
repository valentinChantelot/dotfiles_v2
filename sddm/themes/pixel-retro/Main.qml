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
    color: config.color-bg

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
            // TODO : animation on success ? 
        }
        onLoginFailed: {
            // TODO : better password fail handling  
            passwordBox.text = ""
            passwordBox.focus = true
        }
    }

    FontLoader { id: mainFont; name: config.font_family }
    FontLoader { id: btnFont; name: config.button_font_family }

    // --- Sidebar ---
    Column {
        id: sidebar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 40
        width: 200
        spacing: 20

        SidebarItem {
            text: "sleep"
            iconSource: "assets/eye-closed.svg"
            font.family: config.font_family
            font.pixelSize: config.font_size
            onClicked: sddm.suspend()
            visible: sddm.canSuspend
        }

        SidebarItem {
            text: "hibernate"
            iconSource: "assets/moon-star.svg"
            font.family: config.font_family
            font.pixelSize: config.font_size
            onClicked: sddm.hibernate()
            visible: sddm.canHibernate
        }

        SidebarItem {
            text: "reboot"
            iconSource: "assets/reload.svg"
            font.family: config.font_family
            font.pixelSize: config.font_size
            onClicked: sddm.reboot()
            visible: sddm.canReboot
        }

        SidebarItem {
            text: "shutdown"
            iconSource: "assets/start.svg"
            font.family: config.font_family
            font.pixelSize: config.font_size
            onClicked: sddm.powerOff()
            visible: sddm.canPowerOff
        }
    }

    // --- Main Content ---
    Column {
        id: mainContent
        anchors.centerIn: parent
        width: 400
        spacing: 30

        // -- Clock --
        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            
            Text {
                id: timeLabel
                text: Qt.formatTime(new Date(), "hh:mm")
                color: config.color-text
                font.family: config.font_family
                font.pixelSize: config.font_size_clock
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                id: dateLabel
                text: Qt.formatDate(new Date(), "dd.MM.yyyy")
                color: config.color-text
                font.family: config.font_family
                font.pixelSize: config.font_size_date
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Timer {
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    timeLabel.text = Qt.formatTime(new Date(), "hh:mm")
                    dateLabel.text = Qt.formatDate(new Date(), "dd.MM.yyyy")
                }
            }
        }

        // -- Welcome title --
        Text {
            text: "> Welcome back"
            color: config.color-text
            font.family: config.font_family
            font.pixelSize: config.font_size_title
            anchors.left: parent.left
        }

        // -- Login form --
        Column {
            width: parent.width
            spacing: 15

            Rectangle {
                width: parent.width
                height: 40
                color: config.color-bg
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Image {
                        source: "assets/user.svg"
                        sourceSize: Qt.size(16, 16)
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                    }
                    
                    TextField {
                        id: userBox
                        text: userModel.lastUser
                        font.family: config.font_family
                        font.pixelSize: config.font_size
                        color: config.color-text-text
                        background: null
                        Layout.fillWidth: true
                        
                        KeyNavigation.tab: passwordBox
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 40
                color: config.color-bg
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Image {
                        source: "assets/eye.svg"
                        sourceSize: Qt.size(16, 16)
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                    }
                    
                    TextField {
                        id: passwordBox
                        font.family: config.font_family
                        font.pixelSize: config.font_size
                        color: config.color-text-text
                        echoMode: TextInput.Password
                        background: null
                        Layout.fillWidth: true
                        focus: true
                        
                        onAccepted: sddm.login(userBox.text, passwordBox.text, session.index)
                        KeyNavigation.tab: loginBtn
                    }
                }
            }
            
            Button {
                id: loginBtn
                text: "LOGIN"
                anchors.right: parent.right
                
                contentItem: Text {
                    text: loginBtn.text
                    font.family: config.button_font_family
                    font.pixelSize: config.font_size
                    color: config.color-text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: loginBtn.down ? Qt.darker(config.color-bg) : config.color-bg
                    implicitWidth: 80
                    implicitHeight: 30
                }
                
                onClicked: sddm.login(userBox.text, passwordBox.text, session.index)
            }
        }
    }

    // --- Footer ---
    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 40
        spacing: 20
        z: 100 // Ensure popup is above other elements

        SidebarItem {
            id: sessionButton
            text: sessionModel.lastIndex >= 0 ? sessionModel.itemAt(sessionModel.lastIndex) : "Session"
            iconSource: "assets/session.svg"
            font.family: config.font_family
            font.pixelSize: config.font_size
            width: 150
            
            onClicked: {
                sessionPopup.open()
            }
            
            Popup {
                id: sessionPopup
                y: -height - 10
                width: 200
                height: Math.min(sessionListView.contentHeight + 20, 300)
                padding: 10
                
                background: Rectangle {
                    color: config.color-bg
                    border.color: config.color-text
                    border.width: 1
                }
                
                ListView {
                    id: sessionListView
                    anchors.fill: parent
                    model: sessionModel
                    clip: true
                    
                    delegate: Item {
                        width: parent.width
                        height: 30
                        
                        Rectangle {
                            anchors.fill: parent
                            color: sessionMouseArea.containsMouse ? "#333333" : "transparent"
                        }
                        
                        Text {
                            text: name
                            color: config.color-text
                            font.family: config.font_family
                            font.pixelSize: config.font_size
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                        }
                        
                        MouseArea {
                            id: sessionMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                session.currentIndex = index
                                sessionPopup.close()
                            }
                        }
                    }
                }
            }
        }
        
        SidebarItem {
            text: "virtual keyboard"
            iconSource: "assets/keyboard.svg"
            font.family: config.font_family
            font.pixelSize: config.font_size
            width: 180
            onClicked: {
                virtualKeyboard.visible = !virtualKeyboard.visible
            }
        }
    }

    // --- Virtual Keyboard ---
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

    // Session Model (Hidden but used)
    ComboBox {
        id: session
        model: sessionModel
        currentIndex: sessionModel.lastIndex
        visible: false
    }
}
