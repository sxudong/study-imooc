/*
01 дһ����������һ��Ҫ��
	a.�ⲿ����һ��name�ṹģ�壬������2����Ա:һ���ַ������ڴ�����֣���һ���ַ������ڴ�����ϡ�
	b.�ⲿ����һ��student�ṹģ�壬������3����Ա��һ��name�ṹ��һ�����3��������������grade���飬�Լ�һ�������3��������ƽ���ֵı�����

	c.��main����������һ������CSIZE(CSIZE=4)��student�ṹ�����飬�������ʼ����Щ�ṹ������ֲ��֡�ʹ�ú�����ִ��d��e��f�Լ�g����������������

	d.�����û�����ѧ���������ͷ������Խ����ػ��ÿ��ѧ���ĳɼ�����������ŵ���Ӧ�ṹ��grade�����Ա�С�����������ѡ����main����һ��������ʵ�����ѭ����

	e.Ϊ����ṹ����ƽ���֣��������ֵ�����ʺϵĳ�Ա��
	f.���ÿ���ṹ�е���Ϣ��
	g.����ṹ��ÿ����ֵ��Ա�İ༶ƽ���֡�
*/

#define CSIZE 2

void init_students(struct sutdent *stu){
	for (int i = 0; i < CSIZE; i++){
		//��ʼ��ƽ���ɼ�
		stu[i].average_score = 0;

		printf("�������%d��ѧ��������:\n",i + 1);
		scanf("%s", stu[i].stu_name.family_name);
		printf("�������%d��ѧ��������:\n", i + 1);
		scanf("%s", stu[i].stu_name.given_name);
		for (int j = 0; j < 3;j ++){
			printf("������%s %s�ĵ�%d�ųɼ�:\n", stu[i].stu_name.family_name, stu[i].stu_name.given_name,j + 1);
			scanf("%f", &(stu[i].grade[j]));
			//�ۼƳɼ�
			stu[i].average_score += stu[i].grade[j];
		}
		//����ƽ���ɼ�
		stu[i].average_score = stu[i].average_score / 3;
	}
}

void show_students(struct sutdent *stu){
	int avg_score = 0;
	for (int i = 0; i < CSIZE; i++){
		printf("%s %s�ĳɼ�Ϊ:\n",stu[i].stu_name.family_name,stu[i].stu_name.given_name);
		for (int j = 0; j < 3; j ++){
			printf(" ��%d�ųɼ�Ϊ%f\n",j + 1,stu[i].grade[j]);
		}
		printf("ƽ���ɼ�Ϊ:%f\n",stu[i].average_score);
		printf("------------------------------\n");
	}
}

void test(){
	//�����ĸ�ѧ��
	struct sutdent stu[CSIZE];
	init_students(stu);
	printf("------------------------------\n");
	show_students(stu);
}