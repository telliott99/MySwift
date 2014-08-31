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


