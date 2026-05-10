/*
##################
EN POSTGRES
##################
*/

/*record guarda el resultado de una consulta*/
DO
$$
    DECLARE
        rec record := NULL;
        contador INTEGER := 0;
    BEGIN

        FOR rec IN SELECT * FROM perfil LOOP
            RAISE NOTICE 'La persona se llama %', rec.nombres_perfil;
            contador := contador + 1;
        END LOOP;
        RAISE NOTICE 'cantidad: %', contador;

    END
$$

/*
=====================
FUNCIONES
=====================*/

/*crear una funcion*/
CREATE OR REPLACE FUNCTION consultar_perfiles() RETURNS void
AS 
$$
    DECLARE
        rec record := NULL;
        contador integer := 0;
    BEGIN

        FOR rec IN SELECT perfil.nombres_perfil FROM perfil LOOP
            RAISE NOTICE 'Nombres: %', rec.nombres_perfil;
            contador := contador + 1;
        END LOOP;
        RAISE NOTICE 'La cantidad de registros es %', contador;

    END;
$$
LANGUAGE PLPGSQL;

/*para usar la funciona creada*/
SELECT consultar_perfiles();

/*para eliminar la funcion*/
DROP FUNCTION consultar_perfiles();


CREATE OR REPLACE FUNCTION contar_perfiles() RETURNS INTEGER
AS 
$$
    DECLARE
        contador integer := 0;
    BEGIN
        SELECT COUNT(perfil.id_perfil) INTO contador FROM perfil;
        RAISE NOTICE 'La cantidad de registros es %', contador;

        RETURN contador;
    END;
$$
LANGUAGE PLPGSQL;


/*Consultar las funciones creadas*/
\df

/*Para ver el codigo de la funcion*/
\sf consultar_perfiles


/*funcion con código en python
toca usar este comando
CREATE EXTENSION plpython3u;
*/
CREATE OR REPLACE FUNCTION obtener_maximo(a integer, b integer) 
RETURNS integer 
LANGUAGE plpython3u 
AS $$
    # ¡Aquí adentro escribes Python puro!
    if a > b:
        return a
    else:
        return b
    
    # O simplemente: return max(a, b)
$$;