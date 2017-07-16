-module(f).
-include("log.hrl").
-compile(export_all).

fact(Num,Proc) when is_integer(Num) and is_integer(Proc) and (Num >= 0) and (Proc > 0) ->
    Pid = spawn(f,start_listner,[Proc,self(),  []]),
    start_nodes(Pid, Num, Proc),
    receive
        Res -> ?LOG("Received result ~p",[Res])
    end;
fact(_,_) -> 
    ?LOG("Wrong arguments",[]).

start_listner(0, Pid,Acc) -> 
    Res = lists:foldl(fun(X,Prod) -> X*Prod end, 1, Acc),
    Pid ! Res;
start_listner(Proc,Pid, Acc) ->
    receive 
        X -> ?LOG("Receive from Node ~p",[X]),
             start_listner(Proc - 1,Pid,[X|Acc])
    end.

start_nodes(Pid, Num, Proc) when Num > Proc ->
    start_nodes(1, Num, Proc, Pid);
start_nodes(_Pid, _Num,_Proc) when _Num =< _Proc -> 
    ?LOG("Too much process",[]).
start_nodes(Start, Num, Proc, Pid) when Start =< Proc ->
    {ok,WorPid} = fac_ser:start_link(),
    fac_ser:prod_part(Start, Num, Proc, Pid, WorPid),
    start_nodes(Start + 1,Num, Proc, Pid);
start_nodes(Start, _Num, Proc, _Pid) when Start > Proc ->
    ok.