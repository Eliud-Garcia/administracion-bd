/*
################
USANDO MYSQL
################
*/

CREATE DATABASE fisicadatos;

--Creación de tablas en la base de datos.

CREATE TABLE perfil(
	
	id_perfil INT NOT NULL,
	nom1_perfil VARCHAR (12) NOT NULL,
	nom2_perfil VARCHAR (12) NULL,
	apell1_perfil VARCHAR (12) NOT NULL,
	apell2_perfil VARCHAR (12) NULL,
	idioma_perfil VARCHAR (12) NOT NULL,
	temavisual_perfil VARCHAR (12) NOT NULL,
	fechanacimiento_perfil DATE NOT NULL,
	edad_perfil INT NOT NULL,
	correo_perfil VARCHAR (30) NOT NULL,
	contrasena_perfil VARCHAR (12) NOT NULL,
	genero_perfil VARCHAR (9) NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE usuario (

	fkid_perfil INT NOT NULL,
	fechacreacioncuenta_usuario DATE NOT NULL,
	puntableglobal_usuario INT NOT NULL,
	piezasrecolectadas_usuario INT NOT NULL

)  ENGINE = 'INNODB';

CREATE TABLE admin (
	
	fkid_perfil INT NOT NULL,
	fechaultimoingreso_admin DATE NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE certificado (

	id_certificado INT NOT NULL,
	fechaemision_certificado DATE NOT NULL,
	est_certificado VARCHAR (20) NOT NULL,
	desempeno_certificado VARCHAR (20) NOT NULL,
	
	fkid_perfil INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE modulo (

	id_modulo INT NOT NULL,
	nombre_modulo VARCHAR (20) NOT NULL,
	ordensecuencia_modulo INT NOT NULL,
	est_modulo VARCHAR (20) NOT NULL,
	descripcion_modulo VARCHAR (40) NOT NULL,

	fkid_perfil INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE simulacion (
	
	id_simulacion INT NOT NULL,
	nombre_simulacion VARCHAR (20) NOT NULL,
	descripcion_simulacion VARCHAR (40) NOT NULL,
	orden_simulacion INT NOT NULL,
	est_simulacion VARCHAR (20) NOT NULL,
	
	fkid_modulo INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE progresosimulacion (
	
	id_progresosimulacion INT NOT NULL,
	fechaingreso_progresosimulacion DATE NOT NULL,
	fechasalida_progresosimulacion DATE NOT NULL,
	etapa_progresosimulacion VARCHAR (20) NOT NULL,
	
	fkid_perfil INT NOT NULL,
	fkid_simulacion INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE quiz (
	
	id_quiz INT NOT NULL,
	puntaje_quiz INT NOT NULL,
	
	fkid_modulo INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE preguntaquiz (

	id_preguntaquiz INT NOT NULL,
	enunciado_preguntaquiz VARCHAR (40) NOT NULL,

	fkid_quiz INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE estadorespuesta (
	
	id_estadorespuesta INT NOT NULL,
	opcion_estadorespuesta VARCHAR (20) NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE respuesta (

	id_respuesta INT NOT NULL,
	opcion_respuesta VARCHAR (20) NOT NULL,
	
	fkid_estadorespuesta INT NOT NULL,
	fkid_preguntaquiz INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE progresoquiz (
	
	id_progresoquiz INT NOT NULL,
	fechaingreso_progresoquiz DATE NOT NULL,
	fechasalida_progresoquiz DATE NOT NULL,
	est_progresoquiz VARCHAR (20) NOT NULL,
	
	fkid_perfil INT NOT NULL,
	fkid_quiz INT NOT NULL

) ENGINE = 'INNODB';

CREATE TABLE respuestaprogresoquiz (

	fkid_progresoquiz INT NOT NULL,
	fkid_respuesta INT NOT NULL,

	fechaseleccion_respuestaprogresoquiz DATE NOT NULL
	
) ENGINE = 'INNODB';



--**************** LLAVES PRIMARIAS ******************

ALTER TABLE perfil 
ADD CONSTRAINT pk_perfil
PRIMARY KEY (id_perfil);

--creo que toca hacerlo unique para que solo se pueda crear uno
ALTER TABLE usuario 
ADD CONSTRAINT pk_usuario
PRIMARY KEY (fkid_perfil);

ALTER TABLE admin 
ADD CONSTRAINT pk_admin
PRIMARY KEY (fkid_perfil);

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

ALTER TABLE estadorespuesta
ADD CONSTRAINT pk_estadorespuesta
PRIMARY KEY (id_estadorespuesta);

ALTER TABLE respuesta
ADD CONSTRAINT pk_respuesta
PRIMARY KEY (id_respuesta);

ALTER TABLE progresoquiz
ADD CONSTRAINT pk_progresoquiz
PRIMARY KEY (id_progresoquiz);

ALTER TABLE respuestaprogresoquiz 
ADD CONSTRAINT pk_respuestaprogresoquiz 
PRIMARY KEY (fkid_progresoquiz, fkid_respuesta);


--********************** LLAVES FORANEAS ***********************

ALTER TABLE usuario 
ADD CONSTRAINT fkusuario_perfil
FOREIGN KEY (fkid_perfil)
REFERENCES perfil(id_perfil);

ALTER TABLE admin
ADD CONSTRAINT fkadmin_perfil
FOREIGN KEY (fkid_perfil)
REFERENCES perfil(id_perfil);

ALTER TABLE certificado
ADD CONSTRAINT fkcertificado_usuario
FOREIGN KEY (fkid_perfil)
REFERENCES usuario(fkid_perfil);

ALTER TABLE modulo
ADD CONSTRAINT fkmodulo_admin
FOREIGN KEY (fkid_perfil)
REFERENCES admin(fkid_perfil);

ALTER TABLE simulacion
ADD CONSTRAINT fksimulacion_modulo
FOREIGN KEY (fkid_modulo)
REFERENCES modulo(id_modulo);

ALTER TABLE progresosimulacion
ADD CONSTRAINT fkprogresosimulacion_usuario
FOREIGN KEY (fkid_perfil)
REFERENCES usuario(fkid_perfil);

ALTER TABLE progresosimulacion
ADD CONSTRAINT fkprogresosimulacion_simulacion
FOREIGN KEY (fkid_simulacion)
REFERENCES simulacion(id_simulacion);

ALTER TABLE quiz
ADD CONSTRAINT fkquiz_modulo
FOREIGN KEY (fkid_modulo)
REFERENCES modulo(id_modulo);

ALTER TABLE preguntaquiz
ADD CONSTRAINT fkpreguntaquiz_quiz
FOREIGN KEY (fkid_quiz)
REFERENCES quiz(id_quiz);

ALTER TABLE respuesta 
ADD CONSTRAINT fkrespuesta_estadorespuesta
FOREIGN KEY (fkid_estadorespuesta)
REFERENCES estadorespuesta(id_estadorespuesta);

ALTER TABLE respuesta
ADD CONSTRAINT fkrespuesta_preguntaquiz
FOREIGN KEY (fkid_preguntaquiz)
REFERENCES preguntaquiz(id_preguntaquiz);

ALTER TABLE progresoquiz
ADD CONSTRAINT fkprogresoquiz_usuario
FOREIGN KEY (fkid_perfil)
REFERENCES usuario(fkid_perfil);

ALTER TABLE progresoquiz
ADD CONSTRAINT fkprogresoquiz_quiz
FOREIGN KEY (fkid_quiz)
REFERENCES quiz(id_quiz);

ALTER TABLE respuestaprogresoquiz
ADD CONSTRAINT fkrespuestaprogresoquiz_progresoquiz
FOREIGN KEY (fkid_progresoquiz)
REFERENCES progresoquiz(id_progresoquiz);

ALTER TABLE respuestaprogresoquiz
ADD CONSTRAINT fkrespuestaprogresoquiz_respuesta
FOREIGN KEY (fkid_respuesta)
REFERENCES respuesta(id_respuesta);












