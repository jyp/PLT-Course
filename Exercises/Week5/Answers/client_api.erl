
-module(client_api).
-export([init/0, handle/2, pure_request/2]).
% This module implements the logic of the transactional server.
% Messages (the Msg) from the client can be of two types:
%   List - A request to add in the printout this atom. It changes the state of the server.
%
%   {atom} - a request for executing the service atom from the server. It does not have side effects.
%
% The server takes atoms and it converts them to strings. The state is a list
% of the atoms received so far (and printed). A transaction fails if any 
% atom to be printed out appears to have been already printed.


init() -> [].

handle(Msg,State) ->
 case Msg of
         List when is_list(List) -> {ok,handle_list(Msg,State,[])};
         _-> exit('non valid request')
       end.


handle_list(Msg,State,TempState) ->
 case Msg of
   [] -> commit(TempState,State);
   [Head|List] when is_atom(Head)->
       case lists:member(Head,List) of
               true -> exit("Malformed transaction.");
               false ->
                 case lists:member(Head,State) of
                   true -> exit(string:concat(atom_to_list(Head) ," has already
been printed."));
                   false -> handle_list(List,State,[Head|TempState])
                 end
       end;
   _-> exit('non valid message format')
 end.


commit(Trans,State)->
  case Trans of
    [] -> State;
    [Head|List] when is_list(List) -> 
      io:format("SUCCESS!!!: ~p~n",[atom_to_list(Head)]),
      commit(List,[Head|State])

  end.


pure_request(Fun,State) ->
  case Fun of 
    {level} -> {length(State),State}; % asking how many strings have been printed so far
    _ -> exit('non valid request')
  end.
