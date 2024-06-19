--INSERCIONES Y ACTUALIZACIONES ---

-- Reservar un espacio de trabajo
INSERT INTO reservations (user_id, workspace_id, session_id) VALUES (11, 11, 11);

SELECT * FROM reservations ORDER BY id DESC;

-- Cancelar una reserva
DELETE FROM reservations WHERE id = 101;


--CONSULTAS ---

-- Ver la lista de espacios de trabajo disponibles de una sala en una sesión x. 

SELECT * FROM workspaces
WHERE room_id = 3 
AND id NOT IN (
    SELECT workspace_id 
    FROM reservations 
    WHERE session_id = 2
);


SELECT w.id AS workspace_id, w.row_num, w.column_num, r.room_name
FROM workspaces w
JOIN rooms r ON r.id = w.room_id
LEFT JOIN reservations res ON res.workspace_id = w.id AND res.session_id = 2
WHERE w.room_id = 3
AND res.workspace_id IS NULL;

-- Espacios de trabajo ocupados en una sala para una sesión específica
SELECT * FROM workspaces
WHERE room_id = 1 AND id IN (
    SELECT workspace_id FROM reservations WHERE session_id = 1
);


SELECT w.*
FROM workspaces w
JOIN reservations res ON res.workspace_id = w.id
WHERE w.room_id = 1 AND res.session_id = 1;

-- Sesiones ordenadas por las más ocupadas
SELECT s.id AS session_id, s.description, COUNT(*) AS num_reservations
FROM sessions s
JOIN reservations r ON r.session_id = s.id
GROUP BY s.id, s.description
ORDER BY num_reservations DESC;

-- Sesiones ordenadas por las más disponibles
SELECT s.id AS session_id, s.description, COUNT(*) AS num_reservations
FROM sessions s
LEFT JOIN reservations r ON r.session_id = s.id
GROUP BY s.id, s.description
ORDER BY num_reservations ASC;


-- Espacios de trabajo asignados a un usuario
SELECT w.id AS workspace_id, w.row_num, w.column_num
FROM reservations r
JOIN workspaces w ON w.id = r.workspace_id
WHERE r.user_id = 5;

-- Espacios de trabajo asignados a una sesión
SELECT w.id AS workspace_id, w.row_num, w.column_num
FROM reservations r
JOIN workspaces w ON w.id = r.workspace_id
WHERE r.session_id = 3;