// atomic_flag as a spinning lock
#include <iostream>       // std::cout
#include <atomic>         // std::atomic_flag
#include <thread>         // std::thread
#include <vector>         // std::vector
#include <sstream>        // std::stringstream

std::atomic_flag lock_stream = ATOMIC_FLAG_INIT;
std::stringstream stream;

void append_number(int x) {
	while (lock_stream.test_and_set()) {}
	stream << "thread #" << x << '\n';
	lock_stream.clear();
}

/*
* 操作系统原理-清华 第9章 同步
* http://www.cplusplus.com/reference/atomic/atomic_flag/test_and_set/
*/
int main()
{
	std::vector<std::thread> threads;
	for (int i = 1; i <= 10; ++i) threads.push_back(std::thread(append_number, i));
	for (auto& th : threads) th.join();

	std::cout << stream.str();
	return 0;
}
/* Output:
thread #3
thread #2
thread #1
thread #5
thread #4
thread #7
thread #6
thread #8
thread #10
thread #9
*/