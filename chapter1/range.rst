.. _range:

##################
Range and Interval
##################

Swift has the notions of intervals, ranges, and strides.

It also has both a closed or half-open intervals and ranges.  A closed interval includes both endpoints, and a half-open one extends up to but does not include the top value.

An interval "contains" the values between two endpoints, but it does not know anything about iterating through the values or incrementing them.  An interval can even extend between one (or two) *non-integer* values, and a value of interest can then be tested for inclusion in the interval.

From StackOverflow

http://stackoverflow.com/questions/25308978/what-are-intervals-in-swift-ranges

    A Range type is optimized for generating values that increment through the range, and works with types that can be counted and incremented.

    An Interval type is optimized for testing whether a given value lies within the interval. It works with types that don't necessarily need a notion of incrementing, and provides [other] operations

    Because the ``..<`` and ``...`` operators have two forms each--one that returns a Range and one that returns an Interval--type inference automatically uses the right one based on context.

Here the type information isn't required, but I want to tell the compiler what we expect:

.. sourcecode:: bash

    let i1: ClosedInterval = 1...5
    i1.contains(3)
    i1.contains(3.14159265)
    // both are true

A new operator ``~=`` can be used to test for this:

.. sourcecode:: bash

    i1 ~= 6
    // false

The operators for ranges and intervals are the same.

.. sourcecode:: bash

    let r1: Range = 1...5
    let r2: Range = 1..<6
    if r1 == r2 { }
    // true

(The previously used half-open notation ``..`` has been replaced by ``..<``, which is definitely clearer).

To reverse a range, use ``reverse``

.. sourcecode:: bash

    for i in reverse(1...3) { print(String(i) + " ") }
    print()

.. sourcecode:: bash

    > xcrun swift test.swift
    3 2 1
    >

There is also ``stride``, sort of like ``range`` in Python with the optional third argument.  In Swift:

.. sourcecode:: bash

    for i in stride(from: 0, through: -4, by: -2) {
      print(i)
    }
    print

.. sourcecode:: bash

     > xcrun swift test.swift
    0 -2 -4
    >

.. sourcecode:: bash

    for i in lazy(0...5).reverse() {
        print(String(i) + " ")
    }
    print()

.. sourcecode:: bash

    > xcrun swift test.swift
    5 4 3 2 1 0 
    >

(Sequences can be generated lazily).

And finally:

.. sourcecode:: bash

    let x = 6
    switch (x) {
        case (5...10):
            print("OK")
        default:
            print("not in interval")
    }
    // OK

.. sourcecode:: bash

    let x = 6
    let y = 5

    switch (x,y) {
        case (5...10, 3...6):
            print("OK")
        default:
            print("not in interval")
    }
    // also OK
