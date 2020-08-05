-module(categories).
-include("oma.hrl").
 -include_lib("stdlib/include/qlc.hrl").

-export([new/2, index/0, show/1, update/2, delete/1, get_record_from_lastname/1, get_all_keys/0, select/1, select_all/0, select_search/1]).

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
		select(F),
		io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, oma table records ~n~p", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE, REC])

	end.

select( Index) ->
	io:format("~n~n testing"),
    Fun = 
        fun() ->
            mnesia:read({oma, Index})
        end,
    {atomic, [Row]}=mnesia:transaction(Fun),
io:format("~n ?MODULE:~p,~n ?MODULE_STRING:~p~n, ?FILE:~p~n, ?LINE:~p~n, ?MACHINE:~p~n, ?FUNCTION_NAME:~p~n, ?FUNCTION_ARITY:~p~n, ?OTP_RELEASE:~p~n, oma table records ~nCategory is: ~p, Type is: ~p ~n", [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?MACHINE, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?OTP_RELEASE, Row#oma.category, Row#oma.type]).
    % io:format(" ~p ~p ~n ", [Row#oma.category, Row#oma.type] ).

select_all() -> 
	mnesia:transaction( 
	fun() ->
		qlc:eval( qlc:q(
			[ X || X <- mnesia:table(oma) ] 
		)) 
	end ).



% select_search( Word ) -> 
% 	Results = mnesia:transaction( 
% 		fun() ->
% 			qlc:eval( qlc:q(
% 			[ {F0,F1, F2} || 
% 			{F0,F1,F2} <- 
% 			mnesia:table(oma),
% 				{{"_", Word, "_"}, {"_", "_", Word}}
% 				% (string:str(F1, Word))
% 			] )) 
% 	end ), 
% 	io:format("~n Results is: ~p~n", [Results]),
% 	case Results of
% 		{aborted, _}->
% 			io:format("issue");
% 		{atomic, _} ->
% 			io:format("working");
% 		_->	
% 			io:format("some unknown response")
% 	end.


 select_search( Word ) -> 
 	io:format("~n ~p ~n", [is_atom(Word)]),
 	io:format("~n ~p ~n", [is_list(Word)]),
     mnesia:transaction( 
     fun() ->
          qlc:eval( qlc:q(
                % [ {F0,F1,F2} || 
                %     {F0,F1,F2} <- 
                %          mnesia:table(oma),
                %          (string:str(F0, Word)>0) or  
                %          (string:str(F1, Word)>0) or  
                %          (string:str(F2, Word)>0)
                % ]
                [ QueryResult || 
                    QueryResult <- 
                         mnesia:table(oma),
                         % (string:str(F0, Word)>0) or  
                         % (string:str(F1, Word)>0) or  
                         % (string:str(F2, Word)>0)
                         (QueryResult#oma.category == Word) or
                         (QueryResult#oma.type == Word) 
                ] 
                )) 
	end ).
		% (mnesiapoc@127.0.0.1)64> categories:select_search(singha).

		% true 

		% false 
		% {atomic,[{oma,karamjeet,singha}]}

		% (mnesiapoc@127.0.0.1)65> categories:select_search(abhijeet).

		% true 

		% false 
		% {atomic,[{oma,abhijeet,singhmultani}]}




get_record_from_lastname(L)->
	Fun = fun() ->
		mnesia:match_object({oma, '_', L})
	end,
	{atomic, Results} = mnesia:transaction( Fun),
	Results.

get_all_keys()->
	mnesia:dirty_all_keys(oma).

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
