import QtQuick 2.0

Item {
    id: main
    View {
        id: view
        model: model
    }

    Model {
        id: model
    }

    width: view.width
    height: view.height

    function newGame() {
        model.reset();
    }

    Component.onCompleted: {
        newGame();
    }
}
