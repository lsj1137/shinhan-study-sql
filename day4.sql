-- 서브쿼리

select department_id
from employees
where first_name='Lex';

-- 같은 부서에 일하는 사람

select *
from employees
where department_id = (select department_id
from employees
where first_name='Lex');

select *
from employees
where department_id in (select department_id
from employees
where first_name='Alexander');

-- Alexander 보다 많이 받는 사람

select first_name, salary
from employees
where salary > any(select salary
from employees
where first_name='Alexander');

-- 시애틀 사는 사람

--select first_name, department_name, city
--from locations
--    join departments using(location_id)
--    join employees using(department_id)
--where city = 'Seattle';

select first_name
from employees
where department_id in (
    select department_id
    from departments
    where location_id = (
        select location_id
        from locations
        where city='Seattle'));
        
-- Sales 부서에 근무하는 직원들 조회
-- Join 방식

select
    employees.*
from
    employees join departments on (employees.department_id = departments.department_id)
where
    department_name = 'Sales';
    
-- SubQuery 방식
select
    *
from
    employees
where
    department_id = (
    select department_id
    from departments
    where department_name='Sales');
    
-- 직속상관이 Steven인 직원의 급여와 입사일
select
    first_name,
    salary,
    hire_date
from employees
where
    manager_id in (
    select employee_id
    from employees
    where first_name='Steven');
    
-- 7000 이상 받는 사원이 소속된 부서와 동일한 부서에 근무하는 직원

select
    department_id
from
    employees
where
    salary>=14000;

select
    *
from
    employees
where
    department_id in (
    select
        department_id
    from
        employees
    where
        salary>=14000);
        
-- 부서별로 가장 급여를 많이 받는 사원
select
    *
from
    employees
where (department_id, salary) in (
    select department_id, max(salary)
    from employees
    group by department_id)
order by
    department_id;
    
-- 직급이 매니저인 사람이 속한 부서 번호, 부서명, 지역
select
    d.department_id,
    d.department_name,
    l.city
from
    locations l
    join departments d using (location_id)
where
    department_id in (
    select distinct department_id 
    from employees
    where
        job_id in (
        select job_id
        from jobs
        where job_title like '%Manager'));
        
-- 30번 부서 소속 사원들 중 급여를 가장 많이 받는 사원보다 더 많은 급여를 받는 사람의 이름, 급여
select
    first_name,
    salary
from
    employees
where
    salary > (
    select
        max(salary)
    from
        employees
    where
        department_id=30
    );

select
    first_name,
    salary
from
    employees
where
    salary > all(
    select
        salary        
    from
        employees
    where
        department_id=30
    );
    
-- 영업 사원들(Sales부서) 보다 급여를 많이 받는 사원들의 이름과 급여와 직급을 출력하되 영업사원은 제외
select *
from employees
where
    salary > any (
        select salary
        from employees
        where department_id = (
            select department_id
            from departments
            where department_name='Sales'))
and 
department_id <> (
            select department_id
            from departments
            where department_name='Sales');
            
            
create table shinhanTbl1(
    id number,
    name1 char(20),
    name2 varchar2(20)
);

select * from shinhantbl1;
desc shinhantbl1;

-- varchar2 는 공백도 data임
-- char 는 고정길이 20byte, 조회시 자동으로 trim
insert into shinhantbl1 values(1, 'a ', 'a ');
insert into shinhantbl1 values(1, 'a', 'a ');

select *
from shinhantbl1
where name1 = 'a ';

select *
from shinhantbl1
where name2 = 'a';

select *
from shinhantbl1
where name2 = 'a ';


select rowid, rownum, first_name, salary
from employees;

create table emp_backup
as
select * from employees;

select * from emp_backup;

create table emp_backup2
as
select employee_id, first_name, salary from employees;

create table emp_backup3
as
select employee_id, first_name, salary from employees where 1=0;

select * from emp_backup3;

alter table emp_backup3 add(job varchar2(20));

alter table emp_backup3 modify(job varchar2(30));

desc emp_backup3;

alter table emp_backup3 drop column job;
drop table emp_backup3;

select * from emp_backup2;
truncate table emp_backup2;

select * from user_tables;