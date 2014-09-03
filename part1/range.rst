.. _range:

##################
Range and Interval
##################

Swift has the notions of intervals, ranges, and strides.

It also has the ideas of a closed interval or range (that includes both endpoints), and a half-open one, which extends up to but does not include the top value.

An interval contains the values between two endpoints, but it does not know anything about iterating through the values or incrementing them.  An interval can extend between one (or two) non-integer values, and another value can be tested for inclusion in the interval.

Here the type information isn't required, but I wanted to tell the compiler what we want:

.. sourcecode:: bash

    let i1: ClosedInterval = 1...5
    i1.contains(3)
    i1.contains(3.14159265)
    // both are true

A new operator tests for this:

.. sourcecode:: bash

    i1 ~= 6
    // false

The operators for ranges and intervals are the same.

.. sourcecode:: bash

    let r1: Range = 1...5
    let r2: Range = 1..<6
    if r1 == r2 { }
    // true

(The previously used ``..`` has been replaced by ``..<``).

To reverse a range, use ``reverse``

.. sourcecode:: bash

    for i in reverse(1...3) { print(String(i) + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    3 2 1
    >

There is also ``stride``

.. sourcecode:: bash

    for i in stride(from: 0, through: -4, by: -2) {
      print(i)
    }
    println

.. sourcecode:: bash

     > xcrun swift test.swift
    0 -2 -4
    >

.. sourcecode:: bash

    for i in lazy(0...5).reverse() {
        print(String(i) + " ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    5 4 3 2 1 0 
    >

And finally:

.. sourcecode:: bash

    let x = 6
    switch (x) {
        case (5...10):
            println("OK")
        default:
            println("not in interval")
    }
    // OK

.. sourcecode:: bash

    let x = 6
    let y = 5

    switch (x,y) {
        case (5...10, 3...6):
            println("OK")
        default:
            println("not in interval")
    }
    // also OK
