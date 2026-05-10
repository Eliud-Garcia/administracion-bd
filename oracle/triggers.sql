
CREATE TABLE employee_audit(
    EMPLOYEE_ID NUMBER(6) NOT NULL,
    FIRST_NAME VARCHAR2(20),
    LAST_NAME VARCHAR2(20) NOT NULL,
    EMAIL VARCHAR2(25) NOT NULL,
    PHONE_NUMBER VARCHAR2(20),
    HIRE_DATE DATE NOT NULL,
    JOB_ID VARCHAR2(10) NOT NULL,
    SALARY NUMBER(8,2),
    COMMISSION_PCT NUMBER(2,2),
    MANAGER_ID NUMBER(6),
    DEPARTMENT_ID NUMBER(4),
    AUDIT_DATE DATE NOT NULL,
    USER_ VARCHAR2(100) NOT NULL,
    OPERATION VARCHAR2(1) NOT NULL
);


CREATE OR REPLACE TRIGGER tgr_ingresoempleados
    BEFORE  INSERT ON employees
    FOR EACH ROW
BEGIN
    IF :NEW.first_name != NULL THEN
        :NEW.first_name := UPPER(:NEW.first_name);
    END IF;

    IF :NEW.salary < 1000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El salario no puede ser menor a 1000');
    END IF;
END tgr_ingresoempleados;
/

/*uso*/
INSERT INTO EMPLOYEES(
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    PHONE_NUMBER,
    HIRE_DATE,
    JOB_ID,
    SALARY,
    COMMISSION_PCT,
    MANAGER_ID,
    DEPARTMENT_ID
)VALUES(
    207,
    'asd',
    'asd',
    'asd@gmail.com',
    '857182381',
    TO_DATE('26-04-2026', 'dd-MM-yyyy'),
    'AC_ACCOUNT',
    1100,
    0.02,
    205,
    110
);

/*PARA VER LOS TRIGGERS CREADOS*/
SELECT trigger_name, trigger_type, triggering_event
FROM user_triggers;


/*consultar codigo del trigger*/
select text from user_source where name = 'TGR_COMISIONEMPLEADOS' AND TYPE='TRIGGER' ORDER BY line;


/*crear columna en employees llamada salario*/

/*trigger en oracle
cada vez que actualice el salario o el cargo
*/

ALTER TABLE EMPLOYEES 
ADD salario_comision NUMBER(8,2);

/*trigger*/
CREATE OR REPLACE TRIGGER tgr_comisionempleados
    BEFORE UPDATE ON employees
    FOR EACH ROW
DECLARE 
    v_minsalary jobs.min_salary%TYPE;
    v_maxsalary jobs.max_salary%TYPE;
    v_jobname jobs.JOB_TITLE%TYPE;
BEGIN
    SELECT j.min_salary, j.max_salary, j.job_title
    INTO v_minsalary, v_maxsalary, v_jobname
    FROM jobs j
    WHERE job_id = :NEW.job_id;

    IF v_jobname = 'Sales Manager' THEN
        IF :NEW.COMMISSION_PCT IS NULL THEN
            :NEW.COMMISSION_PCT := 0.0;
        END IF;

        IF :NEW.SALARY > (v_maxsalary + v_minsalary) / 2 THEN
            :NEW.COMMISSION_PCT := :NEW.COMMISSION_PCT + 0.1;
        ELSE 
            :NEW.COMMISSION_PCT := :NEW.COMMISSION_PCT + 0.25;
        END IF;

        :NEW.salario_comision := :NEW.salary + (:NEW.salary * :NEW.COMMISSION_PCT);
    END IF;
END;
/

/*para validar errores en la creacion de triggers*/
SELECT line, position, text
FROM user_errors
WHERE name = 'TGR_COMISIONEMPLEADOS'
ORDER BY line;


SELECT
    e.EMPLOYEE_ID,
    e.FIRST_NAME,
    e.SALARY,
    e.COMMISSION_PCT,
    j.min_salary,
    j.max_salary,
    e.salario_comision
FROM EMPLOYEES e
INNER JOIN JOBS j
ON e.JOB_ID = j.JOB_ID
WHERE j.JOB_TITLE = 'Sales Manager';


UPDATE employees
SET salary = 8000
WHERE employee_id = 149;


/*trigger de auditoria para departments 
cada vez que se registre un nuevo departamento

si es una actualizacion solo traer el dato que cambio
*/


CREATE TABLE departments_audit(
    DEPARTMENT_ID NUMBER(4),
    DEPARTMENT_NAME VARCHAR2(30),
    MANAGER_ID NUMBER(6),
    LOCATION_ID NUMBER(4),
    USUARIO VARCHAR2(100),
    OPERATION VARCHAR2(1),
    FECHA TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valores VARCHAR2(500)
);


CREATE OR REPLACE TRIGGER tgr_departments
    AFTER INSERT OR UPDATE ON departments
    FOR EACH ROW
DECLARE 
    v_cambios VARCHAR2(500) := '';
    v_operation VARCHAR2(1) := '';
BEGIN

    IF INSERTING THEN
        v_operation := 'I';
    ELSIF UPDATING THEN
        v_operation := 'U';
        IF :OLD.DEPARTMENT_NAME != :NEW.DEPARTMENT_NAME THEN
            v_cambios := v_cambios || :NEW.DEPARTMENT_NAME;
            v_cambios := v_cambios || ', ';
        END IF;

        IF :OLD.MANAGER_ID != :NEW.MANAGER_ID THEN
            v_cambios := v_cambios || :NEW.MANAGER_ID;
            v_cambios := v_cambios || ', ';
        END IF;

        IF :OLD.LOCATION_ID != :NEW.LOCATION_ID THEN
            v_cambios := v_cambios || :NEW.LOCATION_ID;
            v_cambios := v_cambios || ', ';
        END IF;
    END IF;


    INSERT INTO departments_audit(
        DEPARTMENT_ID,
        DEPARTMENT_NAME,
        MANAGER_ID,
        LOCATION_ID,
        USUARIO,
        OPERATION,
        valores
    )VALUES(
        :NEW.DEPARTMENT_ID,
        :NEW.DEPARTMENT_NAME,
        :NEW.MANAGER_ID,
        :NEW.LOCATION_ID,
        USER,
        v_operation,
        v_cambios
    );
END;
/

/*uso*/

INSERT INTO departments(
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    LOCATION_ID
)VALUES(
    280,
    'servicio personalizado',
    2500
);

UPDATE departments
SET 
    DEPARTMENT_NAME = 'service x',
    LOCATION_ID = 1700
WHERE DEPARTMENT_ID = 280;


SELECT * 
FROM departments_audit;