/*
=================
POSTGRES
=================

\i 'C:\\Users\\jhonn\\OneDrive - Universidad de la Amazonia\\UNIVERSIDAD\\9NO SEMESTRE\\ADMINISTRACION DE BASES DE DATOS\\temas vistos\\TRIGGERS.sql'

*/


/*
====================================
mostrar los triggers de una tabla
====================================
SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'administrador';
*/

/*
====================================
eliminar un trigger de una tabla
====================================
DROP TRIGGER fn_audit_administrador_update ON administrador;
*/


/*
================
ADMINISTRADOR
================
*/

DROP TABLE IF EXISTS administrador_auditoria;
CREATE TABLE administrador_auditoria(
    pfkidperfil_administrador INTEGER NOT NULL,
    fechaultimoingreso_administrador TIMESTAMP,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_administrador_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO administrador_auditoria(
        pfkidperfil_administrador,
        fechaultimoingreso_administrador,
       
        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.pfkidperfil_administrador,
        NEW.fechaultimoingreso_administrador,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_administrador_insert
AFTER INSERT ON administrador
FOR EACH ROW EXECUTE FUNCTION fn_audit_administrador_insert();

/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_administrador_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO administrador_auditoria(
        pfkidperfil_administrador,
        fechaultimoingreso_administrador,
        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.pfkidperfil_administrador,
        OLD.fechaultimoingreso_administrador,
        
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_administrador_update
AFTER UPDATE ON administrador
FOR EACH ROW EXECUTE FUNCTION fn_audit_administrador_update();

/*
UPDATE administrador SET fechaultimoingreso_administrador = '2026-03-29 00:00:00' WHERE pfkidperfil_administrador = 1;
*/


/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_administrador_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO administrador_auditoria(
        pfkidperfil_administrador,
        fechaultimoingreso_administrador,

        usuario_audit,
        proceso_audit
    )VALUES(
      OLD.pfkidperfil_administrador,
      OLD.fechaultimoingreso_administrador,
      
      current_user,
      'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_administrador_delete
AFTER DELETE ON administrador
FOR EACH ROW EXECUTE FUNCTION fn_audit_administrador_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'administrador';

/*
================
CERTIFICADO
================
*/

DROP TABLE IF EXISTS certificado_auditoria;
CREATE TABLE certificado_auditoria(
    id_certificado INTEGER NOT NULL,
    fkidusuario_certificado INTEGER NOT NULL,
    fechaemision_certificado DATE NOT NULL,
    desempeno_certificado VARCHAR(13),

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_certificado_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO certificado_auditoria(
        id_certificado,
        fkidusuario_certificado,
        fechaemision_certificado,
        desempeno_certificado,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_certificado,
        NEW.fkidusuario_certificado,
        NEW.fechaemision_certificado,
        NEW.desempeno_certificado,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_certificado_insert
AFTER INSERT ON certificado
FOR EACH ROW EXECUTE FUNCTION fn_audit_certificado_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_certificado_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO certificado_auditoria(
        id_certificado,
        fkidusuario_certificado,
        fechaemision_certificado,
        desempeno_certificado,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_certificado,
        OLD.fkidusuario_certificado,
        OLD.fechaemision_certificado,
        OLD.desempeno_certificado,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_certificado_update
AFTER UPDATE ON certificado
FOR EACH ROW EXECUTE FUNCTION fn_audit_certificado_update();

/*
UPDATE certificado SET desempeno_certificado = 'Sobresaliente' WHERE id_certificado = 1;
*/

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_certificado_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO certificado_auditoria(
        id_certificado,
        fkidusuario_certificado,
        fechaemision_certificado,
        desempeno_certificado,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_certificado,
        OLD.fkidusuario_certificado,
        OLD.fechaemision_certificado,
        OLD.desempeno_certificado,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_certificado_delete
AFTER DELETE ON certificado
FOR EACH ROW EXECUTE FUNCTION fn_audit_certificado_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'certificado';

/*
================
MODULO
================
*/

DROP TABLE IF EXISTS modulo_auditoria;
CREATE TABLE modulo_auditoria(
    id_modulo INTEGER NOT NULL,
    fkidadministrador_modulo INTEGER NOT NULL,
    nombre_modulo VARCHAR(20) NOT NULL,
    descripcion_modulo TEXT NOT NULL,
    ordensecuencia_modulo INTEGER NOT NULL,
    activo_modulo SMALLINT NOT NULL,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_modulo_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO modulo_auditoria(
        id_modulo,
        fkidadministrador_modulo,
        nombre_modulo,
        descripcion_modulo,
        ordensecuencia_modulo,
        activo_modulo,
       
        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_modulo,
        NEW.fkidadministrador_modulo,
        NEW.nombre_modulo,
        NEW.descripcion_modulo,
        NEW.ordensecuencia_modulo,
        NEW.activo_modulo,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_modulo_insert
AFTER INSERT ON modulo
FOR EACH ROW EXECUTE FUNCTION fn_audit_modulo_insert();

/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_modulo_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO modulo_auditoria(
        id_modulo,
        fkidadministrador_modulo,
        nombre_modulo,
        descripcion_modulo,
        ordensecuencia_modulo,
        activo_modulo,
       
        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_modulo,
        OLD.fkidadministrador_modulo,
        OLD.nombre_modulo,
        OLD.descripcion_modulo,
        OLD.ordensecuencia_modulo,
        OLD.activo_modulo,

        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_modulo_update
AFTER UPDATE ON modulo
FOR EACH ROW EXECUTE FUNCTION fn_audit_modulo_update();

/*
UPDATE modulo SET descripcion_modulo = 'xx' WHERE id_modulo = 5;
*/

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_modulo_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO modulo_auditoria(
        id_modulo,
        fkidadministrador_modulo,
        nombre_modulo,
        descripcion_modulo,
        ordensecuencia_modulo,
        activo_modulo,
       
        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_modulo,
        OLD.fkidadministrador_modulo,
        OLD.nombre_modulo,
        OLD.descripcion_modulo,
        OLD.ordensecuencia_modulo,
        OLD.activo_modulo,

        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_modulo_delete
AFTER DELETE ON modulo
FOR EACH ROW EXECUTE FUNCTION fn_audit_modulo_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'modulo';

/*
================
PERFIL
================
*/

DROP TABLE IF EXISTS perfil_auditoria;
CREATE TABLE perfil_auditoria(
    id_perfil INT NOT NULL,
    nombres_perfil VARCHAR(150) NOT NULL,
    apellidos_perfil  VARCHAR(150) NOT NULL,
    fechanacimiento_perfil DATE NOT NULL,
    idioma_perfil SMALLINT NOT NULL,
    temavisual_perfil SMALLINT NOT NULL,
    correo_perfil VARCHAR(255) NOT NULL,
    contrasena_perfil VARCHAR(255) NOT NULL,
    genero_perfil VARCHAR(15),


    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_perfil_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO perfil_auditoria(
        id_perfil,
        nombres_perfil,
        apellidos_perfil,
        fechanacimiento_perfil,
        idioma_perfil,
        temavisual_perfil,
        correo_perfil,
        contrasena_perfil,
        genero_perfil,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_perfil,
        NEW.nombres_perfil,
        NEW.apellidos_perfil,
        NEW.fechanacimiento_perfil,
        NEW.idioma_perfil,
        NEW.temavisual_perfil,
        NEW.correo_perfil,
        NEW.contrasena_perfil,
        NEW.genero_perfil,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_perfil_insert
AFTER INSERT ON perfil
FOR EACH ROW EXECUTE FUNCTION fn_audit_perfil_insert();

/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_perfil_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO perfil_auditoria(
        id_perfil,
        nombres_perfil,
        apellidos_perfil,
        fechanacimiento_perfil,
        idioma_perfil,
        temavisual_perfil,
        correo_perfil,
        contrasena_perfil,
        genero_perfil,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_perfil,
        OLD.nombres_perfil,
        OLD.apellidos_perfil,
        OLD.fechanacimiento_perfil,
        OLD.idioma_perfil,
        OLD.temavisual_perfil,
        OLD.correo_perfil,
        OLD.contrasena_perfil,
        OLD.genero_perfil,

        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_perfil_update
AFTER UPDATE ON perfil
FOR EACH ROW EXECUTE FUNCTION fn_audit_perfil_update();

/*
UPDATE perfil SET apellidos_perfil = 'Messi' WHERE id_perfil = 25;
*/

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_perfil_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO perfil_auditoria(
        id_perfil,
        nombres_perfil,
        apellidos_perfil,
        fechanacimiento_perfil,
        idioma_perfil,
        temavisual_perfil,
        correo_perfil,
        contrasena_perfil,
        genero_perfil,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_perfil,
        OLD.nombres_perfil,
        OLD.apellidos_perfil,
        OLD.fechanacimiento_perfil,
        OLD.idioma_perfil,
        OLD.temavisual_perfil,
        OLD.correo_perfil,
        OLD.contrasena_perfil,
        OLD.genero_perfil,

        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER fn_audit_perfil_delete
AFTER DELETE ON perfil
FOR EACH ROW EXECUTE FUNCTION fn_audit_perfil_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'perfil';

/*
================
PREGUNTAQUIZ
================
*/

DROP TABLE IF EXISTS preguntaquiz_auditoria;
CREATE TABLE preguntaquiz_auditoria(
    id_preguntaquiz INT NOT NULL,
    fkidquiz_preguntaquiz INT NOT NULL,
    enunciado_preguntaquiz TEXT NOT NULL,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_preguntaquiz_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO preguntaquiz_auditoria(
        id_preguntaquiz,
        fkidquiz_preguntaquiz,
        enunciado_preguntaquiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_preguntaquiz,
        NEW.fkidquiz_preguntaquiz,
        NEW.enunciado_preguntaquiz,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_preguntaquiz_insert
AFTER INSERT ON preguntaquiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_preguntaquiz_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_preguntaquiz_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO preguntaquiz_auditoria(
        id_preguntaquiz,
        fkidquiz_preguntaquiz,
        enunciado_preguntaquiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_preguntaquiz,
        OLD.fkidquiz_preguntaquiz,
        OLD.enunciado_preguntaquiz,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_preguntaquiz_update
AFTER UPDATE ON preguntaquiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_preguntaquiz_update();

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_preguntaquiz_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO preguntaquiz_auditoria(
        id_preguntaquiz,
        fkidquiz_preguntaquiz,
        enunciado_preguntaquiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_preguntaquiz,
        OLD.fkidquiz_preguntaquiz,
        OLD.enunciado_preguntaquiz,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_preguntaquiz_delete
AFTER DELETE ON preguntaquiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_preguntaquiz_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'preguntaquiz';


/*
================
PROGRESOQUIZ
================
*/

DROP TABLE IF EXISTS progresoquiz_auditoria;
CREATE TABLE progresoquiz_auditoria(
    id_progresoquiz INT NOT NULL,
    fkidusuario_progresoquiz INT NOT NULL,
    fkidquiz_progresoquiz INT NOT NULL,
    fechaingreso_progresoquiz TIMESTAMP NOT NULL,
    fechasalida_progresoquiz TIME NOT NULL,
    puntajeobtenido_progresoquiz NUMERIC(5, 2) NOT NULL,
    estado_progresoquiz VARCHAR(20) NOT NULL,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_progresoquiz_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO progresoquiz_auditoria(
        id_progresoquiz,
        fkidusuario_progresoquiz,
        fkidquiz_progresoquiz,
        fechaingreso_progresoquiz,
        fechasalida_progresoquiz,
        puntajeobtenido_progresoquiz,
        estado_progresoquiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_progresoquiz,
        NEW.fkidusuario_progresoquiz,
        NEW.fkidquiz_progresoquiz,
        NEW.fechaingreso_progresoquiz,
        NEW.fechasalida_progresoquiz,
        NEW.puntajeobtenido_progresoquiz,
        NEW.estado_progresoquiz,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_progresoquiz_insert
AFTER INSERT ON progresoquiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_progresoquiz_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_progresoquiz_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO progresoquiz_auditoria(
        id_progresoquiz,
        fkidusuario_progresoquiz,
        fkidquiz_progresoquiz,
        fechaingreso_progresoquiz,
        fechasalida_progresoquiz,
        puntajeobtenido_progresoquiz,
        estado_progresoquiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_progresoquiz,
        OLD.fkidusuario_progresoquiz,
        OLD.fkidquiz_progresoquiz,
        OLD.fechaingreso_progresoquiz,
        OLD.fechasalida_progresoquiz,
        OLD.puntajeobtenido_progresoquiz,
        OLD.estado_progresoquiz,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_progresoquiz_update
AFTER UPDATE ON progresoquiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_progresoquiz_update();

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_progresoquiz_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO progresoquiz_auditoria(
        id_progresoquiz,
        fkidusuario_progresoquiz,
        fkidquiz_progresoquiz,
        fechaingreso_progresoquiz,
        fechasalida_progresoquiz,
        puntajeobtenido_progresoquiz,
        estado_progresoquiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_progresoquiz,
        OLD.fkidusuario_progresoquiz,
        OLD.fkidquiz_progresoquiz,
        OLD.fechaingreso_progresoquiz,
        OLD.fechasalida_progresoquiz,
        OLD.puntajeobtenido_progresoquiz,
        OLD.estado_progresoquiz,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_progresoquiz_delete
AFTER DELETE ON progresoquiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_progresoquiz_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'progresoquiz';


/*
================
PROGRESOSIMULACION
================
*/

DROP TABLE IF EXISTS progresosimulacion_auditoria;
CREATE TABLE progresosimulacion_auditoria(
    id_progresosimulacion INT NOT NULL,
    fkidusuario_progresosimulacion INT NOT NULL,
    fkidsimulacion_progresosimulacion INT NOT NULL,
    fechaingreso_progresosimulacion TIMESTAMP NOT NULL,
    fechasalida_progresosimulacion TIMESTAMP,
    terminada_progresosimulacion SMALLINT NOT NULL,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_progresosimulacion_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO progresosimulacion_auditoria(
        id_progresosimulacion,
        fkidusuario_progresosimulacion,
        fkidsimulacion_progresosimulacion,
        fechaingreso_progresosimulacion,
        fechasalida_progresosimulacion,
        terminada_progresosimulacion,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_progresosimulacion,
        NEW.fkidusuario_progresosimulacion,
        NEW.fkidsimulacion_progresosimulacion,
        NEW.fechaingreso_progresosimulacion,
        NEW.fechasalida_progresosimulacion,
        NEW.terminada_progresosimulacion,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_progresosimulacion_insert
AFTER INSERT ON progresosimulacion
FOR EACH ROW EXECUTE FUNCTION fn_audit_progresosimulacion_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_progresosimulacion_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO progresosimulacion_auditoria(
        id_progresosimulacion,
        fkidusuario_progresosimulacion,
        fkidsimulacion_progresosimulacion,
        fechaingreso_progresosimulacion,
        fechasalida_progresosimulacion,
        terminada_progresosimulacion,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_progresosimulacion,
        OLD.fkidusuario_progresosimulacion,
        OLD.fkidsimulacion_progresosimulacion,
        OLD.fechaingreso_progresosimulacion,
        OLD.fechasalida_progresosimulacion,
        OLD.terminada_progresosimulacion,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_progresosimulacion_update
AFTER UPDATE ON progresosimulacion
FOR EACH ROW EXECUTE FUNCTION fn_audit_progresosimulacion_update();

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_progresosimulacion_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO progresosimulacion_auditoria(
        id_progresosimulacion,
        fkidusuario_progresosimulacion,
        fkidsimulacion_progresosimulacion,
        fechaingreso_progresosimulacion,
        fechasalida_progresosimulacion,
        terminada_progresosimulacion,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_progresosimulacion,
        OLD.fkidusuario_progresosimulacion,
        OLD.fkidsimulacion_progresosimulacion,
        OLD.fechaingreso_progresosimulacion,
        OLD.fechasalida_progresosimulacion,
        OLD.terminada_progresosimulacion,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_progresosimulacion_delete
AFTER DELETE ON progresosimulacion
FOR EACH ROW EXECUTE FUNCTION fn_audit_progresosimulacion_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'progresosimulacion';


/*
================
QUIZ
================
*/

DROP TABLE IF EXISTS quiz_auditoria;
CREATE TABLE quiz_auditoria(
    id_quiz INT NOT NULL,
    fkidmodulo_quiz INT NOT NULL,
    puntaje_quiz INT NOT NULL,
    
    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_quiz_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO quiz_auditoria(
        id_quiz,
        fkidmodulo_quiz,
        puntaje_quiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_quiz,
        NEW.fkidmodulo_quiz,
        NEW.puntaje_quiz,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_quiz_insert
AFTER INSERT ON quiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_quiz_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_quiz_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO quiz_auditoria(
        id_quiz,
        fkidmodulo_quiz,
        puntaje_quiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_quiz,
        OLD.fkidmodulo_quiz,
        OLD.puntaje_quiz,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_quiz_update
AFTER UPDATE ON quiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_quiz_update();

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_quiz_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO quiz_auditoria(
        id_quiz,
        fkidmodulo_quiz,
        puntaje_quiz,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_quiz,
        OLD.fkidmodulo_quiz,
        OLD.puntaje_quiz,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_quiz_delete
AFTER DELETE ON quiz
FOR EACH ROW EXECUTE FUNCTION fn_audit_quiz_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'quiz';


/*
================
RESPUESTA
================
*/

DROP TABLE IF EXISTS respuesta_auditoria;
CREATE TABLE respuesta_auditoria(
    id_respuesta INT NOT NULL,
    fkidpreguntaquiz_respuesta INT NOT NULL,
    opcion_respuesta VARCHAR(100) NOT NULL,
    escorrecta_respuesta SMALLINT NOT NULL,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_respuesta_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO respuesta_auditoria(
        id_respuesta,
        fkidpreguntaquiz_respuesta,
        opcion_respuesta,
        escorrecta_respuesta,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_respuesta,
        NEW.fkidpreguntaquiz_respuesta,
        NEW.opcion_respuesta,
        NEW.escorrecta_respuesta,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_respuesta_insert
AFTER INSERT ON respuesta
FOR EACH ROW EXECUTE FUNCTION fn_audit_respuesta_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_respuesta_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO respuesta_auditoria(
        id_respuesta,
        fkidpreguntaquiz_respuesta,
        opcion_respuesta,
        escorrecta_respuesta,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_respuesta,
        OLD.fkidpreguntaquiz_respuesta,
        OLD.opcion_respuesta,
        OLD.escorrecta_respuesta,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_respuesta_update
AFTER UPDATE ON respuesta
FOR EACH ROW EXECUTE FUNCTION fn_audit_respuesta_update();

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_respuesta_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO respuesta_auditoria(
        id_respuesta,
        fkidpreguntaquiz_respuesta,
        opcion_respuesta,
        escorrecta_respuesta,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_respuesta,
        OLD.fkidpreguntaquiz_respuesta,
        OLD.opcion_respuesta,
        OLD.escorrecta_respuesta,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_respuesta_delete
AFTER DELETE ON respuesta
FOR EACH ROW EXECUTE FUNCTION fn_audit_respuesta_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'respuesta';


/*
================
SIMULACION
================
*/

DROP TABLE IF EXISTS simulacion_auditoria;
CREATE TABLE simulacion_auditoria(
    id_simulacion INT NOT NULL,
    fkidmodulo_simulacion INT NOT NULL,
    nombre_simulacion VARCHAR(100) NOT NULL,
    descripcion_simulacion TEXT NOT NULL,
    orden_simulacion INT NOT NULL,
    activo_simulacion SMALLINT NOT NULL,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_simulacion_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO simulacion_auditoria(
        id_simulacion,
        fkidmodulo_simulacion,
        nombre_simulacion,
        descripcion_simulacion,
        orden_simulacion,
        activo_simulacion,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.id_simulacion,
        NEW.fkidmodulo_simulacion,
        NEW.nombre_simulacion,
        NEW.descripcion_simulacion,
        NEW.orden_simulacion,
        NEW.activo_simulacion,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_simulacion_insert
AFTER INSERT ON simulacion
FOR EACH ROW EXECUTE FUNCTION fn_audit_simulacion_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_simulacion_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO simulacion_auditoria(
        id_simulacion,
        fkidmodulo_simulacion,
        nombre_simulacion,
        descripcion_simulacion,
        orden_simulacion,
        activo_simulacion,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_simulacion,
        OLD.fkidmodulo_simulacion,
        OLD.nombre_simulacion,
        OLD.descripcion_simulacion,
        OLD.orden_simulacion,
        OLD.activo_simulacion,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_simulacion_update
AFTER UPDATE ON simulacion
FOR EACH ROW EXECUTE FUNCTION fn_audit_simulacion_update();


/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_simulacion_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO simulacion_auditoria(
        id_simulacion,
        fkidmodulo_simulacion,
        nombre_simulacion,
        descripcion_simulacion,
        orden_simulacion,
        activo_simulacion,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.id_simulacion,
        OLD.fkidmodulo_simulacion,
        OLD.nombre_simulacion,
        OLD.descripcion_simulacion,
        OLD.orden_simulacion,
        OLD.activo_simulacion,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_simulacion_delete
AFTER DELETE ON simulacion
FOR EACH ROW EXECUTE FUNCTION fn_audit_simulacion_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'simulacion';


/*
================
USUARIO
================
*/

DROP TABLE IF EXISTS usuario_auditoria;
CREATE TABLE usuario_auditoria(
    pfkidperfil_usuario INTEGER NOT NULL,
    fechacreacioncuenta_usuario TIMESTAMP,
    puntajeglobal_usuario NUMERIC(5, 2),
    piezasrecolectadas_usuario SMALLINT,

    usuario_audit VARCHAR(100) NOT NULL,
    fecha_audit TIMESTAMPTZ DEFAULT NOW(),
    proceso_audit VARCHAR(1) NOT NULL
);

/*INSERT*/
CREATE OR REPLACE FUNCTION fn_audit_usuario_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO usuario_auditoria(
        pfkidperfil_usuario,
        fechacreacioncuenta_usuario,
        puntajeglobal_usuario,
        piezasrecolectadas_usuario,

        usuario_audit,
        proceso_audit
    )VALUES(
        NEW.pfkidperfil_usuario,
        NEW.fechacreacioncuenta_usuario,
        NEW.puntajeglobal_usuario,
        NEW.piezasrecolectadas_usuario,

        current_user,
        'I'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR INSERT*/
CREATE OR REPLACE TRIGGER tgr_audit_usuario_insert
AFTER INSERT ON usuario
FOR EACH ROW EXECUTE FUNCTION fn_audit_usuario_insert();


/*UPDATE*/
CREATE OR REPLACE FUNCTION fn_audit_usuario_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO usuario_auditoria(
        pfkidperfil_usuario,
        fechacreacioncuenta_usuario,
        puntajeglobal_usuario,
        piezasrecolectadas_usuario,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.pfkidperfil_usuario,
        OLD.fechacreacioncuenta_usuario,
        OLD.puntajeglobal_usuario,
        OLD.piezasrecolectadas_usuario,
      
        current_user,
        'U'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/*TGR UPDATE*/
CREATE OR REPLACE TRIGGER tgr_audit_usuario_update
AFTER UPDATE ON usuario
FOR EACH ROW EXECUTE FUNCTION fn_audit_usuario_update();

/*DELETE*/
CREATE OR REPLACE FUNCTION fn_audit_usuario_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO usuario_auditoria(
        pfkidperfil_usuario,
        fechacreacioncuenta_usuario,
        puntajeglobal_usuario,
        piezasrecolectadas_usuario,

        usuario_audit,
        proceso_audit
    )VALUES(
        OLD.pfkidperfil_usuario,
        OLD.fechacreacioncuenta_usuario,
        OLD.puntajeglobal_usuario,
        OLD.piezasrecolectadas_usuario,
      
        current_user,
        'D'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
/*TGR DELETE*/
CREATE OR REPLACE TRIGGER tgr_audit_usuario_delete
AFTER DELETE ON usuario
FOR EACH ROW EXECUTE FUNCTION fn_audit_usuario_delete();

SELECT 
  trigger_name, 
  event_manipulation,
  action_timing
FROM information_schema.triggers
WHERE event_object_table = 'usuario';



