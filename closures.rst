.. _closures:

########
Closures
########

A closure is like an un-named function.  You are going to use it right away, so it seems like a shame to waste a good name on it.

The Array class function ``map`` takes a function and applies it to each member of the array.  Here is a first example, using ``map`` with a function (rather than a closure):

.. sourcecode:: bash

    var a = ["a","b","c"]
    func star (input: String) -> String {
        return input + "*" 
    }
    let result = a.map(star)
    println(result)

.. sourcecode:: bash

    > xcrun swift x.swift 
    [a*, b*, c*]
    >

Now, maybe we don't expect to want to reuse ``star`` in any other place.  Or... well, there are some common usages we can talk about in a bit.  Let's modify this to use a closure:

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map({
        (input: String) -> String in
        return input + "*" 
        })
    
    println(result)

It gives the same result.  The keyword ``in`` separates the argument list and return type from the body.

Here is a second example:

.. sourcecode:: bash

    var a = [20, 19, 7, 12]
    let result = a.map({
        (number: Int) -> Int in
        let result = 3 * number
        return result
        })

    println(result)
    
    .. sourcecode:: bash
    
    > xcrun swift x.swift 
    [60, 57, 21, 36]
    >

The rules allow you to omit things if they're obvious.  In the above example, we can omit the argument type since it's obvious from the array we use:

.. sourcecode:: bash

    var a = [20, 19, 7, 12]
    let result = a.map({
        number -> Int in
        let result = 3 * number
        return result
        })
    
You can omit the return type because it is also obvious (but you must omit the ``->Int``, the variable ``result`` and the ``return`` statement).

.. sourcecode:: bash
    
    var a = [20, 19, 7, 12]
    let result = a.map({
        number in 3 * number
        })
    
