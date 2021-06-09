#include <cstdio>
#include <cstdlib>
// ���������
class Strategy
{
public:
	Strategy(){}
	virtual void sort(int arr[], int N) = 0;
};
// ������ԣ�ð������
class BubbleSort :public Strategy
{
public:
	BubbleSort(){
		printf("ð������\n");
	}
	void sort(int arr[], int N){
		for (int i = 0; i<N; i++)
		{
			for (int j = 0; j<N - i - 1; j++)
			{
				if (arr[j]>arr[j + 1]){
					int tmp = arr[j];
					arr[j] = arr[j + 1];
					arr[j + 1] = tmp;
				}
			}
		}
	}
};
// ������ԣ�ѡ������
class SelectionSort :public Strategy
{
public:
	SelectionSort(){
		printf("ѡ������\n");
	}
	void sort(int arr[], int N){
		int i, j, k;
		for (i = 0; i<N; i++)
		{
			k = i;
			for (j = i + 1; j<N; j++)
			{
				if (arr[j] < arr[k]){
					k = j;
				}
			}
			int temp = arr[i];
			arr[i] = arr[k];
			arr[k] = temp;
		}
	}
};
// ������ԣ���������
class InsertSort :public Strategy
{
public:
	InsertSort(){
		printf("��������\n");
	}
	void sort(int arr[], int N){
		int i, j;
		for (i = 1; i<N; i++)
		{
			for (j = i - 1; j >= 0; j--)
			{
				if (arr[i]>arr[j]){
					break;
				}
			}
			int temp = arr[i];
			for (int k = i - 1; k > j; k--){
				arr[k + 1] = arr[k];
			}
			arr[j + 1] = temp;
		}
	}
};
#include <stdio.h>

// ��������
class Context
{
public:
	Context(){
		arr = NULL;
		N = 0;
	}
	Context(int iArr[], int iN){
		this->arr = iArr;
		this->N = iN;
	}
	void setSortStrategy(Strategy* iSortStrategy){
		this->sortStrategy = iSortStrategy;
	}
	void sort(){
		this->sortStrategy->sort(arr, N);
		printf("����� ");
		this->print();
	}
	void setInput(int iArr[], int iN){
		this->arr = iArr;
		this->N = iN;
	}
	void print(){
		for (int i = 0; i < N; i++){
			printf("%3d ", arr[i]);
		}
		printf("\n");
	}

private:
	Strategy* sortStrategy;
	int* arr;
	int N;
};


int main()
{
	Context* ctx = new Context();
	int arr[] = { 10, 23, -1, 0, 300, 87, 28, 77, -32, 2 };
	ctx->setInput(arr, sizeof(arr) / sizeof(int));
	printf("���룺");
	ctx->print();

	// ð������
	ctx->setSortStrategy(new BubbleSort());
	ctx->sort();

	// ѡ������
	ctx->setSortStrategy(new SelectionSort());
	ctx->sort();

	// ��������
	ctx->setSortStrategy(new InsertSort());
	ctx->sort();

	printf("\n\n");
	system("pause");
	return 0;
}
