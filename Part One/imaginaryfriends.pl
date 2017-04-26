% Problem #2, "Imaginary Friends"
% Each kid wrote a story with an imaginary friend in an adventure.
friend(grizzly_bear).
friend(moose).
friend(seal).
friend(zebra).

kid(joanne).
kid(lou).
kid(ralph).
kid(winnie).

adventure(circus).
adventure(rock_band).
adventure(spaceship).
adventure(train).

solve :-
    friend(JoanneFriend), friend(LouFriend), friend(RalphFriend), friend(WinnieFriend),
    all_different([JoanneFriend, LouFriend, RalphFriend, WinnieFriend]),
    
    adventure(JoanneAdventure), adventure(LouAdventure),
    adventure(RalphAdventure), adventure(WinnieAdventure),
    all_different([JoanneAdventure, LouAdventure, RalphAdventure, WinnieAdventure]),

    Triples = [ [joanne, JoanneFriend, JoanneAdventure],
                [lou, LouFriend, LouAdventure],
                [ralph, RalphFriend, RalphAdventure],
                [winnie, WinnieFriend, WinnieAdventure] ],
							
	% 1. The seal (who isn't the creation of either Joanne or Lou) neither rode to the moon in a spaceship nor took a trip around the world on a magic train.
    \+ member([joanne, seal, _], Triples),
    \+ member([lou, seal, _], Triples),
    \+ member([_, seal, spaceship], Triples),
    \+ member([_, seal, train], Triples),

    % 2. Joanne's imaginary friend (who isn't the grizzly bear) went to the circus.
    \+ member([joanne, grizzly_bear, _], Triples),
    member([joanne, _, circus], Triples),
    
    % 3. Winnie's imaginary friend is a zebra.
    member([winnie, zebra, _], Triples),
    
    % 4. The grizzly bear didn't board the spaceship to the moon.
    \+ member([_, grizzly_bear, spaceship], Triples),
	
    tell(joanne, JoanneFriend, JoanneAdventure),
    tell(lou, LouFriend, LouAdventure),
    tell(ralph, RalphFriend, RalphAdventure),
    tell(winnie, WinnieFriend, WinnieAdventure).

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(X, Y, Z) :-
    write(X), write(' wrote the story with a '), write(Y),
    write(' and a '), write(Z), write('.'), nl.