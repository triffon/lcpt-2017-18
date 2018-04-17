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
:- op(145, xfx, ≡).
:- op(142, xfy, @@).
:- op(140, xfx, :).
:- op(120, xfy, ⇒).
:- op(100, yfx, @).

i(λ(x,x)).
k(λ(x,λ(y,x))).
s(λ(x,λ(y,λ(z,x@z@(y@z))))).
ω(λ(x,x@x)).
y(λ(f,λ(x,f@(x@x)) @ λ(x,f@(x@x)))).

ti(α ⇒ α).
tk(α ⇒ β ⇒ α).
ts((α ⇒ β ⇒ γ) ⇒ (α ⇒ β) ⇒ α ⇒ γ).


/*
  Γ ⊢ M : T @@ TypedTerms ≡ N : Σ, където
  TypedTerms = [ M1 : T1, M2 : T2, ..., Mn : Tn ]
  В контекста Γ, Mi има тип Ti, M има тип T и N има тип Σ, като
    T = T1 ⇒ T2 ⇒ ... ⇒ Tn ⇒ Σ
    M @ M1 @ M2 @ ... @ Mn = N
*/

/*
Γ ⊢ X     : T              :- member(X : T, Γ).
Γ ⊢ λ(X,M) : Ρ ⇒ Σ         :- [ X : Ρ | Γ ] ⊢ M : Σ.
Γ ⊢ M @ N : Σ              :- Γ ⊢ M : Ρ ⇒ Σ,
                              Γ ⊢ N : Ρ.
*/

/* Γ ⊢ X : T @@ ? ≡ ? : Σ */
_ ⊢ X : T      @@ []             ≡ X : T.
Γ ⊢ X : Ρ ⇒ T  @@ [N : Ρ | NTs]  ≡ M : Σ  :- Γ ⊢ N : Ρ, !,
                                             Γ ⊢ (X @ N) : T @@ NTs ≡ M : Σ.
/* NTs е списък от типови съждения, т.е. термове с типове */

Γ ⊢ λ(X, M) : Ρ ⇒ Σ      :- [ X : Ρ | Γ ] ⊢ M : Σ.
Γ ⊢ M       : Σ          :- member(X : T, Γ), Γ ⊢ X : T @@ _ ≡ M : Σ.

⊢ M : T  :-       [] ⊢ M : T.
