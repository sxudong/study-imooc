package design.principle.liskovsubstitution.v1;

/**
 * 正方形
 */
public class Square extends Rectangle{
    private long sidelength;

    public long getSidelength() {
        return sidelength;
    }

    public void setSidelength(long sidelength) {
        this.sidelength = sidelength;
    }

    @Override
    public long getLength() {
        return getSidelength();
    }

    @Override
    public void setLength(long length) {
        setSidelength(length);
    }

    @Override
    public long getWidth() {
        return getSidelength();
    }

    @Override
    public void setWidth(long width) {
        setLength(width);
    }
}