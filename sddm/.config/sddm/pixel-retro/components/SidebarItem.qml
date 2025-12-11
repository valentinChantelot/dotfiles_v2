import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    id: root

    property string text: ""
    property string iconSource: ""
    property string fontFamily: ""
    property int fontSize: 14
    signal clicked()

    width: 200
    height: 40

    RowLayout {
        anchors.fill: parent
        spacing: 12

        Image {
            source: Qt.resolvedUrl(root.iconSource)
            sourceSize.width: 24
            sourceSize.height: 24
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            fillMode: Image.PreserveAspectFit
            visible: root.iconSource !== ""
        }

        Text {
            id: textEl
            text: root.text
            color: "white"
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        hoverEnabled: true

        onEntered: root.opacity = 0.7
        onExited: root.opacity = 1.0
    }
}
