package design.pattern.behavioral.strategy.example.log.impl;

import design.pattern.behavioral.strategy.example.log.Logger;

import java.sql.Connection;
import java.sql.SQLException;

// 数据库记录日志
public class DbLogger implements Logger {
	Connection connection;

	@Override
	public void log(String s) {
		try {
			connection.prepareStatement("insert into t_log values (...)").execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}