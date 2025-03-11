/* 내장함수
 * */

/* 문자(열)함수*/

-- INITCAP()
SELECT 'hello oracle'
	FROM dual; -- dual: 실제하지 않는 테이블(oracle만!)
	
SELECT initcap('hello oracle') AS "result"
	FROM dual; -- dual: 실제하지 않는 테이블(oracle만!)

-- LOWER() 모든 글자 소문자, UPPER() 모든 글자 대문자
SELECT LOWER(first_name) AS "first_name",
       UPPER(last_name) AS "last_name",
       first_name AS "Original first_name"
	FROM employees;

-- LENGTH()/ LENGTHB() 함수
SELECT LENGTH('Hello oracle'),  -- 글자길이 12
	   LENGTHB('Hello oracle'), -- 12bytes
	   LENGTH('반가워요 오라클'),   -- 글자길이 8
	   LENGTHB('반가워요 오라클')   -- 22bytes, 한글 7자 x 3bytes = 21bytes + 공백 1bytes
	FROM dual;
	
-- CONCAT() == ||와 동일한 기능
SELECT CONCAT(first_name, last_name)
	FROM employees;
	
SELECT CONCAT(CONCAT(first_name, ' '), last_name) AS "full_name"
	FROM employees;
	
	
	
	
	
	
	