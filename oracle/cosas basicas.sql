/*para ver mejor las consultas en la consola*/
SET LINESIZE 500;
SET PAGESIZE 1000;
SET WRAP OFF;

/*limpiar terminal*/
clear screen;

/*
=========================================================
VALIDAR QUE ESTA CON EL USUARIO/SCHEMA QUE CREO LAS TABLAS
=========================================================
para saber el usuario actual*/
SHOW USER;

/*para iniciar sesion en oracle con un usuario*/
sqlplus usuario/contraseña

/*estando dentro se puede hacer */
connect usuario/contraseña;


/*Listar las tablas*/
SELECT * FROM tab;

/*
equivalente a hacer /dt en postgres
*/
SELECT table_name FROM user_tables;

/*describir tabla*/
DESC nombre_de_tu_tabla;


/*para ver las llaves foraneas y otros constraints*/
SELECT 
    padre.table_name AS tabla_padre,
    hija.constraint_name AS nombre_relacion,
    hija.table_name AS tabla_hija
FROM 
    user_constraints hija
JOIN 
    user_constraints padre ON hija.r_constraint_name = padre.constraint_name
WHERE 
    hija.constraint_type = 'R';