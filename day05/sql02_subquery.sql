/*
 * 서브쿼리
 * */

SELECT * FROM student;

SELECT * FROM department;

-- join 으로 두 테이블 검색
SELECT S.NAME, D.DNAME
	FROM STUDENT S, DEPARTMENT d
   WHERE S.DEPTNO1 = D.DEPTNO
     AND S.DEPTNO1 = 103;

-- Anthony Hopkins 학생과 같은 학과에 다니는 학생을 모두 조회 
SELECT S.NAME, D.DNAME
	FROM STUDENT S, DEPARTMENT d
   WHERE S.DEPTNO1 = D.DEPTNO
     AND S.DEPTNO1 = (SELECT DEPTNO1 
						FROM STUDENT 
					   WHERE NAME = 'Anthony Hopkins'); -- 학생 이름따라 학과번호가 변경 가능

--SELECT DEPTNO1 FROM STUDENT WHERE NAME = 'Anthony Hopkins';

-- WHERE 절 서브쿼리에서 = 로 비교할 때 주의점
-- WHERE 절 서브쿼리는 다중행이 되면 안됨
SELECT S.NAME, D.DNAME
	FROM STUDENT S, DEPARTMENT d
   WHERE S.DEPTNO1 = D.DEPTNO
     AND S.DEPTNO1 = (SELECT DEPTNO1 
						FROM STUDENT); -- 학생 이름따라 학과번호가 변경 가능

-- 특정 교수의 입사일보다 뒤에 입사한 교수들의 정보 출력
SELECT * 
	FROM PROFESSOR;

SELECT *
	FROM DEPARTMENT;

-- 조인되는 쿼리부터 생성
-- 맥 라이언교수 입사일자로 비교
SELECT P.NAME AS "PROF_NAME",
	   P.HIREDATE,
	   D.DNAME AS "DEPT_NAME"
	FROM PROFESSOR P, DEPARTMENT d
   WHERE P.DEPTNO = D.DEPTNO
	 AND P.HIREDATE = '1985-09-18';

SELECT HIREDATE
	FROM PROFESSOR
WHERE NAME = 'Meg Ryan';
						
SELECT P.NAME AS "PROF_NAME",
	   P.HIREDATE,
	   D.DNAME AS "DEPT_NAME"
	FROM PROFESSOR P, DEPARTMENT d
   WHERE P.DEPTNO = D.DEPTNO
	 AND P.HIREDATE > (SELECT HIREDATE
						 FROM PROFESSOR
						WHERE NAME = 'Meg Ryan');

COMMIT;

-- 다중행 서브쿼리
-- IN 서브쿼리 결과와 같은 값, 여러개(OR 와 동일)
-- EXIST 서브쿼리의 값이 있는 경우 메인쿼리를 수행
-- >ANY 서브쿼리의 최솟값보다 큰 값을 메인쿼리에서 조회
-- <ANY 서브쿼리의 최댓값보다 작은 값을 메인쿼리에서 조회
-- <ALL 서브쿼리의 최댓값보다 메인쿼리의 큰 값 조회
-- >ALL 서브쿼리의 최솟값보다 메인쿼리의 작은 값 조회

-- 지역이 Pohang Main Office 인 부서코드에 해당하는 직원들의 사번, 이름, 부서번호를 출력하시오

SELECT DCODE
  FROM DEPT2
 WHERE AREA = 'Pohang Main Office';

SELECT EMPNO, NAME, DEPTNO
  FROM EMP2
 WHERE DEPTNO IN (SELECT DCODE
				   FROM DEPT2
				   WHERE AREA = 'Pohang Main Office');

-- EMP2 테이블에서 'Section head' 직급의 최소 연봉보다 연봉이 높은 사람의 이름, 직급, 연봉을 출력하시요
-- 단 연봉는 $75,000,000 식으로 출력할 것
DELETE FROM EMP2
 WHERE EMPNO = '20000219';

COMMIT;

SELECT *
  FROM EMP2;

SELECT *
  FROM DEPT2;

SELECT *
  FROM EMP2
 WHERE EXISTS(SELECT MIN(PAY) 
 			    FROM EMP2
 			   WHERE POSITION = 'Section head');

-- 서브쿼리 MIN 함수 최솟값 스칼라에서 비교연산으로
SELECT NAME, POSITION, TO_CHAR(PAY, '$999,999,999') AS "SALARY"
  FROM EMP2
 WHERE PAY > (SELECT MIN(PAY) 
 			    FROM EMP2
 			   WHERE POSITION = 'Section head');

-- >ANY 로 서브쿼리 다중행에서 최솟값
SELECT NAME, POSITION, TO_CHAR(PAY, '$999,999,999') AS "SALARY"
  FROM EMP2
 WHERE PAY > ANY(SELECT PAY 
 			    FROM EMP2
 			   WHERE POSITION = 'Section head');

-- 다중 칼럼 서브쿼리, 파이썬 튜플과 동일
-- 1~4학년 중 몸무게가 가장 많이 나가는 학생의 정보를 출력하라(4행)
SELECT GRADE, NAME, HEIGHT, WEIGHT
  FROM STUDENT
 WHERE (GRADE, WEIGHT) IN (SELECT GRADE, MAX(WEIGHT)
							  FROM STUDENT
							 GROUP BY GRADE);

SELECT GRADE, MAX(WEIGHT)
  FROM STUDENT
 GROUP BY GRADE;

-- 교수테이블과 학과DEPARTMENT 테이블 조회하여 학과별로 입사일이 가장 오래된 교수의
-- 교수번호, 이름, 학과명을 출력하시오. 입사일 순으로 오름차순
SELECT P.PROFNO AS "교수번호",
	   P.NAME   AS "교수명",
	   D.DNAME  AS "학과명",
	   TO_CHAR(P.HIREDATE, 'YYYY-MM-DD')  AS "입사일"
  FROM PROFESSOR p, DEPARTMENT d 
 WHERE P.DEPTNO = D.DEPTNO
   AND (P.DEPTNO, P.HIREDATE) IN (SELECT DEPTNO, MIN(HIREDATE)
                                    FROM PROFESSOR
                                   WHERE DEPTNO IS NOT NULL
                                   GROUP BY DEPTNO)
 ORDER BY P.HIREDATE ASC;

SELECT P.PROFNO, P.NAME, D.DNAME 
  FROM PROFESSOR P, DEPARTMENT d 
 WHERE P.DEPTNO = D.DEPTNO 
   AND (P.DEPTNO, P.HIREDATE) IN (SELECT DEPTNO, MIN(HIREDATE)
								FROM PROFESSOR
							   WHERE DEPTNO IS NOT NULL
							   GROUP BY DEPTNO);

SELECT DEPTNO, MIN(HIREDATE)
  FROM PROFESSOR
 WHERE DEPTNO IS NOT NULL
 GROUP BY DEPTNO;

-- 상호연관 쿼리: 메인쿼리의 컬럼이 서브쿼리의 조건에 들어가는 경우
-- 전체 20명의 평균연봉
SELECT B.POSITION, AVG(B.PAY)
  FROM EMP2 B
 GROUP BY B.POSITION;

SELECT AVG(B.PAY)
  FROM EMP2 B;

-- 상호연관 쿼리로 작성
SELECT A.NAME, A.POSITION, A.PAY
  FROM EMP2 A
 WHERE A.PAY >= (SELECT AVG(B.PAY)
  					FROM EMP2 B
				    WHERE B.POSITION = A.POSITION);

COMMIT;

-- 여기까지, WHERE 절 서브쿼리

-- 스칼라 서브쿼리, SELECT 절 서브쿼리
-- 부서명을 같이 보려면 JOIN 을 해야함
SELECT *
  FROM EMP2 E;

-- 조인은 건수가 만약 700만건이라해도 조인은 한번만 수행
SELECT E.EMPNO, E.NAME, E.DEPTNO, D.DNAME AS "부서명"
  FROM EMP2 E, DEPT2 d 
 WHERE E.DEPTNO = D.DCODE;

-- 조인없이 스칼라 서브쿼리로 해결
-- 조인으로 되는 값을 서브쿼리 쓰면 성능에 악영향을 끼침
-- 스칼라 서브쿼리를 쓰면 WHERE 검색을 700만건 수행
SELECT E.EMPNO, E.NAME, E.DEPTNO, (SELECT DNAME FROM DEPT2 WHERE DCODE = E.DEPTNO) AS "부서명",
	   (SELECT AREA FROM DEPT2 WHERE DCODE = E.DEPTNO) AS "지역"
  FROM EMP2 e;


-- 여기까지 스칼라(SELECT 절) 서브쿼리

-- FROM 절 서브쿼리
SELECT *
  FROM EMP2;

SELECT EMPNO, NAME, BIRTHDAY, DEPTNO, EMP_TYPE, TEL
  FROM EMP2;

-- FROM 절에 소괄호 내에 서브쿼리를 작성하는 방식
SELECT ES.EMPNO, ES.NAME
  FROM (SELECT EMPNO, NAME, BIRTHDAY, DEPTNO, EMP_TYPE, TEL FROM EMP2) ES;

SELECT grpP.DEPTNO, grpP.paySum
  FROM (SELECT DEPTNO, SUM(PAY) AS paySum
		  FROM EMP2
		 GROUP BY DEPTNO) grpP;

SELECT DEPTNO, SUM(PAY)
  FROM EMP2
 GROUP BY DEPTNO;

SELECT grpP.DEPTNO, grpP.payAvg
  FROM (SELECT DEPTNO, AVG(PAY) AS payAvg
		  FROM EMP2
		 GROUP BY DEPTNO) grpP;

-- 11. EMP2와 위에서 구한 값을 조인해서 DEPTNO별 평균연봉보다 얼마씩 차이가 나는지
SELECT E.NAME, E.EMPNO, E.POSITION, E.DEPTNO, E.PAY, G.payAvg, (E.PAY - G.payAvg) AS "평균연봉차액"
  FROM EMP2 E, (SELECT DEPTNO, AVG(PAY) AS payAvg
				  FROM EMP2
			     GROUP BY DEPTNO) G -- G는 가상테이블
WHERE E.DEPTNO = G.DEPTNO;

-- 12. WITH 절로 가상테이블 형태 서브쿼리
WITH G1 AS
(SELECT DEPTNO, AVG(PAY) AS payAvg
		  FROM EMP2
		 GROUP BY DEPTNO)
SELECT E.NAME, E.EMPNO, E.POSITION, E.DEPTNO, E.PAY, G1.payAvg, (E.PAY - G1.payAvg) AS "평균연봉차액"
  FROM EMP2 E,G1
WHERE E.DEPTNO = G1.DEPTNO;		 

-- 11번 12번은 차이가 없음

-- WHERE 절 서브쿼리 > FROM 절 서브쿼리 > SELECT 절 서브쿼리(사용자 정의 함수로 대체)

INSERT INTO EMP2(EMPNO, NAME, BIRTHDAY, DEPTNO,EMP_TYPE,TEL)
VALUES(2020000219,'Ray Osmond','1988-03-22','999','Intern','02)909-2345');

COMMIT;

SELECT * FROM EMP2;

-- 각 직원의 부서명을 같이 출력하라
-- NULL 은 출력을 안하는게 좋음
SELECT NAME, DEPTNO, NVL((SELECT DNAME FROM DEPT2 WHERE DCODE=EMP2.DEPTNO),'부서명없음') AS "부서명"
  FROM EMP2
 ORDER BY DEPTNO;

-- 위의 쿼리 조인으로 변경 가능
SELECT E.NAME, E.DEPTNO, NVL(D.DNAME, '부서명없음') AS "부서명"
  FROM EMP2 E, DEPT2 D
 WHERE  E.DEPTNO = D.DCODE(+)
 ORDER BY DEPTNO, NAME;

COMMIT;







