
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(20),
    name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    room_name VARCHAR(20) NOT NULL,
    num_rows INT NOT NULL,
    num_columns INT NOT NULL,
    capacity INT
);

CREATE TABLE workspaces (
    id SERIAL PRIMARY KEY,
    room_id INT REFERENCES rooms(id),
    row_num VARCHAR(2) NOT NULL,
    column_num VARCHAR(2) NOT NULL,
    UNIQUE(room_id, row_num, column_num)
);


CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    room_id INT REFERENCES rooms(id),
    description VARCHAR (100),
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    CONSTRAINT no_overlap UNIQUE (room_id, date, start_time, end_time)
)

CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    workspace_id INT REFERENCES workspaces(id),
    session_id INT REFERENCES sessions(id)
);

DROP table workspaces;
DROP table reservations;

DROP table sessions;
DROP table rooms;
DROP table users;
DELETE FROM workspaces;

DELETE FROM reservations;

DELETE FROM sessions;

DELETE FROM rooms;

DELETE FROM users;
