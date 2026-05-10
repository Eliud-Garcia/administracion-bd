/*todos los los empleados que no 
esten en el historial de empleos
y crear una vista
*/

CREATE OR REPLACE VIEW employees_not_historyjob
AS
SELECT 
    EMP.EMPLOYEE_ID,
    EMP.FIRST_NAME
FROM EMPLOYEES EMP
INNER JOIN (
    SELECT DISTINCT
        E.EMPLOYEE_ID
    FROM EMPLOYEES E
    MINUS
    SELECT
        J.EMPLOYEE_ID
    FROM JOB_HISTORY J
) DIFF
ON EMP.EMPLOYEE_ID = DIFF.EMPLOYEE_ID;


select * from employees_not_historyjob;