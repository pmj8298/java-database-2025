/*
 * 기본 SELECT문
 * */
-- 문제 1) Employees 테이블에서 사원번호, 이름(이름 성 합쳐서 표기), 급여, 업무, 입사일, 상사의 사원번호로 출력하시오 (107행)
SELECT * FROM EMPLOYEES;

SELECT employee_id, 
	   FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   SALARY, 
	   JOB_ID, 
	   TO_CHAR(HIRE_DATE, 'yyyy-mm-dd') AS "HIRE_DATE", 
	   MANAGER_ID
  FROM EMPLOYEES
  
-- 문제 2) Employees 테이블에서 모든 사원의 이름과 연봉을 '이름: 1 YEAR SALARY = $연봉' 형식으로 출력하고
-- 		  컬럼명을 1 YEAR SALARY 로 변경하시오 (107행)
SELECT EMPLOYEES.LAST_NAME || ' : 1 YEAR SALARY  = ' || TO_CHAR(EMPLOYEES.SALARY * 12, '$9,999,999.99') AS "1 YEAR SALARY"
  FROM EMPLOYEES
  
-- 문제 3) 부서별로 담당하는 업무를 한번씩만 출력하시오(20행)
SELECT DISTINCT EMPLOYEES.DEPARTMENT_ID, EMPLOYEES.JOB_ID
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID DESC;

/*
 * WHERE절, ORDER BY절
 * */
-- 문제 4) EMPLOYEES 에서 급여가 7000 ~ 10000 달러 범위 이외 사람의 이름과 성을 FULL_NAME, 급여를 오름차순으로 출력하시오 (75행)
SELECT FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   SALARY
  FROM EMPLOYEES
 WHERE SALARY < 7000 OR EMPLOYEES.SALARY > 10000
 ORDER BY SALARY;

SELECT FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   SALARY
  FROM EMPLOYEES
 WHERE SALARY NOT BETWEEN 7000 AND 10000
 ORDER BY SALARY;

-- 문제 5) 현재 날짜 타입을 날짜 함수를 통해서 확인하고,
--		  입사 일자가 2003년 5월 20일부터 2004년 5월 20일 사이에 입사한 사원의 이름(full_name), 사원번호, 고용일자를 출력하시오
--		  단, 입사일을 빠른순으로 정렬하시오 (10행)
SELECT SYSDATE FROM DUAL;

SELECT FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   EMPLOYEES.EMPLOYEE_ID,
	   TO_CHAR(HIRE_DATE, 'yyyy-mm-dd') AS "HIRE_DATE"
  FROM EMPLOYEES 
 WHERE EMPLOYEES.HIRE_DATE BETWEEN '2003-05-20' AND '2004-5-20'
 ORDER BY HIRE_DATE;


/*
 * 단일행 함수와 변환함수
 * */
-- 문제 6) 이번 분기, 60번 IT 부서가 지대한 공헌을 함
-- 		  IT 부서 사원 급여를 15.3%  인상하기로 했다. 정수만 반올림해서 출력하시오
--		  출력형식은 사번, 이름과 성(full_name), 급여 인상된 급여(컬럼명: Increased Salary) 출력 (5행)
SELECT EMPLOYEE_ID,
	   FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   SALARY,
	   SALARY + (SALARY * 0.153) AS "Increased Salary(참조)",
	   ROUND(SALARY * 1.153) AS "Increased Salary"
  FROM EMPLOYEES
 WHERE EMPLOYEES.DEPARTMENT_ID = 60;

-- 문제 7) 모든 사원의 연봉을 표시하는 보고서 작성
-- 		  사원 full_name, 급여, 수당여부에 따라 연봉을 표시하시오
-- 		  수당이 있으면 SALARY + COMMISSION, 없으면 SALARY ONLY 라고 표시
--		  연봉이 높은 순으로 정렬 (107행)
SELECT FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   SALARY,
	   (SALARY * 12) + (SALARY * NVL(COMMISSION_PCT,0)) AS "ANNUAL SALARY",
	   CASE WHEN COMMISSION_PCT IS NULL THEN 'SALARY ONLY'
	   		WHEN COMMISSION_PCT IS NOT NULL THEN 'SALARY + COMMISSION_PCT'
	   		END AS "COMMISION?",
	   COMMISSION_PCT
  FROM EMPLOYEES
 ORDER BY 3 DESC;

--NVL 함수란?
--NVL(expr1, expr2)
--
--expr1이 NULL이면 expr2를 반환
--expr1이 NULL이 아니면 expr1을 그대로 반환
--
--SALARY * NVL(COMMISSION_PCT, 0)는
--
--COMMISSION_PCT가 NULL이면 → SALARY * 0 = 0
--COMMISSION_PCT가 0.1이면 → SALARY * 0.1

/*
 * 집계함수, MIN MAX, SUM, AVG, COUNT../
 * */
-- 문제 8) EMPLOYEES 에서 각 사원이 소속된 부서별 급여합계, 급여평균, 급여최댓값, 급여최솟값 집계
--		  출력형식은 여섯자리와 세자리 구분기호, $ 를 앞에 표시할 것
--	 	  부서번호를 오름차순으로 정렬
--		  단, 부서에 소속되지 않은 사원은 제외(11행)
SELECT EMPLOYEES.DEPARTMENT_ID,
       TO_CHAR(SUM(EMPLOYEES.SALARY), '$999,999')  AS "SUM SALARY",
       TO_CHAR(AVG(EMPLOYEES.SALARY), '$99,999.9') AS "AVG SALARY",
       TO_CHAR(MAX(EMPLOYEES.SALARY), '$999,999')  AS "MAX SALARY",
       TO_CHAR(MIN(EMPLOYEES.SALARY), '$99,999')   AS "MIN SALARY"
  FROM EMPLOYEES
 WHERE EMPLOYEES.DEPARTMENT_ID IS NOT NULL
 GROUP BY EMPLOYEES.DEPARTMENT_ID 
 ORDER BY DEPARTMENT_ID;

/*
 * JOIN
 * */
-- 문제 9) EMPLOYEES, DEPARTMENT, LOCATIONS 테이블 구조 파악
-- 		  OXFORD 에 근무하는 사원 FULL_NAME, 업무, 부서명, 도시명을 출력하시오 (34행)
SELECT *
  FROM EMPLOYEES e 


SELECT E. FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   E. JOB_ID,
	   D. DEPARTMENT_NAME,
	   L. CITY 
  FROM EMPLOYEES e , DEPARTMENTS d, LOCATIONS l 
 WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
   AND D.LOCATION_ID  = L.LOCATION_ID
   AND L.CITY = 'Oxford';

COMMIT;

-- 문제 10) 부서가 없는 직원까지 모두 FULL_NAME, 업무, 부서명을 출력하시오 (107행)
SELECT E. FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   E. JOB_ID,
	   D. DEPARTMENT_NAME
  FROM EMPLOYEES e , DEPARTMENTS d
 WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);

/*
 * 서브쿼리
 * */
-- 문제 11) Tucker 사원보다 급여를 많이 받는 사원의 FULL_NAME, 업무, 부서명을 출력하시오 (15행)
SELECT SALARY
  FROM EMPLOYEES
 WHERE LAST_NAME = 'Tucker'

SELECT FIRST_NAME || ' ' || LAST_NAME AS "FULL NAME",
	   JOB_ID,
	   SALARY
  FROM EMPLOYEES
 WHERE SALARY > (SELECT SALARY
 				   FROM EMPLOYEES
 				  WHERE LAST_NAME = 'Tucker');
	 




