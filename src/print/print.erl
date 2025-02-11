-module(print).
-export([start/1]).

start(Str) ->
    io:format(string:concat(Str, "\n")). % You can use ++ too, like this: Str ++ "\n".
