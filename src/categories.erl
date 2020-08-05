-module(categories).
-include("oma.hrl").

-export([new/2, index/0, show/1, update/2, delete/1]).

new(F,L)->
	% mnesia:dirty_write({oma, F, L}),
	% (or)
	New = fun()->
		mnesia:write(#oma{category=F, type=L})
	end,
	mnesia:transaction(New),
	mnesia:dirty_read({oma, F}),

	% (mnesiapoc@127.0.0.1)13> F = fun()-> mnesia:select(oma, [{'_',[],['$_']}]) end,
	% (mnesiapoc@127.0.0.1)13> mnesia:activity(transaction, F). 


	io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, inserting new records", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE]).

index()->
	 F = fun()-> mnesia:select(oma, [{'_',[],['$_']}]) end,
	 REC = mnesia:activity(transaction, F),
	io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, oma table records ~n~p", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE, REC]).

show(F)->
	REC = mnesia:dirty_read({oma, F}),
	io:format("~n result REC is ~p~n", [REC]),
	
	% REC1 = mnesia:dirty_read({oma, F}),
	FRec = fun()->
		mnesia:read({oma, F})
	end,
	REC1 = mnesia:transaction(FRec),
	io:format("~n result of REC1 is  ~p~n", [REC1]),
	case REC =:= [] orelse
	REC1 =:= [] of
	true ->
		% {error, unknown_friend};
		io:format("error");
	false ->
		io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, oma table records ~n~p", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE, REC])

	end.


	% REC = mnesia:dirty_read({oma, F}),

update(F, L)->
	Fu = fun()->
		[P]= mnesia:wread({oma, F}), 
		mnesia:write(P#oma{type=L})
	end,
	mnesia:transaction(Fu),
	mnesia:dirty_read({oma, F}).

delete(F)->
	% mnesia:dirty_delete({oma, F}),
	Fu = fun()->
		mnesia:delete({oma, F})
	end,
	mnesia:transaction(Fu),
	index().
