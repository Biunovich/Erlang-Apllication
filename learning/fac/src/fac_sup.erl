%%%-------------------------------------------------------------------
%% @doc fac top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(fac_sup).

-behaviour(supervisor).
-include("def.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    MainWorker = ?CHILD(fac_start, worker, []),
    SubSuper = ?CHILD(fac_start_sup, supervisor,[]),
    {ok, { {one_for_all, 1, 5}, [MainWorker, SubSuper]}}.

%%====================================================================
%% Internal functions
%%====================================================================
