%%%-------------------------------------------------------------------
%% @doc fac top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(fac_start_sup).

-behaviour(supervisor).
-include("def.hrl").

%% API
-export([start_child/1, start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%%====================================================================
%% API functions
%%====================================================================
start_child(Proc)->  start_child(Proc, []).
start_child(0, Acc) -> Acc;
start_child(Proc, Acc) ->
    Child_Proc =  ?CHILDWor(make_ref(),fac_ser, worker, []),
    {ok, Pid } = supervisor:start_child(?SERVER, Child_Proc),
    start_child(Proc - 1, [Pid|Acc]).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).
%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 1, 5}, []}}.

%%====================================================================
%% Internal functions
%%====================================================================