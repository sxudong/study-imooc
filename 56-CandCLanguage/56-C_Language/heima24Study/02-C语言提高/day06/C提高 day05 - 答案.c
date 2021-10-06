/*
01 某个数据文件包含了家庭成员的年龄。一个家庭各个成员的年龄位于同一行，由空格分割。例如
下面的数据
----------------------
45 42 22
36 35 7 3 1
22 30
----------------------
描述了三个家庭的所有成员的年龄，它们分别有3个、5个和2个成员。
编写一个程序，计算这种用文件表示的每个家庭所有成员的平均年龄。程序应该用格式代码 % 5.2f
打印出平均年龄，家庭每个成员的年龄。
*/

void test() {

	FILE* fp = fopen("./age.txt", "r");
	if (NULL == fp) {
		printf("文件打开失败!\n");
		return;
	}

	char buf[1024] = { 0 };
	while (fgets(buf, 1024, fp)) {
		//printf("%s",buf);
		//去掉行末的换行
		buf[strlen(buf) - 1] = '\0';
		char* temp = strtok(buf, " ");
		printf("家庭成员年龄:%d  ", atoi(temp));
		//统计当前家庭成员年龄综合
		float total_age = (float)atoi(temp);
		//记录家庭人数
		int num = 1;
		while (temp) {
			temp = strtok(NULL, " ");
			if (temp) {
				printf("%d  ", atoi(temp));
				total_age += (float)atoi(temp);
				num++;
			}
		}

		//打印家庭成员平均年龄
		printf("\n当前家庭平均年龄为:%5.2f\n", total_age / num);
		printf("----------------------------------\n");
		memset(buf, 0, 1024);
	}

	//关闭文件
	fclose(fp);
}

/*
02 编写一个名叫sort的函数，它用于对一个任意类型的数组进行排序。为了使函数更为通用，它的
其中一个参数必须是一个指向比较回调函数的指针，该回调函数由调用程序提供。比较函数接受
两个参数，也就是两个指向需要比较的值的指针。如果两个值相等，函数返回0；如果第1个值小
于第2个，函数返回一个小于0的整数；如果第1个值大于第2个值，函数返回一个大于0的整数。
sort函数的参数是：
1. 一个指向需要排序的数组的第1个值的指针。
2. 数组中元素的个数。
3. 一个指向比较回调函数的指针。
*/

struct Person {
	int ID;
	char name[64];
};

void sort(void* arr, int len_eles, size_t size_ele, int(*compare)(void*, void*)) {

	char* p_start = (char*)arr;
	//辅助空间
	char* temp = (char*)malloc(size_ele);
	for (int i = 0; i < len_eles; i++) {
		for (int j = len_eles - 1; j > i; j--) {
			char* first_ptr = p_start + j * size_ele;
			char* second_ptr = p_start + (j - 1) * size_ele;
			if (compare(first_ptr, second_ptr)) {
				memcpy(temp, first_ptr, size_ele);
				memcpy(first_ptr, second_ptr, size_ele);
				memcpy(second_ptr, temp, size_ele);
			}
		}
	}
	//释放辅助空间
	free(temp);
	temp = NULL;
}

int mycompare_person(void* data1, void* data2) {
	struct Person* d1 = (struct Person*)data1;
	struct Person* d2 = (struct Person*)data2;
	return d1->ID > d2->ID;
}

int mycompare_int(void* data1, void* data2) {
	int* d1 = (int*)data1;
	int* d2 = (int*)data2;
	return *d1 > *d2;
}


void test01() {
	//test();
	int arr[] = { 6, 2, 9, 8, 1, 3 };
	int len = sizeof(arr) / sizeof(int);
	sort(arr, len, sizeof(int), mycompare_int);
	//打印
	for (int i = 0; i < len; i++)
		printf("%d ", arr[i]);
}

void test02() {
	struct Person persons[5] = {
		{ 4, "Smith" },
		{ 2, "Obama" },
		{ 8, "John" },
		{ 6, "Jordon" },
		{ 5, "Polly" },
	};

	//获取数组大小
	int len = sizeof(persons) / sizeof(struct Person);
	//排序
	sort(persons, len, sizeof(struct Person), mycompare_person);
	//打印
	for (int i = 0; i < len; i++)
		printf("ID:%d Name:%s\n", persons[i].ID, persons[i].name);
}
/* Output:
10 20 30 40 50 60
请按任意键继续. . .
*/
