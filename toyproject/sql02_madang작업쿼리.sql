-- madang 로그인

-- 조회
SELECT * FROM students;

-- 더미데이터 삽입
INSERT INTO students(STD_ID, STD_NAME, stg_mobile, STD_REGYEAR)
VALUES (seq_student.nextval, '홍길동', '010-4562-7895', 1997);

INSERT INTO students(STD_ID, STD_NAME, stg_mobile, STD_REGYEAR)
VALUES (seq_student.nextval, '홍길순', '010-1235-7895', 2000);

COMMIT;