.. _optionals:

#########
Optionals
#########

Swift has optional values (called "Optionals") that may be ``nil``, and not have a value, or they may have a value including a basic type like Int or String.  Consider the following:

.. sourcecode:: bash

    let s: String = "123x"
    let m: Int? = s.toInt()
    let t: String = "123"
    let n: Int? = t.toInt()
    println(m)
    println(n)

The first conversion ``s.toInt()`` will fail because the value ``"123x"`` can't be converted to an integer.  Nevertheless, the code compiles and when run it prints

.. sourcecode:: bash

    > xcrun swift test.swift 
    nil
    Optional(123)
    >

The values ``m`` and ``n`` are "Optionals".  Test for ``nil`` by doing either of the following:

.. sourcecode:: bash

    let m: Int? = "123x".toInt()
    let n = "123".toInt()
    // "forced unwrapping"
    if m != nil { println("m = toInt() worked: \(m!)") }
    if n != nil { println("n = toInt() worked: \(n!)") }
    if let o = "123".toInt() {  println("really") }
    
.. sourcecode:: bash

    > xcrun swift test.swift
    n = toInt() worked: 123
    really
    >
    
    
.. sourcecode:: bash
    
    import Foundation
    func getOptional() -> Int? {
        let r = Int(arc4random_uniform(10))
        if r < 5 {
            return nil
        }
        return r*10
    }

    var n: Int?
    for i in 1...10 {
        n = getOptional()
        if (n != nil) { 
            println("\(i): \(n!)")
        }
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    1: 80
    2: 60
    7: 50
    8: 70
    10: 70
    >

Use of the ! symbol in ``n!`` forces the value of ``n`` as an Int to be used, which is fine, once we know for sure that it is not ``nil``.

Another idiom in Swift is "optional binding"

.. sourcecode:: bash

    if let n = dodgyNumber.toInt() {
        println("\(dodgyNumber) has an integer value of \(n)")
           } 
    else {
        println("\(dodgyNumber) could not be converted to an integer")
    }

Normally one has to use a Boolean for an if construct, but here we're allowed to use an optional, if it evaluates to ``nil`` we do the ``else``, otherwise ``n`` has an Int value and we can use it.