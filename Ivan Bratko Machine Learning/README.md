# Learning from example

Run *fig18_11.pl* and consult *fig18_9.pl* and *classify.pl*.

``` Prolog
?- consult(fig18_9).
true.

?- consult(classify).
true.

?- learn(nut), learn(key), learn(scissors).

nut  <==
  [shape=compact,holes=1]

key  <==
  [shape=other,size=small]
  [holes=1,shape=long]

scissors  <==
  [holes=2,size=large]
true .

?- classify([ size = small, shape = other, holes = 2], Class).
Class = key.

?- classify([size=small, shape=compact, holes=1], Class).
Class = nut.
```
