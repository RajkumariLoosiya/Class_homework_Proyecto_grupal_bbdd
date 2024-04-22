Consultas bbdd pueblos.

2.
Select * from alumnado.

select (nombre, apellido, curso, edad) from alumnado.

3.
// Esta consulta devolverá un entero que junto al nombre del alumno, mostrará cuanta gente se llama igual.
select count(nombre),nombre from alumnado a inner join pueblos p on a.cp = p.cp group by (nombre)

// Esta consulta saca el número de personas que se llaman igual de cada localidad, lo ordena por estas y lo ordena de mayor a menor.
select count(nombre),nombre from alumnado a inner join pueblos p on a.cp = p.cp group by (localidad) order by (nombre) desc. 

4.
// Insercciones.
Insert into pueblos (cp int,localidad VARCHAR(30),N_hab int) VALUES (28350,Ciempozuelos, 55000);
Insert into alumnado (dni int, nombre VARCHAR(30), apellido VARCHAR(30), curso VARCHAR(30),edad int, cp int) VALUES (26115616,Pepito,Ramirez,5,10,6262662);

//Alters
//Alteramos el nombre de un alumno.
Alter Table alumnado RENAME nombreAlumno* to nuevoNombre** VARCHAR(30;)
*(Variable antigua de nombre) ** (Nueva variable de alumno)
//Alteramos el curso en el que está un alumno, para cuando pasan de curso.
Alter Table alumnado RENAME curso to cursoNuevo** VARCHAR(30;)
*(Variable antigua de curso) ** (Nueva variable de curso)

// Drops.
// Quitar un alumno de alumnado.
Alter table alumnado drop column nombreAlumno(*);
* Consideramos que el asterisco es el nombre del alumno que queremos eliminar. 
Alter table alumnado drop column puebloQuitar(*);
* Consideramos que el asterisco es el nombre del pueblo que queremos eliminar.
 
5.

5.1. create view padresConsulta as select * from alumnado where name == nombreEntrada*; 
* Consideramos que el asterisco es un parámetro de entrada que representa el nombre del niño.

// Esta es para admin, que le proporcionaremos los datos de cada alumno en cada pueblo.
5.2. create view admin as select * select * from alumnado a inner join pueblos p on a.cp = p.cp;

6.

Create user padres identified by 'contraseñaCentro';
Grant select on alumnado to padres.

Create user admin identified by 'admin1';

Grant all privileges on *.* to admin1. 

7.

Create INDEX indicePueblo on pueblos(cp,localidad,N_hab);

8.
// Triggers. 
8.1 
create trigger trigger1 after insert on alumnado
	for each row 
	begin 
	insert into pueblos (cp)
	(localidad,N_hab) values (nombreLocalidad*,n_habitantes*) if cp not exists ;
	end;
	(*)(Valores pedidos del nuevo pueblo si no existe).
	(Jugamos con cp, si el alumno inserta un cp que no existe, se crea el pueblo automáticamente).
8.2 
create trigger trigger2 before insert on alumnado
	for each row 
	begin 
	alter table alumnado drop column alumnoInsertado* if exists.
	(*)(Este nombre es el del nuevo alumno que se está insertando, comprueba si ya tiene una insercción y si está, la borra).
	end;
8.3 
create trigger trigger3 before insert on pueblos
	for each row 
	begin 
	alter table pueblos drop column puebloInsertado* if exists.
	(*)(Este nombre es el del nuevo pueblo que se está insertando, comprueba si ya tiene una insercción y si está, la borra).
	end;
8.4
// Esta consulta creará un pueblo por defecto si insertamos un alumno, que tiene el cp de un pueblo que no existe. Ese cp del pueblo, será el insertado con el alumno.
create trigger trigger4 before insert on alumnado
	for each row 
	begin 
	insert into pueblos (cp,nombreLocalidad*,n_habitantes) 
	values(00001, "","") if cp not exists;
	end;


9.

Create procedure createPueblo as insert into pueblos(cp,nombreLocalidad,n_habitantes) values (?,?,?); GO;

Create procedure createAlumno as insert into alumnado(dni int, nombre VARCHAR(30), apellido VARCHAR(30), curso VARCHAR(30),edad int, cp int) values (?,?,?,?,?,?,?); GO;