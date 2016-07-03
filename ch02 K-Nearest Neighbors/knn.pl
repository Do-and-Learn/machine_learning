:- use_module(library(dialect/hprolog)).

knn(E, C, K) :-
    findall(D-C,(example(L2, C), distance(E, L2, D)), All),  % 計算 E 與所有樣本的距離
	msort(All, Sorted),  % 將距離由小排到大
	take(K, Sorted, FirstK),  % 挑選最近的 K 筆樣本
	most_common_item(FirstK, C-_).  % 挑選最多的類別作為答案

sub(Int1, Int2, Int3) :- Int3 is Int1 - Int2.
pow(Int1, Int2) :- Int2 is Int1 * Int1.

distance(L1, L2, Dist) :-
    maplist(sub, L1, L2, Sub),
	maplist(pow, Sub, Pow),
	sum_list(Pow, Sum),
	Dist is sqrt(Sum).

count(E, L, C) :-
    findall(E, member(E, L), All),
	length(All, C).

most_common_item([], _-0).
most_common_item([_-I1|L], I-C) :-
	count(_-I1, [_-I1|L], C1),
	delete(L, _-I1, L2),
	most_common_item(L2, I2-C2),
	(
	    C1 >= C2, I = I1, C = C1, !;
		I = I2, C = C2
	).