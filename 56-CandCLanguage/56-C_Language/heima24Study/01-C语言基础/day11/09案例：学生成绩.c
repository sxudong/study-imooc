#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct stu2
{
    //成员列表
    //char name[21];
    char * name;
    float * scores;
};


int main()
{
    //开辟3个stu2结构体对象堆空间
    struct stu2 *p = (struct stu2 *)malloc(sizeof(struct stu2) * 3);
    for (int i = 0; i < 3; i++){
        p[i].name = (char *)malloc(sizeof(char) * 21);    //开辟堆空间存储名字
        p[i].scores = (float *)malloc(sizeof(float) * 3); //开辟堆空间存储分数
        //(p+i)->name

        printf("请您输入学生 姓名   成绩 ：\n");
        scanf("%s%f%f%f", p[i].name, &p[i].scores[0], &p[i].scores[1], &p[i].scores[2]);

    }

    //冒泡排序
    for (int i = 0; i < 3 - 1; i++){
        for (int j = 0; j < 3 - i - 1; j++){
            //学生总成绩
            float sum1 = p[j].scores[0] + p[j].scores[1] + p[j].scores[2];
            float sum2 = p[j + 1].scores[0] + p[j + 1].scores[1] + p[j + 1].scores[2];
            //成绩大的学生放在后面
            if (sum1 > sum2){
                struct stu2 temp = p[j];
                p[j] = p[j + 1];
                p[j + 1] = temp;
            }
        }
    }

    //打印学生成绩
    for (int i = 0; i < 3; i++){
        printf("姓名：%s\n", p[i].name);
        printf("成绩: %.1f   %.1f   %.1f\n", p[i].scores[0], p[i].scores[1], p[i].scores[2]);
    }


    //释放堆空间
    for (int i = 0; i < 3; i++){
        free(p[i].name);
        free(p[i].scores);
    }

    //释放结构体堆空间
    free(p);

    system("pause");
    return EXIT_SUCCESS;
}
/* Output:
请您输入学生 姓名   成绩 ：
lucy 100 60 80
请您输入学生 姓名   成绩 ：
Aaron 77 95 100
请您输入学生 姓名   成绩 ：
Jimmy 98 66 78
姓名：lucy
成绩: 100.0   60.0   80.0
姓名：Jimmy
成绩: 98.0   66.0   78.0
姓名：Aaron
成绩: 77.0   95.0   100.0
请按任意键继续. . .
*/