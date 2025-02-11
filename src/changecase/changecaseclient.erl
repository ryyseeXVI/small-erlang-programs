-module(changecaseclient).
-export([changecase/3]).

changecase(Server, Str, Command) ->
    Server ! {self(), {Str, Command}}, % Send the command to the server
    receive % Wait for the result
        {Server, Result} ->
            Result % Return the result
    end.

% The goal of making this function as a client is to make it easier to test the server,
% as we can now send commands to the server without having to manually create a client with the self() function.
% This function sends a string, and a command to the server and waits for the result.