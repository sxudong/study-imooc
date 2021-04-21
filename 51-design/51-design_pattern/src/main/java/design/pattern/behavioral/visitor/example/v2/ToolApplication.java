package design.pattern.behavioral.visitor.example.v2;

import java.util.ArrayList;
import java.util.List;

public class ToolApplication {
    public static void main(String[] args) {
        Extractor extractor = new Extractor();
        List<ResourceFile> resourceFiles = listAllResourceFiles();
        for (ResourceFile resourceFile : resourceFiles) {
            // 根据多态特性，程序会调用实际类型的 accept 函数，比如 PdfFile 的 accept 函数，
            // this 类型是 PdfFile 的，，所以会调用 extractor 的 extract2txt(PdfFile pdfFile)
            // 这个重载函 数。
            resourceFile.accept(extractor);
        }
    }

    private static List<ResourceFile> listAllResourceFiles() {
        List<ResourceFile> resourceFiles = new ArrayList<>();
        //...根据后缀(pdf/ppt/word)由工厂方法创建不同的类对象(PdfFile/PPTFile/WordFile)
        resourceFiles.add(new PdfFile("a.pdf"));
        resourceFiles.add(new WordFile("b.word"));
        resourceFiles.add(new PPTFile("c.ppt"));
        return resourceFiles;
    }
}
/* Output:
Extract PDF.
Extract WORD.
Extract PPT.
*///~