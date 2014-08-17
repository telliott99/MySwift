.. _collections:

###########
Collections
###########

Two basic collection types are arrays and dictionaries, which use syntax like in Python:

.. sourcecode:: bash

    var L = ["apples", "bananas", "cats"]
    println(L[0])
    for s in L { print(s + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    apples
    apples bananas cats 
    >

Notice the ``for x in L`` usage.

Array access (0-based indexing):

.. sourcecode:: bash

    var a = ["a","b","c","d","e","f"]
    println(a)
    a[4] = "k"
    println(a)
    
    // fatal error: Array index out of range
    // a[3...6] = ["w","x","y","z"]
    a[3...5] = ["x","y","z"]
    println(a)

    a.insert("spam", atIndex: 1)
    println(a)
    println(a.count)


.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, b, c, d, e, f]
    [a, b, c, d, k, f]
    [a, b, c, x, y, z]
    [a, spam, b, c, x, y, z]
    7
    >

.. sourcecode:: bash

    var a = [Int]()
    println(a)
    println("a is of type [Int]")
    println("a has \(a.count) items")
    for x in 1...3 { a.append(x) }
    println(a)
    println("Now, a has \(a.count) items")

.. sourcecode:: bash

    > xcrun swift test.swift 
    []
    a is of type [Int]
    a has 0 items
    [1, 2, 3]
    Now, a has 3 items
    >

This works as you'd expect

.. sourcecode:: bash

    var a = [Double](count: 3, repeatedValue: 2.5)

Swift has array enumeration:

.. sourcecode:: bash

    var L = ["apples", "bananas", "cats"]
    for (index, value) in enumerate(L) {
        println("Item \(index + 1): \(value)")
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    Item 1: apples
    Item 2: bananas
    Item 3: cats
    >
    
Here is a simple dictionary

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    for (k,v) in D {
        println("\(k) is for \(v)")
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    b is for banana
    c is for cookie
    a is for apple
    >

Another example:

.. sourcecode:: bash

    var D: [String: Int] = ["apple":1, "banana":2]
    println(D)
    D["apple"] = 0
    println(D)
    D["cookie"] = 10
    println(D)

    if let oldValue = D.updateValue(100, forKey:"cookie") {
        println("The old value was \(oldValue)")
    }
    println(D)

.. sourcecode:: bash

    > xcrun swift test.swift 
    [apple: 1, banana: 2]
    [apple: 0, banana: 2]
    [cookie: 10, apple: 0, banana: 2]
    The old value was 10
    [cookie: 100, apple: 0, banana: 2]
    >

As usual for a dictionary, the keys are not sorted.  Unlike Python, the ``for`` construct on a dictionary returns a tuple of (key,value) pairs.

For sorted arrays, one can use ``sorted``

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    var sorted_names = sorted(names)
    println(sorted_names)

This prints what you'd expect.  The use of ``let`` here is a little weird, it means that the length of the array can't be changed, but one can still change values

.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sort { $0 < $1 }
    println(a)

This also prints what you'd expect.  We are using a closure rather than a named function, but we'll look at those in a later section.  It's important that the comparison method must be provided, you can't just call ``sort``.

.. sourcecode:: bash

    > xcrun swift test.swift 
    [Alex, Barry, Chris]
    >

I don't see anything comparable to Python's ``dict(zip(key_list,value_list))`` idiom.

And I don't understand this one yet.

.. sourcecode:: bash

    var D: [String: Int] = ["apple":1, "banana":2]
    for s in D.keys {
        print(s)
        println(D[s])
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    appleOptional(1)
    bananaOptional(2)
    >