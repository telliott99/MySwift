.. _sorting:

#######
Sorting
#######

To obtain a sorted array, one can use either ``sort`` (in-place sort) or ``sorted`` (returns a new sorted array).

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    var sorted_names = sorted(names)
    println(sorted_names)

This prints what you'd expect.  The use of ``let`` here looks a little weird, the "constant" part of this means that the length of the array can't be changed, but one can still change the values.

.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sort { $0 < $1 }
    println(a)

This also prints what you might guess.  This is a bit advanced, because we are using a closure (notice the brackets ``{ }``) rather than a named function, and there is no call operator ``( )``, but we'll look at the use of closures in a later section.  

The important thing is that you must provide a comparison method, you can't just call ``sort``.

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

