package design.pattern.behavioral.visitor.example.v3;

public class PPTFile extends ResourceFile {

    public PPTFile(String filePath) {
        super(filePath);
    }

    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }
}