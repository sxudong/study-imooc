package com.mmall.concurrency.example.aqs;

import java.util.concurrent.PriorityBlockingQueue;
import java.util.stream.IntStream;

public class UsePriorityBlockingQueue {
	public static void main(String[] args) throws Exception{

		PriorityBlockingQueue<Task> priority = new PriorityBlockingQueue<Task>();
		IntStream.range(1, 6).forEach(i -> priority.add(new Task(i, "id为" + i)));

		System.out.println("容器：" + priority);
		System.out.println(priority.take().getId());
		System.out.println("容器剩余：" + priority);
		
	}
}
/* Output:
容器：[1,id为1, 2,id为2, 3,id为3, 4,id为4, 5,id为5]
1
容器剩余：[2,id为2, 4,id为4, 3,id为3, 5,id为5]
*///:~

class Task implements Comparable<Task> {

	private int id;
	private String name;

	public Task(int id, String name){
		this.id = id;
		this.name = name;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public int compareTo(com.mmall.concurrency.example.aqs.Task task) {
		return this.id > task.id ? 1 : (this.id < task.id ? -1 : 0);
	}

	public String toString() {
		return this.id + "," + this.name;
	}
}