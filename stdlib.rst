.. _stdlib:

################
Standard Library
################

http://practicalswift.com/2014/06/14/the-swift-standard-library-list-of-built-in-functions/
   
``dropFirst``, ``dropLast``

``dump``

.. sourcecode:: bash

    var D = ["a":"apple","c":"cookie"]
    dump(D)

.. sourcecode:: bash

    > xcrun swift test.swift
    ▿ 2 key/value pairs
      ▿ [0]: (2 elements)
        - .0: c
        - .1: cookie
      ▿ [1]: (2 elements)
        - .0: a
        - .1: apple
    >

``enumerate``

.. sourcecode:: bash

    for (i,v) in enumerate([29, 85, 42]) {
        println("\(i): \(v)")
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    0: 29
    1: 85
    2: 42
    >
    
``join``

.. sourcecode:: bash

    println(join(":", ["A", "B", "C"]))

.. sourcecode:: bash

    > xcrun swift test.swift
    A:B:C
    >

``startsWith``

.. sourcecode:: bash

    if startsWith(10...100, 10...15) { 
        println("Yes") 
        }

.. sourcecode:: bash

    > xcrun swift test.swift
    Yes
    >

``sort``

.. sourcecode:: bash

    var a = [3,100,56,1]
    sort(&a)
    println(a)

.. sourcecode:: bash

    > xcrun swift test.swift
    [1, 3, 56, 100]
    > 

Functional programming tools:

``filter``

.. sourcecode:: bash

    for i in filter(1...100, { $0 % 10 == 0 }) {
        print("\(i) ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    10 20 30 40 50 60 70 80 90 100 

``map``

.. sourcecode:: bash

    for i in map(1...10, { $0 * 10 }) {
        print("\(i) ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    10 20 30 40 50 60 70 80 90 100 

``reduce``

.. sourcecode:: bash

    var languages = ["Swift", "Objective-C"]
    println(reduce(languages, "", { $0 + $1 }))
    println(reduce([10, 20, 5], 1, { $0 * $1 }))

.. sourcecode:: bash

    > xcrun swift test.swift
    SwiftObjective-C
    1000
    > 

``Zip2`` (not documented)

.. sourcecode:: bash

    var kL = Array(1...3)
    var vL = ["apple","banana","cookie"]
    println(Array(Zip2(kL,vL)))

.. sourcecode:: bash

    > xcrun swift test.swift
    [(1, apple), (2, banana), (3, cookie)]
    >

Here is one that is not in the library, but that I saw implemented in a complicated way.  Here is my simple version:

.. sourcecode:: bash

    var a = ["apple","banana","cookie"]
    var sep = "*"

    func interpose(sep: String, a: Array<String>) -> Array<String> {
        var result = [String]()
        if a.count == 0 {
            return result
        }
        result.append(a[0])
        for i in 1...(a.count - 1) {
            result.append(sep)
            result.append(a[i])
        }
        return result
    }

    println(interpose(sep,a))

.. sourcecode:: bash

    xcrun swift test.swift
    ["apple","*","banana","*","cookie"]