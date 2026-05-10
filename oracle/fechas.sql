/*fechas en oracle*/

/*Fecha y hora actual del servidor*/
SELECT SYSDATE FROM dual;
/*Timestamp actual con zona horaria*/
SELECT SYSTIMESTAMP FROM dual;

/*Fecha actual de la sesión*/
SELECT CURRENT_DATE FROM dual;

/*Timestamp actual de la sesión*/
SELECT CURRENT_TIMESTAMP FROM dual;


/*
==========================================
    para trabajar con las fechas
==========================================
*/

/*ADD_MONTHS(fecha, n)*/
ADD_MONTHS(SYSDATE, 3)

SELECT
EMPLOYEE_ID,
FIRST_NAME,
LAST_NAME,
HIRE_DATE,
ADD_MONTHS(HIRE_DATE, 3) AS siguienteAumento
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 117;

/*MONTHS_BETWEEN(r, l)*/

SELECT
EMPLOYEE_ID,
FIRST_NAME,
LAST_NAME,
HIRE_DATE,
MONTHS_BETWEEN(ADD_MONTHS(HIRE_DATE, 3), HIRE_DATE) AS cantidad_meses
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 117;

/*NEXT_DAY(fecha, día)
da la proxima fecha en la que cae el dia
*/

SELECT 
NEXT_DAY(SYSDATE, 'DOMINGO')
FROM DUAL;

/*LAST_DAY(fecha)
Último día del mes
*/
SELECT 
LAST_DAY(SYSDATE)
FROM DUAL;

/*TRUNC(fecha, formato)
para truncar fecha
*/
SELECT
JH.EMPLOYEE_ID,
JH.START_DATE,
JH.END_DATE,
TRUNC(MONTHS_BETWEEN(JH.END_DATE, JH.START_DATE) / 12) AS ANIOS_TRABAJO
FROM JOB_HISTORY JH;


/*EXTRACT(parte FROM fecha)
para extraer una parte de una fecha

TO_CHAR(fecha, formato)
Convierte fecha a texto

YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, TIMEZONE_HOUR, TIMEZONE_MINUTE
*/
SELECT
EMPLOYEE_ID,
FIRST_NAME,
TO_CHAR(HIRE_DATE, 'DAY') AS dia,
EXTRACT(DAY FROM HIRE_DATE) AS n_dia,
TO_CHAR(HIRE_DATE, 'MONTH') AS mes,
EXTRACT(YEAR FROM HIRE_DATE) AS anio
FROM EMPLOYEES;


/*diferencia entre fechas*/
SELECT
    JH.EMPLOYEE_ID,
    JH.START_DATE,
    JH.END_DATE,
    (JH.END_DATE - JH.START_DATE) AS dias
FROM JOB_HISTORY JH;
