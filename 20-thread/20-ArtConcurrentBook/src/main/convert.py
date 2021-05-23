# Python3 将GBK转换成utf-8编码，明天继续实现，把*.java文件 *.porperties文件都转成utf-8
import codecs
def ReadFile(filePath,encoding="gbk"):
    with codecs.open(filePath,"r",encoding) as f:
        return f.read()
 
def WriteFile(filePath,u,encoding="utf-8"):
    with codecs.open(filePath,"w",encoding) as f:
        f.write(u)
 
def UTF8_2_GBK(src,dst):
    content = ReadFile(src,encoding="gbk")
    WriteFile(dst,content,encoding="utf-8")

import os
import os.path
# 递归遍历rootdir目录，把目录中的*.java编码由gbk转换为utf-8
def ReadDirectoryFile(rootdir):
    for parent,dirnames,filenames in os.walk(rootdir):
            #case 1:
            for dirname in dirnames:
                    print("parent folder is:" + parent)
                    print("dirname is:" + dirname)
            #case 2
            for filename in filenames:    
                    print("parent folder is:" + parent)
                    print("filename with full path:"+ os.path.join(parent,filename))
                    if filename.endswith(".java"):
                            UTF8_2_GBK(os.path.join(parent,filename),os.path.join(parent,filename))
                            print("Java文件")
if __name__=="__main__":
    ReadDirectoryFile(".")