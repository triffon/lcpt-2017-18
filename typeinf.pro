/*
man(john).
man(ed).
woman(mary).
loves(john,mary).
loves(john, X) :- loves(X, mary).
*/

/*
  λ(x,x)
  λ(x,λ(y,x))
  ...
  x@x <–> @(x,x)
  x@y@z <-> @(@(x,y),z)
  α ⇒ β <-> ⇒(α,β)
  α ⇒ β ⇒ α <-> ⇒(α,⇒(β,α))
  Γ ⊢ M : τ <-> ⊢(Γ,:(M,τ))
*/

:- set_prolog_flag(occurs_check, true).
:- op(160, fx, ⊢).
:- op(150, xfx, ⊢).
:- op(140, xfx, :).
:- op(120, xfy, ⇒).
:- op(100, yfx, @).

i(λ(x,x)).
k(λ(x,λ(y,x))).
s(λ(x,λ(y,λ(z,x@z@(y@z))))).
ω(λ(x,x@x)).
y(λ(f,λ(x,f@(x@x)) @ λ(x,f@(x@x)))).

Γ ⊢ X     : T              :- member(X : T, Γ).
Γ ⊢ M @ N : Σ              :- Γ ⊢ M : Ρ ⇒ Σ,
                              Γ ⊢ N : Ρ.
Γ ⊢ λ(X,M) : Ρ ⇒ Σ         :- [ X : Ρ | Γ ] ⊢ M : Σ.

⊢ M : Τ  :- [] ⊢ M : Τ.
