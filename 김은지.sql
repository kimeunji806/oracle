-- 1번.
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, DEPARTMENT_ID
FROM employees
WHERE salary BETWEEN 7000 AND 12000
AND last_name LIKE 'H%';

-- 2번.
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID, SALARY, DEPARTMENT_ID
FROM employees
WHERE DEPARTMENT_ID BETWEEN 50 AND 60
AND salary > 5000;

-- 3번.
SELECT FIRST_NAME, LAST_NAME, SALARY,
CASE
  WHEN SALARY <= 5000 THEN (SALARY*0.2)+SALARY
  WHEN SALARY <= 10000 THEN (SALARY*0.15)+SALARY
  WHEN SALARY <= 15000 THEN (SALARY*0.1)+SALARY
  WHEN SALARY >= 15001 THEN SALARY
  END SALARY_UP
FROM employees;

SELECT *
FROM employees;

-- 4번.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.CITY
FROM DEPARTMENTS D, LOCATIONS L;

-- 5번.
SELECT D.DEPARTMENT_ID, E.LAST_NAME, E.JOB_ID 
FROM EMPLOYEES E, DEPARTMENTS D
WHERE D.DEPARTMENT_NAME = 'IT';

-- 6번.
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, to_char(HIRE_DATE,'dd/mon/rr')HIRE_DATE, JOB_ID
FROM EMPLOYEES
WHERE substr(hire_date,1,4) < 2014
AND JOB_ID = 'ST_CLERK';

-- 7번.
SELECT LAST_NAME, JOB_ID, SALARY, to_char(COMMISSION_PCT, '.9')COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
ORDER BY 3 ;

-- 8번.
create table prof(
                PROFNO number(4),
                NAME varchar2(15) not null,
                ID varchar2(15) not null,
                HIREDATE date,
                PAY number(4));

SELECT *
FROM PROF;

-- 9번.
insert into prof(PROFNO, NAME, ID, HIREDATE, PAY)
values(1001, 'Mark', 'm1001', '07/03/01', 800);
insert into prof(PROFNO, NAME, ID, HIREDATE, PAY)
values(1003, 'Adam', 'a1003', '11/03/02', null);

update prof
set    pay = 1200
where profno = 1001;

delete from prof
where profno = 1003;

-- 10번.
alter table prof add primary key(PROFNO);

alter table prof add GENDER char(3);

alter table prof modify NAME varchar2(20);