package design.pattern.behavioral.visitor.example.v2;

public class PdfFile extends ResourceFile {
    public PdfFile(String filePath) {
        super(filePath);
    }

    @Override
    public void accept(Extractor extractor) {
        // 将本身 PdfFile 传进去
        extractor.extract2txt(this);
    }
}