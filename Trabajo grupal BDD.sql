DROP SCHEMA IF EXISTS AlumnosPueblos;

CREATE SCHEMA IF NOT EXISTS AlumnosPueblos;

USE AlumnosPueblos;


CREATE TABLE Pueblos(
cp INTEGER PRIMARY KEY,
localidad VARCHAR(30),
N_hab INTEGER
); -- ENGINE = INNODB;

CREATE TABLE alumnado(
dni INTEGER PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
apellido VARCHAR(50) NOT NULL,
curso VARCHAR(30),
edad INTEGER,
cp INTEGER NOT NULL,
CONSTRAINT fk_Alumnado_cp FOREIGN KEY (cp) REFERENCES Pueblos(cp)
);-- ENGINE = INNODB;	





INSERT INTO Pueblos VALUES (13670,'Villarrubia de los Ojos',18789);
INSERT INTO Pueblos VALUES (13779,'Calzada de Calatrava',2149);
INSERT INTO Pueblos VALUES (13679,'Arenas de San Juan',1717);
INSERT INTO Pueblos VALUES (13440,'Argamasilla de Calatrava',3342);
INSERT INTO Pueblos VALUES (13260,'Bolaños de Calatrava',5818);


INSERT INTO alumnado VALUES (7369,'ANA','SÁNCHEZ','3 ESO',15,13670);
INSERT INTO alumnado VALUES (7499,'JUAN','ARROYO','1 BACHILLERATO',17,13779);
INSERT INTO alumnado VALUES (7521,'EVA','SALA','4 ESO',16,13670);
INSERT INTO alumnado VALUES (7566,'LUIS','JIMÉNEZ','3 ESO',16,13679);
INSERT INTO alumnado VALUES (7654,'CARMEN','MARTÍN','2 BACHILLERATO',19,13260);
INSERT INTO alumnado VALUES (7698,'MARÍA','NEGRO','4 ESO',17,13260);
INSERT INTO alumnado VALUES (7782,'CARLOS','CEREZO','4 ESO',17,13670);
INSERT INTO alumnado VALUES (7788,'MARTA','GIL','1 BACHILLERATO',18,13440);
INSERT INTO alumnado VALUES (7839,'ALICIA','REY','2 BACHILLERATO',20,13260);
INSERT INTO alumnado VALUES (7844,'PACO','TOVAR','3 ESO',15,13670);
INSERT INTO alumnado VALUES (7876,'JOSÉ','ALONSO','2 BACHILLERATO',19,13260);
INSERT INTO alumnado VALUES (7900,'LOLA','JIMENO','1 BACHILLERATO',18,13670);
INSERT INTO alumnado VALUES (7902,'MARTÍN','FERNÁNDEZ','4 ESO',16,13779);
INSERT INTO alumnado VALUES (7934,'LAURA','MUÑOZ','3 ESO',15,13679);

use alumnosPueblos

-- 2. Crea 2 consultas monotabla que se ejecuten regularmente en la aplicación. Por ejemplo, si al conectarnos la app nos muestra las ofertas de los productos “SELECT ofertas FROM productos;”

select localidad, N_hab from pueblos;

select dni, curso from alunado;

-- 3. Igual que en el apartado anterior, crea 2 consultas multitablas que se ejecutarán de manera frecuente en la aplicación (JOIN)

select a.nombre, a.apellido, p.localidad, p.N_hab
from alumnado as a
inner join pueblos as p on a.cp = p.cp;

select a.curso, avg(a.edad) as mediaEdad
from alumnado as a
inner join pueblos as p on a.cp = p.cp
group by a.curso;

-- 4. Crea 2 inserciones, 2 modificaciones y 2 eliminaciones frecuentes que se llevarán a cabo en la aplicación.

-- inserciones

insert into pueblos (cp, localidad, N_hab) values (28320, 'Pinto', 50000);

insert into alumnado (dni, nombre, apellido, curso, edad, cp) values (5483, 'Laura', 'Garcia', '2ESO', 14, 13500);

-- moodificaciones

update alumnado set curso = '3ESO' where dni = 4856;

update pueblos set N_hab = 50000 where  cp = 13500;

-- eliminaciones

delete from alumnado where dni = 7499;

delete from pueblos where cp = 13779;

-- 5. Imaginaros que vienen dos personas nuevas a vuestra empresa, os ayudarán a mejorar aspectos de la aplicación ¿Qué vistas le proporcionaríais teniendo en cuenta las funciones que van a desarrollar (define también qué función desarrollarán)? crea mínimo 2 vistas.

create view EstadisticasAlumnos as select p.localidad, count(a.dni) as totalAlumnosPorLocalidad
from alumnado as a join pueblos as p on a.cp = p.cp
group by p.localidad; 

create view TendenciasDemograficas as select edad, count(*) as totalAlumnosPorEdad
from alumnado 
group by edad; 

-- 6. Define qué usuarios crearías para que puedan acceder al SGBD y qué permisos tendrán.

Create user alumno identified by 'contraseñaCentro';
Grant select on alumnado to alumno;

Create user profesores identified by 'contraseñaProfesor';
Grant select, update on alumnado to profesores;

-- 7. ¿Has detectado alguna consulta que se realiza constantemente? ¿echas de menos algún índice? por ejemplo, si se busca siempre información por ciudad sería recomendable crear un índice en el campo ciudad.

create index indiceCurso on alumnado(curso);

-- 8. ¿Qué triggers pensáis que necesita la base de datos?, crea 2 trigger por tabla.

-- tabla alumnado

create trigger antesDeFechaIngresoNuevoAlumno before insert on alumnado
for each row
set new.fechaIngreso = current_timestamp;

create trigger cursoMayuscula before insert on alumnado
for each row update alumnado
set new.curso = upper(new.curso);

-- tabla pueblos

create trigger despuesDeInsertarAlumno after insert on alumnado 
for each row 
update pueblos set N_hab = N_hab + 1 where cp = new.cp;

create trigger DespuesDeEliminarAlumno after delete on alumnado
for each row
update pueblos set N_hab = N_hab - 1 where cp = old.cp;

-- 9. ¿Qué procedimientos almacenados podría necesitar la base de datos?, crea 2 procedimientos almacenados.

delimiter //
create procedure informacionDelAlumnoPorDni (in dni integer)
begin
	select a.nombre, a.apellido, a.curso, a.edad, p.localidad
    from alumnado as a inner join pueblos as p on a.cp = p.cp
    where a.dni = dni;
end //

delimiter //
create procedure SalidaDeUnAlumno (in dni integer)
begin
	update alumnado set fechaSalida = current_timestamp where dni = dni;
end //
