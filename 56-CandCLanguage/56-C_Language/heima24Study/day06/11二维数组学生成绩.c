#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main11()
{
	//�����ά����
	int scores[5][3];
	//int stuSum[5] = 0;
	//¼��ѧ���ɼ�
	for (int i = 0; i < 5; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			switch (j)
			{
			case 0:
				printf("���������ĳɼ���\n");
				scanf("%d", &scores[i][j]);
				break;
			case 1:
				printf("��������ѧ�ɼ���\n");
				scanf("%d", &scores[i][j]);
				break;
			case 2:
				printf("����������ɼ���\n");
				scanf("%d", &scores[i][j]);
				break;
				//stuSum[i] += scores[i][j];
			}
		}
	}
	//���ѧ����ƽ���ɼ�
	int stuSum = 0;
	///int stuAvg = 0;
	for (int i = 0; i < 5; i++)
	{
		stuSum = 0;
		//stuAvg = 0;
		for (int j = 0; j < 3; j++)
		{
			stuSum += scores[i][j];
			//stuAvg = stuSum / 3;
		}
		printf("��%d��ѧ����ƽ���ɼ�Ϊ��%d\n", i + 1, stuSum / 3);
	}

	//ѧ��ƽ���ɼ�
	int cSum = 0, mSum = 0, eSum = 0;
	for (int i = 0; i < 5; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			switch (j)
			{
			case 0:
				cSum += scores[i][j];
				break;
			case 1:
				mSum +=scores[i][j];
				break;
			case 2:
				eSum += scores[i][j];
				break;
			}

		}
	}

	printf("�༶������ƽ���ɼ�Ϊ��%d\n", cSum / 5);
	printf("�༶����ѧƽ���ɼ�Ϊ��%d\n", mSum / 5);
	printf("�༶��Ӣ��ƽ���ɼ�Ϊ��%d\n", eSum / 5);

	system("pause");
	return EXIT_SUCCESS;
}