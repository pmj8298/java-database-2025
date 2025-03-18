-- 함수 실행

SELECT MAX_SAL(10) FROM DUAL;

SELECT * FROM EMP
  WHERE DEPTNO = 10;

-- 스칼라 서브뭐리
SELECT e.empno, e.name, e.deptno
     , (SELECT dname FROM dept2 WHERE dcode = e.deptno) AS "부서명"
     , (SELECT area FROM dept2 WHERE dcode = e.deptno) AS "지역"
  FROM emp2 e;

-- 함수로 변경
SELECT e.empno, e.name, e.deptno
     , GET_DNAME(e.deptno) AS "부서명"
     , GET_AREA(e.deptno) AS "지역"
  FROM emp2 e;

-- 조인으로 가능
SELECT e.empno, e.name, e.deptno
     , d.dname, d.area
  FROM emp2 e, dept2 d
 WHERE e.deptno = d.dcode;

COMMIT;








