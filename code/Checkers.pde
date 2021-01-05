Board b = new Board();
MoveTree m = new MoveTree();
ArrayList<ArtificialPlayer> players = new ArrayList<ArtificialPlayer>(Arrays.asList(null, new BrainZero(), new BrainOne(), new BrainTwo()));
StartScreen s = new StartScreen(players);
String scene = "start";

void setup() {
    size(1500, 1500);
    frameRate(60);
    background(100);
}

void mouseClicked() {
    if (scene.equals("start")) {
        if (s.click()) {
            scene = "game";
            b.setPlayerOne(s.getPlayerOne());
            b.setPlayerTwo(s.getPlayerTwo());
        }
    }
    else if (scene.equals("game")) {
        b.click(mouseX, mouseY);
    }
}

void keyPressed() {
    if (keyCode == ENTER) {
        b.submitClicks();
    }
}

void draw() {
    if (scene.equals("start")) {
        s.display();
    }
    else if (scene.equals("game")) {
        b.displayBoard();
        if (b.gameStatus() == 0) {
            b.pollForMove();
        } else {
            fill(200, 200);
            rect(0, 0, 1500, 1500);
            fill(0, 0, 0);
            text(b.gameStatus() == -1 ? "RED WINS" : "BLACK WINS", 750, 750);
            noLoop();
        }
    }
};
