-module(changecaseserver).
-export([start/0, loop/0]).

start() ->
    spawn (changecaseserver, loop, []). % spawn a new process

loop() ->
    receive
        {Client, {Str, uppercase}} -> 
            Client ! { self(), string:to_upper(Str) }; % send the result to the client (Uppercase)
        {Client, {Str, lowercase}} ->
            Client ! { self(), string:to_lower(Str) }; % send the result to the client (Lowercase)
        _ -> % Unknown specifier
            ok
    end,
    loop().

% The goal of making this function as a server is to make it easier to test the server,
% as we can now send commands to the server without having to manually create a client with the self() function to act as a server.
% This function receives a string, and a command from the client and sends the result back to the client.