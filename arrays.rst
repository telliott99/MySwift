.. _arrays:

######
Arrays
######

Two basic collection types are arrays and dictionaries, which use syntax like in Python:

.. sourcecode:: bash

    var fruits = ["apples", "bananas", "cats"]
    println(fruits[0])
    for f in fruits { print(f + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    apples
    apples bananas cats 
    >

Notice the ``for f in fruits`` usage.

Array access (0-based indexing):

.. sourcecode:: bash

    var array = ["a","b","c","d","e","f"]
    println(array)
    array[4] = "k"
    println(array)
    
    // fatal error: Array index out of range
    // array[3...6] = ["w","x","y","z"]
    array[3...5] = ["x","y","z"]
    println(array)

    array.insert("spam", atIndex: 1)
    println(array)
    println(array.count)


.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, b, c, d, e, f]
    [a, b, c, d, k, f]
    [a, b, c, x, y, z]
    [a, spam, b, c, x, y, z]
    7
    >

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

This works as you'd expect

.. sourcecode:: bash

    var intArr = [Double](count: 3, repeatedValue: 2.5)

Swift has array enumeration:

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

-------
Sorting
-------

To obtain a sorted array, one can use either ``sort`` (in-place sort) or ``sorted`` (returns a new sorted array).

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    var sorted_names = sorted(names)
    println(sorted_names)

This prints what you'd expect.  The use of ``let`` here looks a little weird, the "constant" part of this is it means that the length of the array can't be changed, but one can still change the values.



.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sort { $0 < $1 }
    println(a)

This also prints what you might guess.  We are using a closure rather than a named function, but we'll look at those in a later section.  

It's important that the comparison method must be provided, you can't just call ``sort``.

.. sourcecode:: bash

    > xcrun swift test.swift 
    [Alex, Barry, Chris]
    >

Swift has a few global functions, of which some work on arrays including ``sort(array)``, ``sort(array, predicate)``, ``sorted(array)`` and ``reversed``.

Here is a ``cmp`` function for Strings:

.. sourcecode:: bash

    func cmp(a: String, b: String) -> Bool {
        let aCount = countElements(a)
        let bCount = countElements(b)
        if aCount < bCount {
            return true
        }
        if aCount > bCount {
            return false
        }
        return a < b
    }

    var a: [String] = ["a","abc","c","cd"]
    println(sorted(a,cmp))
    println(a)
    a.sort(cmp)
    println(a)

.. sourcecode:: bash

    > xcrun swift test.swift
    [a, c, cd, abc]
    [a, abc, c, cd]
    [a, c, cd, abc]
    >

We've sorted first by length and then lexicographically, as desired.

