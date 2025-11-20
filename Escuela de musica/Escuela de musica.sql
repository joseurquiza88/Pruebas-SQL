-- Ejercicios
-- Primero vemos que tienne las tablas
SELECT nombre FROM alumnos;
SELECT * FROM cursos;
SELECT * FROM inscripciones;

-- ¿Qué curso tiene más inscripciones? Devuelve solo una fila: curso + cantidad.
SELECT inscripciones.id_curso, cursos.nombre, COUNT(inscripciones.id_curso) AS cantidad_alumnos
FROM cursos
INNER JOIN inscripciones
ON cursos.id_curso = inscripciones.id_curso
GROUP BY inscripciones.id_curso, cursos.nombre
ORDER BY cantidad_alumnos DESC
LIMIT 1;

SELECT inscripciones.id_curso, cursos.nombre, COUNT(inscripciones.id_curso) AS cantidad_alumnos
FROM cursos
INNER JOIN inscripciones
ON cursos.id_curso = inscripciones.id_curso
GROUP BY inscripciones.id_curso, cursos.nombre
HAVING COUNT(inscripciones.id_curso) = (
    SELECT COUNT(*)
    FROM inscripciones
    GROUP BY id_curso
    ORDER BY COUNT(*) DESC
    LIMIT 1);


-- ¿Qué alumno se inscribió a más cursos? Devuelve el que más inscripciones hizo.
SELECT alumnos.id_alumno, alumnos.apellido, alumnos.nombre, COUNT(inscripciones.id_alumno) AS cantiadad_incripciones
FROM alumnos
INNER JOIN inscripciones
ON alumnos.id_alumno = inscripciones.id_alumno
GROUP BY alumnos.id_alumno, alumnos.apellido, alumnos.nombre
ORDER BY cantiadad_incripciones
LIMIT 1;

-- Hay muchos con dos cursos, no seria la forma de mostrar los maximos
SELECT alumnos.id_alumno, alumnos.apellido, alumnos.nombre, COUNT(inscripciones.id_alumno) AS cantidad_incripciones
FROM alumnos
INNER JOIN inscripciones
ON alumnos.id_alumno = inscripciones.id_alumno
GROUP BY alumnos.id_alumno, alumnos.apellido, alumnos.nombre
HAVING COUNT(inscripciones.id_alumno) = (
    SELECT COUNT(*)
    FROM inscripciones
    GROUP BY id_alumno
    ORDER BY COUNT(*) DESC
    LIMIT 1);

-- ¿En qué día hubo más inscripciones? Mostrar fecha + total.
SELECT fecha_inscripicion, COUNT(fecha_inscripicion) AS inscripciones_dia
FROM inscripciones
GROUP by fecha_inscripicion
ORDER BY inscripciones_dia DESC;

-- Listar todos los alumnos que tienen más de 30 años.
SELECT apellido, nombre, edad FROM alumnos
WHERE edad>30; 

-- Mostrar los nombres de todos los cursos de nivel “Intermedio”.
SELECT * FROM cursos WHERE nivel_habilidad = 'Intermedio';

-- Obtener todas las inscripciones donde abono_insc es FALSE.
SELECT * FROM inscripciones WHERE abono_insc = FALSE;
-- Cuantos no pagaron todavia?
SELECT COUNT(abono_insc) AS cantidad_noPagos FROM inscripciones WHERE abono_insc = FALSE;

-- Quienes no pagaron todavia?
SELECT alumnos.id_alumno, alumnos.nombre, alumnos.apellido,  inscripciones.abono_insc
FROM alumnos
INNER JOIN inscripciones
ON alumnos.id_alumno = inscripciones.id_alumno
WHERE inscripciones.abono_insc = FALSE;

-- Mostrar apellido, nombre y la fecha de inscripción de todos los alumnos junto con el nombre del curso al que se inscribieron.
SELECT cursos.nombre AS curso,  alumnos.apellido, alumnos.nombre,  inscripciones.fecha_inscripicion
FROM alumnos
INNER JOIN inscripciones
ON alumnos.id_alumno = inscripciones.id_alumno 
INNER JOIN cursos
ON inscripciones.id_curso = cursos.id_curso;

-- ¿Cuántas inscripciones totales hubo por mes?
SELECT MONTH(fecha_inscripicion) FROM inscripciones;
SET lc_time_names = 'es_ES'; -- Sirve para poner en español, por ejemplo los meses de la consulta
SELECT MONTH(fecha_inscripicion) AS mes_inscripcion,
MONTHNAME(fecha_inscripicion) AS nombre_mes,
COUNT(fecha_inscripicion) AS cant_inscripciones_mes
FROM inscripciones
GROUP BY mes_inscripcion,nombre_mes
ORDER BY mes_inscripcion ASC;

-- Obtener los alumnos que se inscribieron en más de 2 cursos.
SELECT 
    alumnos.id_alumno,
    alumnos.nombre, 
    alumnos.apellido,
    COUNT(inscripciones.id_curso) AS cantidad_cursos
FROM inscripciones
INNER JOIN alumnos
    ON inscripciones.id_alumno = alumnos.id_alumno
GROUP BY alumnos.id_alumno, alumnos.nombre, alumnos.apellido
HAVING COUNT(inscripciones.id_curso) < 2;

-- Mostrar para cada tipo de instrumento cuántos alumnos distintos se inscribieron.
SELECT * FROM cursos;
SELECT * FROM inscripciones;

SELECT cursos.tipo_instrumento,
       COUNT(DISTINCT inscripciones.id_alumno) AS cantidad_alumnos_unicos
FROM inscripciones
INNER JOIN cursos
    ON inscripciones.id_curso = cursos.id_curso
GROUP BY cursos.tipo_instrumento;
