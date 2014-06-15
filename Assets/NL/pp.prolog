%%
%% Prepositional phrases
%%
%% VPs produce predications as their meanings (e.g. go(Agent, Destination)).
%% Syntactically, go is non-transitive, so the predication of the phrase "I go"
%% go($me, _Dest), meaning the destination slot is left blank on exit from
%% the parsing of the verb.  PPs can be used to fill these slots in.  The parser
%% does not support fancier uses of PPs, since logical forms are restricted to
%% look like: quantifiers(modal(predication(args...))).
%%

%% opt_pp(Predication, SentenceLFIn, SentenceLFOut)
%  Fills in slots of Predication, specified by PPs, and wrapping SentenceLFIn
%  in any further quantifiers from the NPs of the PPs, to produce SentenceLFOut
:- randomizable opt_pp//3.

opt_pp(_, S, S) --> [ ].
opt_pp(Predication, S1, S3) -->
   [ Preposition ],
   { preposition(Preposition),
     prepositional_slot(Preposition, X, Predication) },
   np((X^S1)^S2, object, _, nogap),
   opt_pp(Predication, S2, S3).

%% preposition(?Word)
%  Word is a preposition
:- randomizable preposition/1.
preposition(to).

%% prepositional_slot(?Preposition, ?Referrent, ?Predication
%  True when the slot of Predication corresponding to Preposition
%  has the value Referrent.
:- randomizable prepositional_slot/3.
prepositional_slot(to, Destination, go(_Agent, Destination)).
prepositional_slot(to, Recipient, give(_Agent, Recipient, _Patient)).
   