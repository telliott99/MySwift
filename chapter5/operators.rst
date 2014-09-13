.. _operators:

#########
Operators
#########

I believe I put this in the section on random numbers, but it is pretty cool so I'll repeat it here:

.. sourcecode:: bash

    import Foundation

    infix operator **{}
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)
    }
    println("\(2**5)")

This prints what you'd expect (except that the type of the result is Double).

Another operator is ``??``, defined as

    A new ?? nil coalescing operator.. ?? is a short-circuiting operator, similar to && and ||, which takes an optional on the left and a lazily-evaluated non-optional expression on the right.
    
    The nil coalescing operator provides commonly useful behavior when working with optionals, and codifies this operation with a standardized name. If the optional has a value, its value is returned as a non-optional; otherwise, the expression on the right is evaluated and returned.

.. sourcecode:: bash

    let D = ["a":"apple"]
    var v = D["a"]
    var result = v ?? "no result"
    println(result)
    result = D["b"] ?? "no result"
    println(result)

.. sourcecode:: bash

    > xcrun swift test.swift
    apple
    no result
    >

I think the key here is that the rhs is "lazily-evaluated", but I don't have a good example at the moment.

The docs say this:

.. sourcecode:: bash

    public func ?? <T> (optional: T?, defaultValue: @autoclosure () -> T?) ->
       T? {
         switch optional {
         case .Some(let value): return value
         case .None: return defaultValue()
         }
    !}

    let a: Int? = nil
    let b: Int? = 5
    a ?? b // was nil; is now .Some(5)

To understand this we have to go back to enumerations.

..


What is even better is that we can define new operators, and those can be any symbol we want, here is an obvious one:

.. sourcecode:: bash

    import Foundation

    prefix operator √{}
    prefix func √(f: Double) -> Double {
        return sqrt(f)
    }

    println("\(√(2.0))")

.. sourcecode:: bash

    > xcrun swift test.swift 
    1.4142135623731
    >


This one's not working yet

.. sourcecode:: bash

    import Foundation

    unary operator  ☂ {}
    unary func ☂ (a: [String:Int], b: [String:Int]) -> [String:Int] {
        var D = a
        for k in b {
            let v = b[k]
            if let value = D[k] {
                D.updateValue(value + v, forKey:k)
            }
            else {
                D[k] = v
            }
        }
        return a
    }
