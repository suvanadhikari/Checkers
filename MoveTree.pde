import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Iterator;
public class MoveTree {
    private Node root = new Node(new Move(""));
    private ArrayList<Move> leaves = new ArrayList<Move>();
    
    private class Node {
        private Move move;
        private ArrayList<Node> children = new ArrayList<Node>();
        
        public Node(Move move) {
            this.move = move;
        }
        
        public void addChild(Node child) {
            children.add(child);
        }
        
        public Move getMove() {
            return move;
        }
        
        public ArrayList<Node> getChildren() {
            return children;
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
            buffer.append(move.getMoveStr());
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
    
    private boolean inRange(int x, int y) {
        return x > -1 && x < 8 && y > -1 && y < 8;
    }
    
    private void findStartingJumps(Piece[][] board, int x, int y, boolean turn) {
        int tMod = turn ? -1 : 1;
        if (board[x][y] != null && board[x][y].getColor() == turn) {
            if (inRange(x + 2, y + tMod * 2) && board[x + 2][y + tMod * 2] == null && board[x + 1][y + tMod] != null && turn != board[x + 1][y + tMod].getColor()) {
                root.addChild(new Node(new Move("" + x + y + (x + 2) + (y + tMod * 2))));
            }
            if (inRange(x - 2, y + tMod * 2) && board[x - 2][y + tMod * 2] == null && board[x - 1][y + tMod] != null && turn != board[x - 1][y + tMod].getColor()) {
                root.addChild(new Node(new Move("" + x + y + (x - 2) + (y + tMod * 2))));
            }
            if (board[x][y].getKing()) {
                if (inRange(x + 2, y - tMod * 2) && board[x + 2][y - tMod * 2] == null && board[x + 1][y - tMod] != null && turn != board[x + 1][y - tMod].getColor()) {
                    root.addChild(new Node(new Move("" + x + y + (x + 2) + (y - tMod * 2))));
                }
                if (inRange(x - 2, y - tMod * 2) && board[x - 2][y - tMod * 2] == null && board[x - 1][y - tMod] != null && turn != board[x - 1][y - tMod].getColor()) {
                    root.addChild(new Node(new Move("" + x + y + (x - 2) + (y - tMod * 2))));
                }
            }
        }
    }
    
    private void followingJumps(Piece[][] board, Node prevJump) {
        String moveStr = prevJump.getMove().getMoveStr();
        int startX = parseInt("" + moveStr.charAt(0));
        int startY = parseInt("" + moveStr.charAt(1));
        int endX = parseInt("" + moveStr.charAt(moveStr.length() - 2));
        int endY = parseInt("" + moveStr.charAt(moveStr.length() - 1));
        Piece piece = board[startX][startY];
        int tMod = piece.getColor() ? -1 : 1;
        
        if (piece.getKing()) {
            if (inRange(endX + 2, endY - tMod * 2) && (board[endX + 2][endY - tMod * 2] == null || board[endX + 2][endY - tMod * 2] == piece) && board[endX + 1][endY - tMod] != null && piece.getColor() != board[endX + 1][endY - tMod].getColor() && checkReJump(new Move(moveStr + "|" + endX + endY + (endX + 2) + (endY - tMod * 2)))) {
                prevJump.addChild(new Node(new Move(moveStr + "|" + endX + endY + (endX + 2) + (endY - tMod * 2))));
            }
            
            if (inRange(endX - 2, endY - tMod * 2) && (board[endX - 2][endY - tMod * 2] == null || board[endX - 2][endY - tMod * 2] == piece) && board[endX - 1][endY - tMod] != null && piece.getColor() != board[endX - 1][endY - tMod].getColor() && checkReJump(new Move(moveStr + "|" + endX + endY + (endX - 2) + (endY - tMod * 2)))) {
                prevJump.addChild(new Node(new Move(moveStr + "|" + endX + endY + (endX - 2) + (endY - tMod * 2))));
            }
            if (inRange(endX + 2, endY + tMod * 2) && (board[endX + 2][endY + tMod * 2] == null || board[endX + 2][endY + tMod * 2] == piece) && board[endX + 1][endY + tMod] != null && piece.getColor() != board[endX + 1][endY + tMod].getColor() && checkReJump(new Move(moveStr + "|" + endX + endY + (endX + 2) + (endY + tMod * 2)))) {
                prevJump.addChild(new Node(new Move(moveStr + "|" + endX + endY + (endX + 2) + (endY + tMod * 2))));
            }
            
            if (inRange(endX - 2, endY + tMod * 2) && (board[endX - 2][endY + tMod * 2] == null || board[endX - 2][endY + tMod * 2] == piece) && board[endX - 1][endY + tMod] != null && piece.getColor() != board[endX - 1][endY + tMod].getColor() && checkReJump(new Move(moveStr + "|" + endX + endY + (endX - 2) + (endY + tMod * 2)))) {
                prevJump.addChild(new Node(new Move(moveStr + "|" + endX + endY + (endX - 2) + (endY + tMod * 2))));
            }
        } else {
            if (inRange(endX + 2, endY + tMod * 2) && board[endX + 2][endY + tMod * 2] == null && board[endX + 1][endY + tMod] != null && piece.getColor() != board[endX + 1][endY + tMod].getColor()) {
                prevJump.addChild(new Node(new Move(moveStr + "|" + endX + endY + (endX + 2) + (endY + tMod * 2))));
            }
            
            if (inRange(endX - 2, endY + tMod * 2) && board[endX - 2][endY + tMod * 2] == null && board[endX - 1][endY + tMod] != null && piece.getColor() != board[endX - 1][endY + tMod].getColor()) {
                prevJump.addChild(new Node(new Move(moveStr + "|" + endX + endY + (endX - 2) + (endY + tMod * 2))));
            }
        }
    }
    
    private boolean checkReJump(Move checkMove) {
        String[] moves = checkMove.getMoveStr().split("\\|");
        int jumpX = (Integer.parseInt("" + moves[moves.length - 1].charAt(0)) + Integer.parseInt("" + moves[moves.length - 1].charAt(2))) / 2;
        int jumpY = (Integer.parseInt("" + moves[moves.length - 1].charAt(1)) + Integer.parseInt("" + moves[moves.length - 1].charAt(3))) / 2;
        for (int i = 0; i < moves.length - 1; i++) {
            String move = moves[i];
            int moveJumpX = (Integer.parseInt("" + move.charAt(0)) + Integer.parseInt("" + move.charAt(2))) / 2;
            int moveJumpY = (Integer.parseInt("" + move.charAt(1)) + Integer.parseInt("" + move.charAt(3))) / 2;
            if (jumpX == moveJumpX && jumpY == moveJumpY) {
                return false;
            }
        }
        return true;
    }
    
    private void findJumps(Board b) {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                findStartingJumps(b.getBoard(), i, j, b.getTurn());
            }
        }
        
        LinkedList<Node> checkList = new LinkedList<Node>();
        
        for (Node node : root.getChildren()) {
            checkList.add(node);
        }

        Node current;
        while (!checkList.isEmpty()) {
            current = checkList.remove();
            followingJumps(b.getBoard(), current);
            for (Node n : current.getChildren()) {
                checkList.add(n);
            }
        }
    }
    
    private void findValidJumps(Node node) {
        if (node.isLeaf()) {
            leaves.add(node.getMove());
        } else {
            for (Node child : node.getChildren()) {
                findValidJumps(child);
            }
        }
    }
    
    private ArrayList<Move> findMoves(Piece[][] board, boolean turn) {
        ArrayList<Move> returnList = new ArrayList<Move>();
        int tMod = turn ? -1 : 1;
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                if (board[i][j] != null && board[i][j].getColor() == turn) {
                    if (inRange(i + 1, j + tMod) && board[i + 1][j + tMod] == null) {
                        returnList.add(new Move("" + i + j + (i + 1) + (j + tMod)));
                    }
                    if (inRange(i - 1, j + tMod) && board[i - 1][j + tMod] == null) {
                        returnList.add(new Move("" + i + j + (i - 1) + (j + tMod)));
                    }
                    if (board[i][j].getKing()) {
                        if (inRange(i + 1, j - tMod) && board[i + 1][j - tMod] == null) {
                            returnList.add(new Move("" + i + j + (i + 1) + (j - tMod)));
                        }
                        if (inRange(i - 1, j - tMod) && board[i - 1][j - tMod] == null) {
                            returnList.add(new Move("" + i + j + (i - 1) + (j - tMod)));
                        }
                    }
                }
            }
        }
        return returnList;
    }
    
    public ArrayList<Move> getMoves(Board b) {
        clear();
        findJumps(b);
        findValidJumps(root);
        if (!leaves.get(0).getMoveStr().equals("")) {
            return leaves;
        }
        return findMoves(b.getBoard(), b.getTurn());
    } 
    
    public void clear() {
        root = new Node(new Move(""));
        leaves.clear();
    }
    
    public String toString() {
        return root.toString();
    }
    
}
