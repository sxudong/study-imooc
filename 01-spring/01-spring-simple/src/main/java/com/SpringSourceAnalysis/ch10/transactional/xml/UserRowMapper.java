package com.SpringSourceAnalysis.ch10.transactional.xml;


import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRowMapper implements RowMapper {
    @Override
    public Object mapRow(ResultSet set, int index) throws SQLException {
        User user = new User(set.getInt("id"), set.getString("name"),
                set.getInt("age"), set.getString("sex"));
        return user;
    }
}
