-- Table 구조 복사

create table dept_backup
as
select *
from departments where 1=0;

-- DQL에서 subQuery 이용하기 (select (select=1),,, from (select=2) where (select=3) )
-- 1은 스칼라 서브쿼리, 2는 인라인뷰, 3은 일반 서브쿼리라고 함
-- DML에서 subQuery 이용하기
insert into dept_backup
select *
from departments
where department_id < 90;

select * from dept_backup;

create table emp_hire
as
select employee_id, first_name, hire_date from employees
where 1=0;

create table emp_mgr
as
select employee_id, first_name, manager_id from employees
where 1=0;

insert all
into emp_hire values(employee_id, first_name, hire_date)
into emp_mgr values(employee_id, first_name, manager_id)
select employee_id, first_name, hire_date, manager_id
from employees;

select * from emp_hire;
select * from emp_mgr;

-- 20번 부서의 지역 코드를 40번 부서의 지역명으로 변경하기
select location_id
from dept_backup
where department_id=20;

update dept_backup
set location_id = (
    select location_id
    from dept_backup
    where department_id=20
)
where department_id=40;

select * from dept_backup;

-- DML에서만 가능
-- DB반영
commit;
-- DB반영 취소
rollback;

delete from dept_backup;

create table emp
as
select *
from employees
where department_id = 60;

create table emp2
as
select *
from employees
where department_id = 60 and salary>=5000;

select * from emp;
select * from emp2;

update emp2
set first_name = '알렉산더' where employee_id = 103;
update emp2
set first_name = '브루스' where employee_id = 104;
commit;

insert into emp2
values(200, '호날두', '크리스티아누', 'siuuu@gmail.com', '111-222-3333', sysdate, 'IT_PROG', 150000, 0.12, 101, null);

merge into emp
using emp2
on (emp.employee_id = emp2.employee_id)
when matched then
    update set emp.first_name = emp2.first_name
when not matched then
    insert values(emp2.EMPLOYEE_ID,
emp2.FIRST_NAME,
emp2.LAST_NAME,
emp2.EMAIL,
emp2.PHONE_NUMBER,
emp2.HIRE_DATE,
emp2.JOB_ID,
emp2.SALARY,
emp2.COMMISSION_PCT,
emp2.MANAGER_ID,
emp2.DEPARTMENT_ID);

-- DQL: select
-- DDL: create, drop, rename, alter
-- DML: 


-- 무결성 제약조건
-- 1) not null
-- 2) unique
-- 3) primary key = not null+unique
-- 4) foreign key = 부모키가 먼저 있어서 참조키
-- 5) check

desc departments;
insert into departments values(3,'b',null,1111);
select * from departments;
select * from locations;
select * from employees;
update employees
set salary = -100
where employee_id = 3;

desc user_constraints;
select * from user_constraints
where table_name = 'EMPLOYEES';

select *
from user_cons_columns
where table_name='EMPLOYEES';


create table tbl_test1 (
    id number primary key,
    name1 char(20) not null,
    name2 varchar2(20) unique    
);

create table tbl_test2 (
    id number constraint tbl_test2_id_pk primary key,
    name1 char(20) constraint tbl_test2_n1_nn not null,
    name2 varchar2(20) constraint tbl_test2_n2_uk unique
);
desc tbl_test2;

insert into tbl_test2 values(1, '홍1', '홍2');
insert into tbl_test2 values(2, '홍1', '홍3');
select * from tbl_test2;


create table dept (
    deptno number constraint dept_deptno_pk primary key,
    deptname varchar2(50) not null
);
insert into dept values(1, '인사팀');

drop table emp;
create table emp(
    empno number constraint emp_empno_pk primary key,
    empname varchar2(50) not null,
    phone varchar2(11) unique,
    deptno number constraint emp_deptno_fk references dept(deptno),
    salary number constraint emp_salary_chk check (salary between 0 and 50000),
    gender varchar2(1) constraint emp_gender_chk check (gender in ('M', 'F'))
);
desc emp;
insert into emp values(1, '홍', '01012345678', null, 35000, 'M');
insert into emp values(2, '홍', '01012345670', 1, 50000, 'F');
insert into emp values(3, '홍', '01023423678', 1, 1000, 'M');
insert into emp values(4, '홍투', '01013423678', 1, null, null);

select * from emp;

drop table emp2;
-- 제약 조건은 table level 또는 column level 작성 가능
-- table level에 작성하는 경우 (pk가 다중 칼럼인 경우)
create table emp2(
    empno1 number,
    empno2 number,
    empname varchar2(50) not null,
    phone varchar2(11) unique,
    deptno number,
    salary number,
    gender varchar2(1),
    constraint emp2_empno_pk primary key (empno1, empno2),
    constraint emp2_deptno_fk foreign key (deptno) references dept(deptno),
    constraint emp2_salary_chk check (salary between 0 and 50000),
    constraint emp2_gender_chk check (gender in ('M', 'F'))
);

select * from user_constraints where table_name='EMP2';
select * from user_cons_columns where table_name='EMP2';

select constraint_Type, search_condition, column_name
from user_cons_columns
    join user_constraints using (constraint_name)
where user_cons_columns.table_name='EMP2';