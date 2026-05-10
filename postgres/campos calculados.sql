/*
Para calcular un atributo de una tabla:
el trigger va en la tabla progresosimulacion
y actualiza la cantidad de fichas recolectadas,
basado en la cantidad de simulaciones completadas
por medio de una consulta
*/

CREATE OR REPLACE FUNCTION fn_progresosimulacion_piezas()
RETURNS TRIGGER AS $$
DECLARE
    fk_usuariosimulacion INTEGER;
    cantidad_obtenida SMALLINT = 0;
BEGIN

    IF TG_OP = 'DELETE' THEN
        fk_usuariosimulacion := OLD.fkidusuario_progresosimulacion;
        IF OLD.terminada_progresosimulacion = 1 THEN
            cantidad_obtenida := -1;
        END IF;
    ELSIF TG_OP = 'INSERT' THEN
        fk_usuariosimulacion := NEW.fkidusuario_progresosimulacion;
        IF NEW.terminada_progresosimulacion = 1 THEN
            cantidad_obtenida := 1;
        END IF;
    ELSE
        --ES UPDATE
        fk_usuariosimulacion := NEW.fkidusuario_progresosimulacion;
        IF OLD.terminada_progresosimulacion = 0 AND  NEW.terminada_progresosimulacion = 1 THEN
            cantidad_obtenida := 1;
        ELSIF OLD.terminada_progresosimulacion = 1 AND  NEW.terminada_progresosimulacion = 0 THEN
            cantidad_obtenida := -1;
        END IF;
    END IF;

    IF cantidad_obtenida != 0 THEN
        UPDATE usuario
        SET piezasrecolectadas_usuario = piezasrecolectadas_usuario + cantidad_obtenida
        WHERE pfkidperfil_usuario = fk_usuariosimulacion;
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tgr_progresosimulacion_piezas
AFTER INSERT OR UPDATE OR DELETE ON progresosimulacion
FOR EACH ROW EXECUTE FUNCTION fn_progresosimulacion_piezas();


SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'progresosimulacion';

/*
se sincronizan todos los usuarios
para que tengan su valor correcto
*/

UPDATE usuario AS usu
SET piezasrecolectadas_usuario = (
    SELECT COUNT(prog_simu.id_progresosimulacion)
    FROM progresosimulacion AS prog_simu
    WHERE prog_simu.terminada_progresosimulacion = 1 AND
    prog_simu.fkidusuario_progresosimulacion = usu.pfkidperfil_usuario
);

/*ejemplo simulacion realizada por el usuario 6*/

SELECT 
    pfkidperfil_usuario,
    piezasrecolectadas_usuario
FROM usuario;


SELECT 
    prog_simu.id_progresosimulacion AS id_prog,
    prog_simu.fkidusuario_progresosimulacion AS fk_usuario,
    prog_simu.terminada_progresosimulacion AS culminado
FROM progresosimulacion AS prog_simu
WHERE prog_simu.fkidusuario_progresosimulacion = 10;

--insert
INSERT INTO progresosimulacion(
    fkidusuario_progresosimulacion,
    fkidsimulacion_progresosimulacion,
--    fechaingreso_progresosimulacion,
    fechasalida_progresosimulacion,
    terminada_progresosimulacion
)VALUES(
    10,
    5,
    CURRENT_TIMESTAMP,
    1
);

--delete
DELETE FROM progresosimulacion WHERE id_progresosimulacion = 186;

--update
UPDATE progresosimulacion 
SET terminada_progresosimulacion = 0
WHERE progresosimulacion.id_progresosimulacion = 100;



/*
para tomar varias variables desde una consulta

DO $$
DECLARE
    -- Declaración de variables individuales
    v_nombre producto.nombre%TYPE; -- Hereda el tipo de la columna
    v_precio NUMERIC;
    v_fecha  TIMESTAMP := CURRENT_TIMESTAMP; -- Valor por defecto [1]
BEGIN
    -- Asignación de valores desde un SELECT
    SELECT nombre, precio 
    INTO v_nombre, v_precio 
    FROM producto 
    WHERE id = 1;

    -- Uso de las variables (ejemplo de inserción)
    INSERT INTO producto_historial(nombre, precio, fecha_registro)
    VALUES (v_nombre, v_precio, v_fecha);
END $$;

*/


