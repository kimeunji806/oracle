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
      ,replace(jumin, substr(jumin,7), '-')
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

-- round(123.4)
SELECT round(123.456, -2) round
      ,trunc(123.4567, -1) trunc
      ,mod(12,5) mod
      ,ceil(12.3) ceil
      ,floor(12.3) floor
      ,to_char(trunc(sysdate, 'hh'), 'rrrr/mm/dd hh24:mi:ss') trunc2 -- 년/월/일 시/분/초
FROM dual;

-- 날짜 관련 함수.
SELECT ADD_MONTHS(sysdate, -1) next_month -- 28
      ,months_between(sysdate + 28, sysdate) months
FROM dual;

-- 사원번호, 이름, 근속년수 (23년 7개월)
SELECT empno
      ,ename
      ,hiredate
      ,trunc((months_between(sysdate,hiredate))/12) || '년 '
      || mod(trunc((months_between(sysdate,hiredate))),12) || '개월' 근속년수
FROM emp;

-- 교수번호, 이름, 입사일자, 급여 (30년 이상)
SELECT profno
      ,name
      ,hiredate
      ,pay
      ,trunc(months_between(sysdate, hiredate)/12) 근속년수
      ,p.deptno
FROM professor p
WHERE trunc(months_between(sysdate, hiredate)/12) >= 30
ORDER BY 3;

-- 교수번호, 이름, 입사일자, 급여 (20년 이상, Software Engineering)
SELECT profno
      ,name
      ,hiredate
      ,pay
      ,position
      ,p.deptno "P.deptno"
      ,d.deptno "D.deptno"
      ,d.dname
FROM professor p, department d
WHERE trunc(months_between(sysdate, hiredate)/12) >= 20
AND d.dname = 'Software Engineering'
AND d.deptno = p.deptno; -- 두 테이블간의 equal 조건.

--SALES부서에서 근속년수 40년이 넘는 사람. 사번, 이름, 급여, 부서명
SELECT e.empno
      ,e.ename
      ,e.sal
      ,d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND d.dname = 'SALES'
AND (months_between(sysdate, hiredate)/12) >= 40
ORDER BY e.empno;

-- 학과.
SELECT *
FROM department;

SELECT profno, name, p.deptno, d.deptno, dname
FROM professor p, department d
WHERE p.deptno = d.deptno
AND d.dname = 'Computer Engineering'; -- 16*12=192

--2 + '2'
SELECT 2 + to_number('2', 9)
      ,concat(2, '2')
      ,sysdate
FROM dual
WHERE sysdate > '2026/02/03';

-- to_char(날짜, '포맷문자')
SELECT sysdate
      ,to_char(sysdate, 'RRRR-MM-DD HH24:MI:SS') to_char
      ,to_date('05/2024/03', 'MM/RRRR/DD') to_date
FROM dual;

-- to_char
SELECT to_char(12345.6789, '099,999.99') -- 반올림한 연산 결과를 문자로 출력.
FROM dual;

-- p.105 형 변환 함수 퀴즈
SELECT studno
      ,name
      ,to_char(birthday,'dd/mon/rr') birthday
FROM student
WHERE to_char(birthday,'mm') = '01';

-- nvl()
SELECT nvl(10,0) -- null ? 0 : 10
FROM dual;

SELECT pay + nvl(bonus,0) "월급"
FROM professor;

-- student(profno) -> 9999(없으면)/담당교수번호
--                    담당교수 없음/담당교수번호
SELECT name
      ,nvl(profno,9999) prof1
      ,nvl(to_char(profno),'담당교수없음') prof2 -- null값 -> 치환하는 것
FROM student
ORDER BY 2 desc;

-- decode(A, B, '같은조건', '다른조건')
SELECT decode(10, 20, '같다', '다르다') -- 10 == 20 ? '같다' : '다르다'
FROM dual;

SELECT studno, profno, decode(profno, null, 9999, profno)
FROM student
ORDER BY profno desc;

SELECT decode('C', 'A', '현재A', 'B', '현재B', '기타')
FROM dual;

-- p.114 예제1)
SELECT deptno
      ,name
      ,decode(deptno, 101, 'Computer Engineering') DNAME
FROM professor;

-- p.115 예제2)
SELECT deptno
      ,name
      ,decode(deptno, 101, 'Computer Engineering', 'ETC') DNAME
FROM professor;

-- p.116 예제3)
SELECT deptno
      ,name
      ,decode(deptno, 101, 'Computer Engineering', 102, 'Multimedia Engineering', 103, 'Software Engineering', 'ETC') DNAME
FROM professor;

-- p.117 예제4)
SELECT deptno
      ,name
      ,decode(deptno, 101, decode(name, 'Audie Murphy', 'BEST!')) ETC
FROM professor;

-- p.118 예제5)
SELECT deptno
      ,name
      ,decode(deptno, 101, decode(name, 'Audie Murphy', 'BEST!','GOOD!')) ETC
FROM professor;