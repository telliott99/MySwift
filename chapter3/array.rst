.. _array:

#####
Array
#####

The two basic collection types are arrays and dictionaries, which use syntax something like in Python:

.. sourcecode:: bash

    let fruits = ["cats", "apples", "bananas"]
    println(fruits[0])
    for f in fruits { print(f + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    cats
    cats apples bananas 
    >

Array access starts from ``0`` (indexing is 0-based).  Notice the simplicity of the ``for f in fruits`` usage.  

To check the number of items in an array, query the ``count`` property, or use ``countElements(a)``.  If there are no items, then ``isEmpty()`` will return ``true``.

.. sourcecode:: bash
    
    var a = [4,5,6]
    a.count == 3
    // true
    a.isEmpty()
    // false
    
.. sourcecode:: bash

    var array = ["a","b","c","d","e","f"]
    println("\(array)")
    array[4] = "k"
    println(array)
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, b, c, d, e, f]
    [a, b, c, d, k, f]
    >

Arrays have properties ``first`` and ``last``

.. sourcecode:: bash

    var a = Array(1..<10)
    println("\(a.first!), \(a.last!)")
    a = [1,2,3,4]
    println("\(a.first), \(a.last)")

.. sourcecode:: bash

    > xcrun swift test.swift
    1, 9
    Optional(1), Optional(4)
    >

There is a global function ``contains`` to test whether a value is included:

.. sourcecode:: bash

    contains([1,2,3], 3)
    // true

These are Optionals, even with an array formed like ``[1,2,3,4]``, so to get the value, use ``!`` as in the first part.  For more details, see :ref:`optionals`.

------------------
Modifying an array
------------------

One way is to use subscript access, as shown above.
 
To insert at a particular position, use ``insert(value, atIndex: index)``, like so:

.. sourcecode:: bash

    var a = ["a","b","c"]
    a.insert("spam", atIndex: 1)
    println(a)
    \\ ["a","spam","b","c"]
    println(a.count)
    \\ 4

When adding onto the end, use ``append`` for a single value or what is really nice, **use concatenation as the equivalent of Python's ``extend``**

.. sourcecode:: bash

    var a = [4,5,6]
    a.append(10)
    // [4,5,6,10]
    a += [21,22,23]
    // [4,5,6,10,21,22,23]

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
    
(or just use ``array[0...count-1]``).

As the docs say

    You can also use subscript syntax to change a range of values at once, even if the replacement set of values has a different length than the range you are replacing:

.. sourcecode:: bash

    var a = ["a","b","c","d","e","f"]
    a[1...4] = ["x"]
    println("\(a)")
    var b = a
    b[1] = "j"
    println("\(a)")
    println("\(b)")
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, x, f]
    [a, x, f]
    [a, j, f]
    >
    
Arrays are value types, so ``a`` and ``b`` refer to different arrays, despite the assignment.

    A value type is a type whose value is copied when it is assigned to a variable or constant

Removing a value by index

.. sourcecode:: bash

    var a = ["a","b","c"]
    println("\(a.removeAtIndex(1))")
    println(a)
    a.insert("x", atIndex:0)
    println(a)

``removeAtIndex`` returns the value:

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
    // b has the value 6

One can specify the type of an array using two synonymous approaches:  ``[Int]`` or ``Array<Int>``.  Usually the first, shorthand way is preferred.  To instantiate, add the call operator ``()``:

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

``repeatedValue`` works as you'd expect

.. sourcecode:: bash

    var intArr = [Double](count: 3, repeatedValue: 2.5)
    
As we said at the beginning, looping over the values can be done by ``for-in``:

.. sourcecode:: bash

    var a = 1...2
    for var i in a { println("\(i)") }
    \\ 1
    \\ 2

---------
Enumerate
---------

Swift also has enumerate:

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

A little functional programming:

.. sourcecode:: bash

    var a = Array(1...10)
    func isEven(i: Int) -> Bool {
       let x = i % 2
       return x == 0
    }
    println(a.filter(isEven))
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [2, 4, 6, 8, 10]
    >

------------------
List comprehension
------------------

List comprehension is not built-in, but the functional programming constructs make it fairly easy.  Here is an example with ``filter`` and a trailing closure.

http://stackoverflow.com/questions/24003584/list-comprehension-in-swift

.. sourcecode:: bash

    let evens = filter(1..<10) { $0 % 2 == 0 }
    println(evens)
    // [2, 4, 6, 8]

------------------
Array Modification
------------------

If you pass an array to a function with the intention of modifying it, declare the array parameter as ``inout`` and pass ``&a`` to the function, like this:

.. sourcecode:: bash

    func pp (s: String, a: [Int]) {
        print (s + " ")
        for n in a { print("\(n) ") }
        println()
    }

    func swap(inout a: [Int], i: Int, j: Int) {
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }

    func selection_sort(inout a: [Int]) {
        for i in 0...a.count - 2 {
            for j in i...a.count - 1 {
                if a[j] < a[i] {
                    swap(&a,i,j)
                }
            }
        }
    }

    var a = [32,7,100,29,55,3,19,82,23]
    pp("a: ", a)

    let b = sorted(a, { $0 < $1 })
    pp("b: ", b)

    var c = a
    pp("c: ", c)
    selection_sort(&c)
    pp("c: ", c)    

.. sourcecode:: bash

    > xcrun swift test.swift
    a:  32 7 100 29 55 3 19 82 23 
    b:  3 7 19 23 29 32 55 82 100 
    c:  32 7 100 29 55 3 19 82 23 
    c:  3 7 19 23 29 32 55 82 100 
    d:  32 7 100 29 55 3 19 82 23 
    d:  3 7 19 23 29 32 55 82 100 
    >

If you forget ``inout`` in the parameters, or ``&`` in the call, you'll get a funny error:

.. sourcecode:: bash

    > xcrun swift test.swift
    test.swift:8:5: error: '@lvalue $T8' is not identical to 'Int'
        a[i] = a[j]
        ^
    test.swift:9:5: error: '@lvalue $T5' is not identical to 'Int'
        a[j] = tmp
        ^
    >
