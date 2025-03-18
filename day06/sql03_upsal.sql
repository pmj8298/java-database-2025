CREATE OR REPLACE PROCEDURE SAMPLEUSER.UP_SAL
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