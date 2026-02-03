--TODO.sql
SELECT ename || '''s' || ' sal is ' || '$' || sal as "Name And Sal"
FROM emp;

-- 2026.02.03(화) TODO.

-- 107page.
SELECT empno
      ,ename
      ,sal
      ,comm
      ,to_char((sal*12)+comm,'999,999') salpay
FROM emp
WHERE ename = 'ALLEN';

SELECT name
      ,pay
      ,bonus
      ,to_char((pay*12)+bonus,'999,999') totpay
FROM professor
WHERE deptno = 201;

-- 108page.

-- 113page(nvl2).

-- 학생테이블의 생년월일을 기준으로 1~3 => 1/4분기.
--                             4~6 => 2/4분기.
--                             7~9 => 3/4분기.
--                             10~12 => 4/4분기.
SELECT name
      ,birthday
      ,decode(to_char(birthday,'mm'),1, '1/4분기', 2, '1/4분기', 3, '1/4분기',
      (decode(to_char(birthday,'mm'),  4, '1/4분기', 5, '2/4분기', 6, '2/4분기',
      (decode(to_char(birthday,'mm'), 7, '3/4분기', 8, '3/4분기', 9, '3/4분기',
      (decode(to_char(birthday,'mm'), 10, '4/4분기', 11, '4/4분기', 12, '4/4분기'))))))) "생년월일"
FROM student;