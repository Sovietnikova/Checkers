import QtQuick 2.0

Rectangle {
    id: simplebutton
    color: area.containsMouse ? 'yellow': 'gray'
    width: buttonLabel.width + 2*buttonLabel.anchors.leftMargin
    height: buttonLabel.height + 2*buttonLabel.anchors.topMargin


    property alias text: buttonLabel.text
    property alias textColor: buttonLabel.color

    signal clicked()

    onClicked: {
        console.log("Inner clicked signal");
    }


    Text {
        id: buttonLabel

        anchors.left: simplebutton.left
        anchors.top: simplebutton.top
        anchors.leftMargin: 8
        anchors.topMargin: 5

        anchors.centerIn: parent
        // text: simplebutton.text
        //text: "Sample text"
        color: area.pressed ? "red" : "blue"
        font.pointSize: 16
        //onTextChanged: {
//                console.log("New text ", text);
//            }
    }


    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: simplebutton.clicked()
        hoverEnabled: true


            //console.log(buttonLabel.text + ' clicked')
        //Qt.quit();
    }
}
