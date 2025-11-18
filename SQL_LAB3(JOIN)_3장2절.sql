--========================================
--		JOIN
--========================================

1.직원들의 이름과 직급명(job_title)을 조회하시오.

select
    employees.first_name,
    jobs.job_title
from
    employees,
    jobs
where
    employees.job_id=jobs.job_id;


2.부서이름과 부서가 속한 도시명(city)을 조회하시오.

select
    department_name,
    city
from
    departments,
    locations
where
    departments.location_id=locations.location_id;


3. 직원의 이름과 근무국가명을 조회하시오. (employees, departments, locations,countries)
 
select
    first_name,
    nvl(country_name, 'No country') country_name
from
    employees,
    departments, 
    locations,
    countries
where
    employees.department_id = departments.department_id
    and
    departments.location_id = locations.location_id
    and
    locations.country_id = countries.country_id;

4. 직책(job_title)이 'manager' 인 사람의 이름, 직책, 부서명을 조회하시오.

select
    first_name,
    job_title,
    department_name
from
    employees,
    jobs,
    departments
where
    employees.job_id = jobs.job_id
    and
    employees.department_id = departments.department_id
    and
    jobs.job_title like '%Manager';

5. 직원들의 이름, 입사일, 부서명을 조회하시오.
 
select
    first_name,
    hire_date,
    department_name
from
    employees,
    departments
where
    employees.department_id = departments.department_id;


6. 직원들의 이름, 입사일, 부서명을 조회하시오.
단, 부서가 없는 직원이 있다면 그 직원정보도 출력결과에 포함시킨다.

select
    first_name,
    hire_date,
    nvl(department_name,'No Department')
from
    employees,
    departments
where
    employees.department_id = departments.department_id(+)
order by
    department_name asc nulls first;


7. 직원의 이름과 직책(job_title)을 출력하시오.
단, 사용되지 않는 직책이 있다면 그 직책정보도 출력결과에 포함시키시오.

select
    first_name,
    job_title
from
    jobs right outer join employees using (job_id);


