CREATE OR REPLACE FUNCTION f_prueba(valor number)
RETURN number
IS
BEGIN
    RETURN valor * 2;
END;
/

SELECT f_prueba(2) AS total FROM dual;


/*para saber si el salario es bajo, medio o alto*/
CREATE OR REPLACE FUNCTION f_categorizarsalario(v_salario number)
RETURN VARCHAR2
IS
v_categoria VARCHAR2(10);
v_maxsalary employees.salary%type;
BEGIN
    v_categoria := 'sin categoria';

    SELECT 
        MAX(SALARY)
        INTO v_maxsalary
    FROM EMPLOYEES;

    IF v_salario <= v_maxsalary / 3 THEN 
        v_categoria := 'bajo';
    ELSIF v_salario <= 2 * v_maxsalary / 3 THEN 
        v_categoria := 'medio';
    ELSE 
        v_categoria := 'alto';
    END IF;

    RETURN v_categoria;
END;
/



CREATE OR REPLACE FUNCTION f_aniostrabajo(hire_date DATE)
RETURN NUMBER
IS
v_anios NUMBER := 0;
BEGIN
    v_anios := (SYSDATE - hire_date) / 365;
    v_anios := ROUND(v_anios);
    RETURN v_anios;
END;
/

select
    first_name,
    hire_date,
    f_aniostrabajo(hire_date)
from employees;


/*
agregar campo tiempo_ingreso
procedimiento almacenado para insertar empleados
luego un trigger que agregue la fecha por defecto
*/

ALTER TABLE employees ADD tiempo_ingreso NUMBER;

CREATE OR REPLACE PROCEDURE p_ingresarempleados(
    v_lastname IN employees.last_name%type,
    v_email IN employees.email%type,
    v_hiredate IN employees.hire_date%type,
    v_jobid IN employees.job_id%type
    )
IS
BEGIN
    INSERT INTO employees(
        employee_id,
        last_name,
        email,
        hire_date,
        job_id
    )VALUES(
        EMPLOYEES_SEQ.nextval,
        v_lastname,
        v_email,
        v_hiredate,
        v_jobid
    );
    COMMIT;
END p_ingresarempleados;
/

call p_ingresarempleados('cañon', 'cañon@gmail.com', '02-05-2020', 'SH_CLERK');

select
    employee_id,
    last_name,
    job_id,
    tiempo_ingreso
from employees;


CREATE OR REPLACE TRIGGER tgr_tiempoempleo
    BEFORE INSERT ON employees
    FOR EACH ROW
DECLARE 
    
BEGIN
    SELECT f_aniostrabajo(:NEW.hire_date) INTO :NEW.tiempo_ingreso from dual;
END;
/


