--==========================================
--	Inline View 와 Top-N SubQuery
--==========================================

--1. 급여를 가장 많이 받는 상위 5명의 직원 정보를 조회하시오.

select *
from 
    (select *
    from employees
    order by salary desc)
where
    rownum<=5;

select *
from
    (select rownum rn, aa.*
    from 
        (select *
        from employees
        order by salary desc) aa)
where rn between 5 and 10;




2. 커미션을 가장 많이 받는 상위 3명의 직원 정보를 조회하시오.

select *
from (
    select *
    from employees
    order by commission_pct desc nulls last
)
where rownum<=3;






3. 월별 입사자 수를 조회하되, 입사자 수가 5명 이상인 월만 출력하시오.

select to_char(hire_date, 'mm') 월, count(*) "입사자 수"
from employees
group by to_char(hire_date, 'mm')
having count(*)>=5
order by to_char(hire_date,'mm') asc;



4. 년도별 입사자 수를 조회하시오. 
단, 입사자수가 많은 년도부터 출력되도록 합니다.

select to_char(hire_date, 'yyyy'), count(*)
from employees
group by to_char(hire_date, 'yyyy')
order by count(*) desc;



