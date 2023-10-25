%Hechos
:- dynamic(persona/5).
:- dynamic(proyecto/5).
:- dynamic(tarea/7).

:- initialization(cargar_personas).
:- initialization(cargar_proyectos).
:- initialization(cargar_tareas).

%Carga el archivo de tareas a la BC
cargar_tareas() :-
    see('tareas.txt'),
    leer_lineas,
    seen.

%Cargar personas del txt
cargar_personas:-
    see('personas.txt'),
    leer_lineas,
    seen.

%Cargar proyectos del txt
cargar_proyectos:-
    see('proyectos.txt'),
    leer_lineas,
    seen.

leer_lineas :-
    repeat,
    leer_linea(Linea),
    (Linea == end_of_file, !;
    agregar_hecho(Linea),
    fail).

leer_linea(Linea) :-
    read(Linea).

agregar_hecho(Linea) :-
    asserta(Linea).


%Lista de tareas para validar
tareas(['requerimientos', 'disenio', 'desarrollo', 'qa', 'fullstack', 'frontend', 'backend', 'administracion']).

%Menu principal
menu:-
    writeln('1. Gestion de personas'),
    writeln('2. Gestion de proyectos'),
    writeln('3. Gestion de tareas'),
    writeln('9. Salir'),
    write('Ingrese su opcion deseada: '),
    read_line_to_string(user_input, Opcion), comprobarOpcionMenuMain(Opcion).

%Funcion auxiliar para comprobar que la opcion ingresada por el usuario el correcta
comprobarOpcionMenuMain(Opcion):- string_lower(Opcion, "1"), menuPersona, menu.
comprobarOpcionMenuMain(Opcion):- string_lower(Opcion, "2"), menuProyecto, menu.
comprobarOpcionMenuMain(Opcion):- string_lower(Opcion, "3"), menu_tarea, menu.
comprobarOpcionMenuMain(Opcion):- string_lower(Opcion, "9").
comprobarOpcionMenuMain(_):- writeln('Opcion invalida. Por favor, ingrese una opcion valida2.'), menu.

%Menu para la funcion de gestion de personas
menuPersona:- writeln('1. Agregar personas'), writeln('2. Imprimir personas'), writeln('3. Volver'), write('Ingrese su opcion: '),
    read_line_to_string(user_input, Opcion), comprobarOpcionPersona(Opcion).

%Funcion auxiliar para comprobar que la opcion ingresada por el usuario el correcta
comprobarOpcionPersona(Opcion):- string_lower(Opcion, "1"), ingresarPersonas, menuPersona.
comprobarOpcionPersona(Opcion):- string_lower(Opcion, "2"), nl, imprimirPersonas, menuPersona.
comprobarOpcionPersona(Opcion):- string_lower(Opcion, "3").
comprobarOpcionPersona(_):- writeln('Opcion invalida. Por favor, ingrese una opcion valida.'), nl, menuPersona.

%Funcion que imprime los hechos de personas
imprimirPersonas :-
    persona(Nombre, Puesto, Costo, Rating, _),
    write('Nombre: '), writeln(Nombre),
    write('Puesto: '), writeln(Puesto),
    write('Costo: '), writeln(Costo),
    write('Rating: '), writeln(Rating),
    nl, not(true).
imprimirPersonas :- true.

%Funcion que pide los datos al usuario sobre un nuevo empleado
ingresarPersonas:- write('Ingrese el nombre de su trabajador: '), read_line_to_string(user_input, Nombre), nl,
    write('Ingrese el puesto de su trabajador: '), read_line_to_string(user_input, Puesto), nl,
    write('Ingrese el costo por tarea de su trabajador: '), read_line_to_string(user_input, Costo), nl,
    write('Ingrese el rating de su trabajador: '), read_line_to_string(user_input, Rating), nl,
    validarPersonas(Nombre, Puesto, Costo, Rating, []).

validarPersonas(Nombre, _, _, _, _):- persona(Nombre, _, _, _, _),
    writeln('!!Error -> No pueden haber personas con el mismo nombre <- Error!!'), nl.

validarPersonas(_, _, Costo, _, _):- not(is_valid_integer(Costo)),
    writeln('!!Error -> El Costo debe ser entero <- Error!!'), nl.

validarPersonas(_, _, _, Rating, _):- not(is_valid_integer(Rating)),
    writeln('!!Error -> El Rating debe ser entero <- Error!!'), nl.

validarPersonas(_, _, Costo, _, _):- atom_number(Costo, Number), not(Number > 0),
    writeln('!!Error -> El Costo debe ser positivo <- Error!!'), nl.

validarPersonas(_, _, _, Rating, _):- atom_string(Atom, Rating), atom_number(Atom, Number), not(Number > 0),
    writeln('!!Error -> El Rating debe ser positivo <- Error!!'), nl.

validarPersonas(_, _, _, Rating, _):- atom_string(Atom, Rating), atom_number(Atom, Number), not(Number < 101),
    writeln('!!Error -> El Rating debe ser menor a 100 <- Error!!'), nl.

validarPersonas(Nombre, Puesto, Costo, Rating, Tareas):- agregarTareas(Nombre, Puesto, Costo, Rating, Tareas).

%Funcion auxiliar que se encarga de pedir tareas y a la vez validarlas
agregarTareas(Nombre, Puesto, Costo, Rating, Tareas):- write('Ingrese su tarea o la letra s para finalizar: '),
    read_line_to_string(user_input, TareaNueva), agregarTareasAux(TareaNueva, Tareas, Nombre, Puesto, Costo, Rating).

agregarTareasAux(TareaNueva, Tareas, _, _, _, _):-
    string_lower(TareaNueva, "s"),
    length(Tareas, 0),
    writeln('!!Error -> no puede ingresar un usuario sin tareas <- Error!!'), nl.

agregarTareasAux(TareaNueva, Tareas, Nombre, Puesto, Costo, Rating):- string_lower(TareaNueva, "s"),
    asserta(persona(Nombre, Puesto, Costo, Rating, Tareas)), guardar_personas(Nombre, Puesto, Costo, Rating, Tareas),
    writeln('!!Usuario agregado con exito!!').

agregarTareasAux(TareaNueva, Tareas, Nombre, Puesto, Costo, Rating):- string_lower(TareaNueva, TareaNuevaLower),
    tareas(Lista), maplist(string_lower, Lista, ListaLower),
    not(member(TareaNuevaLower, ListaLower)),
    writeln('!!Error -> Esta tarea no existe en nuestra empresa <- Error!!'), agregarTareas(Nombre, Puesto, Costo, Rating, Tareas).

agregarTareasAux(TareaNueva, Tareas, Nombre, Puesto, Costo, Rating):- string_lower(TareaNueva, TareaNuevaLower),
    member(TareaNuevaLower, Tareas),
    writeln('!!Error -> Esta tarea ya ha sido ingresada <- Error!!'), agregarTareas(Nombre, Puesto, Costo, Rating, Tareas).

agregarTareasAux(TareaNueva, Tareas, Nombre, Puesto, Costo, Rating):-
    append(Tareas, [TareaNueva], NuevasTareas),
    agregarTareas(Nombre, Puesto, Costo, Rating, NuevasTareas).

%Funcion que se encarga de guardar el predicado persona en un txt
guardar_personas(Nombre, Puesto, Costo, Rating, Tareas):-
    open('personas.txt', append, Stream),
    writeq(Stream, persona(Nombre, Puesto, Costo, Rating, Tareas)), write(Stream, '.\n'),
    close(Stream).

%Menu para la funcion de gestion de proyectos
menuProyecto:- writeln('1. Agregar proyectos'), writeln('2. Imprimir proyectos'), writeln('3. Volver'), write('Ingrese su opcion: '),
    read_line_to_string(user_input, Opcion), comprobarOpcionProyecto(Opcion).

%Funcion auxiliar para comprobar que la opcion ingresada por el usuario el correcta
comprobarOpcionProyecto(Opcion):- string_lower(Opcion, "1"), ingresarProyectos, !, menuProyecto.
comprobarOpcionProyecto(Opcion):- string_lower(Opcion, "2"), nl, imprimirProyectos, !, menuProyecto.
comprobarOpcionProyecto(Opcion):- string_lower(Opcion, "3").
comprobarOpcionProyecto(_):- writeln('Opcion invalida. Por favor, ingrese una opcion validax.'), nl, menuProyecto.

%Funcion que agrega proyectos junto a sus auxiliares que ayudan a validar
ingresarProyectos:- write('Ingrese el nombre de su proyecto: '), read_line_to_string(user_input, Nombre), nl,
    write('Ingrese la empresa a la que pertenece este proyecto: '), read_line_to_string(user_input, Empresa), nl,
    write('Ingrese el presupuesto para este proyecto: '), read_line_to_string(user_input, Presupuesto), nl,
    write('Ingrese una fecha de inicio para este proyecto (Formato DD-MM-YYYY): '), read_line_to_string(user_input, FechaIni), nl,
    write('Ingrese una fecha de fin para este proyecto (Formato DD-MM-YYYY): '), read_line_to_string(user_input, FechaFin), nl,
    ingresarProyectosAux(Nombre, Empresa, Presupuesto, FechaIni, FechaFin).

ingresarProyectosAux(Nombre, _, _, _, _):- proyecto(Nombre, _, _, _, _),
    writeln('!!Error -> No pueden haber proyectos con el mismo nombre <- Error!!'), nl.

ingresarProyectosAux(_, _, Presupuesto, _, _):- not(is_valid_integer(Presupuesto)),
    writeln('!!Error -> el presupuesto no es entero <- Error!!'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- string_length(FechaIni, Length), not(Length = 10),
    writeln('!!Error -> la fecha de inicio no tiene el largo del formato esperado <- Error!!'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- string_length(FechaFin, Length), not(Length = 10),
    writeln('!!Error -> la fecha de fin no tiene el largo del formato esperado <- Error!!'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena, 2, 1, FechaIni), not(string_lower(Cadena, "-")),
    writeln('!!Error -> la fecha de inicio no sigue el formato de - <- Error!!'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena, 5, 1, FechaIni), not(string_lower(Cadena, "-")),
    writeln('!!Error -> la fecha de inicio no sigue el formato de - <- Error!!'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena, 2, 1, FechaFin), not(string_lower(Cadena, "-")),
    writeln('!!Error -> la fecha de fin no sigue el formato de - <- Error!!'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena, 5, 1, FechaFin), not(string_lower(Cadena, "-")),
    writeln('!!Error -> la fecha de fin no sigue el formato de - <- Error!!'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena, 0, 2, FechaIni), not(is_valid_integer(Cadena)),
    writeln('Formato invalido -> En la fecha de inicio los dias no siguen el formato'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena, 3, 2, FechaIni), not(is_valid_integer(Cadena)),
    writeln('Formato invalido -> En la fecha de inicio los meses no siguen el formato'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena, 6, 4, FechaIni), not(is_valid_integer(Cadena)),
    writeln('Formato invalido -> En la fecha de inicio el anio no sigue el formato'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena, 0, 2, FechaFin), not(is_valid_integer(Cadena)),
    writeln('Formato invalido -> En la fecha de fin los dias no siguen el formato'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena, 0, 2, FechaFin), not(is_valid_integer(Cadena)),
    writeln('Formato invalido -> En la fecha de fin los meses no siguen el formato'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena, 6, 4, FechaFin), not(is_valid_integer(Cadena)),
    writeln('Formato invalido -> En la fecha de fin el anio no sigue el formato'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena1, 0, 2, FechaIni), atom_number(Cadena1, Number), not(Number < 31),
    writeln('Formato invalido -> Los dias de la fecha de inicio deben seguir el rango [1, 30]'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena1, 0, 2, FechaIni), atom_number(Cadena1, Number), not(Number > 0),
    writeln('Formato invalido -> Los dias de la fecha de inicio deben seguir el rango [1, 30]'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena1, 3, 2, FechaIni), atom_number(Cadena1, Number), not(Number < 13),
    writeln('Formato invalido -> Los meses de la fecha de inicio deben seguir el rango [1, 12]'), nl.

ingresarProyectosAux(_, _, _, FechaIni, _):- substring(Cadena1, 3, 2, FechaIni), atom_number(Cadena1, Number), not(Number > 0),
    writeln('Formato invalido -> Los meses de la fecha de inicio deben seguir el rango [1, 12]'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena1, 0, 2, FechaFin), atom_number(Cadena1, Number), not(Number < 31),
    writeln('Formato invalido -> Los dias de la fecha de fin deben seguir el rango [1, 30]'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena1, 0, 2, FechaFin), atom_number(Cadena1, Number), not(Number > 0),
    writeln('Formato invalido -> Los dias de la fecha de fin deben seguir el rango [1, 30]'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena1, 3, 2, FechaFin), atom_number(Cadena1, Number), not(Number < 13),
    writeln('Formato invalido -> Los meses de la fecha de fin deben seguir el rango [1, 12]'), nl.

ingresarProyectosAux(_, _, _, _, FechaFin):- substring(Cadena1, 3, 2, FechaFin), atom_number(Cadena1, Number), not(Number > 0),
    writeln('Formato invalido -> Los meses de la fecha de fin deben seguir el rango [1, 12]'), nl.

ingresarProyectosAux(_, _, _, FechaIni, FechaFin):- substring(Cadena1, 6, 4,FechaIni), substring(Cadena2, 6, 4,FechaFin),
    atom_number(Cadena1, Number1), atom_number(Cadena2, Number2),
    Number1 > Number2,
    writeln('Formato invalido -> La fecha de inicio no puede ser mayor a la fecha de fin'), nl.

ingresarProyectosAux(_, _, _, FechaIni, FechaFin):- substring(Cadena1, 0, 2, FechaIni), substring(Cadena2, 0, 2, FechaFin),
    atom_number(Cadena1, Number1), atom_number(Cadena2, Number2), Number1 > Number2,
    substring(Cadena3, 3, 2, FechaIni), substring(Cadena4, 3, 2, FechaFin),
    atom_number(Cadena3, Number3), atom_number(Cadena4, Number4), Number3 >= Number4,
    substring(Cadena5, 6, 4,FechaIni), substring(Cadena6, 6, 4,FechaFin),
    atom_number(Cadena5, Number5), atom_number(Cadena6, Number6),
    not(Number6 >= Number5),
    writeln('Formato invalido -> La fecha de inicio no puede ser mayor a la fecha de fin'), nl.

ingresarProyectosAux(_, _, _, FechaIni, FechaFin):- substring(Cadena1, 0, 2, FechaIni), substring(Cadena2, 0, 2, FechaFin),
    atom_number(Cadena1, Number1), atom_number(Cadena2, Number2), Number1 < Number2,
    substring(Cadena3, 3, 2, FechaIni), substring(Cadena4, 3, 2, FechaFin),
    atom_number(Cadena3, Number3), atom_number(Cadena4, Number4), Number3 > Number4,
    substring(Cadena5, 6, 4,FechaIni), substring(Cadena6, 6, 4,FechaFin),
    atom_number(Cadena5, Number5), atom_number(Cadena6, Number6),
    not(Number6 >= Number5),
    writeln('Formato invalido -> La fecha de inicio no puede ser mayor a la fecha de fin'), nl.

ingresarProyectosAux(_, _, _, FechaIni, FechaFin):- substring(Cadena1, 0, 2, FechaIni), substring(Cadena2, 0, 2, FechaFin),
    atom_number(Cadena1, Number1), atom_number(Cadena2, Number2), Number1 = Number2,
    substring(Cadena3, 3, 2, FechaIni), substring(Cadena4, 3, 2, FechaFin),
    atom_number(Cadena3, Number3), atom_number(Cadena4, Number4), Number3 >= Number4,
    substring(Cadena5, 6, 4,FechaIni), substring(Cadena6, 6, 4,FechaFin),
    atom_number(Cadena5, Number5), atom_number(Cadena6, Number6),
    not(Number6 >= Number5),
    writeln('Formato invalido -> La fecha de inicio no puede ser mayor o igual a la fecha de fin'), nl.

ingresarProyectosAux(Nombre, Empresa, Presupuesto, FechaIni, FechaFin):-
    asserta(proyecto(Nombre, Empresa, Presupuesto, FechaIni, FechaFin)),
    guardar_proyectos(Nombre, Empresa, Presupuesto, FechaIni, FechaFin),
    writeln('Proyecto agregado con exito!!'), nl.

%Funcion que se encarga de guardar el predicado persona en un txt
guardar_proyectos(Nombre, Empresa, Presupuesto, FechaIni, FechaFin):-
    open('proyectos.txt', append, Stream),
    writeq(Stream, proyecto(Nombre, Empresa, Presupuesto, FechaIni, FechaFin)), write(Stream, '.\n'),
    close(Stream).

%Funcion que imprime los hechos de proyectos
imprimirProyectos :-
    proyecto(Nombre, Empresa, Presupuesto, FechaIni, FechaFin),
    write('Nombre: '), writeln(Nombre),
    write('Empresa: '), writeln(Empresa),
    write('Presupuesto: '), writeln(Presupuesto),
    write('Fecha inicio: '), writeln(FechaIni),
    write('Fecha finalizacion: '), writeln(FechaFin),
    nl, not(true).
imprimirProyectos :- true.

% Predicado para recortar una subcadena de una cadena dada
% El start es la posicion antes de donde quieras recortar
substring(Substring, Start, Length, String) :-
    sub_string(String, Start, Length, _, Substring).

% Predicado que verifica si una cadena es una representación válida de un número entero
is_valid_integer(String) :-
    atom_string(Atom, String),
    atom_number(Atom, _).

%menu tareas.
menu_tarea:-
    writeln('1. Agregar tareas'),
    writeln('2. Imprimir tareas'),
    writeln('3. Volver'),
    write('Ingrese su opcion: '),
    read_line_to_string(user_input, Opcion), comprobar_opcion_tarea(Opcion).

%Funcion auxiliar para comprobar que la opcion ingresada por el usuario el correcta
comprobar_opcion_tarea(Opcion):- string_lower(Opcion, "1"), ingresar_tarea, !, menu_tarea.
comprobar_opcion_tarea(Opcion):- string_lower(Opcion, "2"), imprimir_tarea, !, menu_tarea.
comprobar_opcion_tarea(Opcion):- string_lower(Opcion, "3"), !.
comprobar_opcion_tarea(_):- writeln('Opcion invalida. Por favor, ingrese una opcion valida.'), menu_tarea.

%validar que existan proyectos.
ingresar_tarea:- cantidad_proyectos(Cant), Cant =< 0, writeln('Deben existir previamente proyectos.').
%Funcion que pide los datos al usuario sobre un nuevo empleado
ingresar_tarea:-
    writeln('Ingrese el nombre de su tarea: '), read_line_to_string(user_input, Nombre),
    writeln('Ingrese el nombre del proyecto al que pertenece la tarea: '), read_line_to_string(user_input, Proyecto),
    writeln('Ingrese el tipo de tarea: '), read_line_to_string(user_input, Tarea),
    writeln('Ingrese la fecha de inicio de la tarea: '), read_line_to_string(user_input, Fecha),
    validar_tarea(Nombre, Proyecto, Tarea, Fecha),
    guardar_tarea(Nombre, Proyecto, Tarea, "pendiente", "no asignada", Fecha, "no asignada"),
    asserta(tarea(Nombre, Proyecto, Tarea, "pendiente", "no asignada", Fecha, "no asignada")),
    writeln('Tarea agregada con exito.').


% Valida la existencia de la tarea, si ya hay una con este nombre, la
% rechazamos.
validar_tarea(Nombre, _, _, _) :- existe_tarea(Nombre), writeln('!!Error -> Esta tarea ya existe <- Error!!'), !, not(true).
%Valida que la empresa exista.
validar_tarea(_, Proyecto, _, _) :- not(existe_empresa(Proyecto)), writeln('!!Error -> Este proyecto no existe <- Error!!'), !, not(true).
%Valida que el tipo de tarea exista
validar_tarea(_, _, Tarea, _) :-
    string_lower(Tarea, Tarea_lower),
    tareas(Lista), maplist(string_lower, Lista, Lista_lower),
    not(member(Tarea_lower, Lista_lower)),
    writeln('!!Error -> Este tipo de tarea no existe. <- Error!!'), !, not(true).
%valida la fecha de ingreso de la tarea.
validar_tarea(_, _, _, Fecha) :- not(validar_fecha(Fecha)), writeln('!!Error -> La fecha no es valida <- Error!!'), !, not(true).
%Paso correctamente todas las validaciones.
validar_tarea(_, _, _, _):- true.

%Funcion que se encarga de guardar el predicado persona en un txt
guardar_tarea(Nombre, Proyecto, Tipo, Estado, Persona, Fecha_inicio, Fecha_final):-
    open('tareas.txt', append, Stream),
    writeq(Stream, tarea(Nombre, Proyecto, Tipo, Estado, Persona, Fecha_inicio, Fecha_final)), write(Stream, '.\n'),
    close(Stream).

% =============================validaciones==================================
% Funci�n para verificar si la empresa existe
existe_empresa(Nombre) :-
    proyecto(Nombre, _, _, _, _), !.
%Funci�n para verificar si la empresa existe
existe_tarea(Nombre) :-
    tarea(Nombre, _, _, _, _, _, _), !.

%Funcion para validar la fecha.
validar_fecha(Fecha) :-
    split_string(Fecha, "-", "", Lista),  %hacemos el split por guiones.
    %extraemos las posiciones de la lista.
    nth0(0, Lista, Year),
    nth0(1, Lista, Month),
    nth0(2, Lista, Day),
    %las transformamos a int.
    str_to_int(Year, Year_int),
    str_to_int(Month, Month_int),
    str_to_int(Day, Day_int),
    %Validamos los numeros de las fechas.
    (Year_int \= 0, Month_int \= 0, Day_int \= 0),
    Year_int > 2000, Year_int < 2050,
    between(1, 12, Month_int),
    between(1, 30, Day_int).

%String a entero.
str_to_int(Str, Int) :-
    (   catch(atom_number(Str, Int), _, true)
    ->  true
    ;   Int is 0  % O cualquier otro valor predeterminado que desees asignar en caso de error
    ).

% =============================validaciones==================================

%Imprime las tareas.
imprimir_tarea :-
    tarea(Nombre, Proyecto, Tipo, Estado, Persona, Fecha_inicio, Fecha_fin),
    write('Nombre: '), writeln(Nombre),
    write('Proyecto: '), writeln(Proyecto),
    write('Tipo de tareas: '), writeln(Tipo),
    write('Estado: '), writeln(Estado),
    write('Encargado: '), writeln(Persona),
    write('Fecha de inicio: '), writeln(Fecha_inicio),
    write('Fecha de finalizacion: '), writeln(Fecha_fin),
    write('\n'),
    fail.
imprimir_tarea :- true.

%cuenta la cantidad de proyectos existentes.
cantidad_proyectos(Cantidad) :-
    findall(_, proyecto(_,_,_,_,_), Proyectos),
    length(Proyectos, Cantidad).
