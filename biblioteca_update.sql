USE biblioteca;

ALTER TABLE editoriales
ADD CONSTRAINT fk_poblaciones
FOREIGN KEY (id_poblacion)
REFERENCES poblaciones(id_poblacion)
ON DELETE NO ACTION 
ON UPDATE NO ACTION ;

ALTER TABLE prestamos
ADD CONSTRAINT fk_libros_prestamos
FOREIGN KEY (id_libro)
REFERENCES libros(id_libro)
ON DELETE NO ACTION
ON UPDATE NO ACTION,
ADD CONSTRAINT fk_usuarios
FOREIGN KEY (id_usuario)
REFERENCES usuarios(id_usuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE autores
ADD COLUMN id_epoca int NOT NULL;

CREATE TABLE epocas (
id_epoca int PRIMARY KEY AUTO_INCREMENT,
epoca varchar(20) NOT NULL
);

INSERT INTO epocas(epoca) 
VALUES ("s.XX"),("s.XXI"),("S.XIX");

UPDATE autores SET id_epoca = 1;

ALTER TABLE autores
ADD CONSTRAINT fk_epoca
FOREIGN KEY (id_epoca)
REFERENCES epocas(id_epoca)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

INSERT INTO libros (titulo_libro, ejemplares_stock, id_editorial)
VALUES ('Python' , 20,1 ), ('HTML',10,1), ( 'CSS',1,1);

SELECT * FROM libros where ejemplares_stock BETWEEN 1 and 5;
SELECT * FROM libros where ejemplares_stock >= 1 and ejemplares_stock <=5;

-- Títulos de libros en préstamo a usuarios cuyo nombre empieza por S o por L
-- y el nombre del usuario 

SELECT l.titulo_libro , u.nombre_usuario, u.apellido_usuario 
FROM usuarios u
NATURAL JOIN prestamos p
NATURAL JOIN libros l
WHERE u.nombre_usuario LIKE 'S%' or u.nombre_usuario LIKE 'L%';

-- Usuarios  que han tomado prestado más de un libro

SELECT u.nombre_usuario, u.apellido_usuario
FROM usuarios u 
NATURAL JOIN prestamos p
GROUP BY p.id_usuario 
HAVING COUNT( p.id_usuario) > 1; 

-- Cuál o cuáles son los títulos de libros más prestado
-- 1era consulta: quiero saber cuál es la cantidad mayor de préstamos de un libro

SELECT COUNT(p.id_libro) as maximo 
FROM prestamos p
GROUP BY p.id_libro
ORDER BY maximo DESC
LIMIT 1;

-- 2da consulta: y cuál o cuáles son los libros

SELECT  l.titulo_libro
FROM libros l
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = (
SELECT COUNT(p.id_libro) as maximo 
FROM prestamos p
GROUP BY p.id_libro
ORDER BY maximo DESC
LIMIT 1
);

INSERT INTO prestamos(id_usuario,id_libro) VALUES (5,2);

