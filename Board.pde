import java.util.ArrayList;

public class Board {
    private Piece[][] board = new Piece[8][8];
    private boolean turn = false; // false = player 1, true = player 2
    private ArrayList<String> clickedSquares = new ArrayList<String>();
    private ArtificialPlayer player1 = null; // Null if human
    private ArtificialPlayer player2 = new BrainTwo(); // Null if human

    public Board() {
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board.length; j++) {
                if (j < 3 && (i + j) % 2 == 0) {
                    board[i][j] = new Piece(false);
                } else if (j > 4 && (i + j) % 2 == 0) {
                    board[i][j] = new Piece(true);
                } else {
                    board[i][j] = null;
                }
            }
        }
    }
    
    public Board(Piece[][] board) {
        this.board = board;
    }
    
    public void displayBoard() {
        // Offset 50 pixels from each side, 175 is the width of the square
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board[i].length; j++) {
                int xIndex = 0;
                int yIndex = 0;
                yIndex = 7 - j;
                xIndex = i;
                if ((turn && getCurrentPlayer() == null) || (player2 == null && player1 != null)) {
                    xIndex = 7 - i;
                    yIndex = j;
                }
                fill(((i + j) % 2 == 0 ? 75 : 255));
                rect(50 + 175 * xIndex, 50 + 175 * yIndex, 175, 175);
                Piece piece = board[i][j];
                if (piece != null) {
                    fill(piece.getColor() ? 0 : 255, 0, 0);
                    ellipse(137.5 + 175 * xIndex, 137.5 + 175 * yIndex, 150, 150);
                    if (piece.getKing()) {
                        fill(255);
                        textAlign(CENTER, CENTER);
                        textSize(70);
                        text("K", 137.5 + 175 * xIndex, 137.5 + 175 * yIndex);
                    }
                }
            }
        }
    }
    
    public boolean checkValidity(String checkedMove) {
        MoveTree h = new MoveTree();
        ArrayList<Move> validMoves = h.getMoves(this);
        for (Move move : validMoves) {
            if (move.getMoveStr().equals(checkedMove)) {
                return true;
            }
        }
        return false;
    }

    public boolean submitMove (String moveStr) {
        if (!checkValidity(moveStr)) {
            return false;
        }
        Move submittedMove = new Move(moveStr);
        ArrayList<String[]> actions = submittedMove.getActions(turn);
        for (String[] action : actions) {
            if (action[0].equals("m")) {
                int startX = Integer.parseInt("" + action[1].charAt(0));
                int startY = Integer.parseInt("" + action[1].charAt(1));
                int endX = Integer.parseInt("" + action[1].charAt(2));
                int endY = Integer.parseInt("" + action[1].charAt(3));
                board[endX][endY] = board[startX][startY];
                board[startX][startY] = null;
            }
            if (action[0].equals("r")) {
                int removeX = Integer.parseInt("" + action[1].charAt(0));
                int removeY = Integer.parseInt("" + action[1].charAt(1));
                board[removeX][removeY] = null;
            }
            if (action[0].equals("k")) {
                int kingX = Integer.parseInt("" + action[1].charAt(0));
                int kingY = Integer.parseInt("" + action[1].charAt(1));
                board[kingX][kingY].kingPiece();
            }
        }
        turn = !turn;
        return true;
    }
    
    public void click(float x, float y) {
        if (getCurrentPlayer() != null || x < 50 || x > 1450 || y < 50 || y > 1450) {
            return;
        }
        int preX = (int)((x - 50) / 175);
        int preY = (int)((y - 50) / 175);
        if (!turn) {
            clickedSquares.add("" + preX + (7 - preY));
        } else {
            clickedSquares.add("" + (7 - preX) + preY);
        }
    }
    
    public void submitClicks() {
        if (getCurrentPlayer() != null) {
            return;
        }
        String move = "";
        if (clickedSquares.size() < 2) {
            println("Invalid Move: Not enough clicks");
            clickedSquares.clear();
            return;
        }
        for (int i = 0; i < clickedSquares.size() - 1; i++) {
            move += (clickedSquares.get(i) + clickedSquares.get(i + 1) + "|");
        }
        String moveStr = move.substring(0, move.length() - 1);
        boolean success = submitMove(moveStr);
        if (!success) {
            println("Invalid Move: " + moveStr);
        } else {
            println("Success: " + moveStr);
        }
        clickedSquares.clear();
    }
    
    public void pollForMove() {
        if (getCurrentPlayer() != null) {
            submitMove(getCurrentPlayer().findMove(this));
        }
    }
    
    public int gameStatus() {
        // 0: ongoing, -1: red wins, 1: black wins
        MoveTree m = new MoveTree();
        if (m.getMoves(this).size() == 0) {
            return turn ? -1 : 1;
        }
        return 0;
    }
    
    public void flipTurn() {
        turn = !turn;
    }
    
    public Board get() {
        Piece[][] newBoard = new Piece[8][8];
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                if (board[i][j] == null) {
                    newBoard[i][j] = null;
                } else {
                    newBoard[i][j] = board[i][j].get();
                }
            }
        }
        Board newObject = new Board(newBoard);
        newObject.turn = turn;
        return newObject;
    }
    
    public void setPlayerOne(ArtificialPlayer player) {
        player1 = player;
    }
    
    public void setPlayerTwo(ArtificialPlayer player) {
        player2 = player;
    }
    
    public boolean getTurn() {
        return turn;
    }

    public Piece[][] getBoard() {
        return board;
    }
    
    public void setTurn(boolean newTurn) {
        this.turn = newTurn;
    }
    
    public ArtificialPlayer getCurrentPlayer() {
        return this.turn ? player2 : player1;
    }
    
}
