/*
 * 복수행, GROUP BY와 가장 많이 사용
 * COUNT(), SUM(), AVG(), MIN/MAX(), STDDEV(), ...
 * ROLLUP, CUBE, RANK...
 * */
-- COUNT() - 무지무지 많이 사용함
SELECT count(*) -- scalar value
	FROM employees;

SELECT count(employee_id) -- scalar value
	FROM employees;

-- SUM(숫자형컬럼) 합계
-- employees 206 salary 8300 삭제
SELECT sum(salary)
	FROM employees;

-- AVG(숫자형컬럼) 평균
-- column 에 null 값이 있으면 제외하고 계산하기 때문에 잘못된 값이 도출
-- 금액이나 수량을 계산하는 컬럼의 null값은 항상 전처리를 해주어야한다
SELECT avg(salary)
	FROM employees;

-- null은 계산이 안됨
SELECT count(salary)
	FROM employees;

-- MIN(숫자형컬럼|문자형도 가능), MAX()
SELECT MAX(salary), min(salary)
	FROM employees;

SELECT MAX(first_name), min(first_name) -- Winston / Adam
	FROM employees;

/*
 * GROUP BY 연계, 데이터를 그룹화 시킴
 * GROUP BY 를 사용하면 SELECT 절에는 GROUP BY 에 사용한 column 과 집계함수 및 일반함수만 사용할 수 있다. 
 * */
-- 아래의 경우 department_id 이외의 컬럼은 사용불가
SELECT department_id,
	   avg(salary) AS 부서별평균급여,
	   to_char(round(avg(salary),1),'99,999.9') AS 부서별평균급여
	FROM employees
  GROUP BY department_id
  ORDER BY avg(salary) desc;

-- employees 에서 부서와 직군별 급여총액과 직원수를 출력
SELECT department_id, job_id, sum(salary) AS 부서직군별급여총액
	FROM employees
GROUP BY  department_id, job_id
ORDER BY  department_id;

-- employees 에서 부서와 직군별 급여총액과 직원수를 출력하는데
-- department_id 가 30에서 90 사이이고, 부서직군별급여총액이 20000달러 이상인 데이터만 보일것
SELECT department_id, job_id, sum(salary) AS 부서직군별급여총액
	FROM employees
WHERE department_id BETWEEN 30 AND 90
--    AND sum(salary) >= 20000 - 집계함수는 where에 사용불가
GROUP BY  department_id, job_id
HAVING sum(salary) >= 20000
ORDER BY  department_id;

-- ORDER BY에는 컬럼의 순번(1부터 시작)으로 컬럼명을 대체가능
SELECT department_id, job_id, sum(salary) AS 부서직군별급여총액, count(*)
	FROM employees
WHERE department_id BETWEEN 30 AND 90
GROUP BY  department_id, job_id
HAVING sum(salary) >= 20000
ORDER BY 3 desc;

-- ROLLUP 그룹별 소계와 총계를 표시해주는 기능
SELECT department_id, job_id, sum(salary) AS 부서직군별급여총액, count(*)
	FROM employees
WHERE department_id BETWEEN 30 AND 90
GROUP BY ROLLUP (department_id, job_id);
--HAVING sum(salary) >= 20000

-- PIVOT() 엑셀에 동일한 기능
-- PIVOT 안쓰고 각 달별로 입사한 사원릐 수를 표시. 12행
-- 각 입사일자에서 달만 추출
SELECT to_char(hire_date,'MM')
	FROM employees;

-- 1월 달에 입사한 사람 카운팅
SELECT CASE to_char(hire_date,'MM') WHEN '01' THEN count(*) ELSE 0 END AS "1월"
	FROM employees
  GROUP BY to_char(hire_date,'MM');

-- 옆으로 각 달별로 스프레드
SELECT CASE to_char(hire_date,'MM') WHEN '01' THEN count(*) ELSE 0 END AS "1월",
 	   CASE to_char(hire_date,'MM') WHEN '02' THEN count(*) ELSE 0 END AS "2월",
 	   CASE to_char(hire_date,'MM') WHEN '03' THEN count(*) ELSE 0 END AS "3월",
 	   CASE to_char(hire_date,'MM') WHEN '04' THEN count(*) ELSE 0 END AS "4월",
	   CASE to_char(hire_date,'MM') WHEN '05' THEN count(*) ELSE 0 END AS "5월",
   	   CASE to_char(hire_date,'MM') WHEN '06' THEN count(*) ELSE 0 END AS "6월",
 	   CASE to_char(hire_date,'MM') WHEN '07' THEN count(*) ELSE 0 END AS "7월",
 	   CASE to_char(hire_date,'MM') WHEN '08' THEN count(*) ELSE 0 END AS "8월",
	   CASE to_char(hire_date,'MM') WHEN '09' THEN count(*) ELSE 0 END AS "9월",
	   CASE to_char(hire_date,'MM') WHEN '10' THEN count(*) ELSE 0 END AS "10월",
	   CASE to_char(hire_date,'MM') WHEN '11' THEN count(*) ELSE 0 END AS "11월",
 	   CASE to_char(hire_date,'MM') WHEN '12' THEN count(*) ELSE 0 END AS "12월"
  FROM employees
  GROUP BY to_char(hire_date,'MM')
  ORDER BY to_char(hire_date,'MM');











