:- dynamic at/2, i_am_at/1, alive/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).
				
/* Current User Location */

i_am_at(house).

/* How the rooms are connected */

path(house, n, street).
path(street, s, house).

path(house, u, bedroom).
path(bedroom, d, house).

path(house, e, kitchen).
path(kitchen, w, house).

path(closet, s, bedroom).

path(bedroom, n, closet) :- at(key, in_hand).
path(bedroom, n, closet) :-
        write('The door appears to be locked.'), nl,
        fail.

path(zombie, s, street).
path(street, n, zombie).
		
/* Where the items are located */

at(gun, closet).
at(key, kitchen).

/* This fact specifies that the zombie is alive. */

alive(zombie).


/* These rules describe how to pick up an object. */

take(X) :-
        at(X, in_hand),
        write('You''re already holding it!'),
        nl, !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, in_hand)),
        write('OK.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        at(X, in_hand),
        i_am_at(Place),
        retract(at(X, in_hand)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the six direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look, !.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* These rules tell how to handle killing the lion and the zombie. */

kill :-
        i_am_at(zombie),
        at(gun, in_hand),
        retract(alive(zombie)),
        write('You just shot the zombie in the head.'), nl,
        write('The zombie fall on the ground.'), nl,
        write('You are now continuing on your journey to find more supplies.'),
        win.

kill :-
        i_am_at(zombie),
        write('Oh, bad idea!  You have just been eaten by the zombie.'), nl,
        !, die.

kill :-
        write('I see nothing inimical here.'), nl.

/* This rule tells how to die. */

die :-
        !, finish.

win :-
        nl,
        write('You finished the game! Please enter the   halt.   command.'),
        nl, !.

		
finish :-
        nl,
        write('The game is over. Please enter the   halt.   command.'),
        nl, !.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                   -- to start the game.'), nl,
        write('n.  s.  e.  w.  u.  d.   -- to go in that direction.'), nl,
        write('take(Object).            -- to pick up an object.'), nl,
        write('drop(Object).            -- to put down an object.'), nl,
        write('kill.                    -- to attack an enemy.'), nl,
        write('look.                    -- to look around you again.'), nl,
        write('instructions.            -- to see this message again.'), nl,
        write('story.            -- to see the story.'), nl,
        write('halt.                    -- to end the game and quit.'), nl,
        nl.

/* This is a brief story of the situation */
		
story :-
        nl,
        write('A month ago the zombie apocalypse began.'), nl,
        write('Locked in your house since the beginning of it'), nl,
        write('you are now out of food.'), nl,
        write('Its the first time you are going outside since'), nl,
        write('the beginning of the apocalypse.'), nl,
        write('Be careful!'), nl,
		nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
		story,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(house) :-
        write('You are in the house.  To the north is street.'), nl,
        write('The kitchen is east. Your bedroom is upstair'), nl.

describe(street) :-
        write('You are in the street. There is a zombie 100ft in front of you!'), nl.

describe(bedroom) :-
        write('You are in the bedroom.'), nl,
        write('There is a bed and a closet (to the north)'), nl.

describe(kitchen) :-
        write('You are in the kitchen.'), nl.
		
describe(closet) :-
        write('This is where you put your clothes and other stuff.'), nl.
describe(zombie) :-
        write('You are in front of the zombie.'), nl.