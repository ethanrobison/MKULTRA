%% s(?S, ?Mood, ?Polarity, ?Tense, ?Aspect)
%  Sentences

:- randomizable s//5.
s(S, indicative, Polarity, Tense, Aspect) -->
   np(VP^S, subject, Agreement, nogap),
   aux_vp(VP, Polarity, Agreement, Tense, Aspect, nogap).
s(S, imperative, Polarity, present, simple) -->
   aux_vp($addressee^S, Polarity, second:singular, present, simple, nogap).

%%%                  Noun Phrases

%% np(?Meaning, ?Case, ?Person, ?Number, ?Gap)
%  Noun phrases

:- randomizable np//4.
np(NP, _C, third:Number, nogap) --> 
   det(N1^NP), n(Number, N1).
np(NP, _C, third:Number, nogap) --> proper_noun(Number, NP).
np(NP, Case, Agreement, nogap) --> pronoun(Case, Agreement, NP).
np((X^S)^S, _C, _Agreement, np(X)) --> [].

%%%                  Verb Phrases

%% aux_vp(LF, Person, Number, Tense, Progressive, Perfect, Gap)
%  Verb phrases, optionally augmented with auxilliaries and/or negative particle.

aux_vp(LF, Polarity, Agreement, Tense, Aspect, Gap) --> 
	aux(Polarity, Agreement, Tense, Aspect, Form),
	vp(Form, LF, Tense, Agreement, Gap).

%% aux(?Polarity, ?Agreement, ?Tense, ?Aspect, ?Form)
%  An optional string of auxilliaries and/or negative particle.

:- randomizable aux//5.
aux(affirmative, _Agreement, present, simple, simple) --> [ ].
aux(negative, Agreement, Tense, simple, base) -->
	aux_do(Tense, Agreement), [ not ].
aux(Polarity, Agreement, future, Aspect, Form) -->
	[ will ],
	opt_not(Polarity),
	aux_aspect_future(Aspect, Agreement, Form).
aux(Polarity, Agreement, Tense, Aspect, Form) -->
	aux_aspect(Polarity, Tense, Aspect, Agreement, Form).

%% aux_aspect_future(?Aspect, ?Agreement, ?Form)
%  An optional string of auxilliaries devoted to aspect (be, have), and/or negative particle.
%  Special case for after the auxilliary will.  Don't have to check for not particle.

:- randomizable aux_aspect_future//3.
aux_aspect_future(simple, _, simple) --> [ ].
aux_aspect_future(progressive, Agreement, present_participle) -->
	aux_be(future, Agreement).
aux_aspect_future(Aspect, Agreement, Form) -->
	aux_have(future, Agreement),
	aux_perfect(Aspect, Agreement, Form).

%% aux_aspect(?Polarity, ?Tense, ?Aspect, ?Agreement, ?Form)
%  An optional string of auxilliaries devoted to aspect (be, have), and/or negative particle.
%  Case where there has been no prior will auxilliary.

:- randomizable aux_aspect//5.
aux_aspect(affirmative, _, simple, _, simple) --> [ ].
aux_aspect(Polarity, Tense, progressive, Agreement, present_participle) -->
	aux_be(Tense, Agreement),
	opt_not(Polarity).
aux_aspect(Polarity, Tense, Aspect, Agreement, Form) -->
	aux_have(Tense, Agreement),
	opt_not(Polarity),
	aux_perfect(Aspect, Agreement, Form).

:- randomizable aux_perfect//3.
aux_perfect(perfect, _Agreement, past_participle) -->
	[ ].
aux_perfect(perfect_progressive, Agreement, present_participle) -->
	aux_be(past, Agreement).

%% vp(?Form, ?Meaning, ?Tense, ?Agreement ?Gap)

:- randomizable vp//5.

vp(Form, X^S, Tense, Agreement, GapInfo) -->
    tv(Form, Agreement, X^VP, Tense), 
    np(VP^S, object, _, GapInfo).
vp(Form, VP, Tense, Agreement, nogap) --> 
    iv(Form, Agreement, VP, Tense).


/*=====================================================
                      Dictionary
=====================================================*/

/*-----------------------------------------------------
                     Preterminals
-----------------------------------------------------*/

det(LF) --> [D], {det(D, LF)}.

:- randomizable n//2.
n(singular, LF)   --> [N], {n(N, _, LF)}.
n(plural, LF)   --> [N], {n(_, N, LF)}.

proper_noun(singular, (E^S)^S) --> [PN], {proper_noun(PN, E)}.

pronoun(Case, Person:Number, (E^S)^S) --> [PN], {pronoun(PN, Case, Person, Number, E)}.

%relpron --> [RP], {relpron(RP)}.
whpron --> [WH], {whpron(WH)}.

%%
%% Verb conjugations
%%

:- randomizable iv//4.
%                                                      Base TPS Past PastP PresP LF
iv(simple, third:singular, LF, present) --> [IV], { intransitive_verb(_,   IV, _,   _,    _,    LF) }.
iv(simple, Agreement,      LF, present) --> [IV], { intransitive_verb(IV,  _,  _,   _,    _,    LF),
						    Agreement \= third:singular }.
iv(simple, _Agreement,      LF, past)   -->  [IV], { intransitive_verb(_,  _,  IV,  _,    _,    LF) }.
iv(simple, _Agreement,      LF, future) -->  [IV], { intransitive_verb(IV, _,  _,   _,    _,    LF) }.
% Used only in the construction X does not BASEFORM.
iv(base, _Agreement,      LF, present) -->  [IV], { intransitive_verb(IV, _,  _,   _,    _,    LF) }.
iv(past_participle, _Agreement,      LF, _Tense) -->  [IV], { intransitive_verb(_,  _,  _,   IV,   _,    LF) }.
iv(present_participle, _Agreement,   LF, _Tense) -->  [IV], { intransitive_verb(_,  _,  _,   _,    IV,   LF) }.

:- randomizable tv//4.
%                                                      Base TPS Past PastP PresP LF
tv(simple, third:singular, LF, present) --> [TV], { transitive_verb(_,   TV, _,   _,    _,    LF) }.
tv(simple, Agreement,      LF, present) --> [TV], { transitive_verb(TV,  _,  _,   _,    _,    LF),
						    Agreement \= third:singular }.
tv(simple, _Agreement,      LF, past)   -->  [TV], { transitive_verb(_,  _,  TV,  _,    _,    LF) }.
tv(simple, _Agreement,      LF, future) -->  [TV], { transitive_verb(TV, _,  _,   _,    _,    LF) }.
% Used only in the construction X does not BASEFORM.
tv(base, _Agreement,      LF, present) -->  [TV], { transitive_verb(TV, _,  _,   _,    _,    LF) }.
tv(past_participle, _Agreement,      LF, _Tense) -->  [TV], { transitive_verb(_,  _,  _,   TV,   _,    LF) }.
tv(present_participle, _Agreement,   LF, _Tense) -->  [TV], { transitive_verb(_,  _,  _,   _,    TV,   LF) }.

