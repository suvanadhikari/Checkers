public class StartScreen {
    private ArrayList<ArtificialPlayer> choices;
    private int playerOneIndex = 0;
    private int playerTwoIndex = 0;
    
    
    public StartScreen(ArrayList<ArtificialPlayer> choices) {
        this.choices = choices;
    }
    
    public void display() {
        background(100, 100, 100);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(75);
        text("Checkers", 750, 200);
        textSize(50);
        text("Choose Players", 750, 500);
        fill(200, 50, 50);
        rectMode(CENTER);
        rect(375, 750, 500, 250);
        fill(20, 20, 20);
        rect(1125, 750, 500, 250);
        fill(20, 20, 20);
        if (choices.get(playerOneIndex) == null) {
            text("Human", 375, 750);
        } else {
            text(choices.get(playerOneIndex).getName(), 375, 750);
        }
        fill(200, 50, 50);
        if (choices.get(playerTwoIndex) == null) {
            text("Human", 1125, 750);
        } else {
            text(choices.get(playerTwoIndex).getName(), 1125, 750);
        }
        fill(150);
        rect(750, 1200, 300, 100, 100);
        fill(0);
        text("Begin", 750, 1200);
        rectMode(CORNER);
    }
    
    public boolean click() {
        if (mouseX > 125 && mouseX < 615 && mouseY > 625 && mouseY < 875) {
            playerOneIndex++;
            if (playerOneIndex >= choices.size()) {
                playerOneIndex = 0;
            }
        }
        if (mouseX > 875 && mouseX < 1375 && mouseY > 625 && mouseY < 875) {
            playerTwoIndex++;
            if (playerTwoIndex >= choices.size()) {
                playerTwoIndex = 0;
            }
        }
        if (mouseX > 600 && mouseX < 900 && mouseY > 1150 && mouseY < 1250) {
            return true;
        }
        return false;
    }
    
    public ArtificialPlayer getPlayerOne() {
        return choices.get(playerOneIndex);
    }
    
    public ArtificialPlayer getPlayerTwo() {
        return choices.get(playerTwoIndex);
    }
}
