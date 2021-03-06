.. _functions:

#########
Functions
#########

Function definitions are labeled with the keyword ``func``

.. sourcecode:: bash

    func greet(n:String) {
        println("Hello \(n)")
    }
    greet("Tom")

.. sourcecode:: bash

    > xcrun swift test.swift 
    Hello Tom
    >

If you want to return a value, it must be typed

.. sourcecode:: bash

    func count(n:String) -> Int {
        // global function
        return countElements(n)
    }
    println(count("Tom"))

.. sourcecode:: bash

    > xcrun swift test.swift 
    3
    >

Here is an example from the Apple docs:

.. sourcecode:: bash

    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for n in numbers {
            sum += n
        }
        return sum
    }

    println(sumOf())
    println(sumOf(42,597,12))

.. sourcecode:: bash

    > xcrun swift test.swift 
    0
    651
    >

The ``...`` means the function takes a variadic parameter (number of items is unknown at compile-time---see the docs).

But then they say:

    Functions can be nested. Nested functions have access to variables that were declared in the outer function. You can use nested functions to organize the code in a function that is long or complex.
    
So let's try something.  Add ``let x = 2`` as line 1.

.. sourcecode:: bash

    > xcrun swift test.swift 
    2
    653
    >

They're not kidding!  The ``x`` at global scope is available inside ``sumOf``.  You can nest deeper:

.. sourcecode:: bash

    let s = "abc"
    func f() {
        let t = "def"
        println(s)
        func g() {
            println(s + t)
            println(s + "xyz")
        }
        g()
    }
    f()

.. sourcecode:: bash

    > xcrun swift test.swift 
    abc
    abcdef
    abcxyz
    >

Functions can return multiple values (from the Apple docs, with slight modification):

.. sourcecode:: bash

    func minMax(a: [Int]) -> (Int,Int) {
        min = a[0]
        max = a[1]
        for i in a[1..<a.count] {
            if i < min  {
                min = i
            }
            if i > max {
                max = i
            }
        }
        return (min,max)
    }
    arr: [Int] = [8,-6,2,109,3,71]
    var (s1,s2) : (Int,Int) = minMax(arr)
    println("min = " + s1 + " and max = " + s2)

.. sourcecode:: bash

    > xcrun swift test.swift 
    x y
    >

Return a function:

.. sourcecode:: bash

    func adder(Int) -> (Int -> Int) {
        func f(n:Int) -> Int {
            return 1 + n
        }
        return f
    }
    var addOne = adder(1)
    println(addOne(5))

.. sourcecode:: bash

    > xcrun swift test.swift 
    6
    >

Notice how the return type of ``adder`` is specified.

Provide a function as an argument to a function:

.. sourcecode:: bash

    func filter(list: [Int], cond:Int->Bool) -> [Int] {
        var result:[Int] = []
        for e in list {
           if cond(e) {
              result.append(e)
           }
        }
        return result
    }
    func lessThanTen(number: Int) -> Bool {
        return number < 10
    }
    println(filter([1,2,13],lessThanTen))

.. sourcecode:: bash

    > xcrun swift test.swift 
    [1, 2]
    >

Function parameters
-------------------

It may be useful to require the caller to identify the parameters as they are entered into the function call.  For example, when calling ``NSMakeRect`` one would do something like this:

.. sourcecode:: bash

    let r = NSMakeRect(x:1.0,y:1.0,width:50.0,height:50.0)

``x``, ``y``, ``width`` and ``height`` are named parameters.  The declaration of the function might be something like this

.. sourcecode:: bash

    ``func NSMakeRect(x x: Double, y y: Double, width w: Double, height h: Double)``
    
The *external* parameter name preceeds the *internal* parameter name.  In this case, the internal name is already a good external name for ``x`` and ``y``.  So combine them, like this:

.. sourcecode:: bash

    ``func NSMakeRect(#x: Double, #y: Double, width w: Double, height h: Double)``

    
An example from the Apple docs:

.. sourcecode:: bash

    func join(string1 s1: String, string2 s2: String, withJoiner joiner: String) -> String {
        return s1 + joiner + s2
    }

    println(join(string1: "hello", string2: "world", withJoiner: ", "))

Prints:

.. sourcecode:: bash

    > xcrun swift test.swift 
    hello, world
    >

As the code shows, we have two identifiers for each variable, one used in calling the function, and the other used inside the function.

As we said, while the "external parameter" and the "internal parameter" identifiers can be different (above), they don't have to be.  In that case, the arguments are marked with "#".  Here is the example in the docs:

.. sourcecode:: bash

    func containsCharacter(#string: String, #char: Character) -> Bool {
        for c in string {
            if char == c {
                return true
            }
        }
        return false
    }

    let containsV = containsCharacter(string: "aardvark", char: "v")
    if containsV {
        println("aardvark contains a v")
    }

Prints:

.. sourcecode:: bash

    > xcrun swift test.swift 
    aardvark contains a v
    >

Default parameters
------------------

A function can also have default parameters.  As in Python, the *default parameters must come after all non-default parameters*:

.. sourcecode:: bash

    func join(s1: String, s2: String, joiner: String = " ") -> String {
        return s1 + joiner + s2
    }
    println(join("hello","world"))
    println(join("hello","world",joiner: "-"))
    
.. sourcecode:: bash
     
    > xcrun swift test.swift 
    hello world
    hello-world
    >
    
There are several other fancy twists on parameters that you can read about in the docs, for example:  variadic parameters, parameters that are constant.