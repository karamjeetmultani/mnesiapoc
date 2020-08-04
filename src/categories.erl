-module(categories).
-include("oma.hrl").

-export([new/2, index/0]).

new(F,L)->
	mnesia:dirty_write({oma, F, L}),
	mnesia:dirty_read({oma, F}),

	% (mnesiapoc@127.0.0.1)13> F = fun()-> mnesia:select(oma, [{'_',[],['$_']}]) end,
	% (mnesiapoc@127.0.0.1)13> mnesia:activity(transaction, F). 


	io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, inserting new records", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE]).

index()->
	 F = fun()-> mnesia:select(oma, [{'_',[],['$_']}]) end,
	 REC = mnesia:activity(transaction, F),
io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, oma table records ~p", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE, REC]).