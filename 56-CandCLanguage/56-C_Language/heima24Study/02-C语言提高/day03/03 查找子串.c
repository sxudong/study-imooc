#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*
* �����Ӵ���һ�γ��ֵ�λ��
*
* ˼·��abcdefgdfpoiq  ����df
*       ���ȱ����ҵ�d
*       �ҵ�d֮���ٱ���d֮����Ӵ����Ƚϵ�2���ַ��Ƿ���ȣ�
*       �������Ƚ����˴�whileѭ���������whileѭ���м���
*       Ѱ��d,�ҵ�d֮���ٱ���d֮����Ӵ����Ƚϵ�һ�θ�ѭ��
*       ֱ���ҵ�Ϊֹ��
*/
char* myStrStr(const char* str, const char* substr)
{
	//printf("%s\n",str); //abcdefgdfpoiq
	//printf("%s\n", substr); //df

	const char* mystr = str;
	const char* mysub = substr;

	while (*mystr != '\0')
	{
		//�Ƚ��׵�ֵַ�Ƿ���ȣ�d = d��
		if (*mystr != *mysub)
		{
			++mystr;
			continue; //��������ѭ����������һ��whileѭ��
		}


		//��ʱָ�����
		const char* temp_mystr = mystr;
		const char* temp_mysub = mysub;

		while (*temp_mysub != '\0') //���Ҫ�ҵ��ַ�����û����β
		{
			//�Ƚ��׵�ֵַ�Ƿ���ȣ�d = d������������++���Ƚϵ�2���ַ�
			if (*temp_mystr != *temp_mysub)
			{
				++mystr; //����ȣ����ҵ�Դ�ӷ���++,�����һ���ַ�
				break;   //����whileѭ�����������whileѭ����������mystr��Ѱ������ĸƥ����ַ���
			}

			++temp_mysub;
			++temp_mystr;
		}

		//˵��ƥ��ɹ�
		if (*temp_mysub == '\0') //'\0'˵���Ѿ��ҵ����ַ�������β
		{
			return (char*)mystr;
		}

	}

	return NULL;
}


void test()
{
	char* str = "abcdefgdfpoiq";
	char* sub = "df";
	char* pos = myStrStr(str, sub);
	printf("pos = %s\n", pos); //pos = dfpoiq

}

int main() {

	test();

	system("pause");
	return EXIT_SUCCESS;
}