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