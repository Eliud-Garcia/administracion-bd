/*
=============
POSTGRES
=============

son para gestionar transacciones
*/


/*crear procedimiento*/
CREATE OR REPLACE PROCEDURE insertar_perfil(
    p_id integer,
    p_nombres character,
    p_apellidos character,
    p_fechanacimiento date,
    p_idioma smallint,
    p_temavisual smallint,
    p_correo character,
    p_contrasena character,
    p_genero character
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO perfil(
        id_perfil,
        nombres_perfil,
        apellidos_perfil,
        fechanacimiento_perfil,
        idioma_perfil,
        temavisual_perfil,
        correo_perfil,
        contrasena_perfil,
        genero_perfil
    )VALUES(
        p_id,
        p_nombres,
        p_apellidos,
        p_fechanacimiento,
        p_idioma,
        p_temavisual,
        p_correo,
        p_contrasena,
        p_genero
    );

    
    RAISE NOTICE 'Usuario % registrado exitosamente.', p_nombres;
EXCEPTION

    WHEN unique_violation THEN
        ROLLBACK;
        RAISE WARNING 'No se pudo registrar: El correo % ya existe en el sistema.', p_correo;
END;
$$;

/*para usar el procedimiento*/
CALL insertar_perfil(7373, 'XX', 'YY', '2004-05-23', 1::smallint, 1::smallint, 'xxyy@qq.com', 'x123', 'Masculino');

/*para eliminar un procedimiento*/

DROP PROCEDURE insertar_perfil;