.. _generics:

########
Generics
########

Amazingly enough, one can even write a function that deliberately modifies a parameter that is a primitive type.  We convert call-by-value into call-by-reference!  There is no return value and the parameters are marked with the label ``inout``:

.. sourcecode:: bash

    func swapInts(inout a: Int, inout b: Int) {
        let tmp = a
        a = b
        b = tmp
    }
    var x: Int = 1
    var y: Int = -1
    println(String(x) + " " + String(y))
    swapInts(&x,&y)
    println(String(x) + " " + String(y))
    
.. sourcecode:: bash
    
    > xcrun swift test.swift 
    1 -1
    -1 1
    >

Notice the use of ``&x`` and ``&y``, borrowed from C and C++.

We can replace the above by a generic version

.. sourcecode:: bash

    func swapTwo <T> (inout a: T, inout b: T) {
        let tmp = a
        a = b
        b = tmp
    }

    var x = 1, y = 2
    println("x = \(x), y = \(y)")
    swapTwo(&x,&y)
    println("x = \(x), y = \(y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    >

An alternative approach is to use multiple return values in a tuple:

.. sourcecode:: bash

    func swapTwo <T> (a: T, b: T) -> (T,T) {
        return (b, a)
    }

    var x = 1, y = 2
    println("x = \(x), y = \(y)")

    (x,y) = swapTwo(x,y)
    println("x = \(x), y = \(y)")

We declare the return type as (T,T).

.. sourcecode:: bash

    > xcrun swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    >

You might have wondered about the function's name (swapTwo).  The reason for this is that ``swap`` actually exists in the standard library as a generic:

.. sourcecode:: bash

    var x = 1, y = 2
    println("x = \(x), y = \(y)")

    swap(&x,&y)
    println("x = \(x), y = \(y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    > 

-----
Stack
-----

Here is an implementation (from the docs, mostly) of a stack:

.. sourcecode:: bash

    struct StringStack {
        var items = [String]()
        mutating func push(item: String) {
            items.append(item)
        }
        mutating func pop() -> String {
            return items.removeLast()
        } 
    }

    var StrSt = StringStack()
    StrSt.push("uno")
    StrSt.push("dos")
    StrSt.push("tres")
    StrSt.push("cuatro")
    println(StrSt.pop())

.. sourcecode:: bash

    > xcrun swift test.swift
    cuatro
    >

And now, let's rewrite it to use generics

.. sourcecode:: bash

    struct Stack <T> {
        var items = [T]()
        mutating func push(item:T) {
            items.append(item)
        }
        mutating func pop() -> T {
            return items.removeLast()
        } 
    }

    var StrSt = Stack<String>()
    StrSt.push("uno")
    StrSt.push("dos")
    StrSt.push("tres")
    StrSt.push("cuatro")
    println(StrSt.pop())

Prints the same as before.

Use the same struct but with Ints:

.. sourcecode:: bash

    var IntSt = Stack<Int>()
    for i in 1...3 { IntSt.push(i) }
    println(IntSt.pop())

.. sourcecode:: bash

    > xcrun swift test.swift
    3
    >

I don't have a good use case yet, but you can have more than one generic type:

.. sourcecode:: bash

    func pp <S,T> (s: S, t: T) {
        println("The value of s is \(s) and t is \(t)")
    }
    pp(1.33, 17)

.. sourcecode:: bash

    > xcrun swift test.swift
    The value of s is 1.33 and t is 17
    >


And you can name them anything you like (although caps are standard)

.. sourcecode:: bash

    func pp <SillyType1,SillyType2> 
        (s: SillyType1, t: SillyType2) {
        println("The value of s is \(s) and t is \(t)")
    }
    pp(1.33, 17)


This next example deals with both generics and protocols.  The efficient collection to use when you want to check whether a value is present is a dictionary.  Since String and Int types can be KeyValue types for a dictionary, this works great:

.. sourcecode:: bash

    func singles <T: Hashable> (input: [T]) -> [T] {
        var D = [T: Bool]()
        var a = [T]()
        for k in input {
            if let v = D[k] {
                // pass
            }
            else {
                D[k] = true
                a.append(k)
            }
        }
        return a
    }

    println(singles(["a","b","a"]))
    println(singles([0,0,0,0,0]))

What this says is that we'll take an array of type T and then return an array of type T.  For each value in the input, we check if we've seen it (by checking if it's in the dictionary).  The subscript operator is defined, and it returns an optional.  So we use the ``if let value = D[key]`` construct, which is nil if the key is not in the dictionary.

The ``Hashable`` protocol requires that the array contain objects that are "hashable", i.e. either the compiler (or we) have to be able to compute from it an integer value that is (almost always) unique.  The compiler does this for primitive types on its own.

Looks like it works:

.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, b]
    [0]
    > 

In order to use this for a user-defined object, that object must follow the Hashable protocol.  However, let's start by looking at Comparable and Equatable.  For this, an object must respond to the operators ``==`` and ``<``.  These functions must be defined *at global scope*.

We obtain a unique id for each object from the current time (slightly different since they are initialized sequentially):

.. sourcecode:: bash

    import Cocoa

    class Obj: Comparable, Equatable {
        var n: Int
        init() {
            var d = NSDate().timeIntervalSince1970
            let i = Int(1000000*d)
            self.n = i
        }    
    }

    // must be at global scope
    func < (a: Obj, b: Obj) -> Bool {
        return a.n < b.n
    }

    func == (a: Obj, b: Obj) -> Bool {
        return a.n == b.n
    }

    var o1 = Obj()
    var o2 = Obj()
    println("\(o1.n) \(o2.n)")
    println(o1 == o2)
    println(o1 < o2)

.. sourcecode:: bash

    > xcrun swift test.swift 
    1409051635.29793
    1409051635.29838
    1409051635297932 1409051635298383
    false
    true
    >

As you can see, the second object was initialized approximately 0.45 milliseconds after the first one, so it compares as not equal, and less than the second.

For the Hashable protocol, an object is required to have a property ``hashValue``, but is also required to respond to ``==`` (it's undoubtedly faster to check that first).

.. sourcecode:: bash

    import Cocoa

    class Obj: Hashable, Printable {
        var n: Int
        var name: String
        init(name: String) {
            var d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
            self.name = name
        }
        var hashValue: Int {
            get { return self.n }
        }
        var description: String {
            get { return "\(self.name):\(self.n)" }
        }
    }

    func == (a: Obj, b: Obj) -> Bool {
        return a.n == b.n
    }

    func singles <T: Hashable> (input: [T]) -> [T] {
        var D = [T: Bool]()
        var a = [T]()
        for v in input {
            if let f = D[v] {
                // pass
            }
            else {
                D[v] = true
                a.append(v)
            }
        }
        return a
    }

    var o1 = Obj(name:"o1")
    var o2 = Obj(name:"o2")
    let result = singles([o1,o2,o1])
    for o in result {
        print("\(o) ")
    }
    println()
    println(singles([o1,o1,o1,o1,o1,o1]))


This *almost* works.  For some reason, it isn't printing the representation correctly.

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Obj test.Obj 
    [test.Obj]
    >

Here is another simple example that follows the instructions but fails currently (Xcode is beta at the moment I write this)

.. sourcecode:: bash

    import Foundation
    class Obj: Printable {
        var n: Int
        init() {
            var d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
        }
        var description: String {
            get { return "Obj: \(n)" }
        }
    }

    var o = Obj()
    println("\(o)")
// test.Obj