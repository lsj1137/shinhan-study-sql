--desc employees;
--select * from EMPLOYEES;

-- 연결연산자 ||
--select
--    first_name||' '||last_name 이름,
--    salary as 연봉,
--    nvl2(COMMISSION_PCT,TO_CHAR(COMMISSION_PCT),'없음') as "상여금 비율",
--    salary+salary*nvl(COMMISSION_PCT,0) "실수령액"
--from
--    EMPLOYEES;

--select
--    first_name,
--    last_name,
--    salary,
--    nvl2(department_id, TO_CHAR(department_id), '부서 없음')
--from
--    employees;
    
-- 직원들은 몇 개의 부서로 나눠져 있는가?
--select distinct
--    department_id
--from
--    employees;

--select 
--    count(distinct department_id)
--from
--    employees;
    
--select distinct
--    department_id
--from
--    employees
--where department_id is not null;

-- count 할때 *로 하면 null 포함해서 세고, 칼럼명으로 하면 null 제외함

--select 
--    count(department_id)
--from
--    employees;
--
--select 
--    count (*)
--from
--    employees;

-- 2007/01/01 이후 입사자 조회
--select
--    *
--from
--    employees
--where
--    hire_date>='07/01/01';
    
--select
--    first_name,
--    to_char(hire_date, 'dd/mm/yyyy') "입사년월"
--from
--    employees
--where
--    hire_date>='07/01/01';

-- 연산자 우선순위 not > and > or
--select
--    *
--from
--    employees
--where
--    department_id>50
--and
--    salary>=7000
--or
--    not job_id='AD_VP';



-- 날짜, 수치 연산
select distinct sysdate, 10+30
from employees;

select sysdate
from employees;

-- dual: sys계정, synonym(동의어) 공개동의어
desc dual;
select * from dual;

select sysdate
from dual;

select 3.9, floor(3.9), ceil(3.8), round(3.5), round(3.1416592, 2) "2자리까지",
    trunc(1.4214,3) "3자리까지", trunc(24112.423,-2) "-2까지"
from dual;

select first_name, salary, trunc(salary,-3) "100의 자리 버림",
    round(salary,-3) "100의 자리 반올림"
from employees;

select 10/3, trunc(10/3)몫, mod(10,3) 나머지
from dual;

-- UTF-8로 설정 -> 한글 1글자=3바이트
select length('hello'), LENGTHB('hello'), length('안녕하세요'), lengthb('안녕하세요')
from dual;


SELECT name, value$
FROM sys.props$
WHERE name IN ('NLS_CHARACTERSET', 'NLS_NCHAR_CHARACTERSET');


SELECT name, value$
FROM sys.props$
WHERE name IN ('NLS_LANGUAGE', 'NLS_TERRITORY');
SELECT instance_name FROM v$instance;


update employees
set first_name='Steven'
where employee_id=100;
commit;