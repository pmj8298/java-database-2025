-- madang 로그인

-- 조회
SELECT * FROM students;

-- 더미데이터 삽입
INSERT INTO students(STD_ID, STD_NAME, stg_mobile, STD_REGYEAR)
VALUES (seq_student.nextval, '홍길동', '010-4562-7895', 1997);

INSERT INTO students(STD_ID, STD_NAME, stg_mobile, STD_REGYEAR)
VALUES (seq_student.nextval, '홍길순', '010-1235-7895', 2000);

COMMIT;

SELECT std_id, std_name, stg_mobile, std_regyear FROM students;

INSERT INTO MADANG.STUDENTS(std_id, std_name, stg_mobile, std_regyear)
VALUES(seq_student.nextval, :v_std_name, :v_stg_mobile, :v_std_regyear);

UPDATE MADANG.STUDENTS
   SET std_name    = :v_std_name, 
   	   stg_mobile  = :v_stg_mobile, 
   	   std_regyear = :v_std_regyear
 WHERE std_id  	   = :v_std_id
 
 DELETE FROM STUDENTS
   WHERE std_id = :v_std_id