-------------------------------------------------------------
-------------------- CREAR BASE DE DATOS --------------------
-------------------------------------------------------------
CREATE DATABASE Corredor_de_Propiedades
Use Corredor_de_Propiedades;

-------------------------------------------------------------
-------------------- CREACION DE TABLAS ---------------------
------------DDL (Lenguaje en definici�n de datos)------------
-------------------------------------------------------------

-- Comuna --
CREATE TABLE COMUNA(
    cod_comuna INT NOT NULL,
    nombre_comuna VARCHAR(25) NOT NULL,
    PRIMARY KEY(cod_comuna),
    CHECK (LEN(nombre_comuna) > 9) -- Nombre_comuna debe tener mayor a 10 caracteres de largo (Cerro Navia)
);

ALTER TABLE SECTOR
ALTER COLUMN cod_comuna INT NOT NULL;

ALTER TABLE SECTOR
ALTER COLUMN nombre_sector VARCHAR(30) NOT NULL;

ALTER TABLE COMUNA
DROP CONSTRAINT CK__COMUNA__nombre_c__37A5467C;

ALTER TABLE COMUNA
ADD CONSTRAINT CK__COMUNA__nombre_c__37A5467C CHECK (LEN(nombre_comuna) > 9);



-- Sector --
CREATE TABLE SECTOR(
    cod_sector INT NOT NULL,
    nombre_sector VARCHAR(30) NOT NULL,
    cod_comuna INT NOT NULL,
    PRIMARY KEY(cod_sector),
	FOREIGN KEY(cod_comuna) REFERENCES COMUNA(cod_comuna),
    CHECK (LEN(nombre_sector) > 5) -- Nombre_sector debe ser mayor a 5 caracteres de largo (La Vega)
);

ALTER TABLE SECTOR
ADD CONSTRAINT FK_SECTOR_COMUNA
FOREIGN KEY (cod_comuna) REFERENCES COMUNA(cod_comuna);


-- Propiedad --
CREATE TABLE PROPIEDAD(
    cod_propiedad INT NOT NULL,
    calle VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    precio_arriendo DECIMAL(10,2) NOT NULL CHECK (precio_arriendo > 50000), -- Precio debe ser mayor a 0 ej: 5,900,000,000.00
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Disponible', 'Arrendada')), -- Estado debe ser 'Disponible' o 'Arrendada'
    cod_ubicacion INT NOT NULL,
    PRIMARY KEY(cod_propiedad), 
    FOREIGN KEY(cod_ubicacion) REFERENCES SECTOR(cod_sector)
);

-- Arrendatario --
CREATE TABLE ARRENDATARIO (
    cod_arrendatario INT NOT NULL,
    nombre_arrendatario VARCHAR(30) NOT NULL,
    rut_arrendatario VARCHAR(12) NOT NULL,
    renta DECIMAL(10,2) NOT NULL CHECK (renta > 50000), -- La renta debe ser mayor a 50000
    PRIMARY KEY(cod_arrendatario),
    CHECK (LEN(rut_arrendatario) = 12) -- Aseguramos que el RUT tenga 12 caracteres
);

-- Propietario --
CREATE TABLE PROPIETARIO(
    cod_propietario INT NOT NULL,
    nombre_propietario VARCHAR(30) NOT NULL,
    rut_propietario VARCHAR(12) UNIQUE NOT NULL, -- RUT �nico
    renta DECIMAL(10,2) NOT NULL CHECK (renta > 50000), -- La renta debe ser mayor a 50000
    PRIMARY KEY(cod_propietario),
    CHECK (LEN(rut_propietario) = 12) -- Verificar RUT tenga 12 caracteres
);

-- Visitas de propiedad --
CREATE TABLE VISITAS_PROPIEDAD(
    cod_visitas INT NOT NULL,
    cod_propiedad INT NOT NULL,
    nombre_visita VARCHAR(25) NOT NULL,
    rut_visita VARCHAR(12) NOT NULL, -- 12.345.678-9
    fecha_hora DATETIME NOT NULL, -- Fechas y horas combinadas
    PRIMARY KEY(cod_visitas),
    FOREIGN KEY (cod_propiedad) REFERENCES PROPIEDAD(cod_propiedad),
    CHECK (LEN(rut_visita) = 12) -- Verificar RUT tenga 12 caracteres
);

-- Reparaciones --
CREATE TABLE REPARACIONES(
    cod_reparaciones INT NOT NULL,
    descripciones VARCHAR(100) NOT NULL,
    fecha_reparacion DATE NOT NULL,
    costo DECIMAL(10,2) NOT NULL CHECK (costo >= 50000),
    cod_propiedad INT NOT NULL,
    PRIMARY KEY(cod_reparaciones),
    FOREIGN KEY(cod_propiedad) REFERENCES PROPIEDAD(cod_propiedad)
);
--Aca se cambia de antes costo > 50000, a costo >= 50000--
ALTER TABLE REPARACIONES
DROP CONSTRAINT CK__REPARACIO__costo__4E88ABD4;

ALTER TABLE REPARACIONES
ADD CONSTRAINT CK__REPARACIO__costo__4E88ABD4
CHECK (costo >= 50000);

-- Arriendo --
CREATE TABLE ARRIENDO(
    cod_arriendo INT NOT NULL,
    fecha_inicio_arriendo DATE NOT NULL,
    fecha_termino_arriendo DATE NOT NULL,
    costo_final_arriendo DECIMAL(10,2) NOT NULL CHECK (costo_final_arriendo > 50000),
    cod_propiedad INT NOT NULL,
    cod_propietario INT NOT NULL,
    cod_arrendatario INT NOT NULL,
    PRIMARY KEY(cod_arriendo),
    FOREIGN KEY (cod_propiedad) REFERENCES PROPIEDAD(cod_propiedad),
    FOREIGN KEY (cod_propietario) REFERENCES PROPIETARIO(cod_propietario),
    FOREIGN KEY (cod_arrendatario) REFERENCES ARRENDATARIO(cod_arrendatario)
);

-- Pagos de arriendo --
CREATE TABLE PAGOS_ARRIENDO (
    cod_pago INT NOT NULL,
    cod_arriendo INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto_pago DECIMAL(10,2) NOT NULL CHECK (monto_pago > 50000),
    estado_pago VARCHAR(20) NOT NULL CHECK (estado_pago IN ('Pagado', 'Pendiente')),
    PRIMARY KEY(cod_pago),
    FOREIGN KEY (cod_arriendo) REFERENCES ARRIENDO(cod_arriendo)
);


--------------------------------------------------------------
-------------------- INTERSECCION DE DATOS -------------------
----------DML (Lenguaje de manipulaci�n de datos--------------
--------------------------------------------------------------

--COMUNA--
INSERT INTO COMUNA (cod_comuna, nombre_comuna) 
VALUES
(11, 'Cerro Navia'), 
(22, 'La Florida'), 
(33, 'Las Condes'), 
(44, 'Lo Barnechea'), 
(55, 'Providencia');

--SECTOR--
INSERT INTO SECTOR (cod_sector, nombre_sector, cod_comuna) 
VALUES
(10, 'Sector Central', 11),
(20, 'Sector Norte', 22),
(30, 'Sector Sur', 33),
(40, 'Sector Oriente', 44),
(50, 'Sector Poniente', 55),
(60, 'La Vega Chica', 11),
(70, 'Los Jardines', 33),
(80, 'Villa Hermosa', 44),
(90, 'El Mirador', 55);

--PROPIEDAD--
INSERT INTO PROPIEDAD (cod_propiedad, calle, numero, precio_arriendo, estado, cod_ubicacion) 
VALUES
(12, 'Av. Las Torres', 101, 800000.00, 'Disponible', 10),
(23, 'Calle Independencia', 202, 950000.00, 'Arrendada', 20),
(34, 'Av. Providencia', 303, 1200000.00, 'Disponible', 30),
(45, 'Calle Los Pinos', 404, 650000.00, 'Arrendada', 40),
(56, 'Calle Irarrazabal', 505, 750000.00, 'Disponible', 50),
(67, 'Calle Bellavista', 606, 820000.00, 'Disponible', 60);

--ARRENDATARIO--
INSERT INTO ARRENDATARIO (cod_arrendatario, nombre_arrendatario, rut_arrendatario, renta) 
VALUES
(13, 'Juan Perez', '12.345.678-9', 1500000.00),
(24, 'Carla Reyes', '98.765.432-1', 1300000.00),
(35, 'Pedro Gomez', '11.111.111-1', 1400000.00),
(46, 'Ana Diaz', '22.222.222-2', 1700000.00),
(57, 'Luis Lopez', '33.333.333-3', 1600000.00),
(68, 'Miguel Sanchez', '44.444.444-4', 1550000.00);

--PROPIETARIO--
INSERT INTO PROPIETARIO (cod_propietario, nombre_propietario, rut_propietario, renta) 
VALUES
(14, 'Carlos Gonzalez', '44.444.444-4', 2000000.00),
(25, 'Maria Silva', '55.555.555-5', 2100000.00),
(36, 'Jorge Salinas', '66.666.666-6', 1900000.00),
(47, 'Sofia Mendez', '77.777.777-7', 2200000.00),
(58, 'Patricia Vega', '88.888.888-8', 1800000.00),
(69, 'Alberto Vargas', '99.999.999-9', 2300000.00);

--VISITAS_PROPIEDAD--
INSERT INTO VISITAS_PROPIEDAD (cod_visitas, cod_propiedad, nombre_visita, rut_visita, fecha_hora) 
VALUES
(15, 12, 'Miguel Fernandez', '99.999.999-9', '2024-10-10 14:30:00'),
(26, 23, 'Jose Gonzalez', '12.312.312-3', '2024-10-11 09:45:00'),
(37, 34, 'Paula Nu�ez', '98.798.798-7', '2024-10-12 11:15:00'),
(48, 45, 'Ricardo Fuentes', '32.132.132-1', '2024-10-13 15:00:00'),
(59, 56, 'Lucia Morales', '21.321.321-3', '2024-10-14 13:00:00'),
(60, 67, 'Felipe Cruz', '33.344.455-6', '2024-10-15 16:00:00');

--REPARACIONES--
INSERT INTO REPARACIONES (cod_reparaciones, descripciones, fecha_reparacion, costo, cod_propiedad) 
VALUES
(16, 'Falla en las tuberias del ba�o', '2024-09-10', 100000.00, 12),
(27, 'Reparaci�n del Port�n Frontal', '2024-09-15', 150000.00, 23),
(38, 'Obstrucci�n en las Tuberias del Gas', '2024-09-20', 120000.00, 34),
(49, 'Arreglo el�ctrico del medidor', '2024-09-25', 200000.00, 45),
(60, 'Reparaci�n de ventanas', '2024-09-30', 80000.00, 56),
(61, 'Cambio de pisos', '2024-10-05', 50000.00, 67);

UPDATE REPARACIONES
SET costo = 50000.00
WHERE cod_reparaciones = 61;


--ARRIENDO--
INSERT INTO ARRIENDO (cod_arriendo, fecha_inicio_arriendo, fecha_termino_arriendo, costo_final_arriendo, cod_propiedad, cod_propietario, cod_arrendatario) 
VALUES
(17, '2024-10-01', '2025-10-01', 950000.00, 12, 14, 13),
(28, '2024-09-01', '2025-09-01', 900000.00, 23, 25, 24),
(39, '2024-08-01', '2025-08-01', 1000000.00, 34, 36, 35),
(50, '2024-07-01', '2025-07-01', 850000.00, 45, 47, 46),
(61, '2024-06-01', '2025-06-01', 1200000.00, 56, 58, 57),
(62, '2024-05-01', '2025-05-01', 1150000.00, 67, 69, 68);

--PAGOS_ARRIENDO--
INSERT INTO PAGOS_ARRIENDO (cod_pago, cod_arriendo, fecha_pago, monto_pago, estado_pago) 
VALUES
(18, 17, '2024-10-05', 950000.00, 'Pagado'),
(29, 28, '2024-09-05', 900000.00, 'Pendiente'),
(40, 39, '2024-08-05', 1000000.00, 'Pagado'),
(51, 50, '2024-07-05', 850000.00, 'Pagado'),
(62, 61, '2024-06-05', 1200000.00, 'Pendiente'),
(63, 62, '2024-05-05', 1150000.00, 'Pagado');


-------------------------------------------------------------
----------------------- CONSULTAS ---------------------------
-------------------------------------------------------------

--------------------- CONSULTAS SIMPLES ----------------------

--|1|Consulta para listar todas las tablas--
SELECT * FROM ARRENDATARIO;
SELECT * FROM ARRIENDO;
SELECT * FROM COMUNA;
SELECT * FROM PAGOS_ARRIENDO;
SELECT * FROM PROPIEDAD
SELECT * FROM PROPIETARIO;
SELECT * FROM REPARACIONES;
SELECT * FROM SECTOR;
SELECT * FROM VISITAS_PROPIEDAD;

--|2|Obtener todas las comunas que tienen más de 10 caracteres en su nombre--
SELECT * FROM COMUNA
WHERE LEN(nombre_comuna) > 10;

--|3|Obtener todas las propiedades que están disponibles
SELECT * FROM PROPIEDAD
WHERE estado = 'Disponible';

--|4|Listar los arrendatarios con renta mayor a $1 000 000--
SELECT nombre_arrendatario, renta
FROM ARRENDATARIO WHERE renta > 1000000.00;

--|5|Listar los propietarios con renta mayor a $2 000 000--
SELECT nombre_propietario, renta
FROM PROPIETARIO WHERE renta > 2000000.00;

--|6|Obtener todas las propiedades cuyo precio de arriendo sea mayor a 900000
SELECT * FROM PROPIEDAD
WHERE precio_arriendo > 900000;

--|7|Mostrar el costo total de reparaciones en una propiedad espec�fica--
SELECT SUM(costo) AS costo_total_reparaciones
FROM REPARACIONES
WHERE cod_propiedad = (SELECT cod_propiedad FROM PROPIEDAD WHERE calle = 'Av. Providencia');

--|8|Obtener los sectores que contienen la palabra 'Vega'
SELECT * FROM SECTOR
WHERE nombre_sector LIKE '%Vega%';

--|9|Listar todos los pagos de arriendo pendientes--
SELECT PA.cod_pago, PA.fecha_pago, PA.monto_pago FROM PAGOS_ARRIENDO PA
WHERE PA.estado_pago = 'Pendiente';

--|10|Contar cuántas propiedades tienen un precio de arriendo mayor a 600000
SELECT COUNT(*) AS TotalPropiedades
FROM PROPIEDAD
WHERE precio_arriendo > 600000;

--|11|Listar los propietarios que tienen una renta mayor a 2000000 o cuyo RUT comienza con '88'
SELECT * FROM PROPIETARIO
WHERE renta > 2000000 OR rut_propietario LIKE '88%';

--|12|Obtener las reparaciones cuyo costo es mayor o igual a 150000
SELECT * FROM REPARACIONES
WHERE costo >= 150000;

--|13|Listar las propiedades arrendadas que tienen un costo final de arriendo menor a 1000000
SELECT cod_arriendo,costo_final_arriendo,cod_propietario,cod_propietario FROM ARRIENDO
WHERE costo_final_arriendo < 1000000;

--|14|Obtener todos los arrendatarios cuyo nombre contiene la letra 'i'
SELECT * FROM ARRENDATARIO
WHERE nombre_arrendatario LIKE '%i%';

--|15|Obtener la información de las propiedades que están arrendadas y cuyo precio de arriendo es mayor a 700000
SELECT * FROM PROPIEDAD
WHERE estado = 'Arrendada' AND precio_arriendo > 700000;

--|16|Obtener la suma de todas las rentas de propietarios--
SELECT SUM(renta) AS total_renta_propietarios FROM PROPIETARIO;

--|17|Obtener la suma de todas las rentas de arrendatarios--
SELECT SUM(renta) AS total_renta_arrendatarios FROM ARRENDATARIO;

--|18|Obtener todas las propiedades en un sector específico con código 10
SELECT * FROM PROPIEDAD
WHERE cod_ubicacion = 10;

--|19|Obtener los pagos realizados despu�s de una fecha espec�fica--
SELECT PA.cod_pago, PA.fecha_pago, PA.monto_pago
FROM PAGOS_ARRIENDO PA
WHERE PA.fecha_pago > '2024-08-01';

--|20|Obtener el nombre de arrendatarios cuya renta está entre 1500000 y 1800000
SELECT * FROM ARRENDATARIO
WHERE renta BETWEEN 1500000 AND 1800000;


--------------------- CONSULTAS Anidadas/Intersecciones ----------------------


--|1|Propiedades con m�s de 2 visitas realizadas--
SELECT P.calle, P.numero, COUNT(VP.cod_visitas) AS total_visitas
FROM PROPIEDAD P
LEFT JOIN VISITAS_PROPIEDAD VP ON VP.cod_propiedad = P.cod_propiedad
GROUP BY P.calle, P.numero
HAVING COUNT(VP.cod_visitas) > 2;
--si es >0 sale en total_visitas como 1, lo cual en >2 es 0 ninguna

--|2|Lista de propietarios que tienen m�s de una propiedad arrendada--
SELECT PR.nombre_propietario, COUNT(DISTINCT P.cod_propiedad) AS total_propiedades
FROM PROPIETARIO PR
LEFT JOIN ARRIENDO AR ON PR.cod_propietario = AR.cod_propietario
LEFT JOIN PROPIEDAD P ON AR.cod_propiedad = P.cod_propiedad
WHERE P.estado = 'Arrendada'
GROUP BY PR.nombre_propietario
HAVING COUNT(DISTINCT P.cod_propiedad) > 1;


--VERIFICAR PARA EL |2|
SELECT *
FROM PROPIEDAD P
WHERE P.estado = 'Arrendada';

SELECT PR.nombre_propietario, P.cod_propiedad
FROM PROPIETARIO PR
JOIN ARRIENDO AR ON PR.cod_propietario = AR.cod_propietario
JOIN PROPIEDAD P ON AR.cod_propiedad = P.cod_propiedad
WHERE P.estado = 'Arrendada';

--|3|Calcular el promedio de precios de arriendo por comuna
SELECT C.nombre_comuna, AVG(P.precio_arriendo) AS promedio_precio
FROM COMUNA C
LEFT JOIN SECTOR S ON C.cod_comuna = S.cod_comuna
LEFT JOIN PROPIEDAD P ON S.cod_sector = P.cod_ubicacion
GROUP BY C.nombre_comuna;

--|4|Propiedades arrendadas por arrendatarios con renta mayor a $1 500 000--
SELECT P.calle, P.numero, A.nombre_arrendatario, A.renta
FROM PROPIEDAD P
INNER JOIN ARRIENDO AR ON P.cod_propiedad = AR.cod_propiedad
INNER JOIN ARRENDATARIO A ON AR.cod_arrendatario = A.cod_arrendatario
WHERE A.renta > 1500000.00;

--|5|Obtener las propiedades arrendadas en 'Las Condes' con reparaciones realizadas--
SELECT P.calle, P.numero, R.descripciones, R.fecha_reparacion
FROM COMUNA C
LEFT JOIN SECTOR S ON C.cod_comuna = S.cod_comuna
LEFT JOIN PROPIEDAD P ON S.cod_sector = P.cod_ubicacion
LEFT JOIN REPARACIONES R ON P.cod_propiedad = R.cod_propiedad
WHERE C.nombre_comuna = 'Las Condes' AND P.estado = 'Arrendada';

--VERIFICAR PARA EL |5|
SELECT *
FROM PROPIEDAD P
JOIN SECTOR S ON P.cod_ubicacion = S.cod_sector
JOIN COMUNA C ON S.cod_comuna = C.cod_comuna
WHERE C.nombre_comuna = 'Las Condes';

SELECT *
FROM PROPIEDAD P
JOIN SECTOR S ON P.cod_ubicacion = S.cod_sector
JOIN COMUNA C ON S.cod_comuna = C.cod_comuna
WHERE C.nombre_comuna = 'Las Condes' AND P.estado = 'Arrendada';

--|6|Obtener los arrendatarios con pagos pendientes en propiedades de 'Sector Poniente'--
SELECT A.nombre_arrendatario, PA.monto_pago
FROM ARRENDATARIO A
RIGHT JOIN ARRIENDO AR ON A.cod_arrendatario = AR.cod_arrendatario
RIGHT JOIN PAGOS_ARRIENDO PA ON AR.cod_arriendo = PA.cod_arriendo
RIGHT JOIN PROPIEDAD P ON AR.cod_propiedad = P.cod_propiedad
RIGHT JOIN SECTOR S ON P.cod_ubicacion = S.cod_sector
WHERE S.nombre_sector = 'Sector Poniente' AND PA.estado_pago = 'Pendiente';


--|7|Obtener las propiedades disponibles que han tenido reparaciones recientes--
SELECT P.calle, P.numero, R.descripciones, R.fecha_reparacion
FROM PROPIEDAD P
FULL OUTER JOIN REPARACIONES R ON P.cod_propiedad = R.cod_propiedad
WHERE P.estado = 'Disponible' AND R.fecha_reparacion >= '2024-09-01';

--|8|Obtener los propietarios con propiedades que tienen reparaciones mayores a $100 000--
SELECT P.cod_propiedad, PR.nombre_propietario, R.costo
FROM PROPIETARIO PR
LEFT JOIN ARRIENDO AR ON PR.cod_propietario = AR.cod_propietario
LEFT JOIN PROPIEDAD P ON AR.cod_propiedad = P.cod_propiedad
LEFT JOIN REPARACIONES R ON P.cod_propiedad = R.cod_propiedad
WHERE R.costo > 100000.00;


--|9|Listar los arrendatarios con propiedades en 'Lo Barnechea' y pagos pendientes--
SELECT A.nombre_arrendatario, P.calle, PA.monto_pago
FROM ARRENDATARIO A
JOIN ARRIENDO AR ON A.cod_arrendatario = AR.cod_arrendatario
JOIN PAGOS_ARRIENDO PA ON AR.cod_arriendo = PA.cod_arriendo
JOIN PROPIEDAD P ON AR.cod_propiedad = P.cod_propiedad
JOIN SECTOR S ON P.cod_ubicacion = S.cod_sector
JOIN COMUNA C ON S.cod_comuna = C.cod_comuna
WHERE C.nombre_comuna = 'Lo Barnechea' AND PA.estado_pago = 'Pendiente'; --Esta vacia porque no coincide con Pendiente, solo Pagado

--VERIFICAR PARA EL |9|
SELECT P.cod_propiedad, P.calle, P.numero,
P.precio_arriendo, P.estado, P.cod_ubicacion,
S.cod_sector, S.nombre_sector, C.cod_comuna,
C.nombre_comuna, PA.estado_pago
FROM PROPIEDAD P
JOIN SECTOR S ON P.cod_ubicacion = S.cod_sector
JOIN COMUNA C ON S.cod_comuna = C.cod_comuna
JOIN ARRIENDO AR ON P.cod_propiedad = AR.cod_propiedad
JOIN PAGOS_ARRIENDO PA ON AR.cod_arriendo = PA.cod_arriendo
WHERE C.nombre_comuna = 'Lo Barnechea';

SELECT *
FROM PAGOS_ARRIENDO PA
JOIN ARRIENDO AR ON PA.cod_arriendo = AR.cod_arriendo
JOIN PROPIEDAD P ON AR.cod_propiedad = P.cod_propiedad
JOIN SECTOR S ON P.cod_ubicacion = S.cod_sector
JOIN COMUNA C ON S.cod_comuna = C.cod_comuna
WHERE C.nombre_comuna = 'Lo Barnechea' AND PA.estado_pago = 'Pendiente';

--|10|Obtener el n�mero de propiedades en 'La Florida' con reparaciones mayores a $100 000--
SELECT COUNT(P.cod_propiedad) AS total_propiedades
FROM COMUNA C
LEFT JOIN SECTOR S ON C.cod_comuna = S.cod_comuna
LEFT JOIN PROPIEDAD P ON S.cod_sector = P.cod_ubicacion
LEFT JOIN REPARACIONES R ON P.cod_propiedad = R.cod_propiedad
WHERE C.nombre_comuna = 'La Florida' AND R.costo > 100000.00;

--|11|Obtener (solo una) la propiedad m�s cara en 'Las Condes' que est� disponible--
SELECT TOP 1 P.calle, P.numero, P.precio_arriendo
FROM COMUNA C
LEFT JOIN SECTOR S ON C.cod_comuna = S.cod_comuna
LEFT JOIN PROPIEDAD P ON S.cod_sector = P.cod_ubicacion
WHERE C.nombre_comuna = 'Las Condes' AND P.estado = 'Disponible'
ORDER BY P.precio_arriendo DESC;

--|12|Obtener el pago m�s reciente realizado por el arrendatario 'Luis Lopez'--
SELECT TOP 1 PA.fecha_pago, PA.monto_pago
FROM ARRENDATARIO A
LEFT JOIN ARRIENDO AR ON A.cod_arrendatario = AR.cod_arrendatario
LEFT JOIN PAGOS_ARRIENDO PA ON AR.cod_arriendo = PA.cod_arriendo
WHERE A.nombre_arrendatario = 'Luis Lopez'
ORDER BY PA.fecha_pago DESC;


--|13|Obtener el total de rentas generadas por propiedades en 'Sector Sur'--
SELECT SUM(AR.costo_final_arriendo) AS total_renta
FROM SECTOR S
LEFT JOIN PROPIEDAD P ON S.cod_sector = P.cod_ubicacion
LEFT JOIN ARRIENDO AR ON P.cod_propiedad = AR.cod_propiedad
WHERE S.nombre_sector = 'Sector Sur';


--|14|Obtener el n�mero de visitas realizadas por personas con RUT que empiecen con '21'--
SELECT COUNT(VP.cod_visitas) AS total_visitas
FROM VISITAS_PROPIEDAD VP
WHERE VP.rut_visita LIKE '21%';

--|15|Obtener los arrendatarios con m�s de una propiedad arrendada--
SELECT A.nombre_arrendatario, COUNT(AR.cod_arriendo) AS total_arriendos
FROM ARRENDATARIO A
LEFT JOIN ARRIENDO AR ON A.cod_arrendatario = AR.cod_arrendatario
GROUP BY A.nombre_arrendatario
HAVING COUNT(AR.cod_arriendo) > 1;--si es >0 todos tienen un solo arrendatario, lo cual >1 no hay ninguno

--VERIFICAR PARA EL |15|
SELECT A.nombre_arrendatario, AR.cod_arriendo
FROM ARRIENDO AR
JOIN ARRENDATARIO A ON AR.cod_arrendatario = A.cod_arrendatario;

--|16| Obtener propiedades con pagos pendientes y reparaciones recientes
SELECT P.calle, P.numero, PA.monto_pago, R.fecha_reparacion, R.descripciones
FROM PROPIEDAD P
FULL OUTER JOIN PAGOS_ARRIENDO PA ON P.cod_propiedad = PA.cod_arriendo
FULL OUTER JOIN REPARACIONES R ON P.cod_propiedad = R.cod_propiedad
WHERE PA.estado_pago = 'Pendiente' AND R.fecha_reparacion >= '2024-10-01';