-- 210p 연습문제
SELECT * FROM emp;
SELECT * FROM STUDENT;
SELECT * FROM FRUIT;

-- 1번 문제: sal, comm을 합친 금액 -> 가장 많은 경우와 가장 적은 경우, 평균
SELECT sal, comm FROM emp;

SELECT sal, comm, (sal + comm) AS "총합계" --, min(sal + comm)
FROM emp
WHERE comm IS NOT NULL;

-- 2번 문제: student 테이블 birthday
SELECT
    to_char(birthday, 'mm') AS "생일",
    birthday,
    CASE 
        WHEN to_char(birthday, 'mm') = '12' THEN 'DEC'
        WHEN to_char(birthday, 'mm') = '11' THEN 'NOV'
        WHEN to_char(birthday, 'mm') = '10' THEN 'OCT'
        WHEN to_char(birthday, 'mm') = '09' THEN 'SEP'
        WHEN to_char(birthday, 'mm') = '08' THEN 'AUG'
        WHEN to_char(birthday, 'mm') = '07' THEN 'JUL'
        WHEN to_char(birthday, 'mm') = '06' THEN 'JUN'
        WHEN to_char(birthday, 'mm') = '05' THEN 'MAY'
        WHEN to_char(birthday, 'mm') = '04' THEN 'APR'
        WHEN to_char(birthday, 'mm') = '03' THEN 'MAR'
        WHEN to_char(birthday, 'mm') = '02' THEN 'FEB'
        WHEN to_char(birthday, 'mm') = '01' THEN 'JAN'
        ELSE '미분류'
    END AS "생일_분류"
FROM student
ORDER BY "생일";

SELECT 
    COUNT(*) AS "전체 학생 수",
    SUM(CASE WHEN to_char(birthday, 'mm') = '12' THEN 1 ELSE 0 END) AS "DEC",
    SUM(CASE WHEN to_char(birthday, 'mm') = '11' THEN 1 ELSE 0 END) AS "NOV",
    SUM(CASE WHEN to_char(birthday, 'mm') = '10' THEN 1 ELSE 0 END) AS "OCT",
    SUM(CASE WHEN to_char(birthday, 'mm') = '09' THEN 1 ELSE 0 END) AS "SEP",
    SUM(CASE WHEN to_char(birthday, 'mm') = '08' THEN 1 ELSE 0 END) AS "AUG",
    SUM(CASE WHEN to_char(birthday, 'mm') = '07' THEN 1 ELSE 0 END) AS "JUL",
    SUM(CASE WHEN to_char(birthday, 'mm') = '06' THEN 1 ELSE 0 END) AS "JUN",
    SUM(CASE WHEN to_char(birthday, 'mm') = '05' THEN 1 ELSE 0 END) AS "MAY",
    SUM(CASE WHEN to_char(birthday, 'mm') = '04' THEN 1 ELSE 0 END) AS "APR",
    SUM(CASE WHEN to_char(birthday, 'mm') = '03' THEN 1 ELSE 0 END) AS "MAR",
    SUM(CASE WHEN to_char(birthday, 'mm') = '02' THEN 1 ELSE 0 END) AS "FEB",
    SUM(CASE WHEN to_char(birthday, 'mm') = '01' THEN 1 ELSE 0 END) AS "JAN"
FROM student;








