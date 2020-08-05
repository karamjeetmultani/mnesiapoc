-module(mnesiapoc_app).
-behaviour(application).

-include("oma.hrl").

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
application:set_env(mnesia, dir, "/home/waheguru/workspace/erlang/mnesiapoc/"),
	 mnesia:start(),
	% mnesia:create_schema(['mnesiapoc@127.0.0.1']),
	mnesia:create_schema(node()),
	% % mnesia:start(),
	mnesia:change_table_copy_type(schema, node(), disc_copies),
	mnesia:create_table(oma, [
      {attributes, record_info(fields, oma)},
      {disc_copies, [node()]}
   ]),




	mnesiapoc_sup:start_link().

stop(_State) ->
	ok.
