.. _loops:

#####
Loops
#####

We are going to use some arrays below, even though they haven't been introduced yet.  I hope what we're doing is fairly obvious, if not, see the next section.

.. sourcecode:: bash

    var L = [2,4,6]
    for x in L { print(String(x) + " ")}
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    2 4 6 
    >

For some reason, here we need the explicit conversion to String.

We can get a range of values (closed at the high end)

.. sourcecode:: bash

    var i:Int
    for i in 1...3 { print(String(i) + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    1 2 3 
    >

The docs talk about a ``1..3`` construct with only two dots, which is a half-open range, but it doesn't work for me.

A while loop:

.. sourcecode:: bash

    while true {
        println("Yes")
        break
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    Yes
    >