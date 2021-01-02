import java.util.ArrayList;
/* THIS BRAIN DOES RANDOM MOVES */
public class BrainOne extends ArtificialPlayer {
    public BrainOne() {
        this.name = "Randomized";
    }
    public String findMove(Board board) {
        MoveTree m = new MoveTree();
        ArrayList<Move> moves = m.getMoves(board);
        return moves.get((int)(Math.random() * moves.size())).getMoveStr();
    }
    public ArtificialPlayer get() {
        return new BrainOne();
    }
}
