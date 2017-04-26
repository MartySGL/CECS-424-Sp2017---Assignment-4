% Problem #3, "Star Tricked"
% Each person saw something each day of the week.
person(barrada).
person(gort).
person(klatu).
person(nikto).

day(tuesday).
day(wednesday).
day(thursday).
day(friday).

sighting(balloon).
sighting(clothesline).
sighting(frisbee).
sighting(water_tower).

solve :-
    person(TuesdayPerson), person(WednesdayPerson), person(ThursdayPerson), person(FridayPerson),
    all_different([TuesdayPerson, WednesdayPerson, ThursdayPerson, FridayPerson]),
    
    sighting(TuesdaySighting), sighting(WednesdaySighting),
    sighting(ThursdaySighting), sighting(FridaySighting),
    all_different([TuesdaySighting, WednesdaySighting, ThursdaySighting, FridaySighting]),

    Triples = [ [tuesday, TuesdayPerson, TuesdaySighting],
                [wednesday, WednesdayPerson, WednesdaySighting],
                [thursday, ThursdayPerson, ThursdaySighting],
                [friday, FridayPerson, FridaySighting] ],
							
	% 1. Mr. Klatu made his sighting at some point earlier in the week than the one who saw the balloon, but at some point later in the week than the one who spotted the frisbee (who isn't Ms. Gort).
    \+ member([_, klatu, balloon], Triples),	
    \+ member([_, klatu, frisbee], Triples),	
    \+ member([_, gort, frisbee], Triples),	
	day_before([_, klatu, _], [_, _, balloon], Triples),
	day_before([_, _, frisbee], [_, klatu, _], Triples),

    % 2. Friday's sighting was made by either Ms. Barrada or the one who saw a clothesline (or both).
    (member([friday, barrada, _], Triples);
       member([friday, _, clothesline], Triples)),

    % 3. Mr. Nikto did not make his sighting on Tuesday.
    \+ member([tuesday, nikto, _], Triples),	

    % 4. Mr. Klatu isn't the one whose object turned out to be a water tower.
    \+ member([_, klatu, water_tower], Triples),	
	
    tell(tuesday, TuesdayPerson, TuesdaySighting),
    tell(wednesday, WednesdayPerson, WednesdaySighting),
    tell(thursday, ThursdayPerson, ThursdaySighting),
    tell(friday, FridayPerson, FridaySighting).

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

day_before(X, _, [X | _]).
day_before(_, Y, [Y | _]) :- !, fail.
day_before(X, Y, [_ | T]) :- day_before(X, Y, T). 

tell(X, Y, Z) :-
    write(' On '), write(X), write(', Mr/Ms '), write(Y),
    write(' saw a '), write(Z), write('.'), nl.