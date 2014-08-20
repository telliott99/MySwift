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

