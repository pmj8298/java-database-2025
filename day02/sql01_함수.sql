/*단일행 함수*/

SELECT concat('Hello', 'Oracle') -- 한행 한열만 출력되는 값 : 스칼라(Scalar)값
	FROM dual;

-- 인덱스가 1부터 시작, 일반프로그래밍언어는 배열이 0부터 시작하는 것과 차이가 있음
-- SUBSTR(변환할값, 인덱스, 길기) - 파이썬 substring() 함수와 동일
-- -인덱스 : 뒤에서부터 위치
SELECT substr(email, 1,2), -- 진짜진짜 많이 씀
	   substr(email, -2,2),
	   email
	FROM employees;

-- 전화번호 자를 때, 주민번호 자를 때 SUBSTR() 활용

-- INSTR(체크할 문자열, 찾는글자, 시작위치, 몇번째)
SELECT '010-1111-2222',
	   instr('010-1111-2222', '-', 1,1), -- 4
	   instr('010-1111-2222', '-', 1,2)  -- 9
	FROM dual;

-- LPAD(문자열, 자리수, 채울문자), RPAD(문자열, 자리수, 채울문자)
-- 2025-11-23
-- 2025-3-12 -> 2025-03-12
-- 0000100 규칙인데
-- 101 -> 0000101
SELECT LPAD('100',7,'0'), -- 진짜진짜 많이 씀
	   RPAD('ABC',7,'-')
	FROM dual;

-- TRIM() 함수 트리플. == python strip() 함수와 동일
-- LTRIM(), RTRIM(), TRIM()
SELECT '<<<' || '    Hello Oracle    ' || '>>>',
       '<<<' || LTRIM('    Hello Oracle    ') || '>>>',
       '<<<' || RTRIM('    Hello Oracle    ') || '>>>',
       '<<<' || TRIM('    Hello Oracle    ') || '>>>'
	FROM dual;

-- REPLACE(), python에서도 동일하게 존재
SELECT phone_number,
	   replace(phone_number, '123','831') -- 많이 씀
	FROM employees;

/*
 * 숫자함수
 * */
-- ROUND() 반올림 함수 - 파이썬 존재
-- CEIL() 올림함수, FLOOR() 내림함수, TRUNC() 내림함수 소수점
-- MOD() 나누기 나머지값 - python mode(), % 연산과 동일
-- POWER() - python ,math.pow(), power(), 2^10 승수계산 동일
SELECT 786.5427 AS res1,
	   round(786.5427) AS round0,      -- 소수점 없이 : 787    출력
	   round(786.5427, 1) AS round1,   -- 소수점 1   : 786.5  출력
	   round(786.5427, 2) AS round2,   -- 소수점 1   : 786.54 출력
	   ceil(786.5427) AS ceilRes,      -- 787
	   floor(786.5427) AS floorRes,    -- 786
	   trunc(786.5427, 3) AS truncRes, -- 786.542
	   mod(10,3) AS 나머지,              -- 1
	   power(2,10) AS "2의10승"         -- 1024
	FROM dual;

/*
 * 날짜함수, 나라마다 표현방식 다름
 * 2025-03-12 아시아
 * March/12/2025 미국, 캐나다
 * 12/March/2025 유럽, 인도
 * 포매팅을 많이 함
 * */
-- 오늘날짜
SELECT sysdate AS 오늘날짜,                        -- GMT기준, +09 필요            : 2025-03-12 01:50:47.000
	   -- 날짜 포매팅 사용되는 YY, YYYY, MM, DD, DAY 년월일
	   -- AM/PM, HH, HH24, MI, SS, W, Q(분기)
	   TO_CHAR(sysdate, 'YYYY-MM-DD') AS 한국식, -- 글자로 바뀌면서 왼쪽정렬이 되어버림  : 2025-03-12
	   TO_CHAR(sysdate, 'YYYY-MM-DD DAY') AS 한국식요일,                      -- : 2025-03-12 수요일
	   TO_CHAR(sysdate, 'PM HH24-MI-SS') AS 시간,                           -- : 오전 01-50-47   
	   TO_CHAR(sysdate, 'MON/DD/YYYY') AS 미국식,                            -- : 3월 /12/2025    
	   TO_CHAR(sysdate, 'DD/MM/YYYY') AS 영국식                              -- : 12/03/2025  
	FROM dual;

-- ADD_MONTH() 월을 추가함수
-- MON, TUE, WED, TUR, FRI, SAT, SUN
SELECT  hire_date,
		to_char(hire_date, 'yyyy-mm-dd') AS 입사일자, -- 2003-06-17
		add_months(hire_date, 3) AS 정규직일자,        -- 2003-09-17 00:00:00.000
		next_day(hire_date, '월') AS 돌아오는월요일,     -- 2003-06-23 00:00:00.000
		last_day('2025-02-01') AS 달마지막날           -- 2025-02-28 00:00:00.000
	FROM employees;

-- GMT + 9
-- 인터벌 숫자 뒤 HOUR, DAY, MONTH, YEAR
SELECT to_char(sysdate + INTERVAL '9' HOUR, 'yyyy-mm-dd hh24:mi:ss') AS seoul_time, -- 2025-03-12 11:25:39
	   to_char(sysdate + INTERVAL '9' DAY, 'yyyy-mm-dd hh24:mi:ss'),                -- 2025-03-21 02:25:39
	   to_char(sysdate + INTERVAL '9' MONTH, 'yyyy-mm-dd hh24:mi:ss'),              -- 2025-12-12 02:25:39
	   to_char(sysdate + INTERVAL '9' YEAR, 'yyyy-mm-dd hh24:mi:ss')                -- 2034-03-12 02:25:39
	FROM DUAL;





