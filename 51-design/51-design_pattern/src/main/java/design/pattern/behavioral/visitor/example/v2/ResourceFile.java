package design.pattern.behavioral.visitor.example.v2;

public abstract class ResourceFile {
    protected String filePath;

    public ResourceFile(String filePath) {
        this.filePath = filePath;
    }

    abstract public void accept(Extractor extractor);
}
