-- Active: 1718756183478@@b3k8xtdhqsupcg0esadt-postgresql.services.clever-cloud.com@50013
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(20),
    name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL
);

select * from users;

DROP table users;


-- Crear una función para generar un nombre aleatorio
CREATE OR REPLACE FUNCTION generar_nombre_aleatorio() RETURNS TEXT AS $$
DECLARE
    nombres TEXT[] := ARRAY['Juan', 'Ana', 'Luis', 'Maria', 'Pedro', 'Laura', 'Carlos', 'Sofia', 'Jose', 'Lucia'];
    apellidos TEXT[] := ARRAY['Perez', 'Gomez', 'Rodriguez', 'Lopez', 'Martinez', 'Sanchez', 'Garcia', 'Diaz', 'Fernandez', 'Torres'];
    nombre TEXT;
    apellido TEXT;
BEGIN
    nombre := nombres[FLOOR(RANDOM() * ARRAY_LENGTH(nombres, 1) + 1)];
    apellido := apellidos[FLOOR(RANDOM() * ARRAY_LENGTH(apellidos, 1) + 1)];
    RETURN nombre || ' ' || apellido;
END;
$$ LANGUAGE plpgsql;

-- Crear una función para generar un email basado en el nombre aleatorio
CREATE OR REPLACE FUNCTION generar_email_aleatorio(nombre_completo TEXT) RETURNS TEXT AS $$
DECLARE
    dominios TEXT[] := ARRAY['gmail.com', 'outlook.com', 'hotmail.com'];
    nombre_parte TEXT;
    dominio TEXT;
BEGIN
    -- Quitar espacios y convertir a minúsculas el nombre completo para el correo
    nombre_parte := LOWER(REPLACE(nombre_completo, ' ', ''));
    dominio := dominios[FLOOR(RANDOM() * ARRAY_LENGTH(dominios, 1) + 1)];
    RETURN nombre_parte || '@' || dominio;
END;
$$ LANGUAGE plpgsql;

-- Insertar automáticamente 100 usuarios con user_id, nombres y correos electrónicos generados basados en el nombre
DO $$
DECLARE
    nombre_completo TEXT;
BEGIN
    FOR i IN 1..100 LOOP
        nombre_completo := generar_nombre_aleatorio();
        INSERT INTO users (user_id, name, email) 
        VALUES (generar_user_id_aleatorio(), nombre_completo, generar_email_aleatorio(nombre_completo));
    END LOOP;
END $$;

-- Consultar todos los registros en la tabla users
SELECT * FROM users;
