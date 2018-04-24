                                        ; (lambda (x) (x y))
                                        ; (=> rho sigma)

                                        ;(define (cons-app f x) (list f x)
(define cons-app list)
(define (cons-abs x m) (list 'lambda (list x) m))

(define (is-var? m) (not (pair? m)))
(define (is-app? m) (and (list? m) (= (length m) 2)))
(define (is-abs? m) (and (list? m) (eqv? (car m) 'lambda)))

; reify = ↓τ, от обект правим терм
(define (reify tau f)
  (if (is-var? tau) f
      (let ((x (gensym 'x))
            (rho (cadr tau))
            (sigma (caddr tau)))
        (cons-abs x (reify sigma (f (reflect rho x)))))))

; reflect = ↑τ, от терм правим обект
(define (reflect tau M)
  (if (is-var? tau) M
      (let ((rho (cadr tau))
            (sigma (caddr tau)))
        (lambda (a) (reflect sigma
                             (cons-app M (reify rho a)))))))

; eval = [[M]]ξ, стойност на M при оценка ξ
(define (eval M xi)
  (cond ((is-var? M) (xi M))
        ((is-app? M)
         (let ((func (car M))
               (arg  (cadr M)))
           ((eval func xi) (eval arg xi))))
        ((is-abs? M)
         (let ((var  (caadr M))
               (body (caddr M)))
           (lambda (a) (eval body (modify xi var a)))))))

; modify = ξₓᵃ, модифицирана оценка ξ със стойност a в точка x
(define (modify xi x a)
  (lambda (y)
    (if (eqv? x y) a
        (xi y))))

; nbe = lnf(M)
(define (nbe M tau)
  (reify tau (eval M (lambda (x) 'error))))

(define (repeated f x n)
  (if (= n 0) x
      (cons-app f (repeated f x (- n 1)))))

(define (cn n)
  (cons-abs 'f
            (cons-abs 'x
                      (repeated 'f 'x n))))

(define cplus
  (cons-abs 'm
            (cons-abs 'n
                      (cons-abs 'f
                                (cons-abs 'x
                                          (cons-app (cons-app 'n 'f)
                                                    (cons-app (cons-app 'm 'f) 'x)))))))
            
(define tcn '(=> (=> alpha alpha) (=> alpha alpha)))

(define c8 (cons-app (cons-app cplus (cn 3)) (cn 5)))
