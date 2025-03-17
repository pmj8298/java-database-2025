/*
 * 제약조건. 잘못된 데이터가 들어가지 않도록 막는 기능
 */
-- 제약조건 다섯가지 모두 사용한 테이블 생성 쿼리
CREATE TABLE new_emp (
	idx NUMBER PRIMARY KEY,
	name varchar2(20) NOT NULL,
	jumin varchar2(14) NOT NULL UNIQUE,
	loc_code number(1) CHECK (loc_code > 0 AND loc_code < 5), -- loc_code 1, 2, 3, 4
	dcode varchar2(6) REFERENCES dept2(dcode)
);

-- 이름에 UNIQUE 제약조건을 추가로 걸때
ALTER TABLE new_emp
  ADD CONSTRAINT uk_name UNIQUE(name);

-- 제약조건 변경
ALTER TABLE new_emp
  MODIFY (loc_code CONSTRAINT ck_loc_code CHECK (loc_code > 0 AND loc_code < 7));

-- 필요없는 제약조건 삭제
ALTER TABLE new_emp DROP CONSTRAINT "SYS_C007156";