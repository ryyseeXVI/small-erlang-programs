-module(calculus).
-export([start/0, add/1, multiply/1, divide/1, sub/1, stop/0, loop/0]).

start() ->
    Pid = spawn(fun() -> loop() end),
    register(calculus, Pid).

add(NumberList) when is_list(NumberList) ->
    calculus ! {self(), add, NumberList},
    receive
        { result, Result } -> Result
    end.

sub(NumberList) when is_list(NumberList) ->
    calculus ! { self(), sub, NumberList},
    receive
        { result, Result } -> Result
    end.

divide(NumberList) when is_list(NumberList) ->
    calculus ! { self(), divide, NumberList},
    receive
        { result, Result } -> Result
    end.

multiply(NumberList) when is_list(NumberList) ->
    calculus ! {self(), multiply, NumberList},
    receive
        {result, Result} -> Result
    end.

stop() ->
    calculus ! stop.

loop() ->
    receive
        {Client, add, NumberList} ->
            Result = lists:foldl(fun(X, Sum) -> X + Sum end, 0, NumberList),
            Client ! {result, Result},
            loop();
        {Client, multiply, NumberList} ->
            Result = lists:foldl(fun(X, Prod) -> X * Prod end, 1, NumberList),  % Changed initial value from 0 to 1
            Client ! {result, Result},
            loop();
        {Client, divide, [Head|Tail]} ->
            case lists:member(0, Tail) of
                true ->
                    Client ! {result, undefined},
                    loop();
                false ->
                    Result = lists:foldl(fun(X, Acc) -> Acc / X end, Head, Tail),
                    Client ! {result, Result},
                    loop()
            end;
        {Client, sub, [Head|Tail]} ->  % Fixed subtraction logic
            Result = lists:foldl(fun(X, Acc) -> Acc - X end, Head, Tail),
            Client ! {result, Result},
            loop();
        stop ->
            ok
    end.