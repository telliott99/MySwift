.. _arrays:

######
Arrays
######

The two basic collection types are arrays and dictionaries, which use syntax something like in Python:

.. sourcecode:: bash

    let fruits = ["apples", "bananas", "cats"]
    println(fruits[0])
    for f in fruits { print(f + " ") }
    println()

Array access starts from ``0`` (indexing is 0-based):

.. sourcecode:: bash

    > xcrun swift test.swift 
    apples
    apples bananas cats 
    >

Notice the ``for f in fruits`` usage.  To check the number of items in an array, use ``count``.  If there are no items, then ``isEmpty()`` will return ``true``.

.. sourcecode:: bash
    
    var a = [4,5,6]
    a.count == 3
    // true
    a.isEmpty()
    // false
    
.. sourcecode:: bash

    var array = ["a","b","c","d","e","f"]
    println(array)
    array[4] = "k"
    println(array)
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, b, c, d, e, f]
    [a, b, c, d, k, f]
    >

------------------
Modifying an array
------------------

One way is to use a subscript, as shown above.  Another way is this:

.. sourcecode:: bash

    var a = [4,5,6]
    a.insert(10, atIndex:1)
    // [4,10,5,6]

If we're adding onto the end, use ``append`` for a single value or **use concatenation as the equivalent of Python's ``extend``**

.. sourcecode:: bash

    var a = [4,5,6]
    a.append(10)
    // [4,5,6,10]
    a += [21,22,23]
    // [4,5,6,10,21,22,23]

To insert at a particular position, use ``insert(value, atIndex: index)``, like so:

.. sourcecode:: bash

    var a = ["a","b","c"]
    a.insert("spam", atIndex: 1)
    println(a)
    \\ ["a","spam","b","c"]
    println(a.count)
    \\ 4

One can also use Range (slice) notation with arrays.

.. sourcecode:: bash

    var a = ["a","b","c","d","e","f"]    
    // fatal error: Array index out of range
    // array[3...6] = ["w","x","y","z"]
    array[3...5] = ["x","y","z"]
    println(array)
    // ["a","b","c","x","y","z"]

The valid indexes in an array run from 0 to ``count - 1`` so we can do:

.. sourcecode:: bash

    var a = ["a","b","c","d","e","f"]
    let end = a.count - 1   
    array[3...end] = ["x","y","z"]
    println(array)
    // ["a","b","c","x","y","z"]

As the docs say

    You can also use subscript syntax to change a range of values at once, even if the replacement set of values has a different length than the range you are replacing:

.. sourcecode:: bash

    var a = ["a","b","c","d","e","f"]
    a[1...4] = ["x"]
    // ["a","x","f"]
    var b = a
    b[1] = ["j","k","l"]
    // ["a","j","k","l","f"]
    
Arrays are value types, so ``a`` and ``b`` above have different values.

Removing a value by index

.. sourcecode:: bash

    var a = ["a","b","c"]
    println("\(a.removeAtIndex(1))")
    println(a)
    a.insert("x", atIndex:0)
    println(a)

.. sourcecode:: bash

    > xcrun swift test.swift
    b
    [a, c]
    [x, a, c]
    >

Rather than ``pop`` use ``removeLast``:

.. sourcecode:: bash

    var a = [4,5,6]
    let b = a.removeLast()
    // a has the value [4,5]
    // b has the value 4

One can specify the type of an array using two synonymous approaches:  ``[Int]`` or ``Array<Int>``.  Usually the first, shorthand, is preferred.  To instantiate, add the call operator ``()``:

.. sourcecode:: bash

    var array = [Int]()
    println(array)
    println("array is of type [Int]")
    println("array has \(array.count) items")
    for x in 1...3 { array.append(x) }
    println(array)
    println("Now, array has \(array.count) items")

.. sourcecode:: bash

    > xcrun swift test.swift 
    []
    array is of type [Int]
    array has 0 items
    [1, 2, 3]
    Now, array has 3 items
    >
    
In this last example, we've used string interpolation to print the value of the property ``count``.

This works as you'd expect

.. sourcecode:: bash

    var intArr = [Double](count: 3, repeatedValue: 2.5)
    
Looping over the values can be done by ``for-in``:

.. sourcecode:: bash

    var a = 1...2
    for var i in a { println("\(i)") }
    \\ 1
    \\ 2

Swift has enumeration:

.. sourcecode:: bash

    var fruitArr = ["apples", "bananas", "cats"]
    for (index, value) in enumerate(fruitArr) {
        println("Item \(index + 1): \(value)")
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    Item 1: apples
    Item 2: bananas
    Item 3: cats
    >

As a final example, a little functional programming:

.. sourcecode:: bash

    var a = Array(1...10)
    func isEven(i: Int) -> Bool {
       let x = i % 2
       return x == 0
    }

    let even = a.filter(isEven)
    println(even)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [2, 4, 6, 8, 10]
    >
    