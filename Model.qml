import QtQuick 2.0

ListModel {
    id: root

    readonly property int noCheckSelected: -1

    signal endGame(bool winner)

    property int selectedIndex: noCheckSelected
    property bool turn: white

    readonly property bool white: true
    readonly property bool black: false

    readonly property int nRows: 8
    readonly property int nCols: 8

    function reset() {
        root.append({'col': 1, 'row': 0, 'player': false, 'king': false});
        root.append({'col': 3, 'row': 0, 'player': false, 'king': false});
        root.append({'col': 5, 'row': 0, 'player': false, 'king': false});
        root.append({'col': 7, 'row': 0, 'player': false, 'king': false});
        root.append({'col': 0, 'row': 1, 'player': false, 'king': false});
        root.append({'col': 2, 'row': 1, 'player': false, 'king': false});
        root.append({'col': 4, 'row': 1, 'player': false, 'king': false});
        root.append({'col': 6, 'row': 1, 'player': false, 'king': false});
        root.append({'col': 1, 'row': 2, 'player': false, 'king': false});
        root.append({'col': 3, 'row': 2, 'player': false, 'king': false});
        root.append({'col': 5, 'row': 2, 'player': false, 'king': false});
        root.append({'col': 7, 'row': 2, 'player': false, 'king': false});

        root.append({'col': 0, 'row': 5, 'player': true, 'king': false});
        root.append({'col': 2, 'row': 5, 'player': true, 'king': false});
        root.append({'col': 4, 'row': 5, 'player': true, 'king': false});
        root.append({'col': 6, 'row': 5, 'player': true, 'king': false});
        root.append({'col': 1, 'row': 6, 'player': true, 'king': false});
        root.append({'col': 3, 'row': 6, 'player': true, 'king': false});
        root.append({'col': 5, 'row': 6, 'player': true, 'king': false});
        root.append({'col': 7, 'row': 6, 'player': true, 'king': false});
        root.append({'col': 0, 'row': 7, 'player': true, 'king': false});
        root.append({'col': 2, 'row': 7, 'player': true, 'king': false});
        root.append({'col': 4, 'row': 7, 'player': true, 'king': false});
        root.append({'col': 6, 'row': 7, 'player': true, 'king': false});
    }

    function preset1() {
        root.clear();
        root.selectedIndex = -1;
        root.turn = false;

        root.append({'col': 3, 'row': 2, 'player': false, 'king': false});
        root.append({'col': 4, 'row': 1, 'player': true, 'king': false});
    }

    function getRow(index) {
        return parseInt(index / root.nCols);
    }

    function getCol(index) {
        return index % root.nCols;
    }

    function getCellColor(index) {
        return ! ((index%2 + getRow(index)%2)%2);
    }

    //Принимает на вход индекс выделенной шашки, проверяет, может ли эта шашка атаковать шашку игрока другого цвета, возвращает true, если может атаковать
    function canAttack(index) {
        var ourColor = root.get(index).player;
        var ourRow = root.get(index).row;
        var ourCol = root.get(index).col;
        //console.log(index)
        if (root.get(index).king) {
            console.error('определение атаки для дамки не реализовано')
        }
        else {
            var attack1 = root.cellExist(ourCol + 2, ourRow + 2) && root.getCheckAt(ourCol + 1, ourRow + 1) !== null && root.getCheckAt(ourCol + 1, ourRow + 1).player !== ourColor && root.getCheckAt(ourCol + 2, ourRow + 2) === null;
            var attack2 = root.cellExist(ourCol - 2, ourRow + 2) && root.getCheckAt(ourCol - 1, ourRow + 1) !== null && root.getCheckAt(ourCol - 1, ourRow + 1).player !== ourColor && root.getCheckAt(ourCol - 2, ourRow + 2) === null;
            var attack3 = root.cellExist(ourCol + 2, ourRow - 2) && root.getCheckAt(ourCol + 1, ourRow - 1) !== null && root.getCheckAt(ourCol + 1, ourRow - 1).player !== ourColor && root.getCheckAt(ourCol + 2, ourRow - 2) === null;
            var attack4 = root.cellExist(ourCol - 2, ourRow - 2) && root.getCheckAt(ourCol - 1, ourRow - 1) !== null && root.getCheckAt(ourCol - 1, ourRow - 1).player !== ourColor && root.getCheckAt(ourCol - 2, ourRow - 2 ) === null;
            if (attack1 || attack2 || attack3 || attack4) {
                //console.log('attack', attack1, attack2, attack3, attack4);
                return true;
            }
            return false;
        }
    }

    // Удаляет шашку противника с шахматной доски
    // index (integer): индекс шашки, которая бьет шашку противника,
    // col (integer), row (integer): координаты, на которые переходит шашка, которая бьет
    // проверяет на последнюю клетку
    function checkAttack(index, colTo, rowTo) {
        var ourColor = root.get(index).player;

        var rowFrom = root.get(index).row;
        var colFrom = root.get(index).col;

        var colEnemy = (colFrom + colTo)/2
        var rowEnemy = (rowFrom + rowTo)/2
        if (root.get(index).king) {
            console.error('определение атаки для дамки не реализовано')
        }
        else {
            if (root.getCheckAt(colEnemy, rowEnemy ) !== null) {
                var delCheck = root.getCheckIndexAt(colEnemy, rowEnemy);
                //console.log('del index', delCheck);

                root.moveCheck(index, colTo, rowTo);
                if (selectedIndex >= delCheck) {
                    selectedIndex -= 1;
                }

                root.remove(delCheck);
            }
        }
    }

    // Принимает на вход координаты клетки, проверяет, есть ли клетка по заданным координатам на доске и return true if cell is real
    function cellExist(col, row) {

        if (col < 0 || col >= nCols || row < 0 || row >= nRows)
            return false;
        else {
            return true;
        }
    }

    // Принимает на вход индекс кликнутой шашки, проходится циклом по всем шашкам и возвращает true, если есть шашка, которая может бить, и она не наша кликнутая шашка
    function canOtherCheckAttack(index) {
        for (var i = 0; i<root.count; i++) {
            if (root.get(i).player === root.get(index).player &&  i !== index && root.canAttack(i)) {
                return true;
            }
        }
        return false;
    }

    // Принимает на вход индекс выделенной шашки, проверяет на наличие пустой клетки в обе стороны, возвращает true, если свободная клетка есть, и false, если свободной клетки нет
    function canMove(index) {
        var color = root.get(index).player;
        var ourRow = root.get(index).row;
        var ourCol = root.get(index).col;

        if (color) {
            var move1White = root.cellExist(ourCol + 1, ourRow - 1) && root.getCheckAt(ourCol + 1, ourRow - 1) === null; //&& root.getCheckAt(ourCol + 1, ourRow - 1) === null;
            var move2White = root.cellExist(ourCol - 1, ourRow - 1) && root.getCheckAt(ourCol - 1, ourRow - 1) === null; //&& root.getCheckAt(ourCol - 1, ourRow + 1) === null;
            //console.log('move>>>', move1White, move2White);
            if (move1White || move2White) {
                return true;
            }
            return false;
        }
        else {
            var move1Black = root.cellExist(ourCol - 1, ourRow + 1) && root.getCheckAt(ourCol - 1, ourRow + 1) === null; //&& root.getCheckAt(ourCol - 1, ourRow - 1) === null;
            var move2Black = root.cellExist(ourCol + 1, ourRow + 1) && root.getCheckAt(ourCol + 1, ourRow + 1) === null; //&& root.getCheckAt(ourCol + 1, ourRow - 1) === null;
            //console.log('move2>>>', move1Black, move2Black);
            if (move1Black || move2Black) {
                return true;
            }
            return false;
        }
    }

    // Принимает на вход индекс кликнутой шашки, проверяет на возможность битья или хода, если один из вариантов верен - выделяет шашку
    function checkClicked(index) {
        //console.log("Check clicked index=", index, ", selectedIndex=", selectedIndex);
        // if we have one select chess and we click on it, select index = -1
        if (root.selectedIndex === index) {
            console.log("Invert checked state");
            root.selectedIndex = root.noCheckSelected;
            return;
        }
        if (root.get(index).player !== root.turn) {
            //console.log("Wrong player=", root.get(index).player, ", while turn=",root.turn, ", exiting");
            return;
        }

        if (root.canAttack(index)) {
            root.selectedIndex = index;
        }
        else {
            if (root.canOtherCheckAttack(index)){
                //console.log("Other check can attack, exiting");
                return;
            }
            if (root.canMove(index) === false) {
                //console.log("The check can neither attack nor move, exiting");
                return;
            }
            //console.log("OK, select that check");
            root.selectedIndex = index;
        }
    }

    // returns either a check object or null if the cell is empty
    function getCheckAt(col, row) {
        for (var i = 0; i<root.count; i++) {
            var check = root.get(i);
            if (check.row === row && check.col === col) {
                return check;
            }
        }
        return null;
    }

    // Принимает на вход координаты шашки и возвращет ее индекс
    function getCheckIndexAt(col, row) {
        for (var i = 0; i<root.count; i++) {
            var check = root.get(i);
            if (check.row === row && check.col === col) {
                return i;
            }
        }
        return -1;
    }

    // перемещает укзанную шашку на указанную клетку, проверяет условие того, что шашка станет дамкой
    // index - шашка, которую надо переместить, col, row - координаты клетки куда перемещается шашка
    // Проверяет на "последнюю клетку, если клетка последняя - делает шашку дамкой
    function moveCheck(index, col, row) {
        //console.log('moving ', index, 'to', col, row);
        root.setProperty(index, 'row', row);
        root.setProperty(index, 'col', col);
        var checkColor = root.get(index).player;
        if ((checkColor && row === 0)
                || (checkColor === false && row === 7)) {
            root.setProperty(index, 'king', true);
        }
    }

    // Принимает на вход индекс кликнутой клетки, проверяет на возможность бить или ходить, перемещает шашку на кликнутую клетку
    function cellClicked(index) {
        //console.log('Cell clicked, selectedIndex=', selectedIndex, 'turn=', turn);
        // проверка на выделенную шашку
        if (selectedIndex === root.noCheckSelected) {
            return;
        }
        var cellCol = getCol(index); // колонка кликнутой клетки
        var cellRow = getRow(index); // строка кликнутой клетки

        var checkCol = root.get(selectedIndex).col; // колонка выделенной шашки
        var checkRow = root.get(selectedIndex).row; // строка выделенной шашки

        var checkColor = root.get(selectedIndex).player; // цвет выделенной шашки
        var forward = {true: -1, false: 1}[checkColor]; // вперед -1 для белых шашек и +1 для черных
        var attack = {true: -2, false: 2}[checkColor]; // удар на две клетки

        var enemyCol = (checkCol + cellCol)/2; // колонка шашки противника
        var enemyRow = (checkRow + cellRow)/2; // строка шашки противника
        var enemyColor = !checkColor

        // var delCheck = selectedIndex;
        // Проверяет на возможный удар именно на эту клетку, на которую мы кликнули
        /*console.log("Checking...", (cellRow === checkRow + attack)
                    ,(cellCol === checkCol +2 || cellCol === checkCol -2)
                    ,(root.getCheckAt(cellCol, cellRow) === null)
                    ,(root.getCheckAt(enemyCol, enemyRow) !== null)
                    ,(enemyColor !== root.turn)
                    ,(checkColor === root.turn));*/

        if ((cellRow === checkRow + attack || cellRow === checkRow - attack) // проверяет клетку, на которую клетку по строке
                && (cellCol === checkCol +2 || cellCol === checkCol -2) // проверяет клетку по колонке
                && (root.getCheckAt(cellCol, cellRow) === null) // провереят клетку на отсутствие шашки
                && (root.getCheckAt(enemyCol, enemyRow) !== null) // проверяет клетку на наличие шашки противника
                && (enemyColor !== root.turn) // проверяет цвет шашки противника
                && (checkColor === root.turn)) {
            //console.log("Attack!", cellCol, cellRow);
            root.checkAttack(selectedIndex, cellCol, cellRow);

            if (root.canAttack(selectedIndex)) {
                //console.log("Can attack more...");
                return;
            }
        }
        else {
            if (root.canAttack(selectedIndex)) {
                return;
            }
            if (root.getCellColor(index)){
                //console.log('>>>>>', root.getCellColor(index))
                return;
            }

            if (!(cellRow === checkRow + forward)
                    || (!(cellCol === checkCol +1 || cellCol === checkCol -1))
                    || !(root.getCheckAt(cellCol, cellRow) === null)
                    || !(checkColor === root.turn)) {

                //console.log('my>>>>>', cellRow === checkRow + forward)
                return;
            }
            root.moveCheck(selectedIndex, cellCol, cellRow);
        }
        root.turn = !root.turn;
        selectedIndex = -1;
        //checkGameOver();
        if (checkGameOver()) {
            console.log('win');
            root.endGame(root.player);
        }



    }

    // проходится по массиву шашек и возвращает true, если у игрока нет в наличии шашек или ни одна из оставшихся не может ударить либо походить
    function checkGameOver() {
        for (var i = 0; i<root.count; i++) {
            if ((root.get(i).player === root.turn))  {
                console.log(i, root.get(i).player)

                if ((root.canAttack(i))
                        || (root.canMove(i))) {
                    return false;
                }

            }
        }
        return true;
    }

}


