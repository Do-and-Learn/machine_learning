:- use_module(library(readutil)).

lenses(DataSet) :-
    open('lenses.txt', read, Stream),
    read_all_example(Stream, DataSet),
    close(Stream).

read_all_example(Stream, Examples) :-
    read_line_to_codes(Stream, Codes),
    (
        Codes = end_of_file, Examples = [], !
        ;
        string_to_list(String, Codes),
        split_string(String, "\t", "", Tokens),
        build_example(Tokens, Example),
        read_all_example(Stream, L),
        Examples = [Example|L]
    ).

build_example(
    [Age, Prescript, Astigmatic, TearRate, Lenses],
    example(Lenses, ['age'=Age, 'prescript'=Prescript, 'astigmatic'=Astigmatic, 'tearRate'=TearRate])).