import QtQuick 2.0

Item {
    id: root
    width: 600
    height: 600

    property variant model: 0
    property int dist: root.width/model.nCols



    Grid {
        id: checks
        columns: root.model.nCols
        rows: root.model.nRows
        width: parent.width
        height: parent.height

        Repeater {
            model: checks.columns * checks.rows
            Rectangle {
                id: cell

                width: parent.parent.width / root.model.nCols
                height: parent.parent.height / root.model.nRows

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        root.model.cellClicked(index);
                    }
                }

                color: root.model.getCellColor(index) ? 'white' : 'brown'

                Text {
                    text: index
                    color: 'red'
                }
            }
        }
    }

    Repeater {
        model: root.model

        Item {
            id: cellRect
            width: dist
            height: dist
            x: col*dist
            y: row*dist

            Rectangle {
                id: check
                color: {true: 'yellow', false: 'black'}[player]
                width: height
                radius: width
                anchors.centerIn: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.model.checkClicked(index);
                    }

                    //cellRect.state = cellRect.state === cellRect.normalState ? cellRect.selectedState : cellRect.normalState }
                }


                //  Component.onCompleted: console.log('scale>>>>', width, height, cellRect.state)
            }

            readonly property string normalState: 'normal'
            readonly property string selectedState: 'selected'
            states: [
                State {
                    name: normalState
                    PropertyChanges {
                        target: check
                        height: dist*0.6
                    }
                },
                State {
                    name: selectedState
                    PropertyChanges {
                        target: check
                        height: dist*0.8
                    }
                }

            ]
            state: root.model.selectedIndex === index ? selectedState : normalState
            //onStateChanged: console.log('state>>>>', state, 'index>>>>', index)
        }
    }

    Rectangle {
        id: gameOver
        width: root.width/2
        height: root.height/2
        anchors.centerIn: parent
        color: "#eeec6b"
        visible: false

        Text {
            color: "#a82b2b"
            text: 'Congratulations! You won!'
            anchors.centerIn: parent
            font.family: "Serif"
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 16
            horizontalAlignment: Text.AlignHCenter

        }

        Button {
            id: newGame
            color: "#abdfee"
            height: root.width/6
            width: root.width/6
            anchors.left: gameOver.left
            anchors.leftMargin: root.width/20
            anchors.bottom: gameOver.bottom
            anchors.bottomMargin: root.width/20
            text: 'New Game'
            onClicked: {
                root.model.reset();
                gameOver.visible = false
                console.log('work!')
            }
        }
    }
    Connections {
        target: model
        onEndGame: gameOver.visible = true
    }


    focus: true
    Keys.onPressed: {
        console.log('clicked');
        switch(event.key)
        {
        case Qt.Key_1:
            model.preset1();
            break;
        case Qt.Key_2:
            model.preset2();
            break;
        case Qt.Key_3:
            model.preset3();
            break;
        case Qt.Key_4:
            model.preset4();
            break;
        }
    }
}
