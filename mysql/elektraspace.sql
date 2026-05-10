/*
################
USANDO MYSQL
################
*/

/*borrar*/
DROP DATABASE IF EXISTS elektraspace;
/*--------------BASE DE DATOS---------------*/
CREATE DATABASE elektraspace;
USE elektraspace;
/*---------------TABLAS-------------------*/
CREATE TABLE perfil (
     id_perfil INT NOT NULL AUTO_INCREMENT UNIQUE,
     nombres_perfil VARCHAR(30) NOT NULL ,
     apellidos_perfil VARCHAR(40) NOT NULL ,
     fechanacimiento_perfil DATE NOT NULL,
     idioma_perfil TINYINT UNSIGNED NOT NULL DEFAULT 0,
     temavisual_perfil TINYINT UNSIGNED NOT NULL DEFAULT 0,
     correo_perfil VARCHAR(255) NOT NULL UNIQUE,
     contrasena_perfil VARCHAR(255) NOT NULL,
     genero_perfil ENUM('Masculino','Femenino','Otro') NOT NULL 
) ENGINE= InnoDB;

CREATE TABLE usuario (
    pfkidperfil_usuario INT NOT NULL,
    fechacreacioncuenta_usuario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    puntajeglobal_usuario DECIMAL(5,2) DEFAULT 0, 
    piezasrecolectadas_usuario TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE= InnoDB;

CREATE TABLE administrador (
    pfkidperfil_administrador INT NOT NULL,
    fechaultimoingreso_administrador TIMESTAMP NULL DEFAULT NULL
) ENGINE= InnoDB;

CREATE TABLE certificado (
    id_certificado INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidusuario_certificado INT NOT NULL UNIQUE,
    fechaemision_certificado DATE NULL DEFAULT NULL,
    desempeno_certificado ENUM('Bajo','Basico','Sobresaliente')
) ENGINE= InnoDB;

CREATE TABLE modulo (
    id_modulo INT  NOT NULL AUTO_INCREMENT UNIQUE,
    fkidadministrador_modulo INT NOT NULL,
    nombre_modulo VARCHAR(20) NOT NULL,
    descripcion_modulo TEXT NOT NULL,
    ordensecuencia_modulo INT NOT NULL UNIQUE,
    activo_modulo BOOLEAN NOT NULL 
) ENGINE= InnoDB;

CREATE TABLE quiz (
    id_quiz INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidmodulo_quiz INT NOT NULL,
    puntaje_quiz INT NOT NULL DEFAULT 100
) ENGINE= InnoDB;

CREATE TABLE preguntaquiz (
    id_preguntaquiz INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidquiz_preguntaquiz INT NOT NULL,
    enunciado_preguntaquiz TEXT NOT NULL
) ENGINE= InnoDB;

CREATE TABLE respuesta (
    id_respuesta INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidpreguntaquiz_respuesta INT NOT NULL,
    opcion_respuesta VARCHAR (100) NOT NULL,
    escorrecta_respuesta BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE= InnoDB;

CREATE TABLE progresoquiz (
    id_progresoquiz INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidusuario_progresoquiz INT NOT NULL,
    fkidquiz_progresoquiz INT NOT NULL,
    fechaingreso_progresoquiz TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fechasalida_progresoquiz TIMESTAMP NULL DEFAULT NULL,
    puntajeobtenido_progresoquiz DECIMAL(5,2) NOT NULL DEFAULT 0,
    estado_progresoquiz ENUM('En Progreso','Terminado','Abandonado') NOT NULL DEFAULT 'En Progreso'
) ENGINE= InnoDB;

CREATE TABLE respuestaprogresoquiz (
    fkidprogresoquiz_respuestaprogresoquiz INT NOT NULL,
    fkidrespuesta_respuestaprogresoquiz INT NOT NULL,
    fkidpreguntaquiz_respuestaprogresoquiz INT NOT NULL,
    fechaseleccion_respuestaprogresoquiz TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE= InnoDB;

CREATE TABLE simulacion (
    id_simulacion INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidmodulo_simulacion INT NOT NULL,
    nombre_simulacion VARCHAR(40) NOT NULL,
    descripcion_simulacion TEXT NOT NULL,
    orden_simulacion INT NOT NULL UNIQUE,
    activo_simulacion BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE= InnoDB;

CREATE TABLE progresosimulacion (
    id_progresosimulacion INT NOT NULL AUTO_INCREMENT UNIQUE,
    fkidusuario_progresosimulacion INT NOT NULL,
    fkidsimulacion_progresosimulacion INT NOT NULL,
    fechaingreso_progresosimulacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fechasalida_progresosimulacion TIMESTAMP NULL DEFAULT NULL,
    terminada_progresosimulacion BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE= InnoDB;

/*--------------------LLAVES PRIMARIAS------------------------------*/

ALTER TABLE perfil 
ADD CONSTRAINT pk_perfil 
PRIMARY KEY (id_perfil);

ALTER TABLE usuario 
ADD CONSTRAINT pk_usuario 
PRIMARY KEY (pfkidperfil_usuario);

ALTER TABLE administrador 
ADD CONSTRAINT pk_administrador
PRIMARY KEY (pfkidperfil_administrador);

ALTER TABLE certificado 
ADD CONSTRAINT pk_certificado 
PRIMARY KEY (id_certificado);

ALTER TABLE modulo 
ADD CONSTRAINT pk_modulo
PRIMARY KEY (id_modulo);

ALTER TABLE simulacion 
ADD CONSTRAINT pk_simulacion 
PRIMARY KEY (id_simulacion);

ALTER TABLE progresosimulacion 
ADD CONSTRAINT pk_progresosimulacion 
PRIMARY KEY (id_progresosimulacion);

ALTER TABLE quiz 
ADD CONSTRAINT pk_quiz 
PRIMARY KEY (id_quiz);

ALTER TABLE preguntaquiz 
ADD CONSTRAINT pk_preguntaquiz 
PRIMARY KEY (id_preguntaquiz);

ALTER TABLE respuesta 
ADD CONSTRAINT pk_respuesta 
PRIMARY KEY (id_respuesta);

ALTER TABLE progresoquiz 
ADD CONSTRAINT pk_progresoquiz 
PRIMARY KEY (id_progresoquiz);

ALTER TABLE respuestaprogresoquiz 
ADD CONSTRAINT pk_respuestaprogresoquiz 
PRIMARY KEY (fkidprogresoquiz_respuestaprogresoquiz, fkidpreguntaquiz_respuestaprogresoquiz,fkidrespuesta_respuestaprogresoquiz);

/*---------------------------LLAVES FORANEAS-------------------------*/

ALTER TABLE usuario 
ADD CONSTRAINT fkusuario_perfil
FOREIGN KEY (pfkidperfil_usuario)
REFERENCES perfil(id_perfil);

ALTER TABLE administrador
ADD CONSTRAINT fkadministrador_perfil
FOREIGN KEY (pfkidperfil_administrador)
REFERENCES perfil(id_perfil);

ALTER TABLE certificado 
ADD CONSTRAINT fkcertificado_usuario
FOREIGN KEY (fkidusuario_certificado)
REFERENCES usuario(pfkidperfil_usuario);

ALTER TABLE modulo 
ADD CONSTRAINT fkmodulo_administrador
FOREIGN KEY (fkidadministrador_modulo)
REFERENCES administrador(pfkidperfil_administrador);

ALTER TABLE simulacion 
ADD CONSTRAINT fksimulacion_modulo
FOREIGN KEY (fkidmodulo_simulacion)
REFERENCES modulo(id_modulo);

ALTER TABLE progresosimulacion 
ADD CONSTRAINT fkprogresosimulacion_usuario
FOREIGN KEY (fkidusuario_progresosimulacion)
REFERENCES usuario(pfkidperfil_usuario);

ALTER TABLE progresosimulacion 
ADD CONSTRAINT fkprogresosimulacion_simulacion
FOREIGN KEY (fkidsimulacion_progresosimulacion)
REFERENCES simulacion(id_simulacion);

ALTER TABLE quiz
ADD CONSTRAINT fkquiz_modulo
FOREIGN KEY (fkidmodulo_quiz)
REFERENCES modulo (id_modulo);

ALTER TABLE preguntaquiz
ADD CONSTRAINT fkpregunta_quiz
FOREIGN KEY (fkidquiz_preguntaquiz)
REFERENCES quiz (id_quiz);

ALTER TABLE respuesta
ADD CONSTRAINT fkrespuesta_preguntaquiz
FOREIGN KEY (fkidpreguntaquiz_respuesta)
REFERENCES preguntaquiz (id_preguntaquiz);

ALTER TABLE progresoquiz
ADD CONSTRAINT fkprogresoquiz_usuario
FOREIGN KEY (fkidusuario_progresoquiz)
REFERENCES usuario(pfkidperfil_usuario);

ALTER TABLE progresoquiz 
ADD CONSTRAINT fk_progresoquiz_quiz
FOREIGN KEY (fkidquiz_progresoquiz)
REFERENCES quiz(id_quiz);

ALTER TABLE respuestaprogresoquiz 
ADD CONSTRAINT ffkrespuestaprogresoquiz_progresoquiz
FOREIGN KEY (fkidprogresoquiz_respuestaprogresoquiz)
REFERENCES progresoquiz(id_progresoquiz);

ALTER TABLE respuestaprogresoquiz 
ADD CONSTRAINT fkrespuestaprogresoquiz_preguntaquiz
FOREIGN KEY (fkidpreguntaquiz_respuestaprogresoquiz)
REFERENCES preguntaquiz(id_preguntaquiz);

ALTER TABLE respuestaprogresoquiz 
ADD CONSTRAINT fkrespuestaprogresoquiz_respuesta
FOREIGN KEY (fkidrespuesta_respuestaprogresoquiz)
REFERENCES respuesta(id_respuesta);

