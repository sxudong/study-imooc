/*
01 写一个程序满足一下要求：
	a.外部定义一个name结构模板，它含有2个成员:一个字符串用于存放名字，另一个字符串用于存放姓氏。
	b.外部定义一个student结构模板，它含有3个成员：一个name结构，一个存放3个浮点数分数的grade数组，以及一个存放这3个分数的平均分的变量。

	c.在main函数中声明一个具有CSIZE(CSIZE=4)个student结构的数组，并随意初始化这些结构体的名字部分。使用函数来执行d、e、f以及g部分所描述的任务。

	d.请求用户输入学生的姓名和分数，以交互地获得每个学生的成绩。将分数存放到相应结构的grade数组成员中。您可以自主选择在main或者一个函数中实现这个循环。

	e.为这个结构计算平均分，并把这个值赋给适合的成员。
	f.输出每个结构中的信息。
	g.输出结构的每个数值成员的班级平均分。
*/

#define CSIZE 2

void init_students(struct sutdent *stu){
	for (int i = 0; i < CSIZE; i++){
		//初始化平均成绩
		stu[i].average_score = 0;

		printf("请输入第%d个学生的姓氏:\n",i + 1);
		scanf("%s", stu[i].stu_name.family_name);
		printf("请输入第%d个学生的名字:\n", i + 1);
		scanf("%s", stu[i].stu_name.given_name);
		for (int j = 0; j < 3;j ++){
			printf("请输入%s %s的第%d门成绩:\n", stu[i].stu_name.family_name, stu[i].stu_name.given_name,j + 1);
			scanf("%f", &(stu[i].grade[j]));
			//累计成绩
			stu[i].average_score += stu[i].grade[j];
		}
		//计算平均成绩
		stu[i].average_score = stu[i].average_score / 3;
	}
}

void show_students(struct sutdent *stu){
	int avg_score = 0;
	for (int i = 0; i < CSIZE; i++){
		printf("%s %s的成绩为:\n",stu[i].stu_name.family_name,stu[i].stu_name.given_name);
		for (int j = 0; j < 3; j ++){
			printf(" 第%d门成绩为%f\n",j + 1,stu[i].grade[j]);
		}
		printf("平均成绩为:%f\n",stu[i].average_score);
		printf("------------------------------\n");
	}
}

void test(){
	//创建四个学生
	struct sutdent stu[CSIZE];
	init_students(stu);
	printf("------------------------------\n");
	show_students(stu);
}