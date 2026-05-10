/*
################
USANDO POSTGRES
################
*/

/*
=================
ROLES
=================*/

/*crear rol*/
CREATE ROLE nombre_rol WITH 
SUPERUSER
CREATEDB
CREATEROLE
INHERIT
LOGIN
REPLICATION
BYPASSRLS
;

/*eliminar rol*/
DROP ROLE nombre_rol;

/*Consultar los roles existentes usando pg_roles*/
SELECT rolname FROM pg_roles;

/*mostrar roles*/
\du

/*
=================
USUARIOS
=================*/

/*Crear un rol que actuará como "Usuario"*/
CREATE ROLE nombre WITH 
INHERIT
LOGIN PASSWORD 'CONTRASENIA';

/*Si se quiere usar el usuario creado*/
psql -U nombre -d db_name -h localhost -W



/*EJEMPLO*/

/*grupo_consulta es solo para ver tablas*/
CREATE ROLE grupo_consulta;

-- Permiso para entrar a la base de datos
GRANT CONNECT ON DATABASE simulacion TO grupo_consulta;

-- Permiso para usar el esquema
GRANT USAGE ON SCHEMA public TO grupo_consulta;

-- Permiso para leer las tablas actuales
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grupo_consulta;

-- Permiso para leer las tablas futuras
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO grupo_consulta;

--Permiso solo para SELECT en la tabla modulo
GRANT SELECT ON modulo TO grupo_consulta;

--permiso para hacer select en perfil
GRANT SELECT ON perfil TO grupo_consulta;

--puede insertar en la tabla perfil
GRANT INSERT ON perfil to grupo_consulta;


/*se crea al usuario carlitos*/
CREATE ROLE carlitos WITH LOGIN 
PASSWORD 'carlitos'
VALID UNTIL '2026-03-29';

/*
para cambiar de usuario desde la consola de postgres
\c simulacion juan
\c simulacion postgres
*/

/*le doy los permisos de grupo_consulta a carlitos*/
GRANT grupo_consulta TO carlitos;

/*Para quitarle el rol de grupo_consulta a carlitos*/
REVOKE grupo_consulta FROM carlitos;


/*
#############################
EJEMPLO CON ROL ADMINISTRADOR
#############################
*/

CREATE ROLE administrador WITH 
SUPERUSER
CREATEDB
CREATEROLE
INHERIT
LOGIN
REPLICATION
BYPASSRLS
;

CREATE ROLE eliud WITH 
INHERIT
LOGIN PASSWORD 'eliud';


/*eliud va a tener los permisos de un superuser*/
GRANT administrador TO eliud;
ALTER USER eliud SET ROLE administrador;


/*
para ver los permisos especificos de una tabla
*/
\dp nombre_de_la_tabla

/*Ver qué permisos tiene un usuario sobre una tabla específica:*/
SELECT grantee AS usuario, privilege_type AS permiso
FROM information_schema.role_table_grants 
WHERE table_name = 'modulo';

/*Ver todos los roles/usuarios creados en tu base de datos:*/

SELECT rolname AS nombre_rol, rolcanlogin AS puede_iniciar_sesion, rolsuper AS es_superusuario
FROM pg_roles;

/*Ver a qué grupos (roles) pertenece un usuario:*/

SELECT 
    r.rolname AS usuario, 
    r1.rolname AS grupo_al_que_pertenece
FROM pg_catalog.pg_roles r
JOIN pg_catalog.pg_auth_members m ON (m.member = r.oid)
JOIN pg_catalog.pg_roles r1 ON (m.roleid = r1.oid)
WHERE r.rolname = 'carlitos';