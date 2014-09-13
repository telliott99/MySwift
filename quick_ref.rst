.. _chapter8:

###############
Swift Reference
###############

****************
Standard Library
****************

http://practicalswift.com/2014/06/14/the-swift-standard-library-list-of-built-in-functions/

    - ``dropFirst``
    - ``dropLast``
    - ``dump``

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
    
***************
Quick reference
***************

From

https://developer.apple.com/library/prerelease/mac/documentation/General/Reference/APIDiffsMacOSX10_10SeedDiff/modules/Swift.html

(a few are not listed)

String methods:

.. sourcecode:: bash

    append(Character)
    init(count: Int, repeatedValue: Character)
    endIndex
    extend(String)
    hasPrefix(String) -> Bool
    hasSuffix(String) -> Bool
    insert(Character, atIndex: String.Index)
    isEmpty
    join(S) -> String
    removeAll(Bool)
    removeAtIndex(String.Index) -> Character
    removeRange(Range<String.Index>)
    replaceRange(Range<String.Index>, with: C)
    reserveCapacity(Int)
    init(seq: S)
    splice(S, atIndex: String.Index)
    startIndex
    toInt() -> Int?

Array methods:

.. sourcecode:: bash

    append(T)
    capacity
    count
    init(count: Int, repeatedValue: T)
    description
    endIndex
    extend(S)
    filter((T) -> Bool) -> [T]
    first
    insert(T, atIndex: Int)
    isEmpty
    join(S) -> [T]
    last
    map((T) -> U) -> [U]
    reduce(U, combine:(U, T) -> U) -> U
    removeAll(Bool)
    removeAtIndex(Int) -> T
    removeLast() -> T
    removeRange(Range<Int>)
    replaceRange(Range<Int>, with: C)
    reserveCapacity(Int)
    reverse() -> [T]
    sort((T, T) -> Bool)
    sorted((T, T) -> Bool) -> [T]
    splice(S, atIndex: Int)
    startIndex

Dictionary methods

.. sourcecode:: bash

    count
    description
    endIndex
    generate() -> DictionaryGenerator<Key, Value>
    indexForKey(Key) -> DictionaryIndex<Key, Value>?
    isEmpty
    keys
    init(minimumCapacity: Int)
    removeAll(Bool)
    removeAtIndex(DictionaryIndex<Key, Value>)
    removeValueForKey(Key) -> Value?
    startIndex
    updateValue(Value, forKey: Key) -> Value?
    values

   