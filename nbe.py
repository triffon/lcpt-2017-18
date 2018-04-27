class App:
    def __init__(self, func, arg):
        self.func = func
        self.arg  = arg
    def __repr__(self):
        return '{0}({1})'.format(self.func,self.arg)

class Abs:
    def __init__(self, var, body):
        self.var = var
        self.body = body
    def __repr__(self):
        return 'lambda {0}: {1}'.format(self.var,self.body)

class Arrow:
    def __init__(self, arg, result):
        self.arg = arg
        self.result = result
    def __repr__(self):
        if isinstance(self.arg, Arrow):
            return '({0}) => {1}'.fommat(self.arg, self.result)
        else:
            return '{0} => {1}'.format(self.arg, self.result)


lastid = 0

# генериране на свежа променлива
def gensym(var):
    global lastid
    lastid += 1
    return var + str(lastid)

# reify = ↓τ, от обект правим терм
def reify(tau, f):
    if isinstance(tau, Arrow):
        x = gensym('x')
        return Abs(x, reify(tau.result, f(reflect(tau.arg, x))))
    else:
        return f

# reflect = ↑τ, от терм правим обект
def reflect(tau, M):
    if isinstance(tau, Arrow):
        return lambda a: reflect(tau.result, App(M, reify(tau.arg, a)))
    else:
        return M


# eval = [[M]]ξ, стойност на M при оценка ξ
def eval(M, xi):
    if isinstance(M, App):
        return eval(M.func, xi)(eval(M.arg, xi))
    else:
        if isinstance(M, Abs):
            return lambda a: eval(M.body, modify(xi, M.var, a))
        else:
            # променлива
            return xi(M)

# modify = ξₓᵃ, модифицирана оценка ξ със стойност a в точка x
def modify(xi, x, a):
    return lambda y: a if x == y else xi(y)

# nbe = lnf(M)
def nbe(M, tau):
    return reify(tau, eval(M, lambda x: 'error'))

id = Abs('x', 'x')
idtype = Arrow('α','α')

def repeated(n, f, x):
    if n == 0:
        return x
    else:
        return App(f, repeated(n-1, f, x))

def cn(n):
    return Abs('f', Abs('x', repeated(n, 'f', 'x')))

cntype = Arrow(idtype, idtype)

cplus = Abs('m', Abs('n', Abs('f', Abs('x',
                                       App( App('m', 'f'),
                                            App(
                                                App('n', 'f'),
                                                'x'))))))

cmult = Abs('m', Abs('n', Abs('f', App('m', App('n', 'f')))))

# nbe(App(id, id), idtype)
# nbe(App(App(cplus, cn(3)), cn(5)), cntype)
# nbe(App(App(cmult, cn(3)), cn(5)), cntype)
