/*
01 ĳ�������ļ������˼�ͥ��Ա�����䡣һ����ͥ������Ա������λ��ͬһ�У��ɿո�ָ����
���������
----------------------
45 42 22
36 35 7 3 1
22 30
----------------------
������������ͥ�����г�Ա�����䣬���Ƿֱ���3����5����2����Ա��
��дһ�����򣬼����������ļ���ʾ��ÿ����ͥ���г�Ա��ƽ�����䡣����Ӧ���ø�ʽ���� % 5.2f
��ӡ��ƽ�����䣬��ͥÿ����Ա�����䡣
*/

void test() {

	FILE* fp = fopen("./age.txt", "r");
	if (NULL == fp) {
		printf("�ļ���ʧ��!\n");
		return;
	}

	char buf[1024] = { 0 };
	while (fgets(buf, 1024, fp)) {
		//printf("%s",buf);
		//ȥ����ĩ�Ļ���
		buf[strlen(buf) - 1] = '\0';
		char* temp = strtok(buf, " ");
		printf("��ͥ��Ա����:%d  ", atoi(temp));
		//ͳ�Ƶ�ǰ��ͥ��Ա�����ۺ�
		float total_age = (float)atoi(temp);
		//��¼��ͥ����
		int num = 1;
		while (temp) {
			temp = strtok(NULL, " ");
			if (temp) {
				printf("%d  ", atoi(temp));
				total_age += (float)atoi(temp);
				num++;
			}
		}

		//��ӡ��ͥ��Աƽ������
		printf("\n��ǰ��ͥƽ������Ϊ:%5.2f\n", total_age / num);
		printf("----------------------------------\n");
		memset(buf, 0, 1024);
	}

	//�ر��ļ�
	fclose(fp);
}

/*
02 ��дһ������sort�ĺ����������ڶ�һ���������͵������������Ϊ��ʹ������Ϊͨ�ã�����
����һ������������һ��ָ��Ƚϻص�������ָ�룬�ûص������ɵ��ó����ṩ���ȽϺ�������
����������Ҳ��������ָ����Ҫ�Ƚϵ�ֵ��ָ�롣�������ֵ��ȣ���������0�������1��ֵС
�ڵ�2������������һ��С��0�������������1��ֵ���ڵ�2��ֵ����������һ������0��������
sort�����Ĳ����ǣ�
1. һ��ָ����Ҫ���������ĵ�1��ֵ��ָ�롣
2. ������Ԫ�صĸ�����
3. һ��ָ��Ƚϻص�������ָ�롣
*/

struct Person {
	int ID;
	char name[64];
};

void sort(void* arr, int len_eles, size_t size_ele, int(*compare)(void*, void*)) {

	char* p_start = (char*)arr;
	//�����ռ�
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
	//�ͷŸ����ռ�
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
	//��ӡ
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

	//��ȡ�����С
	int len = sizeof(persons) / sizeof(struct Person);
	//����
	sort(persons, len, sizeof(struct Person), mycompare_person);
	//��ӡ
	for (int i = 0; i < len; i++) 
		printf("ID:%d Name:%s\n", persons[i].ID, persons[i].name);
}
/* Output:
10 20 30 40 50 60
�밴���������. . .
*/
