/*
 * 사용자 생성, 기존 사용자
 * */

-- HR 계정 잠금해제
ALTER USER hr account unlock;
ALTER USER hr IDENTIFIED BY 12345;

SELECT *
  FROM EMPLOYEES;

-- PRIVILEGES 권한
-- CREATE SESSION - 접속권한
-- CREATE TABLE, ALTER ANY TABLE, DROP ANY TABLE, ..
-- 권한은 하나하나 다 부여해야 함! 
/*
-- SCOTT 계정 잠금해제 / 계정이 없을 수도 있어서 pass
ALTER USER scott ACCOUNT UNLOCK;

-- SCOTT 은 CREATE SESSION 권한 없음, LOGON DENIED
-- scott 에서 접속권한 부여
GRANT CREATE SESSION TO scott;
*/

SELECT * FROM jobs;

CREATE VIEW jobs_view
AS
	SELECT *
	  FROM jobs;

-- hr 계정에 어떤 권한이 있는지 조회
SELECT *
  FROM user_tab_privs;

-- hr 로 테이블 생성
CREATE TABLE test(
	id NUMBER PRIMARY KEY,
	name varchar2(20) NOT NULL
);

-- Role(역할) 관리
-- 여러 권한을 묶어놓은 개념
-- role 확인
-- CONNECT - DB 접속 및 테이블 생성 조회 권한
-- RESOURCE - PL/SQL 사용권한
-- DBA - 모든 시스템권한
-- EXP_FULL_DATABASE - DB 익스포트 권한...
SELECT * FROM user_role_privs;

SELECT * FROM dba_role_privs;

-- HR에게 DBA 역할 ROLE부여
GRANT DBA TO HR;

SELECT * FROM MEMBER;

-- HR에게 DBA 역할 권한 해제
REVOKE DBA FROM HR;

COMMIT;





