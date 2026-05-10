/*procedimientos almacenados*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE saludo
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola a todos');
END saludo;
/

EXECUTE saludo;
/*
================================================================================
*/
/*EJMPLO*/

CREATE OR REPLACE PROCEDURE aumentar_salario(porcentaje IN FLOAT)
IS
BEGIN
    UPDATE employees SET salary = salary + (salary  * (porcentaje) / 100.0);
END aumentar_salario;
/

EXECUTE aumentar_salario(10);

/*PARA LISTAR LOS PROCEDIMIENTOS ALMACENADOS*/
SELECT 
    object_name,
    object_type
FROM user_objects
WHERE object_type = 'PROCEDURE';



/*
procedimiento anonimo
actualizar 20 primeros empleados
salario sumar el promedio de todos los salarios
*/

DECLARE
    cursor empleados IS
    SELECT EMPLOYEE_ID, SALARY FROM EMPLOYEES
    WHERE ROWNUM <= 20;
    ccl empleados%ROWTYPE;

    v_salariopromedio EMPLOYEES.SALARY%TYPE;
BEGIN

    SELECT 
        AVG(EMPLOYEES.SALARY)
        INTO v_salariopromedio
    FROM EMPLOYEES;

    for ccl in empleados
    loop
    exit when empleados%notfound;
    UPDATE EMPLOYEES 
    SET SALARY=SALARY + v_salariopromedio
    WHERE employee_id = ccl.EMPLOYEE_ID;
    end loop;
END;
