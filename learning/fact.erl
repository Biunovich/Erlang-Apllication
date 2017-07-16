-module(fact).
-export([fact/1]).

fact(Num) when is_integer(Num) and (Num >= 0) ->
     fact(Num,1);
fact(_Num) -> 
    io:format("Negative number~n").
fact(0, Acc) -> 
    Acc;
fact (Num , Acc) -> 
    fact(Num-1, Acc*Num).