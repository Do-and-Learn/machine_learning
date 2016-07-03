classify(Type, _, Type) :- atom(Type), !.
classify(Feature->SubTrees, Vector, Type) :-
    member(Feature = Value, Vector),
    member(Value:Tree, SubTrees),
    classify(Tree, Vector, Type).

create_tree(DataSet, Type) :-
    extract_types(DataSet, Types),
    list_to_set(Types, [Type]), !. % 所剩的 Type 都相同時，則結果為 Type。

create_tree([example(Type, Features)|L], Type) :-
    length(Features, 0), !, % 無 feature 可用於分類
    extract_types([example(Type, Features)|L], Types),
    most_common_item(Types, Type). % 挑選數量最多的 Type 作為結果

create_tree(DataSet, Feature->SubTrees) :-
    choose_best_feature_to_split(DataSet, Feature),
    extract_feature_value_set(DataSet, Feature, Values),
    findall(Value:SubTree, % Feature = Value 的決策樹為 SubTree
            % 以 Feature 切割，並遞迴得到 Value 分支的 SubTree
            (member(Value, Values), split(DataSet, Splited, Feature = Value), create_tree(Splited,SubTree)),
            SubTrees).

shannon_entropy(DataSet, Entropy) :-
    extract_type_set(DataSet, Types),
    findall(Info, (member(Class, Types), l(Class, DataSet, Info)), AllInfo),
    sum_list(AllInfo, Entropy).

l(Type, DataSet, Info) :-
    extract_types(DataSet, Types),
    count(Type, Types, ClassCount),
    length(Types, Amount),
    Info is -(ClassCount/Amount)*(log(ClassCount/Amount)/log(2)).

split(DataSet, Splited, Feature = Value) :-
    findall(example(Type, Features), (member(example(Type, Features), DataSet), member(Feature = Value, Features)), Filtered), % 找出所有 Feature = Value 的 example
    findall(example(Type, Remaining), (member(example(Type, Features), Filtered), delete(Features, Feature = _, Remaining)), Splited). % 從找出的 example 中刪除 Feature

choose_best_feature_to_split(DataSet, Feature) :-
    DataSet = [example(_, Features)|_],
    findall(Entropy/Feature, (member(Feature = _, Features), information_gain(DataSet, Feature, Entropy)), InfoGain),
    sort(0, @>, InfoGain, [_/Feature|_]). % 使用 Feature 切割會得到最高的 information gain

information_gain(DataSet, Feature, InfoGain) :-
    shannon_entropy(DataSet, BaseEntropy),
    extract_feature_value_set(DataSet, Feature, Values),
    length(DataSet, Amount),
    findall(Entropy, 
            (member(Value, Values), split(DataSet, Splited, Feature = Value), shannon_entropy(Splited, SingleEntropy), length(Splited, SingleCount), Entropy is (SingleCount/Amount)*SingleEntropy),
            All),
    sum_list(All, Entropy),
    InfoGain is BaseEntropy - Entropy.

extract_feature_value_set(DataSet, Feature, Values) :-
    findall(Value, (member(example(_, Features), DataSet), member(Feature = Value,Features)), LValues),
    list_to_set(LValues, Values).    

extract_type_set(DataSet, TypesSet) :-
    extract_types(DataSet, Types),
    list_to_set(Types, TypesSet).

extract_types(DataSet, Types) :-
    findall(Type, member(example(Type, _), DataSet), Types).

most_common_item(List, Item) :-
    forall(Count/Item, (list_to_set(List, Set), members(Item, Set), count(Item, List, Count)), Counts),
    sort(0, @>, Counts, [_/Item|_]).

count(E, L, C) :-
    findall(E, member(E, L), All),
    length(All, C).