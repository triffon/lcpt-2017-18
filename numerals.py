I  = lambda x: x
K  = lambda x: lambda y: x
K_ = lambda x: lambda y: y
S  = lambda x: lambda y: lambda z: x(z)(y(z))

c0 = lambda f: lambda x: x      # = K*
c1 = lambda f: lambda x: f(x)
c3 = lambda f: lambda x: f(f(f(x)))

def repeated(f,x,n):
    if n == 0:
        return x
    else:
        return f(repeated(f,x,n-1))

def c(n):
    return lambda f: lambda x: repeated(f,x,n)

def toint(c):
    return c(lambda x: x+1)(0)

cs  = lambda n: lambda f: lambda x: f(n(f)(x))
cs2 = lambda n: lambda f: lambda x: n(f)(f(x))

cplus  = lambda m: lambda n: m(cs)(n)
cplus_ = lambda m: lambda n: \
         lambda f: lambda x: m(f)(n(f)(x))

cmult = lambda m: lambda n: m(cplus(n))(c0)
cmult_ = lambda m: lambda n: lambda f: m(n(f))

cpow = lambda m: lambda n: n(cmult(m))(c1)
cpow_ = lambda m: lambda n: n(m)

ctrue = K
cfalse = K_
cif = I

def tobool(b):
    return b(True)(False)

cand = lambda p: lambda q: p(q)(cfalse)
cor  = lambda p: lambda q: p(ctrue)(q)
cor_ = lambda p: p(ctrue)
cneg = lambda p: p(cfalse)(ctrue)
cneg_ = lambda p: lambda x: lambda y: p(y)(x)

cz = lambda n: n(lambda q:cfalse)(ctrue)
ceven = lambda n: n(cneg)(ctrue)

ccons = lambda m: lambda n: lambda z: z(m)(n)
ccar  = lambda u: u(K)
ccdr  = lambda u: u(K_) 

def topair(u):
    return u(lambda x: lambda y: (x,y))

def tointpair(u):
    return u(lambda x: \
             lambda y: (toint(x),toint(y)))
