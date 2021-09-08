/*
  -- 存储过程：分页查询用户列表
  -- 输入参数：page_index：当前页码
  -- 输入参数：page_size：分页大小
  -- 输出参数：total_count：数据总数
  -- 输出参数：total_page：总页数
*/
DROP PROCEDURE IF EXISTS proc_search_user;
CREATE PROCEDURE proc_search_user(IN page_index INT,IN page_size INT, OUT total_count INT, OUT total_page INT)
BEGIN
		DECLARE begin_no INT;
		SET begin_no = (page_index-1)*page_size;
 
		-- 分页查询列表
		SELECT * FROM emp
		WHERE empno >= (
			SELECT empno FROM emp
			ORDER BY empno ASC
			LIMIT begin_no,1
		)
		ORDER BY empno ASC
		LIMIT page_size;
 
		-- 计算数据总数
		SELECT COUNT(1) INTO total_count FROM emp;
 
		-- 计算总页数
		SET total_page = FLOOR((total_count + page_size - 1) / page_size);
END;


/*
    -- 存储函数：根据用户编号，获取用户姓名
    -- 输入参数：用户编号
    -- 返回结果：用户姓名
*/
DROP FUNCTION IF EXISTS func_get_user_name;
CREATE FUNCTION func_get_user_name(in_id INT)
    RETURNS VARCHAR(30)
BEGIN
	DECLARE out_name VARCHAR(30);

SELECT ename INTO out_name FROM emp
WHERE empno = in_id;

RETURN out_name;
END;