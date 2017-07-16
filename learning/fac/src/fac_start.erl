-module(fac_start).
-include("def.hrl").
-compile(export_all).

%%%%%% API
start_link() -> gen_server:start_link({local, ?MODULE},?MODULE, [],[]).

fact(Num,Proc) when is_integer(Num) and is_integer(Proc) and (Num >= 0) and (Proc > 0) ->
    gen_server:call(?MODULE, {Num, Proc});
fact(_,_) -> 
    ?LOG("Wrong arguments",[]).


%%%%%% Callbacks 
init([]) -> {ok, {}}.

handle_call({Num, Proc}, _From, State) ->
    Pid = spawn(fac_start,start_listner,[Proc,self(),  []]),
    WorPid = fac_start_sup:start_child(Proc),
    start_nodes(Pid, Num, Proc, WorPid),
    receive
        Res -> ?LOG("Received result ~p",[Res])
    end,
    {reply, Res, State}.

start_listner(0, Pid,Acc) -> 
    Res = lists:foldl(fun(X,Prod) -> X*Prod end, 1, Acc),
    Pid ! Res;
start_listner(Proc,Pid, Acc) ->
    receive 
        X -> ?LOG("Receive from Node ~p",[X]),
             start_listner(Proc - 1,Pid,[X|Acc])
    end.


start_nodes(Pid, Num, Proc, WorPid) when Num >= Proc ->
    start_nodes(1, Num, Proc, Pid, WorPid);
start_nodes(_Pid, _Num,_Proc, _WorPid) when _Num < _Proc -> 
    ?LOG("Too much process",[]).
start_nodes(Start, Num, Proc, Pid, [H|WorPid]) when Start =< Proc ->
    fac_ser:prod_part(Start, Num, Proc, Pid, H),
    start_nodes(Start + 1,Num, Proc, Pid, WorPid);
start_nodes(Start, _Num, Proc, _Pid, _WorPid) when Start > Proc ->
    ok.