/*
 * count is the summation of all terms in list
 *the former is the list
 *X is the sum of elements
 *adds elements recursively
 */
count([], X):- X is 0.
count([H|T], N):- count(T, N1), N is N1+H.

/*
 *finds all teams in the database
 *L is the list that contains all teams
 *N is the number of teams
 *findall is the built-in func that finds all teams in the base and append in L1
 *perm takes the permutation of L1
 *length is the built-in function that find the length of L
 */
allTeams(L, N):- findall(X, team(X, _), L1), permutation(L1, L), length(L, N).

/*
 *win_list is the predicate that generates the list
 *findall finds the defeated team and appends into L1 and L2
 *appends L1 and L2 into L
 *
 *check_wins is the predicates that checks the winning conditions
 *W1 is the week between 1 to W
 *match is the predicates in the database
 */
check_wins(T, W, X):- match(W1, T, A, X, B), A>B, between(1, W, W1).
win_list(T, W, L):- findall(X, check_wins(T, W, X), L1),
    findall(X1, check_losses(X1, W, T), L2), append(L1, L2, L).

/*
 *wins finds the teams that are defeated by team T up to week W
 *T and W are constants
 *L is the list of defeated teams
 *N is the length of L
 */
wins(T, W, L, N):- win_list(T, W, L), length(L, N).

/*
 *loss_list is the predicate that generates the list
 *findall finds the winner team and appends into L1 and L2
 *appends L1 and L2 into L
 *
 *check_losses is the predicates that checks the losing conditions
 *W1 is the week between 1 to W
 *match is the predicates in the database
 */
check_losses(T, W, X):- match(W1, T, A, X, B), A<B, between(1, W, W1).
loss_list(T, W, L):- findall(X, check_losses(T, W, X), L1),
    findall(X1, check_wins(X1, W, T), L2), append(L1, L2, L).

/*
 *losses finds the teams that defeated team T up to week W
 *T and W are constants
 *L is the list of winner teams
 *N is the length of L
 *loss_list finds list L
 */
losses(T, W, L, N):- loss_list(T, W, L), length(L, N).

/*
 *check_draws is the predicates that checks the draw conditions
 *W1 is the week between 1 to W
 *match is the predicates in the database
 *
 *draw_list is the predicate that generates the list
 *findall finds the teams and appends into L1 and L2
 *appends L1 and L2 into L
 */
check_draws(T, W, X):- match(W1, T, A, X, B), A is B, between(1, W, W1).
draw_list(T, W, L):- findall(X, check_draws(T, W, X), L1),
    findall(X1, check_draws(X1, W, T), L2), append(L1, L2, L).

/*
 *draws finds the teams that team T could not defeat and did not lose
 up to week W
 *T and W are constants
 *L is the list of winner teams
 *N is the length of L
 */
draws(T, W, L, N):- draw_list(T, W, L), length(L, N).

/*
 * ts_inverse is the predicates that checks the matches in the awayhome
 * tscored is the predicates that checks the matches in the hometown
 */
tscored(T, W, S):- match(W1, T, S, _, _), between(1, W, W1).
ts_inverse(T, W, S):- match(W1, _, _, T, S), between(1, W, W1).

/*
 *scored is the predicate that contains T, W, S
 *T and W are constants, T is the team, W is week
 *S is the number of goals scored by team T
 *findall finds the goals and appends into the L1 and L2
 *appends L1, L2 into the L
 *count is the predicate that adds the elements
 */
scored(T, W, S):- findall(X, tscored(T, W, X), L1),
    findall(X, ts_inverse(T, W, X), L2), append(L1, L2, L), count(L, S).

/*
 * tc_inverse is the predicates that checks the matches in the awayhome
 * tconceded is the predicates that checks the matches in the hometown
 * T and W are constants, T is the team, W is week
 * W1 is the week between 1 to W
 */
tconceded(T, W, C):- match(W1, T, _, _, C), between(1, W, W1).
tc_inverse(T, W, C):- match(W1, _, C, T, _), between(1, W, W1).

/*
 *conceded is the predicate that contains T, W, S
 *T and W are constants, T is the team, W is week
 *S is the number of goals conceded by team T
 *findall finds the goals and appends into the L1 and L2
 *appends L1, L2 into the L
 *count is the predicate that adds the elements
 */
conceded(T, W, C):- findall(X, tconceded(T, W, X), L1),
    findall(X, tc_inverse(T, W, X), L2), append(L1, L2, L), count(L, C).

/*
 *average is the predicates that finds the average score
 *T and W is the constant, T is the team, W is week
 *A is the number of scored goals minus the number of conceded goals
 *scored and conceded give the numbers of goals
 */
average(T, W, A):- scored(T, W, S), conceded(T, W, C), A is S-C.

/*
 *pivot creates left and right list with respect to the pivot element
 *puts the elements left and right list recursively with ascending order
 */
pivot(_, [], [], [], _).
pivot(X, [H|T], [H|L], R, W) :- average(H, W, A), A @=< X,
    pivot(X, T, L, R, W).
pivot(X, [H|T], L, [H|R], W) :-  average(H, W, A), A @> X,
    pivot(X, T, L, R, W).

/*
 * q_sort is sorts with divide and conquer strategy
 * H is the head of list, T is the tail of list
 * X is the updated list
 * W is constant, it is week
 * Sorted is the sorted form of the first list
 * average finds the average score A of H
 * pivot creates L1 and L2 with respect to A
 * sorts L1 and L2 recursively
 */
q_sort([], X, _, X).
q_sort([H|T], X, W, Sorted):- average(H, W, A), pivot(A, T, L1, L2, W),
    q_sort(L1, X, W, Sort1), q_sort(L2, [H|Sort1], W, Sorted).

/*
 * quick_sort sorts the List
 * List contains all teams
 * W is constant, it is week
 * Sorted is the sorted list of all teams with ascending order
 */
quick_sort([], _, _).
quick_sort(List, W, Sorted):- q_sort(List, [], W, Sorted).

/*
 * order is the predicates that gives the league order in that week
 * L is the order of all teams
 * W is constant and it is week
 * findall finds all teams and appends into L1
 * quick_sort sorts the L1, according to W, and appends L
 */
order(L, W):- findall(X, team(X, _ ), L1), quick_sort(L1, W, L).

/*
 *takes N elements of list
 * N is the number of elements
 * first is the given list
 * it takes element recursively and puts into the second list
 */
take(0, _, []).
take(0, [], []).
take(N, [H|X], [H|Y]) :- N1 is N-1, take(N1, X, Y).

/*
 *topThree is the predicate that takes top three elements in order list
 *L is the list of top three teams
 *W is the constant, it is week
 *order finds the list of teams L1 in week W
 *take takes 3 elements in L1 and appends into L
 */
topThree(L, W):- order(L1, W),  take(3, L1, L).
