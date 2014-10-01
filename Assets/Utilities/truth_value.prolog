:- public truth_value/2, admitted_truth_value/3.
:- external know_whether/1, pretend_truth_value/3.

truth_value(P, Value) :-
   P ->
     Value=true
     ;
     (know_whether(P) ->
         Value = false
         ;
         Value = unknown).

:- external pretend_truth_value/3.

admitted_truth_value(Listener, P, Value) :-
   Listener \= $me,
   pretend_truth_value(Listener, P, PretendValue),
   !,
   Value=PretendValue.
admitted_truth_value(_, P, Value) :-
   truth_value(P, Value).
