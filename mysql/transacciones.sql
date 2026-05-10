/*
################
USANDO MYSQL
################
*/
--ejemplo para insertar datos
INSERT INTO perfil(
    nombres_perfil, 
    apellidos_perfil, 
    fechanacimiento_perfil, 
    idioma_perfil, 
    temavisual_perfil, 
    correo_perfil, 
    contrasena_perfil, 
    genero_perfil) 
    VALUES (
        'Carlos', 
        'Garcia', 
        '2001-02-25', 
        0, 
        0, 
        'carlos.garcia@gmail.com', 
        'carlos123', 
        'Masculino'
        );


-- actualizar varios datos de un campo, por medio de un rango
UPDATE usuario
SET estado = 'activo' 
WHERE id BETWEEN 10 AND 50; -->= 10 <= 50

UPDATE usuario
SET estado = 'activo' 
WHERE id NOT BETWEEN 10 AND 50; -- <10  >50


--para actualizar campos que no tienen nada en común
UPDATE empleado
SET estado = 'I'
WHERE cc_emp IN (1, 77, 10);


--para actualizar los primeros n registros
UPDATE empleado
SET estado = 'activo'
ORDER BY id_emp ASC
LIMIT 5;

--para eliminar
DELETE FROM empleado
WHERE id_emp = 1118;


--ordenar por varios campos
SELECT c1, c2, c2
FROM tabla
WHERE estado = 'activo'
ORDER BY c1 ASC, c2 DESC;

--usando alias para el nombre de la tabla
SELECT pf.nombres_perfil, pf.apellidos_perfil
FROM perfil AS pf
WHERE pf.idioma_perfil = 1
ORDER BY pf.nombres_perfil DESC;

