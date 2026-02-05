-- Oracle (DBMS) - version(21C) - xe(database명)
-- user(scott) - 테이블.
-- Structured Query Language(SQL)
SELECT studno, name -- 컬럼명(전체)
FROM STUDENT; -- 테이블.

-- 1) professor 테이블. 전체 컬럼 조회.
SELECT *
FROM PROFESSOR;

-- 2) 학생 -> 학생번호, 이름, 학년
SELECT *
FROM STUDENT;
SELECT STUDNO, NAME, GRADE
FROM STUDENT;

-- 숙제완료함.
select name || '의 ''아이디''는 ' || id || ' 이고 ' || grade || '학년입니다.'
      as "학년설명" --별칭(alias)
      -- ,grade "학년"
from student;
-- James Seo의 '아이디'는 75true 이고 4학년입니다. => alias (학년설명)

SELECT distinct name, grade -- 중복된 값 제거.
FROM student;

SELECT *
FROM emp;

-- 연습1)
SELECT *
FROM student;

SELECT name || '''s ' || 'ID: '|| id || ' , ' || 'WEIGHT is ' || weight || 'kg' as "ID AND WEIGHT"
FROM student;

-- 연습2)
SELECT *
FROM emp;

SELECT ename || '(' || job || '), ' || ename || '''' || job || '''' as "NAME AND JOB"
FROM emp;

-- WHERE
SELECT *
FROM student
WHERE weight between 60 AND 70 --weight >= 60 AND weight <= 70
AND   deptno1 in (101, 201); --비교연산자임! 101이거나 201 조건에 맞는 것

SELECT *
FROM student
WHERE deptno2 is not null;

-- 비교연산자 연습1)emp테이블 급여 3000보다 큰 직원.
SELECT *
FROM emp
WHERE sal >= 3000

-- 비교연산자 연습2) emp테이블 보너스 있는 직원.
SELECT *
FROM emp
WHERE COMM is not null;

-- 비교연산자 연습3) student테이블 주전공학과:101,102,103인 학생.
SELECT *
FROM STUDENT
WHERE deptno1 in (101,102,103);

-- AND / OR
-- IF (sal > 100 || height > 170)
SELECT studno
       ,name
       ,grade
       ,height
       ,weight
FROM student
WHERE (height > 170
OR   weight > 60)
AND (grade = 4 OR height > 150);

-- 비교연산자 연습4) emp테이블 급여가 2000 이상인 직원. 커미션(급여+커미션)
SELECT *
FROM emp
WHERE (sal > 2000) OR (sal+comm)>2000;

-- 교수=> 연봉이 4000 이상인 교수. 보너스 3번.
SELECT profno,
       name,
       bonus,
       pay * 12 as total_1,
       pay * 12 + bonus * 3 as total_2
FROM professor
WHERE (pay * 12 >= 3000 AND bonus is null)
OR (pay * 12 + bonus * 3 >= 3000 AND bonus is not null)
ORDER BY total_1 -- 정렬기준.
;

-- 문자열 like 연산자.
SELECT *
FROM student
WHERE name like '%on____%';
--
SELECT profno
       ,name
       ,pay
       ,bonus
       ,hiredate
FROM professor
WHERE hiredate > to_date('1999-01-01', 'rrrr-mm-dd')
ORDER by hiredate; -- 1970.01.01

-- 학생테이블, 전화번호(02, 031, 051, 052, 053..)
-- 부산 거주.
SELECT *
FROM student
WHERE TEL like '051%';

-- 이름 M 8개 이상인 사람.
SELECT *
FROM student
WHERE name like 'M________%';

-- 주민번호 10월달에 태어난 사람 조회.
SELECT *
FROM student
WHERE JUMIN like '__10%';