//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint256 public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint256 public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint256[9] private board;

    /**
     * @dev Deploy the contract to create a new game
     * @param opponent The address of player2
     **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
     * @dev Check a, b, c in a line are the same
     * _threeInALine doesn't check if a, b, c are in a line
     * @param a position a
     * @param b position b
     * @param c position c
     **/
    function _threeInALine(
        uint256 a,
        uint256 b,
        uint256 c
    ) private view returns (bool) {
        /*Please complete the code here.*/
        bool inALine = false;
        if (board[a] == board[b] && board[b] == board[c]) {
            inALine = true;
        }
        return inALine;
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint256 pos) private view returns (uint256) {
        /*Please complete the code here.*/
        uint256 nextStatus = 0;

        /* check horizontal wins */
        if (_threeInALine(0, 1, 2)) {
            nextStatus = board[0];
        } else if (_threeInALine(3, 4, 5)) {
            nextStatus = board[3];
        } else if (_threeInALine(6, 7, 8)) {
            nextStatus = board[6];

            /* check vertical wins */
        } else if (_threeInALine(0, 3, 6)) {
            nextStatus = board[0];
        } else if (_threeInALine(1, 4, 7)) {
            nextStatus = board[1];
        } else if (_threeInALine(2, 5, 8)) {
            nextStatus = board[2];

            /* check diagonal wins */
        } else if (_threeInALine(0, 4, 8)) {
            nextStatus = board[0];
        } else if (_threeInALine(2, 4, 6)) {
            nextStatus = board[2];

            /* else draw */
        } else {
            nextStatus = 3;
        }

        return nextStatus;
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint256 pos) {
        /*Please complete the code here.*/
        require(status == 0);
        _;
        status = _getStatus(pos);
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
        /*Please complete the code here.*/
        bool senderTurn = false;
        if (turn == 1 && players[0] == msg.sender) {
            senderTurn = true;
        } else if (turn == 2 && players[1] == msg.sender) {
            senderTurn = true;
        }
        return senderTurn;
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
        /*Please complete the code here.*/
        require(myTurn() == true);
        _;
        if (turn == 1) {
            turn = 2;
        } else {
            turn = 1;
        }
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint256 pos) public view returns (bool) {
        /*Please complete the code here.*/
        bool valid = true;
        if (board[pos] == 1 || board[pos] == 2) {
            valid = false;
        }
        return valid;
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint256 pos) {
        /*Please complete the code here.*/
        require(validMove(pos) == true);
        _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint256 pos)
        public
        _validMove(pos)
        _checkStatus(pos)
        _myTurn
    {
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint256[9]) {
        return board;
    }
}
