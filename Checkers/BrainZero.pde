import java.util.ArrayList;
/* THIS BRAIN LOOKS AHEAD FOR FUTURE MATERIAL LOSS (TRIES TO LOSE) */
public class BrainZero extends ArtificialPlayer {
    private Node moveRoot;
    private MoveTree moveFinder = new MoveTree();
    private int depth = 3;
    
    public BrainZero() {
        this.name = "Calculated Loser";
    }
    
    public String findMove(Board b) {
        Board copy = b.get();
        moveRoot = new Node(copy);
        findTree(moveRoot);
        evaluateTree(moveRoot);
        
        Node bestMove = moveRoot.children.get(0);
        if (!b.getTurn()) {
            for (Node move : moveRoot.getChildren()) {
                if (move.getEvaluation() < bestMove.getEvaluation()) {
                    bestMove = move;
                }
            }
        } else {
            for (Node move : moveRoot.getChildren()) {
                if (move.getEvaluation() > bestMove.getEvaluation()) {
                    bestMove = move;
                }
            }
        }
        
        return bestMove.getMoves().get(0).getMoveStr();
    }
    
    public ArtificialPlayer get() {
        return new BrainZero();
    }
    
    // Pass in moveRoot to start
    private void findTree(Node node) {
        if (node.getDepth() == depth * 2) {
            return;
        }
        ArrayList<Move> moves = moveFinder.getMoves(node.getBoard());
        for (int k = 0; k < moves.size(); k++) {
            Move move = moves.get(k);
            Node newNode = new Node(node);
            boolean success = newNode.addMove(move);
            if (success) {
                node.addChild(newNode);
            }
            
            findTree(newNode);
        }
    }
    
    private void evaluateTree(Node node) {
        for (Node child : node.getChildren()) {
            evaluateTree(child);
        }
        node.findEvaluation();
    }
    
    private class Node {
        private Board board;
        private int depth;
        private int evaluation;
        private ArrayList<Move> moves;
        private ArrayList<Node> children = new ArrayList<Node>();
        
        public Node(Node parent) {
            this.moves = (ArrayList) parent.moves.clone();
            this.depth = parent.depth + 1;
            this.board = parent.board.get();
        }
        
        public Node(Board b) {
            this.depth = 0;
            this.moves = new ArrayList<Move>();
            this.board = b.get();
        }
        
        // Most basic form of evaluation: Total piece value
        public void evaluateBoard() {
            int evaluation = 0;
            int pieceEvaluate = 0;
            Piece[][] pieces = board.getBoard();
            for (Piece[] row : pieces) {
                for (Piece piece : row) {
                    if (piece == null) {
                        pieceEvaluate = 0;
                    } else {
                        if (piece.getColor() == false) {
                            pieceEvaluate = 1;
                        } else {
                            pieceEvaluate = -1;
                        }
                        if  (piece.getKing()) {
                            pieceEvaluate *= 3;
                        }
                    }
                    evaluation += pieceEvaluate;
                }
            }
            this.evaluation = evaluation;
        }
        
        public void findEvaluation() {
            if (isLeaf()) {
                evaluateBoard();
            } else if (this.board.getTurn() == true) {
                int minEval = children.get(0).evaluation;
                for (Node child : children) {
                    if (child.evaluation < minEval) {
                        minEval = child.evaluation;
                    }
                }
                this.evaluation = minEval;
            } else {
                int maxEval = children.get(0).evaluation;
                for (Node child : children) {
                    if (child.evaluation > maxEval) {
                        maxEval = child.evaluation;
                    }
                }
                this.evaluation = maxEval;
            }
        }
        
        public int getEvaluation() {
            return evaluation;
        }
        
        public Board getBoard() {
            return board;
        }
        
        public int getDepth() {
            return depth;
        }
        
        public ArrayList<Move> getMoves() {
            return moves;
        }
        
        public ArrayList<Node> getChildren() {
            return children;
        }
        
        public boolean addMove(Move move) {
            moves.add(move);
            return this.board.submitMove(move.getMoveStr());
        }
        
        public void addChild(Node child) {
            children.add(child);
        }
        
        public String toString() {
            StringBuilder buffer = new StringBuilder(50);
            print(buffer, "", "");
            return buffer.toString();
        }
        
        public boolean isLeaf() {
            return children.isEmpty();
        }
        
        private void print(StringBuilder buffer, String prefix, String childrenPrefix) {
            buffer.append(prefix);
            if (moves.isEmpty()) {
                buffer.append("ROOT");
            } else {
                 for (Move move : moves) {
                    buffer.append(move.getMoveStr() + "|");
                 }
                 buffer.append("TURN: " + board.getTurn());
                 buffer.append("|EVALUATION: " + evaluation);
            }
            buffer.append('\n');
            for (Iterator<Node> it = children.iterator(); it.hasNext();) {
                Node next = it.next();
                if (it.hasNext()) {
                    next.print(buffer, childrenPrefix + "├── ", childrenPrefix + "│   ");
                } else {
                    next.print(buffer, childrenPrefix + "└── ", childrenPrefix + "    ");
                }
            }
        }
    }
}
