public abstract class ArtificialPlayer {
    protected String name;
    public abstract String findMove(Board b);
    public abstract ArtificialPlayer get();
    public String getName() {
        return name;
    }
}
