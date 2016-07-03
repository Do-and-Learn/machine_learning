example(fish, ['no surfacing' = 1, 'flippers' = 1]).
example(fish, ['no surfacing' = 1, 'flippers' = 1]).
example(not_fish, ['no surfacing' = 1, 'flippers' = 0]).
example(not_fish, ['no surfacing' = 0, 'flippers' = 1]).
example(not_fish, ['no surfacing' = 0, 'flippers' = 1]).

training_set(Training_Set) :-
    findall(example(Type, Features), example(Type, Features), Training_Set).