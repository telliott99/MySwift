.. _sort:

#######
Sorting
#######

To obtain a sorted array built-in methods, one can use either ``sort`` (in-place sort) or ``sorted`` (returns a new sorted array).

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

This also prints what you might guess.  It's a bit advanced, because we are using a closure (with brackets ``{ }``) rather than a named function.  See (:ref:`closures_med`).  

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