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


