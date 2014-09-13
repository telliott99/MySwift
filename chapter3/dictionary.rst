.. _dictionary:

##########
Dictionary
##########
    
Here is a simple dictionary

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    for (k,v) in D {
        println("key: \(k) is for value: \(v)")
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    key: b is for value: banana
    key: c is for value: cookie
    key: a is for value: apple
    >

The construct ``for (tuple) in dictionary`` loops over tuples of (key, value) pairs.

We can also ask for 

    - ``D.keys`` 
    - ``D.values``
    - ``D.count``

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    println(Array(D.keys))

.. sourcecode:: bash

    > xcrun swift test.swift
    [b, c, a]
    >

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    println(Array(D.values))

.. sourcecode:: bash

    > xcrun swift test.swift
    [banana, cookie, apple]
    >


Without the ``Array()``, you get

.. sourcecode:: bash

    > xcrun swift test.swift
    Swift.LazyBidirectionalCollection
    >

Here is the example from the docs:

.. sourcecode:: bash

    var airports = ["DUB":Dublin, "TYO":"Tokyo"]
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

An important point to remember about dictionaries is that a call to retrieve the value for a key may fail.  In general, dictionary operations return a value if the key is present, and otherwise ``nil``.  So the type defined to be returned is an "Optional".

In the code above we did ``D1["apple"]!``.  The value of return type is a ``ValueType?``, which you must force to ``ValueType`` by saying ``ValueType!`` if you're sure it's not ``nil``.  Of course, you should test for ``nil``, so we should really do:

.. sourcecode:: bash

    var D: Dictionary<String,Int> = ["apple":1]
    if let value = D["apple"] {
        println(value!)
    }

The dictionary method ``updateValue`` returns the old value if present, otherwise it returns ``nil``

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

As usual for a dictionary, the keys *are in a particular order* (based on their hash values), but they're not in lexicographical order and appear to be unsorted.

.. sourcecode:: bash

    var D = ["a":"apple","b":"banana","c":"cookie"]
    for k in sorted(D.keys) { println("\(k): \(D[k]!) ") }

.. sourcecode:: bash

    > xcrun swift test.swift
    a: apple 
    b: banana 
    c: cookie 
    >

--------------------
dict(zip(a,b)) idiom
--------------------

I don't think there is anything comparable to Python's ``dict(zip(key_list,value_list))`` idiom.  So we'll roll our own:

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

Update:  I did find Swift's ``zip``, it is called ``Zip2``

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