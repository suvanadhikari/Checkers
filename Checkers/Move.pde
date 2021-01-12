import java.util.ArrayList;
import java.util.Arrays;

public class Move {
    private String moveStr = "";
    public Move(String moveStr) {
        this.moveStr = moveStr;
    }

    public ArrayList<String[]> getActions(boolean turn) {
        if (moveStr.equals("")) {
            return new ArrayList<String[]>();
        }
        ArrayList<String[]> returnList = new ArrayList<String[]>();
        String[] segments = moveStr.split("\\|");
        for (String item : segments) {
            String[] move = {"m", item};
            returnList.add(move);
            // Finding out if the segment is a jump (seeing if x coordinates before and after are 2 apart)
            if (Math.abs(Integer.parseInt("" + item.charAt(0)) - Integer.parseInt("" + item.charAt(2))) == 2) {
                int x = (Integer.parseInt("" + item.charAt(0)) + Integer.parseInt("" + item.charAt(2))) / 2;
                int y = (Integer.parseInt("" + item.charAt(1)) + Integer.parseInt("" + item.charAt(3))) / 2;
                String[] removal = {"r", ("" + x + y)};
                returnList.add(removal);
            }
            // Kinging if necessary
            if (Integer.parseInt("" + item.charAt(3)) == (turn ? 0 : 7)) {
                String[] kinging = {"k", item.substring(2, 4)};
                returnList.add(kinging);
            }
        }
        return returnList;
    }
    
    public String getMoveStr() {
        return moveStr;
    }

    public String toString() {
        return moveStr;
    }
}
