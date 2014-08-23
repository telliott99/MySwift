.. _generators:

##########
Generators
##########

The Sequence protocol uses a generator:

.. sourcecode:: bash

    var seq = Range(start:1,end:5)
    var g: RangeGenerator<Int> = seq.generate()
    while let i = g.next() {
      print("\(i) ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    1 2 3 4 
    >

We don't need the type for ``g`` but I put it there just to document what it actually is.

Let's try to make a generator of our own.
    http://www.scottlogic.com/blog/2014/06/26/swift-sequences.html
    
.. sourcecode:: bash

    class FibonacciGenerator: GeneratorType {
        var a = 0, b = 1
        //typealias Element = Int
        func next() -> Int? {
            let ret = a
            a = b
            b = ret + b
            return ret 
        }
    }

    let fib = FibonacciGenerator()
    for _ in 1..<10 {
        print("\(fib.next()!) ")
    }
    println()
    
.. sourcecode:: bash    
    
    > xcrun swift test.swift
    0 1 1 2 3 5 8 13 21 
    >
    
We can spiff this up a little bit by adding a class that provides the ``generate`` method:

.. sourcecode:: bash

    class Fibonacci {
        typealias GeneratorType = FibonacciGenerator
        func generate() -> FibonacciGenerator {
            return FibonacciGenerator()
        }
    }
    
I'm not quite certain why the ``typealias`` is needed, but it is.  To run this we just substitute:

.. sourcecode:: bash

    let fib = Fibonacci().generate()

which gives the same output.