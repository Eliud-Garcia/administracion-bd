
/*
en caso de problemas con el listener validar el host
C:\app\jhonn\product\21c\homes\OraDB21Home1\network\admin
*/

/*para listar las tablas*/
SELECT table_name
FROM all_tables;

/*objetos de oracle*/
SELECT *
FROM TAB;

/*para conectarse con un usuario*/
CONNECT usuario;

/*pasar archivo para ejecutar script*/
@'C:\Users\jhonn\OneDrive - Universidad de la Amazonia\UNIVERSIDAD\9NO SEMESTRE\ADMINISTRACION DE BASES DE DATOS\hr.sql'

/*LISTAR TABLESPACES POR DEFECTO DE ORACLE*/
SELECT * FROM DBA_TABLESPACES;

/*LISTAR DATAFILES POR DEFECTO DE ORACLE*/
SELECT * FROM DBA_DATA_FILES;


/*CREAR UN TABLESPACE PERSONALIZADO CON SU DATAFILE*/

/*
RUTA POR DEFECTO DE ORACLE
C:\app\jhonn\product\21c\oradata\XE
*/
CREATE TABLESPACE TBS_VENTAS
DATAFILE 'C:\oracle_data\df_ventas_01.dbf'
SIZE 3M;

/*CON VARIOS DATAFILES*/
CREATE TABLESPACE TBS_REPORTE
DATAFILE 
'C:\oracle_data\df_reporte_01.dbf' SIZE 10M,
'C:\oracle_data\df_reporte_02.dbf' SIZE 10M;

/*PARA BORRAR UN TABLESPACE CON SUS DATAFILES*/
DROP TABLESPACE TBS_VENTAS INCLUDING CONTENTS AND DATAFILES;

/*
SCHEMAS

en Oracle, cuando se crea un usuario, 
automáticamente se crea un esquema con 
ese mismo nombre para almacenar sus 
objetos (tablas, vistas, procedimientos, etc.).
*/

CREATE USER USER_REPORTE
IDENTIFIED BY 123
DEFAULT TABLESPACE TBS_REPORTE
QUOTA UNLIMITED ON TBS_REPORTE;

-- dar permisos
GRANT CONNECT, RESOURCE TO USER_REPORTE;

