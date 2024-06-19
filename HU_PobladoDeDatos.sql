----------------POBLADO DE TABLA USERS --------------------------------
-- Función para generar un nombre aleatorio
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

-- Función para generar un email basado en el nombre aleatorio
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

CREATE OR REPLACE FUNCTION generar_user_id_aleatorio() RETURNS VARCHAR AS $$
DECLARE
    chars TEXT := '0123456789';
    user_id TEXT := '';
    i INT;
BEGIN
    FOR i IN 1..10 LOOP
        user_id := user_id || substr(chars, floor(random() * 10 + 1)::int, 1);
    END LOOP;
    RETURN user_id;
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


----------------POBLADO DE TABLA ROOMS ------------------------------

-- Crear una función para poblar la tabla rooms
CREATE OR REPLACE FUNCTION poblar_rooms() RETURNS VOID AS $$
DECLARE
    sitios TEXT[] := ARRAY[
        'Guatapé', 'Cartagena', 'Santa Marta', 'San Andrés', 'Villa de Leyva',
        'Barichara', 'Palomino', 'Mompox', 'Leticia', 'Manizales', 
        'Medellín', 'Bogotá', 'Cali', 'Bucaramanga', 'Armenia',
        'Pereira', 'Popayán', 'Neiva', 'Cúcuta', 'Ibagué',
        'Montería', 'Pasto', 'Tunja', 'Sincelejo', 'Riohacha'
    ];
    sitio TEXT;
    num INT;
    filas INT;
    columnas INT;
    nombre_room TEXT;
BEGIN
    FOR i IN 1..array_length(sitios, 1) LOOP
        FOR num IN 1..5 LOOP
            sitio := sitios[i];
            nombre_room := sitio || ' ' || num;
            filas := FLOOR(RANDOM() * 5 + 1);
            columnas := FLOOR(RANDOM() * 5 + 1);
            INSERT INTO rooms (room_name, num_rows, num_columns, capacity)
            VALUES (nombre_room, filas, columnas, filas * columnas);
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Llamar a la función para poblar la tabla rooms
SELECT poblar_rooms();


------------------POBLADO DE TABLA WORKSPACES --------------------------------


---Generar solo 100 registros
CREATE OR REPLACE FUNCTION poblar_workspaces() RETURNS VOID AS $$
DECLARE
  room RECORD;
  fila CHAR(1);
  columna INT;
  i INT := 0;  -- Initialize counter variable
BEGIN
  FOR room IN SELECT * FROM rooms LOOP
    FOR fila IN 0..room.num_rows - 1 LOOP
      FOR columna IN 1..room.num_columns LOOP
        i := i + 1;
        IF i > 100 THEN 
            RETURN;  -- Exit the function once 100 rows are inserted
        END IF;
        INSERT INTO workspaces (room_id, row_num, column_num)
          VALUES (room.id, CHR(ASCII('A') + fila), columna::VARCHAR);
      END LOOP;
      IF i > 100 THEN 
          RETURN;  -- Exit the function once 100 rows are inserted
      END IF;
    END LOOP;
  END LOOP;
END;
$$ LANGUAGE plpgsql;




-- Llamar a la función para poblar la tabla workspaces
SELECT poblar_workspaces();

SELECT * FROM workspaces;

SELECT COUNT(*) FROM workspaces;


------------POBLADO DE TABLA SESIONES------------

---
CREATE OR REPLACE FUNCTION poblar_sessions() RETURNS VOID AS $$
DECLARE
    room_id_random INT;
    fecha DATE;
    hora_inicio TIME;
    hora_fin TIME;
    intentos INT;
    sesiones_insertadas INT := 0;  -- Inicializar contador para sesiones insertadas
BEGIN
    WHILE sesiones_insertadas < 100 LOOP
        intentos := 0;

        -- Generar un room_id aleatorio entre 1 y 100
        room_id_random := 1 + FLOOR(RANDOM() * 100);

        -- Generar una fecha aleatoria en el próximo mes
        fecha := CURRENT_DATE + (RANDOM() * 30)::INT;
        -- Generar una hora de inicio aleatoria
        hora_inicio := TIME '08:00' + (RANDOM() * (TIME '18:00' - TIME '08:00'))::INTERVAL;
        -- Generar una hora de fin aleatoria (1 a 3 horas después de la hora de inicio)
        hora_fin := hora_inicio + ((1 + FLOOR(RANDOM() * 3)) || ' hours')::INTERVAL;

        BEGIN
            -- Intentar insertar la sesión
            INSERT INTO sessions (room_id, description, date, start_time, end_time)
            VALUES (room_id_random, 'Reunion ' || sesiones_insertadas::TEXT, fecha, hora_inicio, hora_fin);
            -- Incrementar contador de sesiones insertadas
            sesiones_insertadas := sesiones_insertadas + 1;
            RAISE NOTICE 'Sesión insertada: room_id=%, description=%, fecha=%, hora_inicio=%, hora_fin=%', room_id_random, 'Reunion ' || sesiones_insertadas::TEXT, fecha, hora_inicio, hora_fin;
        EXCEPTION WHEN unique_violation THEN
            -- Ignorar errores de solapamiento y continuar
            RAISE NOTICE 'Solapamiento detectado: room_id=%, fecha=%, hora_inicio=%, hora_fin=%', room_id_random, fecha, hora_inicio, hora_fin;
        END;

        -- Incrementar contador de intentos
        intentos := intentos + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



SELECT poblar_sessions();

SELECT COUNT(*) FROM sessions;

SELECT * FROM sessions;

------------POBLADO DE TABLA RESERVATIONS------------

DO $$
DECLARE
    user_id INT;
    workspace_id INT;
    session_id INT;
    i INT;
BEGIN
    FOR i IN 1..100 LOOP
        -- Generar IDs aleatorios para user, workspace, y session
        user_id := (1 + RANDOM() * 99)::INT;
        workspace_id := (1 + RANDOM() * 99)::INT;
        session_id := (1 + RANDOM() * 99)::INT;

        -- Intentar insertar la reserva
        BEGIN
            INSERT INTO reservations (user_id, workspace_id, session_id)
            VALUES (user_id, workspace_id, session_id);
        EXCEPTION WHEN foreign_key_violation THEN
            -- Ignorar errores de violación de clave foránea y continuar
            RAISE NOTICE 'Violación de clave foránea detectada: user_id=%, workspace_id=%, session_id=%', user_id, workspace_id, session_id;
        END;
    END LOOP;
END;
$$;



SELECT * FROM reservations;


SELECT * FROM reservations;

SELECT COUNT(*) FROM workspaces;



