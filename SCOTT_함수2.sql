SELECT
    name,
    to_char(birthday, 'Q')
    || '/4분기'                                     quarter,
    ceil(to_char(birthday, 'MM') / 3)
    || '/4분기'                                     quarter2,
    decode(to_char(birthday, 'MM'), '01', '1/4분기', '02', '1/4분기',
           '03', '1/4분기', '04', '2/4분기', '05',
           '2/4분기', '06', '2/4분기', '07', '3/4분기',
           '08', '3/4분기', '09', '3/4분기', '10',
           '4/4분기', '11', '4/4분기', '12', '4/4분기') quarter3
FROM
    student;

SELECT
    *
FROM
    emp;

SELECT
    *
FROM
    dept;

SELECT
    e.*,
    dname,
    loc
FROM
    emp  e,
    dept d
WHERE
    e.deptno = d.deptno;

-- ANSI vs. ORACLE => 반드시 알아야함!!
SELECT
    *
FROM
         emp e
    JOIN dept d ON e.deptno = d.deptno
WHERE
    job = 'SALESMAN';

-- student(profno), professor(profno)
-- 학생번호, 이름, 담당교수번호, 이름
SELECT
    s.studno,
    s.name "S.NAME",
    p.profno,
    p.name "P.NAME"
FROM
    student   s
    FULL OUTER JOIN professor p ON s.profno = p.profno; -- 왼(left)/오(right) 기준으로 데이터 전체 보고싶을때 사용.
-- student, professor / full 기준도 가능
SELECT
    *
FROM
    student;

SELECT
    *
FROM
    professor;

-- 학생번호, 학생이름, 담당교수 이름 / 담당교수 없음
-- 0915, Daniel Day-Lewis, Jodie Foster
-- 9712, Sean Connery, 담당교수 없음
-- 자동정렬 => ctrl + F7
SELECT
    studno
    || ','
    || s.name
    || ','
    || nvl(p.name, '담당교수 없음') "NAME"
FROM
    student   s
    LEFT OUTER JOIN professor p ON s.profno = p.profno;
    
-- nvl(), decode(), case when end
--student  지역번호 구분 02(서울) 031(경기도) 051(부산) 그외(기타)
SELECT
    name,
    substr(tel, 1, instr(tel, ')', 1) - 1) tel,
    CASE substr(tel, 1, instr(tel, ')', 1) - 1)
        WHEN '02'  THEN
            '서울'
        WHEN '031' THEN
            '경기도'
        WHEN '051' THEN
            '부산'
        ELSE
            '기타'
    END                                    "지역명"
FROM
    student;

SELECT
    name,
    CASE
        WHEN substr(jumin, 3, 2) BETWEEN '01' AND '03' THEN
            '1/4분기'
        WHEN substr(jumin, 3, 2) BETWEEN '04' AND '06' THEN
            '2/4분기'
        WHEN substr(jumin, 3, 2) BETWEEN '07' AND '09' THEN
            '3/4분기'
        WHEN substr(jumin, 3, 2) BETWEEN '10' AND '12' THEN
            '4/4분기'
    END "분기"
FROM
    student;

-- p.123 퀴즈)
SELECT
    empno,
    ename,
    sal,
    CASE
        WHEN sal BETWEEN 1 AND 1000    THEN
            'Level 1'
        WHEN sal BETWEEN 1001 AND 2000 THEN
            'Level 2'
        WHEN sal BETWEEN 2001 AND 3000 THEN
            'Level 3'
        WHEN sal BETWEEN 3001 AND 4000 THEN
            'Level 4'
        WHEN sal >= 4001               THEN
            'Level 5'
    END "LEVEL"
FROM
    emp
ORDER BY
    3;

SELECT
    job,
    COUNT(*),
    SUM(sal),
    round(AVG(sal), 1) avg,
    MIN(hiredate),
    MAX(hiredate)
FROM
    emp
GROUP BY
    job;

-- 부서별 부서명, 급여 합계, 평균 급여, 인원
SELECT d.dname
      ,e.*
FROM
         (
        SELECT
            deptno             "부서코드",
            SUM(sal)           "급여합계",
            round(AVG(sal), 1) "평균급여",
            COUNT(*)           "인원"
        FROM
            emp
        GROUP BY
            deptno
    ) e
    JOIN dept d ON 부서코드 = d.deptno;
-- emp dept 조인.
SELECT
    d.dname,
    SUM(e.sal)                          "급여합계",
    round(AVG(e.sal + nvl(comm, 0)), 1) "평균급여",
    COUNT(*)                            "인원"
FROM
         emp e
    JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname;

-- rollup()
-- 1)부서별 직무별 평균급여, 사원수.
SELECT deptno
      ,job
      ,avg(sal)
      ,count(*)
FROM emp
GROUP BY deptno
        ,job
union
-- 2)부서별 평균급여, 사원수.
SELECT deptno
      ,'소계'
      ,round(avg(sal),1)
      ,count(*)
FROM emp
GROUP BY deptno
union
-- 3)전체 평균급여, 사원수.
SELECT 99
      ,'총계'
      ,round(avg(sal),1)
      ,count(*)
FROM emp
ORDER BY 1;

-- rollup
SELECT deptno
      ,job
      ,round(avg(sal),1)
      ,count(*)
FROM emp
GROUP BY rollup(deptno,job)
ORDER BY 1;

-- 게시판(board)
-- 글번호, 제목, 작성자, 글내용, 작성시간 --, 조회수, 수정시간, 수정자...
drop table board; -- 테이블 삭제.
create table board (
  board_no number(10),--글번호
  title    varchar2(300) not null,--제목
  writer   varchar2(50) not null,--작성자
  content  varchar2(1000) not null,--글내용
  created_at date--작성시간
);
--컬럼추가.
alter table board add (click_cnt number);
--add(추가) / click_cnt number 클릭 카운트라는 컬럼추가(형태:숫자)
alter table board modify content varchar(1000);
--content의 입력수를 1000으로 늘리겠다.
alter table board modify click_cnt number default 0;
--modify : 수정하겠다
alter table board modify created_at date default sysdate;

desc board;

update board
set    click_cnt = click_cnt + 1
where  board_no = :bno;

--not null : 값을 반드시 입력하겠다.
--primary key : 중복 불가능
--default sysdate : sysdate 값을 기본값으로 설정하겠다.
--drop : table 삭제

--값 입력
insert into board (board_no, title, writer, content)
values (1, 'test', 'user01', '연습글입니다');

insert into board (board_no, title, writer, content)
values (2, 'test2', 'user02', '연습글입니다2');

insert into board (board_no, title, writer, content)
values (3, 'test3', 'user03', '연습글입니다3');

SELECT *
from board;
commit;

update board
set    title = 'test3'
where  board_no = 4;