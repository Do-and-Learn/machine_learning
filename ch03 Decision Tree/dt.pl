classify(Type, _, Type) :- atom(Type), !.
classify(Feature->SubTrees, Vector, Type) :-
    member(Feature = Value, Vector),
    member(Value:Tree, SubTrees),
    classify(Tree, Vector, Type).

create_tree(DataSet, Type) :-
    extract_types(DataSet, Types),
    list_to_set(Types, [Type]), !. % �ҳѪ� Type ���ۦP�ɡA�h���G�� Type�C

create_tree([example(Type, Features)|L], Type) :-
    length(Features, 0), !, % �L feature �i�Ω����
    extract_types([example(Type, Features)|L], Types),
    most_common_item(Types, Type). % �D��ƶq�̦h�� Type �@�����G

create_tree(DataSet, Feature->SubTrees) :-
    choose_best_feature_to_split(DataSet, Feature),
    extract_feature_value_set(DataSet, Feature, Values),
    findall(Value:SubTree, % Feature = Value ���M���� SubTree
            % �H Feature ���ΡA�û��j�o�� Value ���䪺 SubTree
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
    findall(example(Type, Features), (member(example(Type, Features), DataSet), member(Feature = Value, Features)), Filtered), % ��X�Ҧ� Feature = Value �� example
    findall(example(Type, Remaining), (member(example(Type, Features), Filtered), delete(Features, Feature = _, Remaining)), Splited). % �q��X�� example ���R�� Feature

choose_best_feature_to_split(DataSet, Feature) :-
    DataSet = [example(_, Features)|_],
    findall(Entropy/Feature, (member(Feature = _, Features), information_gain(DataSet, Feature, Entropy)), InfoGain),
    sort(0, @>, InfoGain, [_/Feature|_]). % �ϥ� Feature ���η|�o��̰��� information gain

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