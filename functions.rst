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

Return multiple values:

.. sourcecode:: bash

    func two() -> (String,String) {
        return ("x","y")
    }
    var (s1,s2) : (String,String) = two()
    println(s1 + " " + s2)

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

According to the docs:

    Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

Here are some examples of closure declarations:

http://fuckingclosuresyntax.com

Here is the docs' example where the comparison function is turned into a closure:

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    func backwards(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    var rev = sorted(names, backwards)
    println(rev)

    rev = sorted(names, { 
          (s1: String, s2: String) 
          -> Bool in return s1 > s2
          })
    println(rev)

.. sourcecode:: bash

    > xcrun swift test.swift 
    [Chris, Barry, Alex]
    [Chris, Barry, Alex]
    >

(I reformated the closure).  Personally, I don't see what the big deal is.  I prefer the named function for this one.


