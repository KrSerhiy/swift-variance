class C {}
class C1: C {}

let c = C()
func fa(_ a:inout Array<C>) {
    a.append(c)
}

var a1 = [C1()]
fa(&a1)

var capturedArray = [C1()]

func captur(_ a:Array<C1>) -> Array<C> {
    (capturedArray as Array<C>).append(contentsOf: a)
    var b: Array<C> = a
    b.append(c)
    return b
}

captur(<#T##a: Array<C1>##Array<C1>#>)

var b1 = a1
b1.append(c)
print(b1)

// INLINE EXAMPLE:

let c1 = C1()

func fa1(_ a: Array<C1>) {
    var b = a
    b.append(c1)
    print(b)
}

fa1([C()])

let a = [C()]
var b = a
b.append(c1)

// VALUE SEMANTIC PREVENTS US FROM TRUBLES OF USING METHODS WITH ARGUMENTS OF PLACEHOLDER TYPE

var ar1 = [C1()]
var ar: Array<C> = ar1
ar.append(C())
