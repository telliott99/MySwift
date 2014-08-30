.. _closures:

########
Closures
########

A closure is like function with no name.  You are going to use it right away, so it seems like a shame to waste a good name on it.  Sort of like Clint Eastwood

http://en.wikipedia.org/wiki/Man_with_No_Name

Maybe the simplest closure is the one I used in the chapter on sorting:

.. sourcecode:: bash

    var a = ["Chris", "Alex", "Barry"]
    a.sort { $0 < $1 }
    println(a)

.. sourcecode:: bash

    > xcrun swift x.swift 
    ["Alex", "Barry", "Chris"]
    >
    
The second line has a closure in it ``{ $0 < $1 }``.  It uses special built-in variables ``$0`` and ``$1`` and will be called with two arguments that are to be compared to each other.  

The ``<`` is our contribution.  We might as well have put ``>``, to sort in the reverse order. 

We could do this more explicitly as:

.. sourcecode:: bash

    { (a: String, b: String) -> Boolean 
        in return a < b }

Or fairly compactly as

.. sourcecode:: bash

    { a,b in a < b }

The Array class function ``map`` takes a function and applies it to each member of the array.  Here is a first example, using ``map`` with a function (rather than a closure):

.. sourcecode:: bash

    var a = ["a","b","c"]
    func star (s: String) -> String {
        return s + "*" 
    }
    let result = a.map(star)
    println(result)

.. sourcecode:: bash

    > xcrun swift x.swift 
    [a*, b*, c*]
    >

Now, maybe we don't expect to want to reuse ``star`` in any other place.  Or... well, there are some common usages we can talk about in a bit.  So modify the example to use a closure:

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map({
        (s: String) -> String in
        return s + "*" 
        })
    
    println(result)

This second version (above) gives the same result as the first.  The keyword ``in`` separates the argument list and return type from the body.

Here is another example:

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
    
The advantages of closures given in the docs are:

    Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.
    
    Closures can capture and store references to any constants and variables from the context in which they are defined. This is known as closing over those constants and variables, hence the name “closures”. Swift handles all of the memory management of capturing for you.
    
It goes on:

    Global and nested functions, as introduced in Functions, are actually special cases of closures. Closures take one of three forms:

    -Global functions are closures that have a name and do not capture any values.
    -Nested functions are closures that have a name and can capture values from their en closing function.
    -Closure expressions are unnamed closures written in a light weight syntax that can capture values from their surrounding context.
    

So a key feature is that closures capture values from the environment when they are called.  Global functions don't do this.  Or they shouldn't.  However this:

.. sourcecode:: bash

    s = "Hello"
    func f() { println(s) }
    f()
    
Actually *does* print ``5``.  Even this does:

.. sourcecode:: bash

    s = "Hello"
    func f() -> () -> () {
        func g() {
             println(s)
        }
        return g
    }
    let h = f()
    h()

In this example, we return a function from a function.  The function's type is ``() -> ()``, it takes no arguments and returns void.  We could modify it to eliminate the identifier ``g``:

.. sourcecode:: bash

    s = "Hello"
    func f() -> () -> () {
        return { s: String in println(s) }
    }
    let h = f()
    h()

    let sortFuncTakesClosure = ({ a,b: Int return a < b  })
    
make generic?  then use it

.. sourcecode:: bash

    reversed = sortFuncTakesClosure(a,b)

Another great example of progressive simplification of closures is the global ``sorted`` function, which takes an array to be sorted and a sort method as the second argument.  So to sort Strings or Ints you might write this code:

.. sourcecode:: bash

    func rev(s1: String, s2: String) -> Bool { return s1 > s2 }

Here we are doing the opposite of the default sort method.  Then we might use the function as follows:

.. sourcecode:: bash

    let names = ["Bob", "Alex", "Charlie"]
    let a = sorted(names, rev)
    println(a)
    // ["Charlie", "Bob", "Alex"]

In this case, it does seem silly to use a name for ``rev``, if we could just put it directly as the second argument to ``sorted``.  So we use a closure:

.. sourcecode:: bash

    let reversed = sorted(a,{(s1: String, s2: String) -> Bool 
    in return s1 > s2}

In fact, the docs say that the closure's argument types can always be inferred from the context when a closure is passed as an argument to another function.  In fact, the return type can be inferred as well.  So we can lose them and the compiler won't complain:

.. sourcecode:: bash

    let reversed = sorted(a,{ s1, s2 in return s1 > s2}

If the entire closure is a single expression, the return can also be omitted.

    .. sourcecode:: bash

    let reversed = sorted(a,{ s1, s2 in s1 > s2}

Now admittedly, this is pretty brief.  Also, the ``in`` looks weird, so don't parse its meaning but just remember that it says:  the closure body is beginning now.

I found out later that even this will work!

.. sourcecode:: bash

    let reversed = sorted(a, > }
