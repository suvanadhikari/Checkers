public class Piece {
    private boolean col = false; // false = player 1, true = player 2
    private boolean king = false;

    public Piece(boolean col) {
        this.col = col;
    }

    public void kingPiece() {
        this.king = true;
    }

    public Piece get() {
        Piece newPiece = new Piece(col);
        newPiece.king = king;
        return newPiece;
    }

    public boolean getColor() {
        return col;
    }

    public boolean getKing() {
        return king;
    }

    public String toString() {
        String piece = "" + (this.col ? "o" : "x");
        if (king) {
            piece = piece.toUpperCase();
        }
        return piece;
    }
}
