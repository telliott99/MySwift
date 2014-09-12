.. _chapter3:

###########
Collections
###########

.. _arrays:

******
Arrays
******

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

*****************
Sorting (default)
*****************

To obtain a sorted array, one can use either ``sort`` (in-place sort) or ``sorted`` (returns a new sorted array).

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    var sorted_names = sorted(names)
    println(sorted_names)
    
.. sourcecode:: bash
    
    > xcrun swift test.swift
    [Alex, Barry, Chris]
    >

The use of ``let`` looks a little strange (and it is), but here the "constant" designation just means that the length of the array can't be changed, although one *can* still change the values.

.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sort { $0 < $1 }
    println(a)

This also prints what you might guess.  It's a bit advanced, because we are using a closure (with brackets ``{ }``) rather than a named function.  See (:ref:`closures`).  

One of the unusual properties of closures is that under certain circumstances (what is called a "trailing closure" as a single argument), there is no need for a call operator ``( )``, even though ``sort`` is being called with the closure as its second argument.  

The important thing is that you must provide a comparison method, you can't just call ``sort``.

.. sourcecode:: bash

    var names = ["Chris", "Alex", "Barry"]
    names.sort()
    
.. sourcecode:: bash

    > xcrun swift test.swift
    test.swift:3:11: error: \
    missing argument for parameter #1 in call
    names.sort()
              ^
    >

Swift has a few global functions, and some work on arrays including ``sort(array)``, ``sort(array, predicate)``, ``sorted(array)`` and ``reversed``.  ``sorted`` will sort an array of types that know how to do comparison (follow the ``Comparable`` protocol), or you can pass a comparison function to it.  

Here is a ``cmp`` function for Strings:

.. sourcecode:: bash

    func cmp(a: String, b: String) -> Bool {
        let m = countElements(a)
        let n = countElements(b)
        if m < n { return true }
        if m > n { return false }
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

************
Dictionaries
************
    
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

******
Matrix
******

The docs have an example of a two-dimensional array or matrix of double values.  I've modified it to store Ints.  The row and column variables provide entry to the underlying data structure, which is just an array of Ints.

.. sourcecode:: bash

    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Int]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(count: rows * columns, repeatedValue: 0)
        }
        func indexIsValidForRow(row: Int, column: Int) -> Bool {
            return row >= 0 && row < rows && column >= 0 && column < columns
        }    
        subscript(row: Int, column: Int) -> Int {
            get {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                return grid[(row * columns) + column]
            }
            set {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                grid[(row * columns) + column] = newValue
            }
        }
    }

    var m = Matrix(rows: 2, columns: 2)
    m[0, 1] = 1
    m[1, 0] = 3
    println(m)
    println("\(m[0,0]) \(m[0,1])\n\(m[1,0]) \(m[1,1])")

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Matrix
    0 1
    3 0

I'm going to strip out the error checking since I never make mistakes.  :)
And then I want a more flexible way of printing the matrix.  To build each line of the output, convert a slice, obtained by calling ``grid[range]``, to a String.  I found this:

http://vperi.com/2014/06/04/flatten-an-array-to-a-string-swift-extension/

.. sourcecode:: bash

    extension Slice {
      func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
          str += "\(item)"
          if idx < self.count-1 {
            str += separator
          }
        }
        return str
      }
    }

    var a = [1,2,3]
    var s = a[0...2]
    println(s.combine("*"))

.. sourcecode:: bash

    > xcrun swift test.swift
    1*2*3
    >

This extension builds the string by repeated concatenation.  Probably the library method ``join(sep,array)`` would be better, except it takes an array of String values.  So we'll go with this for the time being.

Now, we take the modified class (no error checking), and add to it a method ``repr`` and a couple other tricks:

.. sourcecode:: bash

    extension Array {
        func combine(separator: String) -> String {
            var str : String = ""
            for (idx, item) in enumerate(self) {
                str += "\(item)"
                if idx < self.count-1 {
                    str += separator
                }
            }
            return str
        }
    }

    extension String {
        func rjust(n: Int) -> String {
            let length = countElements(self)
            var extra = n - length
            if extra <= 0 { return self }
            let pad = String(count: extra, repeatedValue: Character(" "))
            return pad + self
        }   
    }

    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Int] = [0]

        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            self.grid = Array(count: rows * columns, repeatedValue: 0)
        }

        init(rows: Int, columns: Int, values: [Int] = [0]) {
            self.rows = rows
            self.columns = columns
            if countElements(values) != rows*columns {
                self.grid = Array(count: rows * columns, repeatedValue: 0)
            }
            else {
                self.grid = values
            }
        }

        subscript(row: Int, column: Int) -> Int {
            get {
                return self.grid[(row * columns) + column]
            }
            set {
                self.grid[(row * columns) + column] = newValue
            }
        }

        var repr: String {
            get {
                let n = countElements(String(maxElement(grid)))
                var s = ""
                for i in 0...rows-1 {
                    var str_array = [String]()
                    var c: String
                    let current = i*rows
                    for j in 0...columns-1 {
                         c = String(self.grid[current + j])
                         str_array.append(c.rjust(n))
                    }
                    let slice = Array(str_array[0...str_array.count-1])
                    s += slice.combine(" ")
                    if i < rows - 1 { s += "\n" }
                }
                return s
            }
        }
    }

    var m = Matrix(rows: 2, columns: 2, values:[1,2,3,4])
    println(m.repr)
    m[0, 1] = 1995
    m[1, 0] = 500
    println(m.repr)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    1 2
    3 4
       1 1995
     500    4
    >
    
I added a String extension that does ``rjust``, and changed the Slice extension to be on Array instead, and convert to an Array before calling ``combine``.  There is a constructor that takes input data for the matrix, as well as the dimensions.

