% The states of the river problem are represented as the positions of FARMER, WOLF, SHEEP and CABBAGE respectively
% Example: state(e,e,e,w) ---> All on east side except cabbage

% Wolf eats sheep
unsafe(state(e,w,w,_)).
unsafe(state(w,e,e,_)).

% Sheep eats cabbage
unsafe(state(e,_,w,w)).
unsafe(state(w,_,e,e)).

% Opposite Sides
opposite(w,e).
opposite(e,w).

% Valid Moves
move(state(X,X,Sheep,Cabbage), state(Y,Y,Sheep,Cabbage)) :-
  opposite(X,Y),
  \+unsafe(state(Y,Y,Sheep,Cabbage)).

move(state(X,Wolf,X,Cabbage), state(Y,Wolf,Y,Cabbage)) :-
  opposite(X,Y),
  \+unsafe(state(Y,Wolf,Y,Cabbage)).

move(state(X,Wolf,Sheep,X), state(Y,Wolf,Sheep,Y)) :-
  opposite(X,Y),
  \+unsafe(state(Y,Wolf,Sheep,Y)).

move(state(X,Wolf,Sheep,Cabbage), state(Y,Wolf,Sheep,Cabbage)) :-
  opposite(X,Y),
  \+unsafe(state(Y,Wolf,Sheep,Cabbage)).

% State not seen yet. Returns false (fails) when it can be proven that State is in Log
not_seen(State, Log) :-
  member(State, Log), !, fail.

% State not seen yet. Returns true if State is not in Log
not_seen(_,_).

% Find Path Predicate for final state. Once reached, reverse the states log and print it
path(State, State, Log) :-
  !,
  reverse(Log, RLog),
  maplist(term_to_atom, RLog, LogAtoms),
  atomic_list_concat(LogAtoms, ' -> ', Solution),
  length(Log, Length),
  format("Solution of length ~d: ~q\n",[Length, Solution]).

% Find Path Predicate. Move in to next state if is safe and not seen yet
path(Current, Goal, Log) :-
  move(Current, Next),
  not_seen(Next, Log),
  path(Next, Goal, [Next|Log]).

% Objective
go(Start, Goal) :-
  path(Start, Goal, [Start]).
