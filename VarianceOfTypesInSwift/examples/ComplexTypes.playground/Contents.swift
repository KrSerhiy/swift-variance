// COMPLEX TYPES CONSTRUCTED WITH SIMPLE TYPES:

func someFunction (int: Int) -> Bool { return true } // complex function type '(Int) -> Bool', constructed with simple 'Int' and 'Bool' types

let tuple = ("a", 0.5) // complex tuple type '(String, Double)', constructed with simple 'String' and 'Double' types

struct SomeGenericStruct<T> {
    init(_ t: T) {}
}
let someGenericStruct = SomeGenericStruct("") // complex generic type 'SomeGenericStruct<String>', constructed with simple 'String' type

// COMPLEX TYPES CONSTRUCTED ALSO WITH COMPLEX TYPES:

let tupleWithFunctionAndTuple = (someFunction, tuple) // complex tuple type '((Int) -> Bool, (String, Double))', constructed with complex '(Int) -> Bool' and '(String, Double)' types

func functionWithFunction(anotherFunc: (Int) -> Bool) {} // complex function type '((Int) -> Bool) -> ()', constructed with complex '(Int) -> Bool' type
