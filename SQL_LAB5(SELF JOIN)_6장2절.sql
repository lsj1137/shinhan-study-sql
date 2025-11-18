-- SELF JOIN
1. 직원의 이름과 관리자 이름을 조회하시오.

select
    e1.first_name 직원, e2.first_name 관리자
from
    employees e1, employees e2
where
    e1.manager_id = e2.employee_id
 order by e1.manager_id;

2. 직원의 이름과 관리자 이름을 조회하시오.
관리자가 없는 직원정보도 모두 출력하시오.

select
    e1.first_name 직원, e2.first_name 관리자
from
    employees e1
    right outer join employees e2 on(e1.manager_id=e2.employee_id)
order by e1.manager_id asc;


3. 관리자 이름과 관리자가 관리하는 직원의 수를 조회하시오.
단, 관리직원수가 3명 이상인 관리자만 출력되도록 하시오.
 
select
    e2.first_name
--    count(e1.employee_id) 
from
    employees e1 join employees e2 using (manager_id);

    