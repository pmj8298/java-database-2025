-- 사번 입력으로 급여를 인상하는 PROCEDURE
--SELECT * FROM EMP WHERE EMPNO = 7900;
--
--CREATE OR REPLACE PROCEDURE UP_SAL
--(
--	V_EMPNO		EMP.EMPNO%TYPE
--)
--IS
--	CNT_EMP		NUMBER(1,0);
--BEGIN
--	
--	SELECT COUNT(*) INTO CNT_EMP
--	  FROM EMP
--	 WHERE EMPNO = V_EMPNO;
--
--	IF CNT_EMP > 0 THEN
--		 DBMS_OUTPUT.PUT_LINE('업데이트 하면 된다');
--	
--		UPDATE EMP SET
--			SAL = SAL + (SAL * 0.1)
--		 WHERE EMPNO = V_EMPNO;
--		
--		DBMS_OUTPUT.PUT_LINE('업데이트 완료');
--	ELSE
--		DBMS_OUTPUT.PUT_LINE('데이터없음');
--	END IF;
--	
--END;
--
-- 프로시저 실행
--CALL UP_SAL(7900);
--
--ROLLBACK;

CREATE OR REPLACE PROCEDURE UP_SAL
(
	V_EMPNO		EMP.EMPNO%TYPE
)
IS
	CNT_EMP		NUMBER(1,0);
BEGIN
	SELECT COUNT(*) INTO CNT_EMP
	  FROM EMP
	 WHERE EMPNO = V_EMPNO;

	--DBMS_OUTPUT.PUT_LINE(CNT_EMP);
	IF CNT_EMP > 0 THEN
		UPDATE EMP SET
			SAL = SAL + (SAL * 0.1)
		 WHERE EMPNO = V_EMPNO;
			DBMS_OUTPUT.PUT_LINE('업데이트 가능');
		ELSE
			DBMS_OUTPUT.PUT_LINE('업데이트 불가');
		END IF;
END UP_SAL;
