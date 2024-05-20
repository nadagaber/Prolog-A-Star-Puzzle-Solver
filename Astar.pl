% Define the possible colors
color(red).
color(yellow).
color(blue).

rows(X,Rows) :-
    Rows is X.

columns(X,Columns) :-
    Columns is X.

% Input:
% define dimensions
rows(2).
columns(3).

% define node positions and their colors
color((0,0), blue).
color((0,1), red).
color((0,2), red).
color((1,0), blue).
color((1,1), red).
color((1,2), blue).

% Define the heuristic predicate (manhattan distance)
heuristic((X1,Y1), (X2,Y2), H) :-
    XDiff is abs(X1 - X2),
    YDiff is abs(Y1 - Y2),
    H is XDiff + YDiff.

% Define a heuristic goal function for sorting
heuristic_goal([Node|Path], H) :-
    length(Path, G),
    last(Path, Goal), % Retrieve the goal node
    heuristic(Node, Goal, H0), % Pass both current node and goal to heuristic/3
    H is G + H0.

move((X,Y), (X1,Y1)) :-
    neighbor((X,Y), (X1,Y1)),
    color((X,Y), C),
    color((X1,Y1), C).

neighbor((X,Y), (X1,Y)) :- X1 is X + 1, valid_position(X1,Y).
neighbor((X,Y), (X1,Y)) :- X1 is X - 1, valid_position(X1,Y).
neighbor((X,Y), (X,Y1)) :- Y1 is Y + 1, valid_position(X,Y1).
neighbor((X,Y), (X,Y1)) :- Y1 is Y - 1, valid_position(X,Y1).

valid_position(X,Y) :-
    rows(Rows), 
    columns(Columns), 
    X >= 0, 
    X < Rows,
    Y >= 0,
    Y < Columns. 

astar(Start, Goal, Path) :-
    astar_path([[Start]], Goal, Path).

% Base case: Goal is reached
astar_path([[Goal|Path]|_], Goal, [Goal|Path]).

% Recursive case: Expand the current path
astar_path([Path|Paths], Goal, FinalPath) :-
    extend(Path, NewPaths),
    append(Paths, NewPaths, AllPaths),
    sort_paths(AllPaths, SortedPaths),
    astar_path(SortedPaths, Goal, FinalPath).

% Extend a path with valid moves
extend([Node|Path], NewPaths) :-
    findall([NewNode,Node|Path], (move(Node, NewNode), \+ member(NewNode, Path)), NewPaths).

% Sort paths based on heuristic
sort_paths(Paths, SortedPaths) :-
    map_list_to_pairs(heuristic_goal, Paths, Keyed),
    keysort(Keyed, Sorted),
    pairs_values(Sorted, SortedPaths).

solve_puzzle(Start, Goal,_) :-
    astar(Start, Goal, Path),
    print_path(Path), nl.

solve_puzzle(_, _, _) :-
    write('No path found.').

print_path([]).
print_path([Node]) :-
    write('Path found to the goal.'),nl,
    write(Node).
print_path([Node|Path]) :-
    print_path(Path),
    write(' -> '),
    write(Node).

% Example query 
% solve_puzzle((0,0), (1,2), Path).