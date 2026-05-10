/*indice simple (B-Tree)*/
CREATE INDEX idx_employees_email
ON employees(email);


/*indice unico*/
CREATE UNIQUE INDEX idx_employees_email
ON employees(email);


/*indice compuesto*/
/*si se consulta el nombre y el apellido
quedan en orden lexocografico*/
CREATE INDEX idx_employees_firstnamelastname
ON employees(first_name, last_name);


/*PARA DESHABILITAR UN INDICE*/
ALTER INDEX idx_employees_email UNSABLE;


/*PARA HABILITAR UN INDICE*/
ALTER INDEX idx_employees_email REBUILD;


/*PARA VER LOS INDICES*/
SELECT INDEX_NAME FROM ALL_INDEXES WHERE TABLE_NAME = 'employees';

/*INDICE DURANTE LA CREACION DE UNA TABLA*/

CREATE TABLE ejemplo(
    idejemplo INT NOT NULL PRIMARY KEY USING INDEX(
        CREATE INDEX idx_ejemplo ON ejemplo(idejemplo)
    ),
    texto VARCHAR2(20)
);

/*
Bitmap Index
Usa un mapa de bits por cada valor distinto. 
Ideal para columnas de baja cardinalidad (pocos valores únicos).
Muy eficiente en data warehouses con consultas analíticas.
No recomendado para OLTP (muchas escrituras concurrentes).
*/
-- Ideal para columnas como: estado, género, región, categoría
CREATE BITMAP INDEX idx_emp_estado
ON empleados (estado);


/*
Function-Based Index (Índice Basado en Función)
Indexa el resultado de una función o expresión, 
no el valor crudo de la columna. 
Útil para búsquedas insensibles a mayúsculas/minúsculas.
*/

CREATE INDEX idx_emp_apellido_upper
ON empleados (UPPER(apellido));

-- Ahora esta query usa el índice:
SELECT * FROM empleados 
WHERE UPPER(apellido) = 'GARCÍA';

/*
 Partitioned Index
Índices sobre tablas particionadas.
Pueden ser locales (un índice por partición)
o globales (un índice para toda la tabla).
*/

-- Tabla particionada por rango
CREATE TABLE ventas (
    venta_id   NUMBER,
    fecha      DATE,
    monto      NUMBER
)
PARTITION BY RANGE (fecha) (
    PARTITION p2023 VALUES LESS THAN (DATE '2024-01-01'),
    PARTITION p2024 VALUES LESS THAN (DATE '2025-01-01'),
    PARTITION p2025 VALUES LESS THAN (DATE '2026-01-01')
);

-- Índice LOCAL (un segmento por partición — más mantenible)
CREATE INDEX idx_ventas_fecha_local
ON ventas (fecha) LOCAL;

-- Índice GLOBAL (atraviesa todas las particiones)
CREATE INDEX idx_ventas_monto_global
ON ventas (monto) GLOBAL;

/*
Invisible Index
El índice existe y se mantiene actualizado,
pero el optimizador no lo usa (a menos que se indique).
Útil para probar un índice antes de activarlo en producción.
*/

-- Crear índice invisible
CREATE INDEX idx_emp_telefono
ON empleados (telefono) INVISIBLE;

-- Forzar uso en sesión específica (para pruebas)
ALTER SESSION SET OPTIMIZER_USE_INVISIBLE_INDEXES = TRUE;

-- Hacer visible cuando esté validado
ALTER INDEX idx_emp_telefono VISIBLE;