# Decision Tree

## Example 1: 魚類分類

|&nbsp; |Can survive without coming surface?|Has flippers?|Fish?|
| ------| --------------------------------- | ----------- | --- |
|1      |Yes                                |Yes          |Yes  |
|2      |Yes                                |Yes          |Yes  |
|3      |Yes                                |No           |No   |
|4      |No                                 |Yes          |No   |
|5      |No                                 |Yes          |No   |

```prolog
?- consult(training_set).
?- consult(dt).
```

### Create Decision Tree

```prolog
?- training_set(DataSet), create_tree(DataSet, Tree).
DataSet = [example(fish, ['no surfacing'=1, flippers=1]), example(fish, ['no surfacing'=1, flippers=1]), example(not_fish, ['no surfacing'=1, flippers=0]), example(not_fish, ['no surfacing'=0, flippers=1]), example(not_fish, ['no surfacing'=0, flippers=1])],
Tree = ('no surfacing'->[1: (flippers->[1:fish, 0:not_fish]), 0:not_fish]).
```

![](80843fee-4b1d-4190-8858-93548837a919.png)

### Classify

```prolog
?- classify(('no surfacing'->[1: (flippers->[1:fish, 0:not_fish]), 0:not_fish]), ['no surfacing' = 1, 'flippers' = 0], Type).
Type = not_fish.
?- classify(('no surfacing'->[1: (flippers->[1:fish, 0:not_fish]), 0:not_fish]), ['no surfacing' = 1, 'flippers' = 1], Type).
Type = fish.
```

## Example 2: 預測隱形眼鏡類型

### Create Decision Tree

```prolog
?- consult(lenses).
?- consult(dt).
?- lenses(DataSet), create_tree(DataSet, Tree).
Tree = (tearRate->["reduced":"no lenses", "normal": (astigmatic->["no": (age->["young":"soft", "pre":"soft", "presbyopic": (prescript->["myope":"no lenses", "hyper":"soft"])]), "yes": (prescript->["myope":"hard", "hyper": (age->["young":"hard", "pre":"no lenses", "presbyopic":"no lenses"])])])]).
```

ps: [see whole answer](http://www.swi-prolog.org/FAQ/AllOutput.html)

```
?- set_prolog_flag(answer_write_options, [quoted(true), portray(true), spacing(next_argument)]).
```