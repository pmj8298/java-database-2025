-- CREATE USER attendance IDENTIFIED BY 12345

-- grant connect, resource to attendance;

DROP TABLE atd;
DROP TABLE student;
DROP TABLE teacher;
DROP TABLE class;

DROP SEQUENCE atd_no_seq;
DROP SEQUENCE student_s_no_seq;
DROP SEQUENCE teacher_t_no_seq;
DROP SEQUENCE class_class_no_seq;

CREATE TABLE class (
    class_no   NUMBER PRIMARY KEY,      -- 반 ID (기본키)
    class_name VARCHAR2(50) NOT NULL,   -- 반 이름
    t_no       NUMBER                   -- 담당 교사 ID (외래키, teacher 테이블 참조)
);

CREATE TABLE teacher (
    t_no     NUMBER PRIMARY KEY,           -- 교사 고유 번호
    t_id     VARCHAR2(50) UNIQUE NOT NULL, -- 로그인 아이디
    t_pw     VARCHAR2(255) NOT NULL,       -- 비밀번호 (암호화 권장)
    t_name   VARCHAR2(50) NOT NULL,        -- 이름
    t_tel    VARCHAR2(20),                 -- 전화번호
    class_no NUMBER,                       -- 담당 반 ID (외래키)
    CONSTRAINT fk_teacher_class FOREIGN KEY (class_no) REFERENCES class(class_no) 
);

CREATE TABLE  student (
    s_no    NUMBER PRIMARY KEY,            -- 학생 고유 번호
    s_id     VARCHAR2(50) UNIQUE NOT NULL, -- 로그인 아이디
    s_pw     VARCHAR2(255) NOT NULL,       -- 비밀번호 (암호화 권장)
    s_name   VARCHAR2(50) NOT NULL,        -- 이름
    s_birth  DATE NOT NULL,           	   -- 생년월일
    s_tel    VARCHAR2(20),                 -- 전화번호
    s_addr   VARCHAR2(255),            	   -- 주소
    class_no NUMBER,                 	   -- 반 ID (외래키)
    CONSTRAINT fk_student_class FOREIGN KEY (class_no) REFERENCES class(class_no)
);

CREATE TABLE atd (
    atd_no   NUMBER    PRIMARY KEY,       				  -- 출결 ID (기본키)
    s_no 	 NUMBER    NOT NULL,            			  -- 학생 ID (외래키)
    atd_date DATE      DEFAULT SYSDATE,   				  -- 출석 날짜 (기본값: 오늘 날짜)
    atd_time TIMESTAMP DEFAULT SYSTIMESTAMP, 		      -- 출석 시간 (기본값: 현재 시간)
    status 	 CHAR(1)   CHECK (status IN ('P', 'A', 'L')), -- 출석 상태 ('P': 출석, 'A': 결석, 'L': 지각)
    t_no	 NUMBER,                     				  -- 담당 교사 ID (외래키)
    CONSTRAINT fk_atd_student FOREIGN KEY (s_no) REFERENCES student(s_no),
    CONSTRAINT fk_atd_teacher FOREIGN KEY (t_no) REFERENCES teacher(t_no)
);


--CREATE OR REPLACE TRIGGER set_atd_status
--BEFORE INSERT ON atd
--FOR EACH ROW
--BEGIN
--    -- 출석 시간에 따라 출결 상태 자동 설정
--    IF TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS') <= '08:59:59' THEN
--        :NEW.status := 'P'; -- 출석
--    ELSIF TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS') BETWEEN '09:00:00' AND '12:59:59' THEN
--        :NEW.status := 'L'; -- 지각
--    ELSE
--        :NEW.status := 'A'; -- 결석
--    END IF;
--END;
CREATE OR REPLACE TRIGGER set_atd_status
BEFORE INSERT ON atd
FOR EACH ROW
BEGIN
    -- 만약 이미 상태가 지정되어 있으면, 트리거에서 덮어쓰지 않음
    IF :NEW.status IS NULL THEN
        -- 출석 시간에 따라 출결 상태 자동 설정
        IF TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS') <= '08:59:59' THEN
            :NEW.status := 'P'; -- 출석
        ELSIF TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS') BETWEEN '09:00:00' AND '12:59:59' THEN
            :NEW.status := 'L'; -- 지각
        ELSE
            :NEW.status := 'A'; -- 결석
        END IF;
    END IF;
END;



-- atd_id 시퀀스 생성
-- DROP SEQUENCE atd_id_seq;
CREATE SEQUENCE atd_no_seq
START WITH 1
INCREMENT BY 1;

-- s_no 시퀀스 생성 (학생 고유 번호)
-- DROP SEQUENCE student_s_no_seq;
CREATE SEQUENCE student_s_no_seq
START WITH 1
INCREMENT BY 1;

-- t_no 시퀀스 생성 (교사 고유 번호)
-- DROP SEQUENCE teacher_t_no_seq;
CREATE SEQUENCE teacher_t_no_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE class_class_no_seq
START WITH 1
INCREMENT BY 1;

COMMIT;

/*
-- student 테이블에 데이터 삽입 예시
INSERT INTO student (s_no, s_id, s_pw, s_name, s_birth, s_tel, s_addr, class_id)
VALUES (student_s_no_seq.NEXTVAL, 's101', 'password123', '학생1', TO_DATE('2000-01-01', 'YYYY-MM-DD'), '010-1234-5678', '서울', 1);

-- teacher 테이블에 데이터 삽입 예시
INSERT INTO teacher (t_no, t_id, t_pw, t_name, t_tel, class_id)
VALUES (teacher_t_no_seq.NEXTVAL, 't201', 'teacherpass', '교사1', '010-1111-2222', 1);

-- atd 테이블에 데이터 삽입 예시
INSERT INTO atd (atd_id, s_no, atd_date, atd_time, t_no)
VALUES (atd_id_seq.NEXTVAL, 101, SYSDATE, SYSTIMESTAMP, 201);
*/

/*
INSERT INTO atd (atd_id, s_no, atd_date, atd_time, t_no)
VALUES (1, 101, SYSDATE, SYSTIMESTAMP, 201);

INSERT INTO atd (atd_id, s_no, atd_date, atd_time, t_no)
VALUES (2, 102, SYSDATE, SYSTIMESTAMP, 201);

SELECT s.s_name, c.class_name, a.atd_date, a.atd_time, a.status
FROM atd a
JOIN student s ON a.s_no = s.s_no
JOIN class c ON s.class_id = c.class_id
WHERE a.atd_date = TRUNC(SYSDATE);

UPDATE atd
SET status = 'P', atd_time = TO_TIMESTAMP('2025-03-25 08:58:00', 'YYYY-MM-DD HH24:MI:SS')
WHERE atd_id = 3;
*/

