.. _random:

######
Random
######

Swift doesn't seem to have a built-in facility for getting random numbers.  However, there are some Unix functions available, after an ``import Foundation``.  These are ``arc4random``, ``arc4random_uniform``, ``rand``, and ``random``.  

Only ``rand`` and ``random`` allow you to set the seed (with ``srand`` or ``srandom`` respectively).  These are usually called with the time, as in ``srand(time(NULL))``.

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

The error message when you try to put the result of ``arc4random`` directly into an ``[Int]`` says that it is a ``UInt32``, an unsigned integer of 32 bits.

We use a bit of trickery to obtain the familiar Python syntax:

.. sourcecode:: bash

    import Foundation

    infix operator **{}
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)

The definition must be at global scope.  (For more about this see  :ref:`operators`).  We compute

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

as we would expect for a signed int32, which is what ``Int`` is.  So, ``random`` gives an Int, which is good, and it can be seeded:

.. sourcecode:: bash

    import Foundation

    func getSeries(seed: Int) -> [Int] {
        srandom(137)
        var a = Array<Int>()
        for i in 1...5 {
            a.append(random())
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
    171676246 1227563367 950914861 1789575326 941409949 
    171676246 1227563367 950914861 1789575326 941409949 
    >

If you want to "shuffle", the correct algorithm is to move through the array and do an exchange with a random value from the current position *through the end of the array*

.. sourcecode:: bash

    import Foundation

    func shuffleIntArray(array: [Int]) {
        var j: Int, a: Int, b: Int, tmp: Int
        for i in 0...array.count-1 {
            let r = UInt32(array.count - i)
            j = i + Int(arc4random_uniform(r))
            // j = min(i + 1, array.count-1)
            tmp = array[i]
            array[i] = array[j]
            array[j] = tmp
        }
    }

    var a: [Int] = [1,2,3,4,5,6,7]
    shuffleIntArray(a)
    println("\(a)")
    
This should work, but I am getting the error:  ``error: '@lvalue $T5' is not identical to 'Int'    array[i] = array[j]``.  It is not letting me assign an Int to ``array[i]`` because the value ``array[i]`` is not an Int.  

It happens even when the ``random`` code is replaced by the fake version ``j = min(i + 1, array.count-1)``.

In simpler terms, this works:

.. sourcecode:: bash

    var a: [Int] = [1,2,3,4,5,6,7]
    println("\(a)")
    let tmp = a[0]
    a[0] = a[2]
    a[2] = tmp
    println("\(a)")

and this gives the error:

.. sourcecode:: bash

    func swapTwo(a: [Int], i: Int, j: Int) {
        let v1 = a[i]
        let v2 = a[j]
        a[i] = v2
        a[j] = v1
    }

It's weird but I believe it is due to a restriction on functions modifying arrays.

I was able to get around it by constructing an entirely new array for each call to ``swap``:

.. sourcecode:: bash

    import Foundation

    func swapTwo(input: [Int], i: Int, j: Int) -> [Int] {
        var a = input
        let first = a[i]
        let second = a[j]
        a.removeAtIndex(i)
        a.insert(second, atIndex:i)
        a.removeAtIndex(j)
        a.insert(first, atIndex:j)
        return a
    }

But a much better solution is to wrap the data in a struct and then have a function that is marked as ``mutating``

.. sourcecode:: bash

    import Darwin

    struct Ordering {
        var a: [Int]
        init() {
            self.a = Array(1...100)
        }
        var repr: String {
            get { return ("\(self.a[0...4])") }
        }
        mutating func shuffleArray() {
            var i: Int, j: Int, t: Int
            var a = self.a
            for i in 0...a.count-1 {
                let r = UInt32(a.count - i)
                j = i + Int(arc4random_uniform(r))
                t = a[i]
                a[i] = a[j]
                a[j] = t
            }
            self.a = a
        }
        mutating func sort() {
            self.a.sort { $0 < $1 }
        }
    }
    

.. sourcecode:: bash

    var o = Ordering()
    println("\(o.repr)")
    o.shuffleArray()
    println("\(o.repr)")
    o.sort()
    println("\(o.repr)")

This works:

.. sourcecode:: bash

    > xcrun swift test.swift
    [1, 2, 3, 4, 5]
    [54, 60, 34, 99, 80]
    [1, 2, 3, 4, 5]
    >
