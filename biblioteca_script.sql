CREATE DATABASE IF NOT EXISTS biblioteca;
-- DROP DATABASE IF EXISTS biblioteca;
USE biblioteca;
CREATE TABLE IF NOT EXISTS libros (
id_libro int AUTO_INCREMENT NOT NULL PRIMARY KEY, 
titulo_libro  varchar(100) NOT NULL,
id_autor int not null,
editorial varchar(50) not null,
ejemplares_stock SMALLINT
-- PRIMARY KEY (id_libro)libroslibros
);

INSERT INTO autores VALUES (1, "Jules", "Verne" );
INSERT INTO autores(nombre_autor,apellido_autor)
VALUES ("Isaac","Asimov"),("Stanislaw","Lem");
INSERT INTO autores(nombre_autor,apellido_autor)
VALUES ("Stephen","King");

SELECT * FROM autores; 
-- obtener los nombres de los autores que empiezan por S
SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "S%";

-- Obtener los autores cuyo nombre contiene 5 letras

SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "_____";

-- Obtener cantidad de autores
SELECT COUNT(*) as "cantidad de autores"
FROM autores;

INSERT INTO autores(nombre_autor,apellido_autor)
VALUES ("Pepe","Vargas Llosa");

UPDATE autores SET nombre_autor = "Mario" WHERE apellido_autor ="Vargas Llosa";
DELETE FROM autores WHERE apellido_autor = "Vargas LLosa";

-- Ordenar alfabéticamente
SELECT CONCAT_WS(", ",UPPER(apellido_autor), nombre_autor) as autor 
FROM autores
ORDER BY apellido_autor
LIMIT 1
;

DESCRIBE libros;
DESCRIBE autores_libros;

ALTER TABLE libros
DROP COLUMN id_autor;

INSERT INTO libros (titulo_libro, editorial, ejemplares_stock) 
VALUES ( "La vuelta al mundo en 80 días", "Taurus", 5),
("De la Tierra a la luna", "Taurus", 3),
("Yo, robot", "Gredos", 3),
("Solaris", "Alfaguara",5);

INSERT INTO autores_libros(id_autor, id_libro) VALUES
(1,1), (1,2), (2,3), (3,4);

CREATE TABLE editoriales (
id_editorial int AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_editorial varchar(50) NOT NULL ,
id_poblacion int NOT NULL
);

-- DROP TABLE poblaciones;

CREATE TABLE IF NOT EXISTS poblaciones (
id_poblacion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
poblacion varchar(25)
);

ALTER TABLE editoriales
DROP COLUMN id_poblacion;

-- Obtener solo las editoriales de la tabla libros
INSERT INTO editoriales(nombre_editorial)
SELECT DISTINCT editorial FROM libros; 

-- Añadir la columna id_editorial a la tabla libros
ALTER TABLE libros
ADD COLUMN id_editorial INT NOT NULL;

UPDATE libros l, editoriales e 
SET l.id_editorial = e.id_editorial
WHERE l.editorial = e.nombre_editorial;

ALTER TABLE libros
DROP COLUMN editorial;

INSERT INTO poblaciones(poblacion) VALUES ("Barcelona"),("Madrid"),("Cornellà"), ("París");

ALTER TABLE editoriales
ADD COLUMN id_poblacion INT NOT NULL;

SELECT SUM(ejemplares_stock) as stock_total FROM libros;

-- Sistema simple pero NO recomendado
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l, editoriales e 
WHERE l.id_editorial = e.id_editorial;

-- Sistema de vinculación recomendado
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l
JOIN editoriales e
ON l.id_editorial = e.id_editorial;

SELECT l.titulo_libro, e.nombre_editorial
FROM libros l
NATURAL JOIN editoriales e;

SELECT e.nombre_editorial, p.poblacion
FROM editoriales e
NATURAL JOIN poblaciones p;

-- Nombre del autor, titulo del libro, editorial, poblacion

SELECT a.nombre_autor , l.titulo_libro , e.nombre_editorial , p.poblacion
FROM autores a
NATURAL JOIN autores_libros al
NATURAL JOIN libros l
NATURAL JOIN editoriales e
NATURAL JOIN poblaciones p;

-- Todos los autores que no tengan libro
SELECT a.nombre_autor , l.titulo_libro
FROM autores a
LEFT JOIN autores_libros al
ON a.id_autor = al.id_autor
LEFT JOIN libros l
ON l.id_libro = al.id_libro
WHERE l.titulo_libro IS NULL;

-- Poblaciones que no tengan editorial
SELECT p.poblacion ,e.nombre_editorial
FROM poblaciones p
LEFT JOIN editoriales e
ON p.id_poblacion = e.id_poblacion
WHERE e.nombre_editorial IS NULL;

CREATE TABLE usuarios (
id_usuario int NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_usuario varchar(20) NOT NULL,
apellido_usuario varchar(50) NOT NULL,
fecha_nacimiento DATE,
carnet_biblio INT UNIQUE NOT NULL,
fecha_inscripcion timestamp DEFAULT CURRENT_TIMESTAMP
);

SELECT FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 as carnet;

INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio)
VALUES ("Steve","Jobs","1955-02-04", FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 ) ,
("Letizia","Ortiz","1968-06-30", FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 ),
("Peter","Parker","2000-03-11", FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 ),
("Clark","Kent","1989-09-11", FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 ),
("Lois","Lane","1989-10-06", FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 );

CREATE TABLE prestamos (
id_prestamos int NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_usuario int NOT NULL,
id_libro int NOT NULL,
fecha_prestamo timestamp DEFAULT CURRENT_TIMESTAMP,
fecha_devolucion timestamp 
);

-- 123,12,1
INSERT INTO prestamos (id_usuario, id_libro) VALUES
(1,1), (1,2), (1,3), (2,1), (2,2), (3,1);

-- Obtener los préstamos de los libros prestados
SELECT l.titulo_libro, COUNT(p.id_libro) as prestamos
FROM libros l 
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING prestamos = 1;

INSERT INTO prestamos(id_usuario, id_libro) VALUES (4,4);

-- Obtener los libros con menor cantidad de préstamos
SELECT COUNT(p.id_libro) as minima_cantidad
FROM prestamos p
GROUP BY p.id_libro
ORDER BY minima_cantidad ASC
LIMIT 1; 

SELECT l.titulo_libro
FROM libros l
NATURAL JOIN prestamos P
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = (
	SELECT COUNT(p.id_libro) as minima_cantidad
    FROM prestamos p
    GROUP BY p.id_libro
    ORDER BY minima_cantidad ASC
    LIMIT 1
)
; 

-- 06/05/2025
-- PROCEDIMIENTO ALMACENADO
use biblioteca;
DELIMITER $$ 
CREATE PROCEDURE insertUsuario (p_nombre varchar(20),p_apellido varchar(50), p_fecha_nacimiento date)
BEGIN
INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio)
VALUES (p_nombre,p_apellido,p_fecha_nacimiento, FLOOR(RAND()*(99999999 - 10000000 + 1)) + 10000000 ) ;

END $$
DELIMITER ;-- importante el espacio entre DELIMITER y ;

CALL insertUsuario ("Bruce","Wayne","1998-06-09");

-- PROCEDIMIENTO ALMACENADO (Store Procedure -> SP)
-- Insercióncompleta de un libro
DELIMITER //
CREATE PROCEDURE insertLibro (
p_titulo_libro varchar(100),
 p_ejemplares_stock smallint,
 p_nombre_editorial varchar(50),
 p_poblacion varchar(25),
 p_nombre_autor varchar(50),
 p_apellido_autor varchar(100),
 p_epoca varchar(20)
 )
BEGIN

-- SET @id_poblacion = (SELECT id_poblacion FROM poblaciones WHERE poblacion = p_poblacion);-- variable global

-- definir variable local
DECLARE v_id_poblacion int;
DECLARE v_id_editorial int;
DECLARE v_id_libro int; 
DECLARE v_id_epoca int;
/* Encontrar el id de la pòblacion */ 
SELECT id_poblacion INTO v_id_poblacion FROM poblaciones WHERE poblacion = p_poblacion;
/* Encontrar el id de la editorial */ 
SELECT id_editorial INTO v_id_editorial FROM editoriales WHERE nombre_editorial = p_nombre_editorial;
/* Encontrar el id del libro */ 
SELECT id_libro INTO v_id_libro FROM libros WHERE titulo_libro = p_titulo_libro;
/* Encontrar el id de la epoca */
SELECT id_epoca INTO v_id_epoca FROM epocas WHERE epoca = p_epoca;


IF v_id_poblacion IS NULL THEN 
	INSERT INTO poblaciones (poblacion) VALUES(p_poblacion);
    SELECT id_poblacion INTO v_id_poblacion FROM poblaciones WHERE poblacion = p_poblacion;
END IF;

IF v_id_editorial IS NULL THEN 
	INSERT INTO editoriales (nombre_editorial,id_poblacion) VALUES(p_nombre_editorial,v_id_poblacion);
	SELECT id_editorial INTO v_id_editorial FROM editoriales WHERE nombre_editorial = p_nombre_editorial;
END IF;
IF v_id_libro IS NULL THEN 
	INSERT INTO libros (titulo_libro, ejemplares_stock,id_editorial) VALUES(p_titulo_libro,p_ejemplares_stock, v_id_editorial);
	SELECT id_libro INTO v_id_libro FROM libros WHERE titulo_libro = p_titulo_libro;
ELSE
	UPDATE libros SET ejemplares_stock = ejemplares_stock + p_ejemplares_stock WHERE id_libro = v_id_libro; 
END IF;
IF v_id_epoca IS NULL THEN
	INSERT INTO epocas (epoca) VALUES(p_epoca);
    SELECT id_epoca INTO v_id_epoca FROM epocas WHERE epoca = p_epoca;
END IF;

END //
DELIMITER ;

CALL insertLibro (
"MySQL",
 5,
 "X",
 "Albacete",
 "A",
 "Pérez",
 "Futuro"
 );
 
 -- 07/05/2025
DROP VIEW IF EXISTS vista_libros;
CREATE VIEW vista_libros AS
SELECT li.titulo_libro, li.ejemplares_stock, au.nombre_autor,au.apellido_autor,ep.epoca,ed.nombre_editorial,po.poblacion
FROM poblaciones po
NATURAL JOIN editoriales ed
NATURAL JOIN libros li
NATURAL JOIN autores_libros al
NATURAL JOIN autores au
NATURAL JOIN epocas ep
ORDER BY li.titulo_libro; 

SELECT * FROM vista_libros; 


DELIMITER $$
-- creación del trigger
CREATE TRIGGER tr_sencillo
-- Si se va a ejecutar antes  (BEFORE) o después (AFTER) de 
-- la acción sobre los datos de la tabla (INSERT, UPDATE, DELETE)
AFTER INSERT ON usuarios 
FOR EACH ROW
BEGIN
SELECT CONCAT_WS(" ", "Se ha añadido el usuario", new.nombre_usuario, new.apellido_usuario);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS tr_disponibilidad;
DELIMITER $$
-- creación del trigger
CREATE TRIGGER tr_disponibilidad
-- Si se va a ejecutar antes  (BEFORE) o después (AFTER) de 
-- la acción sobre los datos de la tabla (INSERT, UPDATE, DELETE)
BEFORE INSERT ON prestamos  
FOR EACH ROW
BEGIN
DECLARE v_stock int; 
DECLARE v_libros_prestados int; 
DECLARE v_prestamos_usuario int;
SELECT COUNT(id_usuario) INTO v_prestamos_usuario FROM prestamos WHERE id_usuario = new.id_usuario;
SELECT COUNT(id_libro) INTO v_libros_prestados FROM prestamos WHERE id_libro = new.id_libro and id_usuario = new.id_usuario;
SELECT ejemplares_stock INTO v_stock FROM libros WHERE id_libro = new.id_libro;

IF v_prestamos_usuario = 2 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=" Ya has hecho 2 préstamos";
END IF;

IF v_libros_prestados = 1 THEN 
	-- funciona como un return 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya tienes el libro prestado";
END IF;

IF v_stock < 1 THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No hay ejemplares disponibles";
ELSE
UPDATE libros SET ejemplares_stock = ejemplares_stock - 1 WHERE id_libro = new.id_libro;
END IF;
END $$
DELIMITER ;

INSERT INTO prestamos ( id_usuario,id_libro) VALUES (5,3);


-- pendiente: incrementar stock al borrar un préstamos
DROP TRIGGER IF EXISTS tr_devolucion;
DELIMITER $$
-- creación del trigger
CREATE TRIGGER tr_devolucion
-- Si se va a ejecutar antes  (BEFORE) o después (AFTER) de 
-- la acción sobre los datos de la tabla (INSERT, UPDATE, DELETE)
AFTER DELETE ON prestamos  
FOR EACH ROW
BEGIN
DECLARE v_stock int; 
SELECT ejemplares_stock INTO v_stock FROM libros WHERE id_libro = old.id_libro;

UPDATE libros SET ejemplares_stock = ejemplares_stock + 1 WHERE id_libro = old.id_libro;
END $$
DELIMITER ;

DELETE FROM prestamos WHERE id_libro = 1 and id_usuario = 1;


-- FUNCION
DROP FUNCTION IF EXISTS fn_prestamos;
DELIMITER $$
CREATE FUNCTION fn_prestamos ( p_titulo varchar(100))
RETURNS int 
DETERMINISTIC 
BEGIN
DECLARE v_prestamos int;
SELECT COUNT(p.id_libro) INTO v_prestamos
FROM prestamos p
NATURAL JOIN libros l 
WHERE l.titulo_libro = p_titulo ;
RETURN v_prestamos;
END $$
DELIMITER ;

SELECT titulo_libro, fn_prestamos (titulo_libro)  as prestamos FROM libros;

-- Los prestamos de libros de cada editorial
-- ordenado de más a menos

DROP FUNCTION IF EXISTS fn_prestamos_editorial;
DELIMITER $$
CREATE FUNCTION fn_prestamos_editorial ( p_editorial varchar(100))
RETURNS int 
DETERMINISTIC 
BEGIN
DECLARE v_prestamos_editorial int;
SELECT COUNT(p.id_libro) INTO v_prestamos_editorial
FROM prestamos p
NATURAL JOIN libros l
NATURAL JOIN editoriales e
WHERE e.nombre_editorial = p_editorial;
RETURN v_prestamos_editorial;
END $$
DELIMITER ;

  
SELECT nombre_editorial, fn_prestamos_editorial (nombre_editorial)  as prestamos FROM editoriales
ORDER BY prestamos ASC;



 
 
 
