%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(balcony_hw_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
 
%% --------------------------------------------------------------------
%% Definitions 
-define(HeartBeatInterval,3*1000).
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------

-export([heartbeat/1]).
-export([start_link/0]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([
	 init/1
        ]).

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(SERVER, ?MODULE).
%% Helper macro for declaring children of supervisor
-define(CHILD(M, Type), {M, {M, start, []}, permanent, 5000, Type, [M]}).
%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================

start_link()->
   supervisor:start_link({local,?MODULE}, ?MODULE,[]).


heartbeat(HeartBeatInterval)->
    spawn(fun()->h_beat(HeartBeatInterval) end).

%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%% --------------------------------------------------------------------
init([]) ->
   % spawn(fun()->h_beat(?HeartBeatInterval) end),
    {ok,{{one_for_one,5,10}, 
	 children()
	}
    }.

children()->
    [?CHILD(balcony_hw,worker)].
%% ====================================================================
%% Internal functions
%% ====================================================================
h_beat(HeartBeatInterval)->
    timer:sleep(HeartBeatInterval),
    Children=children(),
    PingResult=[M:ping()||{M, {M, _, _}, _, _, _, [M]}<-Children],
    Result=update_sd(PingResult,[]),
    io:format("Result ~p~n",[{time(),Result}]),
    rpc:cast(node(),?MODULE,heartbeat,[HeartBeatInterval]).

update_sd([],Result) ->
    Result;
update_sd([{pong,Node,Module}|T],Acc)->
    rpc:cast(node(),if_db,call,[db_sd,h_beat,[Module,Node]]),
    NewAcc=[{ok,Module,Node}|Acc],
    update_sd(T,NewAcc);
update_sd([Reason|T],Acc) ->
    NewAcc=[{error,[Reason,?MODULE,?LINE]}|Acc],
    update_sd(T,NewAcc).
