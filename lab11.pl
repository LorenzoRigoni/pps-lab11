% Part 1: On built-in lists and numbers

% 1.1: search2(+Elem, -List)
% Inputs =>	search2(a, [a, a, b]). -> Yes
% 					search2(a, [a, c, b]). -> No
 
search2(X, [X, X | _]).
search2(X, [_ | T]) :- search2(X, T).

% 1.2: search_two(+Elem, -List)

search_two(X, [X, _, X | _]).
search_two(X, [_ | T]) :- search_two(X, T).

% 1.3: size(+List, -Size)
% It is not fully relational because, if we put size as input and list
% as output, Prolog go in loop.
% Inputs =>	size([a, b, c, d], X) -> yes, X/4
%						size([], X) -> yes, X/0

size([], 0).
size([_ | T], S) :- size(T, PS), S is PS + 1.

% 1.4: sum(+List, -Sum)

sum([], 0).
sum([H | T], S) :- sum(T, PS), S is H + PS.

% 1.5: max(+List, -Max, -Min)
% Inputs =>	max([2, 3, 1, 2], Max, Min). -> yes, Max/3, Min/1
%						max([5, 1, 8, 3], Max, Min). -> yes, Max/8, Min/1

max([H | T], Max, Min) :- max(T, H, H, Max, Min). %Aux values started with first element of the list

max([], Max, Min, Max, Min). % Base: empty list
max([H | T], MaxT, MinT, Max, Min) :- H > MaxT, !, max(T, H, MinT, Max, Min). %Found new max, no need other leaves
max([H | T], MaxT, MinT, Max, Min) :- H < MinT, !, max(T, MaxT, H, Max, Min). %Found new min, no need other leaves
max([H | T], MaxT, MinT, Max, Min) :- max(T, MaxT, MinT, Max, Min). %No new min or max, continue the search

% 1.6: split(+List, +Elements, -SubList1, -SubList2)

split(L, E, L1, L2) :- split(L, E, [], L1, L2).
split(L2, 0, L1, L1, L2).
split([H | T], E, LTemp, L1, L2) :- 
	NE is E - 1, %Decrement counter 
	append(LTemp, [H], LRes), %Append new element to the first sublist
	split(T, NE, LRes, L1, L2). %Check if counter is 0

% 1.7: rotate(+List, -RotatedList)

rotate([H | T], RL) :- rotate(T, H, RL).
rotate([], H, [H]).
rotate([H | T], N, [H | RL]) :- rotate(T, N, RL).

% 1.8: count_occurrences (+Element, +List, -Count)

count_occurrences(E, [], 0).
count_occurrences(E, [H | T], C) :- H = E, ! , count_occurrences(E, T, CS), C is CS + 1.
count_occurrences(E, [H | T], C) :- count_occurrences(E, T, C).

% 1.9: dice(-X)

dice(X) :- dice(1, 6, X).
dice(S, _, S).
dice(C, M, X) :- C < M, N is C + 1, dice(N, M, X).

% 1.10: three_dice(-L)

three_dice([D1, D2, D3]) :- dice(D1), dice(D2), dice(D3).

% 1.11: distinct(+List, -DistinctList)

distinct(L, DL) :- distinct(L, [], DL).

distinct([], _, []).
distinct([H | T], Seen, R) :- member(H, Seen), !, distinct(T, Seen, R).
distinct([H | T], Seen, [H | R]) :- distinct(T, [H | Seen], R).

% Part 2: basic cut operations

% 2.1: dropAny(?Elem, ?List, ?OutList)

dropAny(X, [X | T ], T).
dropAny(X, [H | Xs], [H | L]) :- dropAny(X, Xs, L).

% 2.2: other drops

% drop_first(?Elem, ?List, ?OutList)

drop_first(X, [X | T], T) :- !.
drop_first(X, [H | T], R) :- drop_first(X, T, R).

% drop_last(?Elem, ?List, ?OutList)

drop_last(X, [X], []) :- !.
drop_last(X, [X | T], [X | L]) :- drop_last(X, T, L), !.
drop_last(X, [H | T], [H | L]) :- drop_last(X, T, L).

% drop_all(?Elem, ?List, ?OutList)

drop_all(_, [], []).
drop_all(X, [X | T], L) :- !, drop_all(X, T, L).
drop_all(X, [H | T], [H | L]) :- drop_all(X, T, L).

% Part 3: Operations on graph

% 3.1: fromList(+List, -Graph)

fromList ([_], []) .
fromList ([H1, H2 | T], [e(H1, H2) | L]) :- fromList([H2 | T], L).

% 3.2: out_degree(+Graph, +Node, -Deg)

out_degree([], _, 0).
out_degree([e(N, _) | T], N, D) :- !, out_degree(T, N, PartialD), D is PartialD + 1.
out_degree([_ | T], N, D) :- out_degree(T, N, D).

% 3.3: reaching(+Graph, +Node, -List)

