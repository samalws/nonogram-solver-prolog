:- use_module(library('clpb')).
:- use_module(library('clpfd')).

main(N, M, RowConstrs, ColConstrs) :- boardSized(Board, N, M), solve(Board, RowConstrs, ColConstrs), prettyPrintMain(Board).

boardSized([], _, 0).
boardSized([H|T], N, M) :- rowSized(H, N), MM is M-1, boardSized(T,N,MM).

rowSized([], 0).
rowSized([_|T], N) :- NM is N-1, rowSized(T, NM).

prettyPrintMain(Board) :- prettyPrint(Board, 5).

prettyPrint([],_) :- !.
prettyPrint(R,0) :- writeDelimHoriz(R), prettyPrint(R,5).
prettyPrint([Row|Rest],N) :- prettyPrintRow(Row,5), write('\n'), NM is N-1, prettyPrint(Rest,NM).

writeDelimHoriz([]) :- write('\n').
writeDelimHoriz([_|T]) :- write('-'), writeDelimHoriz(T).

prettyPrintRow([],_) :- !.
prettyPrintRow(R,0) :- write('|'), prettyPrintRow(R,5).
prettyPrintRow([0|R],N) :- write(' '), NM is N-1, prettyPrintRow(R,NM).
prettyPrintRow([1|R],N) :- write('#'), NM is N-1, prettyPrintRow(R,NM).

solve(Board, RowConstrs, ColConstrs) :- checkRows(Board, RowConstrs), transpose(Board, BoardT), checkRows(BoardT, ColConstrs), flatten(Board, BoardFlat), labeling(BoardFlat).

checkRows([], []).
checkRows([Row|Rows], [Constr|Constrs]) :- checkRow(Row, Constr), checkRows(Rows, Constrs).

checkRow([], []).
checkRow([0|R], Ns) :- checkRow(R, Ns).
checkRow(R, [N|Ns]) :- checkRowTrue(R, N, Ns).

checkRowTrue([], 0, Ns) :- checkRow([], Ns).
checkRowTrue([0|R], 0, Ns) :- checkRow(R, Ns).
checkRowTrue([1 |R], N, Ns) :- NDec is N-1, checkRowTrue(R, NDec, Ns).
