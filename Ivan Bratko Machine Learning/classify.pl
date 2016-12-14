classify(Object, Class) :-
  Class <== Description,
  member(Conj, Description),
  satisfy(Object, Conj).
