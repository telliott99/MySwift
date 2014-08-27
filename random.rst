.. _random:

##############
Random numbers
##############

Swift doesn't seem to have a built-in facility for getting random numbers.  However, there are some Unix functions available, after an ``import Foundation``.  These are ``arc4random``, ``arc4random_uniform``, and ``random``.  Only ``random`` allows you to set the seed (with ``srandom``, which is usually called with the time, as in ``srandom(time(NULL))``.

http://iphonedevelopment.blogspot.com/2008/10/random-thoughts-rand-vs-arc4random.html

For *really* random numbers, it seems that ``arc4random`` is preferred, but it can't be seeded.

    - arc4random

.. sourcecode:: bash

    import Foundation

    var a = Array<Int>()
    for i in 1...100000 {
        a.append(Int(arc4random()))
    }

    var m = 0
    for value in a {
        if value > m { m = value }
    }

    println(m)
    // 4294948471

The error message when you try to put the result of the call directly into an ``[Int]`` says that it is a ``UInt32``, an unsigned integer of 32 bits.

We use a bit of trickery to obtain the familiar Python syntax:

.. sourcecode:: bash

    import Foundation

    infix operator **{}
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)

The definition must be at global scope.  We compute

.. sourcecode:: bash

    println("\(2**32)")
    // 4294967296.0

which sounds about right.  (The ``pow`` function takes a pair of ``Double`` values, and returns one as well).

We could certainly work with the result from ``arc4random``.  To obtain a random integer in a particular range, we first need to divide by the maximum value

.. sourcecode:: bash

    import Foundation

    var f = Double(arc4random())/Double(UInt32.max)
    println("\(f)")
    var str = NSString(format: "%7.5f", f)
    println(str)

.. sourcecode:: bash

    > xcrun swift test.swift
    0.333160816070894
    0.33316
    >

then do

.. sourcecode:: bash

    import Foundation

    func randomIntInRange(begin: Int, end: Int) -> Int {
        var f = Double(arc4random())/Double(UInt32.max)
        // we must convert to allow the * operation
        let range = Double(end - begin)
        let result: Int = Int(f*range)
        return result + begin
    }


    for i in 1...100 {
        println(randomIntInRange(0,2)) 
    }

which gives the expected result (only 0 and 1).

However, rather than doing that, do this:

.. sourcecode:: bash

    import Foundation
    for i in 1...10 {
        println(arc4random_uniform(2)) 
    }

The function ``arc4random_uniform(N)`` gives a result in ``0...N-1``, that is ``[0:N)``.

If you want to seed the generator, use ``rand`` or ``random``.  The first one generates a ``UInt32``.  The second generates an Int.

.. sourcecode:: bash

    import Foundation

    import Foundation
    var a = Array<Int>()
    for i in 1...100000 {
        a.append(random())
    }

    var m = 0
    for value in a {
        if value > m { m = value }
    }

    println("\(m)") 

.. sourcecode:: bash

    > xcrun swift test.swift
    2147469841
    >

which appears to be in the range 0 to

.. sourcecode:: bash

    pow(Double(2),Double(31)) - 1

as we would expect for a signed int32, which is what ``Int`` is.  So, ``random`` gives an Int, which is good, but it doesn't respond to ``seed``.  ``rand`` does:

.. sourcecode:: bash

    import Foundation

    func getSeries(seed: Int) -> [Int] {
        srand(137)
        var a = Array<Int>()
        for i in 1...5 {
            a.append(Int(rand()))
        }
        return a
    }

    func doOne(seed: Int) {
        let a = getSeries(seed)
        for v in a { print("\(v) ")}
        println()
    }

    for i in 1...2 { doOne(137) }

.. sourcecode:: bash

    > xcrun swift test.swift
    2302559 44403467 1112244360 1793295032 2124100826 
    2302559 44403467 1112244360 1793295032 2124100826 
    >

If you want to "shuffle", the correct algorithm is to move through the array and do an exchange with a random value from the current position *through the end of the array*

.. sourcecode:: bash

import Foundation

func shuffle(a: [Int]) {
    let top = a.count-1
    for i in 0...top {
        let r = UInt32(top - i)
        let d = Int(arc4random_uniform(r))
        let j = i + d
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }
}

shuffle(Array(1...100))

This should work, but I am getting the error:  ``error: '@lvalue $T5' is not identical to 'Int'    a[i] = a[j]``.  It is not letting me assign an Int to ``a[i]`` because the value ``a[i]`` is not an Int.  Weird.
