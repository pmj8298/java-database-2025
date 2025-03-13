/*
 * 복수행 함수 마무리
 * */
-- GROUP BY
-- 그룹핑시 GROUP BY에 들어가는 컬럼만 select 절에 사용가능
-- WHERE 절은 일반적 조건만 비교, HAVING 집계함수를 조건에 사용할 때
SELECT department_id, sum(salary)
	FROM employees
  WHERE department_id <= 70
  GROUP BY department_id
HAVING sum(salary) <= 20000
  ORDER by 2 DESC;

-- RANK()       - 1,2,2,4
-- DENSE_RANK() - 1,2,2,3
-- ROW_UNMBER() - 행번호
-- 전체 employees 에서 급여가 높은 사람부터 순위 매길때
SELECT first_name || ' '|| last_name AS "full_name",
	   salary,
	   department_id,
	   rank() OVER (ORDER BY salary desc) AS RANK,            -- 1,2,2,4,5,6,7,7,9,10
	   DENSE_RANK() over(ORDER BY salary desc) AS DENSE_RANK, -- 1,2,2,3,4,5,6,6,7,8
	   row_number() over(ORDER BY salary desc) AS ROW_NUM     -- 1,2,3,4,5,6,7,8,9
	FROM employees
  WHERE salary IS NOT null
--  ORDER BY 2 desc;

-- 부서별(department_id) 급여높은 사람부터 순위를 매길때
SELECT first_name || ' '|| last_name AS "full_name",
	   salary,
	   department_id,
	   rank() OVER (PARTITION BY department_id ORDER BY salary desc) AS RANK, -- 1,2,2,4,5,6,7,7,9,10
	   DENSE_RANK() over(PARTITION BY department_id ORDER BY salary desc) AS DENSE_RANK, -- 1,2,2,3,4,5,6,6,7,8
	   row_number() over(PARTITION BY department_id ORDER BY salary desc) AS ROW_NUM     -- 1,2,3,4,5,6,7,8,9
	FROM employees
  WHERE salary IS NOT null
  ORDER BY 3;
































