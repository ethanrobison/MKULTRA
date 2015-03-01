%%
%% Describing objects
%%

strategy(describe(Object, Purpose, NullContinuation),
	 begin(describe_type(Object),
	       describe_attributes(Object, Attributes, NullContinuation))) :-
   all(Attribute,
       interesting_attribute(Purpose, Object, Attribute),
       AllAttributes),
   remove_redundant_attributes(AllAttributes, Attributes).

strategy(describe_type(Object),
	 if(is_a(Object, person),
	    null,
	    let(base_kind(Object, Kind),
		say(is_a(Object, Kind))))).


remove_redundant_attributes([ ], [ ]).
remove_redundant_attributes([Relation/Relatum | Rest], RestRemoved) :-
   decendant_relation(Antecedant, Relation),
   member(Antecedant/Relatum, Rest),
   !,
   remove_redundant_attributes(Rest, RestRemoved).
remove_redundant_attributes([X | Rest], [X | Final]) :-
   remove_implicants(X, Rest, WithoutImplicants),
   remove_redundant_attributes(WithoutImplicants, Final).

remove_implicants(_, [ ], [ ]).
remove_implicants(Rel/Object, [Implicant/Object | Rest], Rest) :-
   ancestor_relation(Implicant, Rel),
   !.
remove_implicants(Attribute, [X | Rest] , [X | RestRemoved]) :-
   remove_implicants(Attribute, Rest, RestRemoved).


interesting_attribute(Purpose, Object, Attribute) :-
   interesting_property(Purpose, Object, Attribute)
   ;
   interesting_relation(Purpose, Object, Attribute).

interesting_property(Purpose, Object, Prop:Value) :-
   property_nondefault_value(Object, Prop, Value),
   \+ /mentioned_to/ $addressee /Object/Prop:Value,
   property_relevant_to_purpose(Purpose, Object, Prop, Value).

interesting_relation(Purpose, Object, Relation/Relatum) :-
   related_nondefault(Object, Relation, Relatum),
   \+ /mentioned_to/ $addressee /Object/Relation/Relatum,
   relation_relevant_to_purpose(Purpose, Object, Relation, Relatum).

strategy(describe_attributes(Object, Attributes, NullContinuation),
	 if(Attributes=[ ],
	    NullContinuation,
	    generate_list(Attributes, attribute_of(Object)))).

strategy(generate_next(Property:Value, attribute_of(Object)),
	 describe_property("", Object, Property, Value, ", ...")).
strategy(generate_last(Property:Value, attribute_of(Object)),
	 describe_property("and", Object, Property, Value, ".")).

strategy(generate_next(Property/Value, attribute_of(Object)),
	 describe_relation("", Object, Property, Value, ", ...")).
strategy(generate_last(Property/Value, attribute_of(Object)),
	 describe_relation("and", Object, Property, Value, ".")).

strategy(describe_property(Linkage, Object, Property, Value, Termination),
	 speech([Linkage, Surface, Termination])) :-
   surface_form(property_value(Object, Property, Value), Surface),
   assert(/mentioned_to/ $addressee /Object/Property:Value).

strategy(describe_relation(Linkage, Object, Relation, Relatum, Termination),
	 speech([Linkage, Surface, Termination])) :-
   surface_form(related(Object, Relation, Relatum), Surface),
   forall(ancestor_relation(A, Relation),
	  assert(/mentioned_to/ $addressee /Object/A/Relatum)).

surface_form(property_value(Object, Property, Value),
	     s(property_value(Object, Property, Value))).

surface_form(related(Object, Relation, Relatum),
	     s(related(Object, Relation, Relatum))).

