% ========================================================================
% Proyecto Prolog. Problema del lobo, la oveja y la col
% ========================================================================
% Autor: Luis Marcelo Chinea Rangel
% Correo: alu0101118116@ull.edu.es
% Universidad de La Laguna
% Escuela Superior de Ingeniería y Tecnología
% Grado de Ingeniería Informática
% Asignatura: Inteligencia Artificial
% ========================================================================
% ploc(X,L)
% Unifica si la Lista L es una solución al problema
% y si la Lista X es una permutación de los integrantes
% del problema (pastor, lobo, oveja, col)
ploc([],Y,R):- append(_,[Y],R1), append(R1,[[]],R).
% 1ª Fase, mover al pastor y a la oveja: {lobo, col} {pastor, oveja}
ploc(X,Y,0,R):-
    extraer(pastor,X,A1), append(Y,[pastor],B1),
    extraer(oveja,A1,A), append(B1,[oveja],B),
    ploc(A,B,1,R1),
    append(R1,[Y],R2), append(R2,[X],R).
% 2ª Fase, el pastor regresa: {pastor, lobo, col} {oveja}
ploc(X,Y,1,R):-
    extraer(pastor,Y,B), append(X,[pastor],A),
    ploc(A,B,2,R1),
    append(R1,[Y],R2), append(R2,[X],R).
% 3ª Fase. El pastor se lleva al lobo: {col} {pastor, oveja, lobo}
ploc(X,Y,2,R):-
    extraer(pastor,X,A1), append(Y,[pastor],B1),
    extraer(lobo,A1,A), append(B1,[lobo],B),
    ploc(A,B,3,R1),
    append(R1,[Y],R2), append(R2,[X],R).
% 4ª Fase. Ups! El lobo y la oveja no pueden estar juntos. El pastor regresa con la oveja:
% {pastor, oveja, col} {lobo}
ploc(X,Y,3,R):-
    extraer(pastor,Y,B1), append(X,[pastor],A1),
    extraer(oveja,B1,B), append(A1,[oveja],A), 
    ploc(A,B,4,R1),
    append(R1,[Y],R2), append(R2,[X],R).
% 5ª Fase. La col no puede estar con la oveja. El pastor lleva la col:
% {oveja} {pastor, lobo, col}
ploc(X,Y,4,R):-
    extraer(pastor,X,A1), append(Y,[pastor],B1),
    extraer(col,A1,A), append(B1,[col],B),
    ploc(A,B,5,R1),
    append(R1,[Y],R2), append(R2,[X],R).
% 6ª Fase. El pastor regresa: {pastor, oveja} {lobo, col}
ploc(X,Y,5,R):-
    extraer(pastor,Y,B), append(X,[pastor],A),
    ploc(A,B,6,R1),
    append(R1,[Y],R2), append(R2,[X],R).
% 7ª Fase. El pastor lleva a la oveja. Fin del problema: {} {pastor, lobo, oveja, col}
ploc(X,Y,6,R):-
    extraer(pastor,X,A1), append(Y,[pastor],B1),
    extraer(oveja,A1,A), append(B1,[oveja],B),
    ploc(A,B,7,R1),
    append(R1,[Y],R2), append(R2,[X],R).
ploc(_,Y,7,R):- append(_,[Y],R1), append(R1,[[]],R).
ploc([W,X,Y,Z],R):-
    permutacion([W,X,Y,Z],[pastor,lobo,oveja,col]),
    ploc([W,X,Y,Z],[],0,L), reverse(L,R).

% extraer(X,L,R) - Unifica si la lista R equivale
% a la lista L, extrayendo de ella el elemento X.
% Ej: extraer(c,[a,b,c,d,e],[a,b,d,e]).
extraer(X,[X|T],T).
extraer(X,[A|T],[A|R]):-extraer(X,T,R).

% permutacion(X,Y) - Unifica si la lista X es una
% permutacion de la lista Y. El segundo argumento
% siempre debe estar completamente definido.
% Ej: permutacion([a,b,c],[b,a,c]).
permutacion([],[]).
permutacion([X|T],Y):-extraer(X,Y,Z),permutacion(T,Z).
