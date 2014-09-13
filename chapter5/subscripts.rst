.. _subscripts:

##########
Subscripts
##########

Here is a slightly reworked example from the docs

.. sourcecode:: bash

    struct TimesTable {
        let multiplier: Int
        subscript(index: Int) -> Int {
            return multiplier * index
        }
    }

    var n = 6
    let t3 = TimesTable(multiplier: 3)
    println("\(n) times \(t3.multiplier) is \(t3[n])")

I think you can guess what this is going to print.  Subscripts are like what we call the ``__getitem__`` operator in Python:  ``[index]``.

You define ``subscript(index: Int) -> Int { }`` and then you can use it by calling ``mystruct[3]`` or whatever.

.. sourcecode:: bash

    > xcrun swift test.swift
    6 times 3 is 18
    > 

Additional behavior includes the ability to replace both "getters" and "setters" with subscripts, as if your class were a type of dictionary.

    Subscripts can take any number of input parameters, and these input parameters can be of any type. Subscripts can also return any type. Subscripts can use variable parameters and variadic parameters, but cannot use in-out parameters or provide default parameter values.

    A class or structure can provide as many subscript implementations as it needs, and the appropriate subscript to be used will be inferred based on the types of the value or values that are contained within the subscript braces at the point that the subscript is used. This definition of multiple subscripts is known as subscript overloading.

    While it is most common for a subscript to take a single parameter, you can also define a subscript with multiple parameters if it is appropriate for your type.
    
OK, that's a mouthful.  Notice that we can use subscripts with either structs or classes.  Here's a simple example of overloading with a struct.  The first subscript takes an Int and returns a String, the second returns an Int.

.. sourcecode:: bash

    struct S {
        var a: [String] = ["Tom", "Joan", "Sean"]
        var ia: [Int] = [72, 63, 69]  // height
        subscript(i: Int) -> String {
            // drop the "get" b/c no setter
            return a[i]
        }
        subscript(i: Int) -> Int {
            get {
                return ia[i]
            }
            set(newValue) {
                ia[i] = newValue
            }
        }
    }

    var s = S()
    var result: String = s[0]
    println(result)
    var i: Int = s[0]
    println(i)

    i = s[2]
    println(i)
    s[2] = 70
    i = s[2]
    println(i)


This is a little tricky because the two subscripts are overloaded on the return type.  We help the compiler by providing explicit type information for the variables ``result`` and ``i``.  We can call the setter and find it.

.. sourcecode:: bash

    > xcrun swift test.swift
    Tom
    72
    69
    70
    >

