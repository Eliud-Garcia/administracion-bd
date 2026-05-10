/*
################
USANDO MYSQL
################
*/

/*traer el certificado de cada usuario*/
SELECT 
    pf.nombres_perfil, 
    certi.desempeno_certificado
FROM usuario AS usu INNER JOIN perfil AS pf
ON usu.pfkidperfil_usuario = pf.id_perfil
INNER JOIN certificado AS certi
ON certi.fkidusuario_certificado = usu.pfkidperfil_usuario
ORDER BY pf.id_perfil ASC;

/*nombre del usuario y si es admin o usuario*/

SELECT 
    pf.nombres_perfil AS nombre,
    'usuario' AS rol
    FROM usuario AS usu INNER JOIN perfil as pf
    ON usu.pfkidperfil_usuario = pf.id_perfil
UNION ALL
    SELECT  pf.nombres_perfil AS nombre, 'admin' AS rol
    FROM administrador AS adm INNER JOIN perfil AS pf
    ON adm.pfkidperfil_administrador = pf.id_perfil
ORDER BY rol ASC;

/*traer 
nombre del usuario que intenta una simulacion
id del modulo
fecha de ingreso
administrador creador de ese modulo
*/

SELECT 
    pf.nombres_perfil, 
    modulo.id_modulo, 
    prog_simu.fechaingreso_progresosimulacion, 
    tabla_admin.administrador
    FROM progresosimulacion AS prog_simu 
    INNER JOIN usuario AS usu
    ON prog_simu.fkidusuario_progresosimulacion = usu.pfkidperfil_usuario
    INNER JOIN perfil AS pf
    ON usu.pfkidperfil_usuario = pf.id_perfil
    INNER JOIN simulacion AS simu
    ON prog_simu.fkidsimulacion_progresosimulacion = simu.id_simulacion
    INNER JOIN modulo
    ON simu.fkidmodulo_simulacion = modulo.id_modulo
INNER JOIN (
    /*subconsulta*/
    SELECT 
        adm.pfkidperfil_administrador AS 'id_administrador', 
        pf.nombres_perfil AS 'administrador'
    FROM perfil AS pf 
    INNER JOIN administrador AS adm
    ON adm.pfkidperfil_administrador = pf.id_perfil
) AS tabla_admin
ON modulo.fkidadministrador_modulo = tabla_admin.id_administrador
ORDER BY pf.nombres_perfil ASC, modulo.id_modulo ASC
;


/*
todos los nombres de los administradores
con su ultima fecha de ingreso
*/
SELECT pf.nombres_perfil, pf.apellidos_perfil, adm.fechaultimoingreso_administrador
FROM perfil AS pf INNER JOIN administrador AS adm
ON adm.pfkidperfil_administrador = pf.id_perfil
ORDER BY pf.nombres_perfil ASC;

/*
mostrar todas las simulaciones que tiene un modulo
traer: 
id y nombre del modulo
id y nombre de la simulacion
*/

SELECT md.id_modulo, md.nombre_modulo, simu.id_simulacion, simu.nombre_simulacion
FROM modulo AS md INNER JOIN simulacion AS simu
ON simu.fkidmodulo_simulacion = md.id_modulo
ORDER BY md.nombre_modulo ASC;


/*
traer todas las respuestas de cada pregunta
id y enunciado de la pregunta
id, opcion respuesta y si es correcta o no
*/

SELECT preg.id_preguntaquiz, preg.enunciado_preguntaquiz, res.id_respuesta, res.opcion_respuesta, res.escorrecta_respuesta
FROM respuesta AS res INNER JOIN preguntaquiz AS preg
ON res.fkidpreguntaquiz_respuesta = preg.id_preguntaquiz
ORDER BY preg.id_preguntaquiz DESC;


/*
traer todos los quizzes de un modulo, tal que el puntaje del quizz sea menor a 50
id, nombre y descripcion del modulo
id y puntaje del quiz
*/

SELECT md.id_modulo, md.nombre_modulo, md.descripcion_modulo, quiz.id_quiz, quiz.puntaje_quiz
FROM quiz INNER JOIN modulo AS md
ON quiz.fkidmodulo_quiz = md.id_modulo
WHERE quiz.puntaje_quiz < 50
ORDER BY md.id_modulo ASC;


/*
3 tablas (perfil, administrador, modulo)

los nombres de los administradores y los modulos que gestionan
traer: 
nombre del administrador
nombre y id del modulo
ordenados por el id del administrador
*/



SELECT 
    pf.id_perfil, 
    pf.nombres_perfil, 
    modu.id_modulo,
    modu.nombre_modulo
FROM modulo AS modu 
INNER JOIN administrador AS adm
ON modu.fkidadministrador_modulo = adm.pfkidperfil_administrador
INNER JOIN perfil AS pf
ON adm.pfkidperfil_administrador = pf.id_perfil
ORDER BY pf.id_perfil, modu.id_modulo ASC;


/*
4 tablas (perfil, usuario, progresosimulacion, simulacion)

todos los progresos de simulacion con el nombre del usuario y el nombre de la simulacion

nombre usuario
fecha de ingreso a la simulacion
nombre de la simulacion
*/

SELECT 
    pf.nombres_perfil,
    pf.apellidos_perfil,
    simu.nombre_simulacion,
    prog_simu.fechaingreso_progresosimulacion
FROM progresosimulacion AS prog_simu 
INNER JOIN usuario AS usu
ON prog_simu.fkidusuario_progresosimulacion = usu.pfkidperfil_usuario
INNER JOIN perfil AS pf
ON usu.pfkidperfil_usuario = pf.id_perfil
INNER JOIN simulacion AS simu
ON prog_simu.fkidsimulacion_progresosimulacion = simu.id_simulacion;
