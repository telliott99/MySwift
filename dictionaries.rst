.. _dictionaries:

############
Dictionaries
############
    
Here is a simple dictionary

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    for (key,values) in D {
        println("\(key) is for \(value)")
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    b is for banana
    c is for cookie
    a is for apple
    >

We can ask for 

    - ``Array(D.keys)``
    - ``Array(D.values)`` (returns tuples with key/value pair)
    - ``D.count`` (an Int value)
    
The docs say that you can also get just the ValueTypes from "values".

.. sourcecode:: bash

    var airports = ["DUB":Dublin, TYO:"Tokyo"]
    for code in airports {
        println("\(code): \(airports[code])")
    }
    for code, city in airports.values {
    println("\(code): \(city)")
    }
    for city in airports.values {
    println("\(city)")
    }

We can access the values by subscript notation.

.. sourcecode:: bash

    var D: [String: Int] = ["apple":1, "banana":2]
    println(D)
    D["apple"] = 5
    println(D)
    D["cookie"] = 10
    println(D)

In the code above we declared the type of ``D`` as ``[String: Int]``.  This also works:

.. sourcecode:: bash

    var D = Dictionary<String,Int>()
    var D1: Dictionary<String,Int> = ["apple":1]
    println(D1["apple"]!)
    
and when run it prints ``1``, as you'd expect.  What is going on is that the ``Dictionary`` class is actually defined as a generic ``Dictionary<KeyType,ValueType>``.  The subscript notation works because that mechanism has been defined inside the class.

In the first line ``var D = Dictionary<String,Int>()``, we are getting an instance of dictionary, so we need the call operator ``( )``, which will call the ``init()`` method of the class.

Also in the code above we did ``D1["apple"]!``.  In general, dictionary operations return a value if the key is present, and otherwise ``nil``.  So the value of return type is a ``ValueType?``, which you must force to ``ValueType`` by saying ``ValueType!`` if you're sure it's not ``nil``.  Of course, you should test for ``nil``, so we should really do:

.. sourcecode:: bash

    var D: Dictionary<String,Int> = ["apple":1]
    if let value = D["apple"] {
        println(value!)
    }

``updateValue`` returns the old value if present, otherwise it returns ``nil``

.. sourcecode:: bash

    if let oldValue = D.updateValue(100, forKey:"cookie") {
        println("The old value was \(oldValue)")
    }
    else {
        println("cookie is not in the dictionary")
    }
    println(D)

.. sourcecode:: bash

    > xcrun swift test.swift 
    [apple: 1, banana: 2]
    [apple: 5, banana: 2]
    [cookie: 10, apple: 0, banana: 2]
    The old value was 10
    [cookie: 100, apple: 0, banana: 2]
    >

As usual for a dictionary, the keys are not sorted.  

As we said, unlike Python, the ``for`` construct on a dictionary returns a tuple of (key,value) pairs, rather than just keys.

.. sourcecode:: bash

    var D = ["apple":1, "banana":2]
    for k in D.keys {
        println("key: \(k), value: \(D[k])")
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    key: apple, value: Optional(1)
    key: banana, value: Optional(2)
    >

What's going on here is that the docs say:

    subscript(KeyType) -> ValueType? { get set }

which means that we can access values for keys with subscript notation, but what is returned is an Optional type (may be ``nil``).  A slight modification:  ``value: \(D[k]!)`` yields

.. sourcecode:: bash

    > xcrun swift test.swift
    key: apple, value: 1
    key: banana, value: 2
    >

I don't see anything comparable to Python's ``dict(zip(key_list,value_list))`` idiom.  So we'll roll our own:

.. sourcecode:: bash

    var L1 = Array(1...3)
    var L2 = ["apple","banana","cookie"]

    func dict_zip (aL: Array<Int>, bL: Array<String> ) 
        -> Dictionary<Int,String> {
        var D = [Int:String]()
        for (i,a) in enumerate(aL) {
            var b = bL[i]
            D[a] = b
        }
        return D
    }

println(dict_zip(L1,L2))

.. sourcecode:: bash

    > xcrun swift test.swift
    [1: apple, 2: banana, 3: cookie]
    >

Later, I did find Swift's ``zip``, it is called ``Zip2``

.. sourcecode:: bash

    var kL = Array(1...3)
    var vL = ["apple","banana","cookie"]
    var D = [Int:String]()

    for (key,value) in Zip2(kL,vL) {
        println("\(key): \(value)")
        D[key] = value
    }
    println(D)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    1: apple
    2: banana
    3: cookie
    [1: apple, 2: banana, 3: cookie]
    >