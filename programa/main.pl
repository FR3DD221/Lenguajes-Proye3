:- dynamic(persona/5).

tareas(['requerimientos', 'disenio', 'desarrollo', 'qa', 'fullstack', 'frontend', 'backend', 'administracion']).

menu:- writeln('1. Gestion de personas'),
    writeln('9. Salir'), write('Ingrese su opcion deseada: '), read_line_to_string(user_input, Opcion), comprobarOpcionMenuMain(Opcion).

comprobarOpcionMenuMain(Opcion):- string_lower(Opcion, "1"), menuPersona, menu.
comprobarOpcionMenuMain(Opcion):- string_lower(Opcion, "9"), !.
comprobarOpcionMenuMain(_):- writeln('Opcion invalida. Por favor, ingrese una opcion valida.'), menu.

menuPersona:- writeln('1. Agregar de personas'), writeln('2. Imprimir personas'), writeln('3. Volver'), write('Ingrese su opcion: '), 
    read_line_to_string(user_input, Opcion), comprobarOpcionPersona(Opcion).

comprobarOpcionPersona(Opcion):- string_lower(Opcion, "1"), ingresarPersonas, menuPersona.
comprobarOpcionPersona(Opcion):- string_lower(Opcion, "3").
comprobarOpcionPersona(_):- writeln('Opcion invalida. Por favor, ingrese una opcion valida.'), menuPersona.

ingresarPersonas:- write('Ingrese el nombre de su trabajador: '), read_line_to_string(user_input, Nombre), nl,
    write('Ingrese el puesto de su trabajador: '), read_line_to_string(user_input, Puesto), nl,
    write('Ingrese el costo por tarea de su trabajador: '), read_line_to_string(user_input, Costo), nl,
    write('Ingrese el rating de su trabajador: '), read_line_to_string(user_input, Rating), nl,
    agregarTareas(Nombre, Puesto, Costo, Rating, []).

agregarTareas(Nombre, Puesto, Costo, Rating, Tareas):- write('Ingrese su tarea o la letra s para finalizar: '), 
    read_line_to_string(user_input, TareaNueva), agregarTareasAux(TareaNueva, Tareas, Nombre, Puesto, Costo, Rating).

agregarTareasAux(TareaNueva, Tareas, _, _, _, _):- 
    string_lower(TareaNueva, "s"),
    length(Tareas, 0), 
    writeln('!!Error -> no puede ingresar un usuario sin tareas <- Error!!').

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

guardar_personas(Nombre, Puesto, Costo, Rating, Tareas):-
    tell('C:/Users/fredd/OneDrive/Documentos/TEC/LENGUAJES/PP3_Fredd_Randall/programa/personas.txt'),
    writeq(persona(Nombre, Puesto, Costo, Rating, Tareas)), write('.\n'),
    told.
