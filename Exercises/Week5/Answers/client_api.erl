
-module(client_api).
-export([init/0, handle/2]).
% This module implements the logic of the transactional server.
% Messages (the Msg) from the client can be of two types:
%   atom - A request to add in the printout this atom. It changes the state of the server.
%
%   {atom} - a request for executing the service atom from the server. It does not have side effects.
%
% The server takes atoms and it converts them to strings. The state is a list
% of the atoms received so far (and printed). A transaction fails if any 
% atom to be printed out appears to have been already printed.
% "Paganini non repete"

init() -> [].

handle(Msg,State) -> 	
  case Msg of
	  Atom when is_atom(Atom) -> 
	     case lists:member(Atom,State) of
	        false ->	io:format("***SUCCESS*** ~p ~n",[atom_to_list(Atom)]), {ok,[Atom|State]};
	        true -> exit(string:concat(atom_to_list(Atom) ," has already been printed."))
		   end;
	  {Fun} -> pure_request(Fun,State); 
	  _-> exit('non valid request')
	end.


pure_request(Fun,State) ->
  case Fun of 
    level -> {length(State),State}; % asking how many strings have been printed so far
    _ -> exit('non valid request')
  end.
