/*
################
USANDO POSTGRES
################
*/

/*
para hacer backcup en postgres
pg_dump -h host -U usuario -d db_name ruta > ruta/backupv1.sql
*/
pg_dump -h localhost -U postgres -d elecktraspacedb > 'C:\Users\jhonn\OneDrive - Universidad de la Amazonia\UNIVERSIDAD\9NO SEMESTRE\ADMINISTRACION DE BASES DE DATOS\v1.sql'


/*
digamos que se elimino la base de datos
*/
drop database elecktraspacedb;

create database simulacion;

/*
ahora para importar el backup
*/
psql -h localhost -U postgres -d simulacion -f 'C:\Users\jhonn\OneDrive - Universidad de la Amazonia\UNIVERSIDAD\9NO SEMESTRE\ADMINISTRACION DE BASES DE DATOS\v1.sql'
