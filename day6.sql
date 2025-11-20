-- view : 가상 테이블
-- 재사용, 복잡한 sql 저장, 보안을 목적으로 함
CREATE TABLE emp_copy
    AS
        SELECT
            *
        FROM
            employees
        WHERE
            department_id = 60;

SELECT
    *
FROM
    employees
WHERE
    department_id = 60;

SELECT
    *
FROM
    emp_copy;

CREATE OR REPLACE VIEW emp_view1 AS
    SELECT
        *
    FROM
        employees
    WHERE
        department_id = 60;

SELECT
    *
FROM
    emp_view1;

CREATE VIEW emp_view1 -- 같은 이름은 replace 없으면 에러

 AS
    SELECT
        *
    FROM
        employees
    WHERE
        department_id = 60;

SELECT
    *
FROM
    emp_view1;

CREATE OR REPLACE NOFORCE VIEW emp_view1 -- force로 강제생성도 가능

 AS
    SELECT
        *
    FROM
        emp_copy2; -- 컴파일 오류 발생하지만 생성되긴 함

SELECT
    *
FROM
    tab;

SELECT
    *
FROM
    emp;

CREATE OR REPLACE VIEW emp_view1 AS
    SELECT
        empno,
        empname,
        gender
    FROM
        emp;

SELECT
    *
FROM
    emp_view1;

SELECT
    *
FROM
    user_views;

-- scott은 view 생성 권한이 없었음 -> sysdba로 conn해서 권한 부여 grant create table to scott

-- 직원이 근무하는 도시와 나라이름을 조회
CREATE OR REPLACE VIEW emp_country_view AS
    SELECT
        employee_id,
        first_name,
        last_name,
        department_name,
        country_name
    FROM
             employees
        JOIN departments USING ( department_id )
        JOIN locations USING ( location_id )
        JOIN countries USING ( country_id );

SELECT
    *
FROM
    emp_country_view;

SELECT
    emp_country_view.*,
    employees.salary
FROM
         emp_country_view
    JOIN employees ON ( emp_country_view.employee_id = employees.employee_id );

-- 1개의 테이블로 뷰생성시 DML 가능
SELECT
    emp_country_view.*,
    employees.salary
FROM
         emp_country_view
    JOIN employees ON ( emp_country_view.employee_id = employees.employee_id );

SELECT
    *
FROM
    emp_view2;

UPDATE emp_view2
SET
    first_name = 'Chris'
WHERE
    employee_id = 3;

SELECT
    *
FROM
    emp_copy;

CREATE OR REPLACE VIEW emp_view2 AS
    SELECT
        *
    FROM
        emp_copy
WITH READ ONLY;

CREATE TABLE emp_copy2
    AS
        SELECT
            *
        FROM
            employees
        WHERE
            salary > 10000;

SELECT
    *
FROM
    emp_copy2;

CREATE OR REPLACE NOFORCE VIEW emp_view4 AS
    SELECT
        *
    FROM
        emp_copy2
    WHERE
        department_id = 90;

SELECT
    *
FROM
    emp_view4;

UPDATE emp_view4
SET
    department_id = 60
WHERE
    employee_id = 100;

CREATE OR REPLACE NOFORCE VIEW emp_view5 AS
    SELECT
        *
    FROM
        emp_copy2
    WHERE
        department_id = 90
WITH CHECK OPTION;

SELECT
    *
FROM
    emp_view5;

UPDATE emp_view5
SET
    department_id = 60
WHERE
    employee_id = 101;

SELECT
    *
FROM
    emp_view5;

-- sequence (OracleDB에서 자동 번호 발생기) <-> auto increment (MySQL 방식)
-- 의미가 없고 겹치면 안되는 경우 사용
CREATE SEQUENCE seq_bno;

SELECT
    *
FROM
    user_sequences;

CREATE TABLE tbl_board (
    bno       NUMBER PRIMARY KEY,
    title     VARCHAR2(50),
    contents  VARCHAR2(2000),
    writer    VARCHAR2(20),
    reg_date  DATE
);

INSERT INTO tbl_board VALUES (
    seq_bno.NEXTVAL,
    '월요일 좋아',
    'ㅈㄱㄴ',
    '스폰지밥',
    sysdate
);

SELECT
    *
FROM
    tbl_board;

SELECT
    seq_bno.NEXTVAL
FROM
    dual;

-- DB의 Object: table, view, sequence, index, synonym
-- index : 조회를 빠르게 하기 위함. 특정 컬럼에 생성
-- pk, uk 는 자동 생성됨.

-- 자동으로 생성된 인덱스 이름은 제약조건 이름을 사용함
SELECT
    *
FROM
    user_ind_columns
WHERE
    table_name = 'TBL_BOARD';

SELECT
    *
FROM
    user_constraints
WHERE
    table_name = 'TBL_BOARD';

SELECT
    *
FROM
    TABLE ( dbms_xplan.display_cursor(sql_id => '5824mg3881d54', format => 'ALLSTATS LAST') );


-- index 속도 비교
SELECT
    *
FROM
    employees
WHERE
--    first_name='Steven'
--    and
--    last_name like '%';

--    employee_id=100;

                upper(job_id) = 'IT_PROG';
    
-- index 만들기
-- employee 테이블 복사해서 많은 양의 데이터 insert, 특정건수 1건 조회
-- 제약 조건은 복사 안됨 (not null 만 복사됨)
CREATE TABLE emp_index_test
    AS
        SELECT
            *
        FROM
            employees;

SELECT
    COUNT(*)
FROM
    emp_index_test;

INSERT INTO emp_index_test
    SELECT
        *
    FROM
        emp_index_test;

SELECT
    *
FROM
    emp_index_test
WHERE
    employee_id = 100;

DESC emp_index_test;

INSERT INTO emp_index_test (
    last_name,
    email,
    hire_date,
    job_id
) VALUES (
    'sejun',
    'lsj1137@naver.com',
    '2025-11-19',
    'IT_PROG'
);

-- index 없는 경우 cost 69, 실행시간 0.016 풀스캔
SELECT
    *
FROM
    emp_index_test
WHERE
    last_name = 'sejun';

CREATE INDEX last_name_idx ON
    emp_index_test (
        last_name
    );

-- index 있는 경우 cost 47, 실행시간 0.014


sql> conn as sysda ..... sys/1234
SQL> create user user02 identified by 1234; -- 유저 생성
SQL> grant create session to user02; -- 접속 가능해짐
SQL> grant create table to user02; -- 테이블 만들수있어짐
SQL> conn hr/hr
SQL> grant select on employees to user02; -- hr 의 employees 테이블 select 권한 부여받음
SQL> conn user02/1234 -- 접속
SQL> select * from hr.employees; -- hr.employees 테이블 조회

SQL> conn as sysda ..... sys/1234
SQL> grant create synonym to user02;
SQL> conn user02/1234
SQL> create synonym hr_emp for hr.employees;
SQL> select * from hr_emp;


set serveroutput on;
declare
    -- 스칼라 타입
    emp_id number;
    emp_name varchar2(20);
    -- 참조 타입
    emp_salary employees.salary%type;
    emp_job_id employees.job_id%type;
begin
    emp_id := 100;
    emp_name := '수티붕';
    emp_salary := 20000;
    emp_job_id := 'IT_PROG';
    DBMS_OUTPUT.PUT_LINE('1. id= '||emp_id);
    DBMS_OUTPUT.PUT_LINE('2. name= '||emp_name);
    DBMS_OUTPUT.PUT_LINE('3. salary= '||emp_salary);
    DBMS_OUTPUT.PUT_LINE('4. job_id= '|| emp_job_id);
end;
/

declare
    v_fn employees.first_name%type;
    v_s employees.salary%type;
    v_emp_record employees%rowtype;
begin
    select first_name, salary into v_fn, v_s
    from employees
    where employee_id = '100';
    dbms_output.put_line('이름: '||v_fn);
    DBMS_OUTPUT.PUT_LINE('급여: '||v_s);
    select * into v_emp_record
    from employees
    where employee_id='100';
    dbms_output.put_line('record 이름: '||v_emp_record.first_name);
end;
/ DECLARE
    TYPE mytype_fname IS
        TABLE OF employees.first_name%TYPE INDEX BY BINARY_INTEGER;
    i          BINARY_INTEGER := 0;
    fname_arr
    mytype_fname;

BEGIN
    FOR emp1 IN (
        SELECT
            first_name
        FROM
            employees
    ) LOOP
        i := i + 1;
        fname_arr(i) := emp1.first_name;
    END LOOP;

    FOR j IN 1..i LOOP
        dbms_output.put_line('이름은 ' || fname_arr(j));
    END LOOP;

END;
/


DECLARE
    v_score number := 99;
    v_grade char(1);

BEGIN
    IF ( v_score >= 90 ) THEN
        v_grade := 'A';
    ELSIF ( v_score >= 80 ) THEN
        v_grade := 'B';
    ELSE
        v_grade := 'F';
    END IF;

    dbms_output.put_line('성적: ' || v_grade);
END;
/

DECLARE
    num NUMBER := 1;
BEGIN
    LOOP
        dbms_output.put_line('num= ' || num);
        num := num + 1;
        IF ( num > 5 ) THEN
            EXIT;
        END IF;
    END LOOP;
END;
/

DECLARE
    num NUMBER := 1;
BEGIN
    while (num<5) loop
        dbms_output.put_line('num= ' || num);
        num := num + 1;
    end loop;
END;
/

create or replace procedure sp_1 (v_empid in number)
is
    v_emp_record employees%rowtype;
begin
    select * into v_emp_record
    from employees
    where employee_id=v_empid;
    dbms_output.put('이름: '||v_emp_record.first_name|| ' ');
    dbms_output.put(v_emp_record.last_name|| ' / ');
    dbms_output.put('급여: '||v_emp_record.salary|| ' / ');
    dbms_output.put_line('직무: '||v_emp_record.job_id);
end;
/
execute sp_1(100);
execute sp_1(101);
execute sp_1(102);

desc user_source;
select * from user_source;


create or replace procedure sp_2 (v_empid in number, v_job_id out employees.job_id%type, v_salary in out employees.salary%type)
is
    v_emp_record employees%rowtype;
begin
    select * into v_emp_record
    from employees
    where employee_id=v_empid;
    v_job_id := v_emp_record.job_id;
    v_salary := v_salary + v_emp_record.salary;
    dbms_output.put('이름: '||v_emp_record.first_name|| ' ');
    dbms_output.put(v_emp_record.last_name|| ' / ');
    dbms_output.put('급여: '||v_salary|| ' / ');
    dbms_output.put_line('직무: '||v_job_id);
end;
/

variable job varchar2(20);
variable salary number;
exec :salary := 123;
execute sp_2(100, :job, :salary);
execute sp_2(101, :job, :salary);
execute sp_2(102, :job, :salary);
execute sp_2(103, :job, :salary);

-- 커서: 여러건을 select 하기 위해 사용
-- 1. 커서 선언
-- 2. 열기
-- 3. 사용 (fetch)
-- 4. 닫기 
create or replace procedure sp_cursor1
is
    cursor c1 is select department_id, department_name from departments;
    v_deptid departments.department_id%type;
    v_deptname departments.department_name%type;
begin
    open c1;
    loop
        fetch c1 into v_deptid, v_deptname;
        exit when c1%notfound;
        dbms_output.put_line(v_deptid||'----' || v_deptname);
    end loop;
    close c1;
end;
/

execute sp_cursor1;

create or replace procedure sp_cursor2
is
    v_deptid departments.department_id%TYPE;
    v_deptname
    departments.department_name%TYPE;

BEGIN
    FOR dept_record IN (
        SELECT
            department_id,
            department_name
        FROM
            departments
    ) LOOP
        dbms_output.put_line(dept_record.department_id
                             || '----'
                             || dept_record.department_name);
    END LOOP;
END;
/

EXECUTE sp_cursor2;


-- sp_1
-- sp_2
CREATE OR REPLACE PACKAGE exam_pkg IS
    PROCEDURE sp_1 (
        v_empid IN NUMBER
    );

    PROCEDURE sp_2 (
        v_empid   IN      NUMBER,
        v_job_id  OUT     employees.job_id%TYPE,
        v_salary  IN OUT  employees.salary%TYPE
    );

END;
/
-- 패키지 몸체
CREATE OR REPLACE PACKAGE BODY exam_pkg IS
    --sp_1
        PROCEDURE sp_1 (
        v_empid IN NUMBER
    ) IS
        v_emp_record employees%rowtype;
    BEGIN
        SELECT
            *
        INTO v_emp_record
        FROM
            employees
        WHERE
            employee_id = v_empid;

        dbms_output.put('이름: '
                        || v_emp_record.first_name
                        || ' ');
        dbms_output.put(v_emp_record.last_name || ' / ');
        dbms_output.put('급여: '
                        || v_emp_record.salary
                        || ' / ');
        dbms_output.put_line('직무: ' || v_emp_record.job_id);
    END;
    --sp_2
        PROCEDURE sp_2 (
        v_empid   IN      NUMBER,
        v_job_id  OUT     employees.job_id%TYPE,
        v_salary  IN OUT  employees.salary%TYPE
    ) IS
        v_emp_record employees%rowtype;
    BEGIN
        SELECT
            *
        INTO v_emp_record
        FROM
            employees
        WHERE
            employee_id = v_empid;

        v_job_id := v_emp_record.job_id;
        v_salary := v_salary + v_emp_record.salary;
        dbms_output.put('이름: '
                        || v_emp_record.first_name
                        || ' ');
        dbms_output.put(v_emp_record.last_name || ' / ');
        dbms_output.put('급여: '
                        || v_salary
                        || ' / ');
        dbms_output.put_line('직무: ' || v_job_id);
    END;

END;
/

EXECUTE exam_pkg.sp_1(100);
Execute exam_pkg.sp_2(100, :job, :salary);

create or replace trigger mytrigger1
after insert on departments
begin
    DBMS_OUTPUT.PUT_LINE('새 부서 생성됨!');
END;
/
insert into departments values(4, 'trigger연습', null,null);
select * from departments;


-- dept에 insert 하면 트리거 테이블에도 insert 하기
create table dept_trigger
(deptno number, deptname varchar(20), contents varchar2(100));

create or replace trigger mytrigger2
after insert on departments
for each row 
begin
    insert into dept_trigger values (:new.department_id, :new.department_name, '신규부서입력');
end;
/

insert into departments values(5, 'trigger연습2', null,null);
select * from dept_trigger;

CREATE TABLE 상품(
상품코드 CHAR(6) PRIMARY KEY,
상품명 VARCHAR2(12) NOT NULL,
제조사 VARCHAR(12),
소비자가격 NUMBER(8),
재고수량 NUMBER DEFAULT 0
);
CREATE TABLE 입고(
입고번호 NUMBER(6) PRIMARY KEY,
상품코드 CHAR(6) REFERENCES 상품(상품코드),
입고일자 DATE DEFAULT SYSDATE,
입고수량 NUMBER(6),
입고단가 NUMBER(8),
입고금액 NUMBER(8)
);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격)
VALUES('A00001','세탁기', 'LG', 500);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격)
VALUES('A00002','컴퓨터', 'LG', 700);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격)
VALUES('A00003','냉장고', '삼성', 600);

select * from 상품;

create or replace trigger trigger_재고
after insert on 입고
for each row
begin
    update 상품
    set 재고수량 = 재고수량 + :NEW.입고수량
    where 상품코드 = :New.상품코드;
end;
/
create or replace trigger trigger_재고_수정
after update on 입고
for each row
begin
    update 상품
    set 재고수량 = 재고수량 + (- :OLD.입고수량 + :NEW.입고수량)
    where 상품코드 = :New.상품코드;
end;
/
create or replace trigger trigger_재고_삭제
after delete on 입고
for each row
begin
    update 상품
    set 재고수량 = 재고수량 - :OLD.입고수량
    where 상품코드 = :OLD.상품코드;
end;
/


insert into 입고 values(1, 'A00002', sysdate, 20, 100, 2000);
insert into 입고 values(2, 'A00002', sysdate, 5, 100, 2000);
select * from 상품;

update 입고 set 입고수량=4 where 입고번호 = 1;
delete from 입고 where 입고번호=1;