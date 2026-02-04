SELECT *
FROM emp;

-- 추가작업(origin merge 테스트)
SELECT *
FROM dept;

-- DML (insert, update, delete, merge)
-- 1) insert into table명 (컬럼1, 컬럼2,...) values(값1, 값2,...)
select * from board;
-- 4/ 글등록연습/ user01/ sql연습중
-- insert 완성.
insert into board (board_no, title, content, writer) -- 순서 외워두기.
values ((select max(board_no)+1 from board)
        ,:title
        ,:content
        ,:writer
        );
insert into board
values(9, 'title', 'user02', 'content', sysdate, 0);

select * from board;
select max(board_no)+1 from board;

-- 규칙 외워두기.
update board
set    click_cnt = click_cnt + 1
      ,title = :title
      ,content = :content
where  board_no = :bno;

delete from board
where content like '%바인드%';

select * from board;

select * from emp order by 1 desc;
-- max+1, 이름, SALESMAN, , 2026-02-01, 3000, 10, 30
insert into emp(empno, ename, job, hiredate, sal, comm, deptno)
values((select max(empno)+1 from emp), '김은지', 'SALESMAN',to_date('2026-02-01','rrrr-mm-dd'), 3000, 10, 30);
-- 30부서의 MANAGER의 사번.
update emp
set    mgr = (select empno from emp
              where deptno = 30
              and job = 'MANAGER')
where  empno = 7935;

select empno from emp
where deptno = 30
and job = 'MANAGER';

-- 상품 테이블(product_tbl)
-- 상품코드, 상품명, 가격, 상품설명, 평점(5,4,3,2,1), 제조사, 등록일자
-- key      nn     nn   nn       3                      sysdate
create table p_tb(
             p_code varchar2(10) primary key, -- 상품코드
             p_name varchar2(100) not null, -- 상품명
             p_price number(30) not null, -- 가격
             p_description varchar2(1000) not null, -- 상품설명
             p_score number(5) default 3, -- 평점
             p_manufacturer varchar2(30), -- 제조사
             p_date date -- 등록일자
);

alter table p_tb modify p_score number default 3;
alter table p_tb modify p_date date default sysdate;

update p_tb
set    p_date = nvl(p_date,sysdate);

update p_tb
set    p_score = nvl(p_score,3);

select * from p_tb
order by 1 desc;

select 's' || select lpad(max(subst(p_code,2,3))+1, 3, '0')
from p_tb;

insert into p_tb(p_code, p_name, p_price, p_description, p_score, p_manufacturer, p_date)
values(:p_code, :p_name, :p_price, :p_description, :p_score, :p_manufaturer, sysdate);

-- merge into table1
-- using table2
-- on 병합조건
-- when matched then
-- update ...
-- when not matched then
-- insert ...
merge into p_tb tbl1
using (select :pcode p_code
              ,:pname p_name
              ,:pprice p_price
              ,:pdesc p_description
       from dual) tbl2
on (tbl1.p_code = tbl2.p_code)
when matched then
  update set
     tbl1.p_name = tbl2.p_name
    ,tbl1.p_price = tbl2.p_price
    ,tbl1.p_description = tbl2.p_description
when not matched then
  insert (p_code, p_name, p_price, p_description)
  values (tbl2.p_code, tbl2.p_name, tbl2.p_price, tbl2.p_description);
