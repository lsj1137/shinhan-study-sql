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