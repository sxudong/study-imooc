#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/**
 * 11案例：学生成绩
 */

struct stu2
{
    //成员列表
    //char name[21];
    char * name;
    float * scores;
};


// windows用下划线命令方式int _role_level  int i_role_level。
// java用驼峰式命名方式bubbleSort
void BubbleSort(struct stu2 * p,int len)
{
    //冒泡排序
    for (int i = 0; i < len - 1; i++){
        for (int j = 0; j < len - i - 1; j++){
            float sum1 = p[j].scores[0] + p[j].scores[1] + p[j].scores[2];
            float sum2 = p[j + 1].scores[0] + p[j + 1].scores[1] + p[j + 1].scores[2];
            if (sum1 > sum2){
                struct stu2 temp = p[j];
                p[j] = p[j + 1];
                p[j + 1] = temp;
            }
        }
    }
}


int main()
{
    struct stu2 *p = (struct stu2 *)malloc(sizeof(struct stu2) * 3);
    for (int i = 0; i < 3; i++){
        //开辟名字和分数的堆空间
        p[i].name = (char *)malloc(sizeof(char) * 21);
        p[i].scores = (float *)malloc(sizeof(float) * 3);
        //(p+i)->name

        printf("请您输入学生 姓名   成绩 ：\n");
        scanf("%s%f%f%f", p[i].name, &p[i].scores[0], &p[i].scores[1], &p[i].scores[2]);

    }

    BubbleSort(p, 3);

    for (int i = 0; i < 3; i++){

        printf("姓名：%s\n", p[i].name);
        printf("成绩: %.1f   %.1f   %.1f\n", p[i].scores[0], p[i].scores[1], p[i].scores[2]);
    }

    //释放名字和分数的堆空间
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
Aaron 78 80 88
请您输入学生 姓名   成绩 ：
Jimmy 98 69 88
请您输入学生 姓名   成绩 ：
lucy 100 100 100
姓名：Aaron
成绩: 78.0   80.0   88.0
姓名：Jimmy
成绩: 98.0   69.0   88.0
姓名：lucy
成绩: 100.0   100.0   100.0
请按任意键继续. . .
*/