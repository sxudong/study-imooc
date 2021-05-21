#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <time.h>


//1.随机 100000 数据  1-1000,写入到文件中.
//2.读取出来，进行从小到大的排序，再写入到文件中.

/**
 * 1.随机100000数据，范围：1~1000,写入到文件中.
 *   写入到g.txt中。
 */
int main1()
{
    //随机种子
    srand((unsigned int)time(NULL));
    //w 以写的方式打开文件 文件不存在会创建新文件 如果文件里面有内容会覆盖原始内容
    FILE * fp = fopen("../../g.txt", "w");
    if (!fp)
        return -1;

    //随机1000以内的数字
    for (int i = 0; i < 100000; i++){
        fprintf(fp, "%d\n", rand() % 1000 + 1);
    }
    //关闭文件
    fclose(fp);

    system("pause");
    return EXIT_SUCCESS;
}
/* 在g.txt文件中写入随机数：
870
856
962
488
788
569
......
*/


/**
 * 2.读取出来，进行从小到大的排序，再写入到文件中.
 *   将上一个main()生成的g.txt文件里的随机数进行排序
 *   此代码运行占用CPU资料30%多，耗时30秒。
 */
int main2()
{
    //开始时间
    unsigned int start_time = time(NULL);

    //r 以只读形式打开文件 不会创建新文件，如果文件不存在会报错
    FILE * fp = fopen("../../g.txt", "r");
    if (!fp)
        return -1;

    //分配4 * 100000 个字节堆空间
    int *p = (int *)malloc(sizeof(int) * 100000);

    //读取数据
    for (int i = 0; i < 100000; i++)
        fscanf(fp, "%d\n", &p[i]); //格式化读取值,读取到p中

    //冒泡排序
    for (int i = 0; i < 100000 - 1; i++){
        for (int j = 0; j < 100000 - i - 1; j++){
            if (p[j] > p[j + 1]){
                int temp = p[j];
                p[j] = p[j + 1];
                p[j + 1] = temp;
            }
        }
    }

    //关闭文件
    fclose(fp);

    //写入到文件中

    //w 以写的方式打开文件 文件不存在会创建新文件 如果文件里面有内容会覆盖原始内容
    fp = fopen("../../g.txt", "w");
    if (!fp)
        return -1;
    for (int i = 0; i < 100000; i++)
        fprintf(fp, "%d\n", p[i]); //格式化写入文件中
    fclose(fp); //关闭文件

    free(p); //释放结构体堆内存

    unsigned int end_time = time(NULL);
    printf("用时时间：%d(s)\n", end_time - start_time);

    system("pause");
    return 0;
}
/* Output:
用时时间：30(s)
请按任意键继续. . .
*/


/**
 * 10000人年龄排序
 *   使用数组方式方式，效率更高，耗时0秒。
 */
int main()
{
    unsigned int start_time = time(NULL);

    FILE * fp = fopen("../../g.txt", "r");
    if (!fp)
        return -1;

    //由于是1~1000的随机数字，创建一个1000的数组
    int arr[1000] = {0}; //定义一个1000个元素的整型数组,并初始化全部值为0
    int value;

    //int sum = 0;
    //计算数组i+1记录的次数，如arr[0]记录“1”出现的次数，
    //arr[0]++代表：数组arr[0]的值加加操作
    for (int i = 0; i < 100000; i++){
        fscanf(fp, "%d\n", &value); //格式化读取值
        arr[value - 1]++;           //
    }

    //关闭文件
    fclose(fp);

    fp = fopen("../../g.txt", "w");
    if (!fp)
        return -1;

    //两层遍历
    for (int i = 0; i < 1000; i++) //遍历数组
        for (int j = 0; j < arr[i]; j++) //遍历打印数组里的次数
            fprintf(fp, "%d\n", i + 1);
    fclose(fp);
    unsigned int end_time = time(NULL);
    printf("用时时间：%d(s)\n", end_time - start_time);

}
/* Output:
用时时间：0(s)
*/

/* 使用数组方式的分析：
1~1000随机数值：
429
218
37
833
162
429
744
113
755
722
411

  int arr[1000] = {0};
  for(int i = 0; i < 1000; i++){
     //1出现次数
     arr[0]++
     arr[429]++
  }

  其结果是：
    arr[0]=2
    arr[1]=2
    arr[2]=2
    arr[3]=1

*/