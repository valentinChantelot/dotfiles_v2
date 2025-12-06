import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: root
    property string text: ""
    property string iconSource: ""
    property font font
    signal clicked()

    width: 200
    height: 40

    RowLayout {
        anchors.fill: parent
        spacing: 15

        Image {
            source: root.iconSource
            sourceSize.width: 24
            sourceSize.height: 24
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            fillMode: Image.PreserveAspectFit
            visible: root.iconSource !== ""
        }

        Text {
            text: root.text
            color: "white"
            font: root.font
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        hoverEnabled: true
        onEntered: parent.opacity = 0.7
        onExited: parent.opacity = 1.0
    }
}
