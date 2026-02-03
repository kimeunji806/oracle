-- 함수.
-- 월급 계산 = pay*12+bonus*3 => 연봉. (professor)
-- 월급 계산 = pay+nvl(bonus,0)
SELECT profno
      ,name
      ,pay*12+nvl(bonus,0)*3 as "연봉"
      ,pay
      ,nvl(bonus,0) bonus
FROM professor

-- initcap('문자열' / 컬럼)
SELECT initcap('hello')
FROM dual; -- 더미 테이블 역할 / 규칙 만들기위해 사용.

SELECT profno
      ,initcap(name)
      ,lower(name)
      ,upper(name)
      ,length(name)
      ,lengthb('김은지')-- 문자열이 길이(바이트 수) 계산.
      ,concat(name,pay)
FROM professor;

-- 예1) 교수테이블의 이름에 'st'(대소문자 구분없이)가 포함된 교수의 교수번호, 이름, 입사일 출력.
SELECT profno
      ,name
      ,hiredate
FROM professor
WHERE lower(name) like '%st%';

-- 예2) 교수테이블의 교수이름이 10글자가 안 되는 교수의 번호, 이름, 이메일 출력.
SELECT profno
      ,name
      ,email
      ,profno || name
      ,concat(profno, name)
FROM professor
WHERE length(name) < 10;

-- substr
SELECT 'hello, world'
      ,substr('hello, world', 1, 5) substr1 --(+)값이면 왼쪽부터 순번.
      ,substr('hello, world', -5, 5) substr2 -- (-)값이면 오른쪽에서부터 검색 후 왼쪽부터 순번.
      ,substr('0'||5, -2, 2) mm
      ,substr('02)3456-2345', 1, instr('02)3456-2345', ')', 1)-1) instr1
      ,substr ('031)2345-2312',1, instr('031)2345-2312', ')', 1)-1) instr2
      ,instr('031)2345-2312', ')', 1) instr2 -- 문자열에서 찾을 문자열의 위치 반환.
FROM dual;

-- 주전공(201) -> 전화번호, 지역번호 구분.(교재 p.79)
SELECT name
      ,tel
      ,substr(tel
             ,1
             ,instr(tel, ')', 1)-1) "AREA CODE"
      ,substr(tel                                      -- 문자열.
             ,instr(tel, ')', 1)+1                     -- 시작위치.
             ,instr(tel, '-', 1)-instr(tel, ')', 1)-1  -- 크기.
             )"1st NO"
       -- instr(tel, ')', 1) ')' 위치값.
       -- instr(tel, '-', 1) '-' 위치값.
FROM student
WHERE deptno1 = 201;

-- lpad / rpad
SELECT rpad('hello', 5, '*')
FROM dual;

-- LPAD퀴즈.
SELECT lpad(ename, 9, '1234567') "lpad"
      ,rpad(ename, 10, '-') "rpad"
      ,rpad(ename, 9, substr('123456789',lengthb(ename))) "rpad2"
      ,substr('123456789',lengthb(ename)) "str"
FROM emp
WHERE deptno = 10;

-- ltrim / rtrim('값', '찾을문자열')
SELECT rtrim('Hello', 'o')
FROM dual;

-- replace('값', '찾을문자열', '대체문자열')
SELECT replace('Hello', 'o', 'o, world')
FROM dual;

SELECT ename
      ,replace(ename, substr(ename, 1, 2), '**') replace
      ,substr(ename, 1, 2) destination
FROM emp
WHERE deptno = 10;

-- replace 퀴즈1)
SELECT ename
      ,replace(ename, substr(ename, 2, 2), '--') replace
      ,substr(ename, 2, 3)
FROM emp
WHERE deptno = 20;

-- replace 퀴즈2)
SELECT name
      ,jumin
      ,replace(jumin, substr(jumin,7), '-/-/-/-') replace
FROM student
WHERE deptno1 = 101;

-- replace 퀴즈3)
SELECT name
      ,tel
      ,replace(tel, substr(tel,5,3), '***') replace
      ,instr(tel, ')', 1)
FROM student
WHERE deptno1 = 102;

-- replace 퀴즈4)
SELECT name
      ,tel
      ,replace(tel, substr(tel,-4, 4),'****') replace
      ,substr(tel,-4, 4) sbustr
FROM student
WHERE deptno1 = 101;