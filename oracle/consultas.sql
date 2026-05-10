/*empleado con su departamento en el que trabaja*/


SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    DEPARTMENT_NAME
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY D.DEPARTMENT_ID;

/*nombre de empleado y su jefe*/

SELECT 
    emp.FIRST_NAME AS empleado,
    jef.FIRST_NAME AS jefe
FROM EMPLOYEES emp
LEFT JOIN EMPLOYEES jef
ON emp.MANAGER_ID = jef.EMPLOYEE_ID
ORDER BY emp.MANAGER_ID ASC;

/*
EMPLEADO CON DEPARTAMENTO Y SU JEFE 
y el departamento en el que está el jefe
*/

SELECT 
    e.FIRST_NAME AS empleado,
    de.DEPARTMENT_NAME AS departamento_empleado,
    datos_jefe.FIRST_NAME,
    datos_jefe.DEPARTMENT_NAME
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS de
    ON e.DEPARTMENT_ID = de.DEPARTMENT_ID
LEFT JOIN (
    SELECT 
        m.EMPLOYEE_ID,
        m.FIRST_NAME,
        dm.DEPARTMENT_NAME
    FROM EMPLOYEES m
    INNER JOIN DEPARTMENTS dm
        ON dm.MANAGER_ID = m.EMPLOYEE_ID
) datos_jefe
ON e.MANAGER_ID = datos_jefe.EMPLOYEE_ID;


/*los paises con el mayor numero de localizaciones*/

SELECT 
    COUNTRIES.COUNTRY_NAME AS nombre,
    COUNT(*) AS cnt
FROM COUNTRIES 
INNER JOIN LOCATIONS
    ON LOCATIONS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
GROUP BY COUNTRIES.COUNTRY_NAME
HAVING COUNT(*) = (
    SELECT 
        COUNT(LOCATION_ID) AS cnt
    FROM LOCATIONS
    GROUP BY LOCATIONS.COUNTRY_ID
    ORDER BY cnt DESC
    FETCH FIRST 1 ROWS ONLY
);


SELECT 
    COUNTRIES.COUNTRY_NAME AS nombre,
    COUNT(*) AS cnt
FROM COUNTRIES 
INNER JOIN LOCATIONS
    ON LOCATIONS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
GROUP BY COUNTRIES.COUNTRY_NAME

HAVING COUNT(*) = (
    SELECT MAX(COUNT(LOCATION_ID))
    FROM LOCATIONS
    GROUP BY COUNTRY_ID
);

/*traer empleados los cuales tengan el salario mayor al promedio*/
SELECT
    e.EMPLOYEE_ID,
    e.FIRST_NAME,
    e.SALARY
FROM EMPLOYEES e
WHERE e.SALARY > (
    SELECT 
        AVG(SALARY)
    FROM EMPLOYEES
);

/*traer los empleados con su salario (salario bajo, medio o alto)*/

SELECT 
    e.EMPLOYEE_ID,
    e.FIRST_NAME,
    e.SALARY,
    CASE
        WHEN e.SALARY <= (SELECT MAX(SALARY) / 3 FROM EMPLOYEES) 
            THEN 'bajo'
        WHEN e.SALARY <= (SELECT 2 * MAX(SALARY) / 3 FROM EMPLOYEES)
            THEN 'medio'
        ELSE 'alto'
    END AS nivel
FROM EMPLOYEES e
ORDER BY e.SALARY;

/*los empleados que sean asistentes de administracion, si su salario está mayor al promedio
del minimo y el maximo y si tienen comision se lo van a incrementar en un 10% y al resto (menos del promedio) un 25%
*/

SELECT
    e.FIRST_NAME,
    e.SALARY,
    e.COMMISSION_PCT,
    j.JOB_TITLE,
    j.JOB_ID,
    CASE 
        WHEN e.SALARY > (j.MIN_SALARY + j.MAX_SALARY) / 2 AND COMMISSION_PCT IS NOT NULL
            THEN e.COMMISSION_PCT + 0.1
        WHEN COMMISSION_PCT IS NOT NULL
            THEN e.COMMISSION_PCT
        WHEN COMMISSION_PCT IS NULL
            THEN 0.25
    END AS comision,
    CASE 
        WHEN e.SALARY > (j.MIN_SALARY + j.MAX_SALARY) / 2 AND COMMISSION_PCT IS NOT NULL
            THEN e.salary  + (e.salary * (e.COMMISSION_PCT + 0.1))
        WHEN COMMISSION_PCT IS NOT NULL
            THEN e.SALARY
        WHEN COMMISSION_PCT IS NULL
            THEN e.salary  + (e.salary * (0.25))
    END AS salario_comision
FROM EMPLOYEES e
INNER JOIN JOBS j
ON e.JOB_ID = j.JOB_ID
WHERE j.JOB_TITLE = 'Sales Manager';


/*cual es el empleado que mas cargos a tenido*/
select 
    e.first_name,
    count(*) AS total
from employees e
left join job_history j
    on j.employee_id = e.employee_id
group by e.employee_id, e.first_name
having count(*) = (
    select 
        max(count(job_history.employee_id))
    from job_history
    group by job_history.employee_id
);




select first_name, job_id, COMMISSION_PCT from EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;
select 2 * 3 from dual;


