CREATE TABLE IF NOT EXISTS estudiantes (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NULL,
    identificacion TEXT NOT NULL UNIQUE,
    correo TEXT NOT NULL UNIQUE,
    programa TEXT NOT NULL,
    estado BOOL DEFAULT true, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP WITH TIME ZONE
);

CREATE OR REPLACE FUNCTION function_modified_at_estudiantes() RETURNS trigger AS
    $$
        begin
            NEW.modified_at := CURRENT_TIMESTAMP;
            RETURN NEW;
        END;
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_modified_at_estudiantes
	BEFORE UPDATE ON estudiantes
		FOR EACH ROW
			EXECUTE FUNCTION function_modified_at_estudiantes();
 
CREATE TABLE IF NOT EXISTS profesores (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    identificacion TEXT NOT NULL UNIQUE,
    correo TEXT NOT NULL UNIQUE,
    especialidad TEXT NOT NULL,
    estado BOOL DEFAULT true, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP WITH TIME ZONE
);

CREATE OR REPLACE FUNCTION function_modified_at_profesores() RETURNS trigger AS
    $$
        begin
            NEW.modified_at := CURRENT_TIMESTAMP;
            RETURN NEW;
        END;
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_modified_at_profesores
  BEFORE UPDATE ON profesores
  	FOR EACH ROW
  		EXECUTE PROCEDURE function_modified_at_profesores();

CREATE TABLE IF NOT EXISTS asignaturas (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    salon TEXT NOT NULL,
    horario TEXT NOT NULL,
    id_profesor INTEGER NOT NULL,
    estado BOOL DEFAULT true, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP WITH TIME zone,
    FOREIGN key (id_profesor) REFERENCES profesores(id)
);

CREATE OR REPLACE FUNCTION function_modified_at_asignaturas() RETURNS trigger AS
    $$
        begin
            NEW.modified_at := CURRENT_TIMESTAMP;
            RETURN NEW;
        END;
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_modified_at_asignaturas
  BEFORE UPDATE ON asignaturas
  	FOR EACH ROW
  		EXECUTE PROCEDURE function_modified_at_asignaturas();

CREATE TABLE IF NOT EXISTS clases (
    id SERIAL PRIMARY KEY,
    id_estudiante INTEGER NOT NULL,
    id_asignatura INTEGER NOT NULL,
    estado BOOL DEFAULT true, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP WITH TIME zone,
    FOREIGN key (id_estudiante) REFERENCES estudiantes(id),
    FOREIGN key (id_asignatura) REFERENCES asignaturas(id)
);

CREATE OR REPLACE FUNCTION function_modified_at_clases() RETURNS TRIGGER AS
    $$
        begin
            NEW.modified_at := CURRENT_TIMESTAMP;
            RETURN NEW;
        END;
    $$
LANGUAGE 'plpgsql';

CREATE TRIGGER trigger_modified_at_clases
  BEFORE UPDATE ON clases
  	FOR EACH ROW
  		EXECUTE PROCEDURE function_modified_at_clases();

INSERT INTO profesores (nombre, apellido, identificacion, correo, especialidad) VALUES 
	('Rick', 'Sanchez', 'C-137', 'adult@Swim.com', 'Ciencias'),
	('Hammurabi', 'Acadio', '6', 'reyes@Babilonia.com', 'Leyes'),
	('Lao', 'Tse', '571', 'Wu@Wei.Tao', 'Filosofia'),
	('Sun', 'Tzu', '1972', 'contacto@estrategia.com', 'Estrategia'),
	('Kentaro', 'Miura', '1989', 'Berserk@Hakusensha.Seinen', 'Artes');

commit;