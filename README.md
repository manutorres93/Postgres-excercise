Se tienen tres documentos:

-HU_CreacionDeTablas.sql:

En este se encontrarán todas las queries para la creación de las tablas según se plantea en el modelo, con sus respectivas validaciones.

 

-HU_PobladoDeDatos:

En este se encontrarán scripts para poblar las tablas teniendo como máximo 100 registros por poblado

Tabla users:

id unico que se incrementa con cada registro en forma serial

nombre de usuario generado aleatoriamente concatenando nombres y apellidos de un listado 

email de usuario generado al tomar como base el nombre del usuario y se le asigna aleatoriamente el dominio. Ej: Nelson Mandela tendría el correo nelsonmandela@xxxxx.com, asignado el dominio aleatoriamente

generación de número de identificación aleatorio de 10 caracteres 

 

Tabla rooms:

id unico que se incrementa con cada registro en forma serial

nombre de sala generado automaticamente en orden consecutivo tomando como base el nombre de un lugar turísitco de Colombia y se le asigna un numero de 1 a 5

Se consideró adecuado dejar las filas y columnas para calcular la capacidad de la habitación solo por gustos de quién planteó el ejercicio considerando que para efectos del ejercicio, el consumo de recursos no era muy afectado y ya se había poblado la tabla cuando se realizó la recomendación, se quiso evitar re procesos.

Tabla workspaces:

id unico que se incrementa con cada registro en forma serial

Se garantiza un máximo de 100 registros puesto que los workspaces podrían ser tantos como se haya determinado (automaticamente) en el anterior ejercicio de poblado, donde con 100 registros de salas, y con capacidades máximas de 25, se podrían generar muchos registros de workspaces.

El nombre o identificacion unica del workspace está dado por la fila identificada con una letra en letra capital y un numero empezando por el 1 hasta que se completen todas las columnas de esa fila

 

Tabla sessions:

id unico que se incrementa con cada registro en forma serial

Se garantiza un máximo de 100 registros 

Se garantiza que no se haga un solapamiento entre fechas y horas para la diferentes sesiones

 

Tabla reservations:

id unico que se incrementa con cada registro en forma serial

Como se sabe que hay users, workspaces y sessions con id del 1 hasta el 100, se crean combinaciones al azar pero se garantiza que no haya una violación de la clave foranea

 

-HU_SciprtsFunciones.sql:

Scripts para las consultas requeridas
