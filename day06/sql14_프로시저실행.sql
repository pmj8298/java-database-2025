CALL EMP_INFO(7902);
CALL EMP_INFO(7934);

--
SELECT * FROM EMP;

-- FOR문1
BEGIN
	FOR I IN 1..10 LOOP
		DBMS_OUTPUT.PUT_LINE(I);
	END LOOP;
END;

-- FOR문2
DECLARE
	V_SUM	NUMBER;
BEGIN
	V_SUM := 0;
	FOR I IN 1..10 LOOP
		V_SUM := V_SUM + I;
		-- DBMS_OUTPUT.PUT_LINE(I);
	END LOOP;

	DBMS_OUTPUT.PUT_LINE(V_SUM);
END;
/