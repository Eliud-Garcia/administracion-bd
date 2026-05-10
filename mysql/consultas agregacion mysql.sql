/*
################
USANDO MYSQL
################
*/

/*para contar registros*/
SELECT COUNT(nombres_perfil) FROM perfil;

/*para contar registros diferentes*/
SELECT COUNT(DISTINCT nombres_perfil) AS nombres_diferentes FROM perfil;

/*suma de un campo*/
SELECT SUM(activo_simulacion) AS total_activos FROM simulacion;

/*promedio*/
SELECT AVG(puntajeobtenido_progresoquiz) AS promedio FROM progresoquiz;

/*maximo*/
SELECT MAX(fechaingreso_progresosimulacion) AS max_fecha FROM progresosimulacion;

/*minimo*/
SELECT MIN(fechaingreso_progresosimulacion) AS min_fecha FROM progresosimulacion;

SELECT * 
FROM x 
WHERE y = (SELECT MAX(cosa) FROM algo);


/*condiciones*/
SELECT 
    query_name,
    SUM(IF(rating < 3, 1, 0)) AS consultas_pobres
FROM Queries
GROUP BY query_name;


/*https://leetcode.com/problems/confirmation-rate/description/?envType=study-plan-v2&envId=top-sql-50*/
SELECT 
    Signups.user_id,
    ROUND(IFNULL(aprove.cantidad / aprove.total, 0), 2) AS confirmation_rate 
FROM Signups
LEFT JOIN Confirmations
ON Confirmations.user_id = Signups.user_id
LEFT JOIN (
	/*saber cantidad de confirmados*/
    SELECT
        Confirmations.user_id AS user_id,
        SUM(CASE WHEN Confirmations.action = 'confirmed' THEN 1 ELSE 0 END) AS cantidad,
		COUNT(user_id) AS total
    FROM Confirmations
    GROUP BY Confirmations.user_id
)AS aprove
ON aprove.user_id = Confirmations.user_id
GROUP BY  Signups.user_id;

/*https://leetcode.com/problems/percentage-of-users-attended-a-contest/?envType=study-plan-v2&envId=top-sql-50*/
SELECT 
    r.contest_id,
    ROUND(COUNT(r.contest_id) / (
        SELECT 
            COUNT(u.user_id)
        FROM Users AS u
    ) * 100, 2) as percentage
FROM Register AS r
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id ASC;

/*https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50*/
SELECT 
    DATE_FORMAT(trans_date , '%Y-%m') AS month,
    t.country,
    COUNT(t.id) AS trans_count,
    SUM(IF(t.state = 'approved', 1, 0)) AS approved_count,
    SUM(t.amount) AS trans_total_amount,
    SUM(IF(t.state = 'approved', t.amount, 0)) AS approved_total_amount 

FROM Transactions AS t
GROUP BY month, t.country;





/*
    Usando GROUP
    para contar la frecuencia de cada idioma
*/
SELECT 
    idioma_perfil, 
    COUNT(id_perfil) AS idioma,
    MAX(id_perfil)
    FROM perfil
    GROUP BY idioma_perfil
    ORDER BY idioma DESC;


/*
contar para cada genero
el idioma y cuantos están ahí
*/
SELECT 
    genero_perfil AS genero, 
    idioma_perfil AS idioma,
    count(id_perfil) AS total 
FROM perfil
GROUP BY idioma_perfil, genero_perfil
ORDER BY genero ASC, idioma DESC;


/*
La persona que más simulaciones tiene
usando ORDER BY
*/

SELECT
    pf.id_perfil,
    pf.nombres_perfil AS nombre,
    COUNT(prog.fkidusuario_progresosimulacion) AS intentos
FROM perfil AS pf 
    INNER JOIN usuario as usu
    ON usu.pfkidperfil_usuario = pf.id_perfil
    INNER JOIN progresosimulacion AS prog
    ON prog.fkidusuario_progresosimulacion = usu.pfkidperfil_usuario
GROUP BY pf.id_perfil, nombre
ORDER BY intentos DESC, pf.nombres_perfil ASC
LIMIT 1;

/*
La persona que más simulaciones tiene
usando sub-consultas y HAVING
*/

SELECT
    pf.id_perfil,
    pf.nombres_perfil AS nombre,
    COUNT(prog.fkidusuario_progresosimulacion) AS intentos
FROM perfil AS pf 
    INNER JOIN usuario as usu
    ON usu.pfkidperfil_usuario = pf.id_perfil
    INNER JOIN progresosimulacion AS prog
    ON prog.fkidusuario_progresosimulacion = usu.pfkidperfil_usuario
GROUP BY pf.id_perfil, nombre
HAVING intentos = (
    /*sub-consulta 1*/
    SELECT 
        MAX(tabla_conteos.cnt)
    FROM (
        /*sub-consulta 2*/
        SELECT 
            COUNT(id_progresosimulacion) AS cnt
        FROM progresosimulacion
        GROUP BY fkidusuario_progresosimulacion
    )AS tabla_conteos
);


/*la misma que la anterior pero solo 1 subconsulta*/
SELECT
    pf.id_perfil,
    pf.nombres_perfil AS nombre,
    COUNT(prog.fkidusuario_progresosimulacion) AS intentos
FROM perfil AS pf 
    INNER JOIN usuario as usu
    ON usu.pfkidperfil_usuario = pf.id_perfil
    INNER JOIN progresosimulacion AS prog
    ON prog.fkidusuario_progresosimulacion = usu.pfkidperfil_usuario
GROUP BY pf.id_perfil, nombre
HAVING intentos = (
    /*sub-consulta 1*/
    SELECT 
        COUNT(id_progresosimulacion) AS cnt
    FROM progresosimulacion
    GROUP BY fkidusuario_progresosimulacion
    ORDER BY cnt DESC
    LIMIT 1  
);





/*id usuario con los intentos realizados*/

SELECT 
    progresosimulacion.fkidusuario_progresosimulacion,
    COUNT(id_progresosimulacion) AS cnt
FROM progresosimulacion
GROUP BY fkidusuario_progresosimulacion;

    

