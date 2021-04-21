package design.pattern.behavioral.visitor.example.v1;

import java.util.ArrayList;
import java.util.List;

/**
 * 假设我们从网站上爬取了很多资源文件，它们的格式有三种：PDF、PPT、Word。我们现 在要开发一个工具来处理这批资源文件。
 * 这个工具的其中一个功能是，把这些资源文件中的 文本内容抽取出来放到 txt 文件中。如果让你来实现，你会怎么来做呢？
 *
 * 实现这个功能并不难，不同的人有不同的写法，我将其中一种代码实现方式贴在这里。其 中，ResourceFile 是一个抽象类，
 * 包含一个抽象函数 extract2txt()。PdfFile、PPTFile、 WordFile 都继承 ResourceFile 类，并且重写了 extract2txt() 函数。
 * 在 ToolApplication 中，我们可以利用多态特性，根据对象的实际类型，来决定执行哪个方法。
 */
public class ToolApplication {
    public static void main(String[] args) {
        List<ResourceFile> resourceFiles = listAllResourceFiles();
        for (ResourceFile resourceFile : resourceFiles) {
            resourceFile.extract2txt();
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