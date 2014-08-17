.. _basic:

############
Basic syntax
############

In order to compile Swift programs, you need Xcode.  I got Xcode6-Beta5.app.  I set it as the default (since I also have Xcode5):

.. sourcecode:: bash

    sudo xcode-select -s /Applications/Xcode6-Beta5.app/Contents/Developer
    
Then, the following method will work.  

With this file on the Desktop

``Hello.swift``

.. sourcecode:: bash

    println("Hello Swift world")

.. sourcecode:: bash

    > xcrun swift Hello.swift
    Hello Swift world
    >

Some other options are to run swift as an "interpreter" by just doing ``xcrun swift`` and then try out some code, or place this as the first line in your code ``#! /usr/bin/xcrun swift``, and then make the file executable before running it:

.. sourcecode:: bash

    > chmod u+x Hello.swift
    > ./Hello.swift 
    Hello Swift world
    >

As shown above, a basic print statement is ``println("a string")`` or ``print("a string")``.  Notice the absence of semicolons.

One can also do variable substitution, like this

.. sourcecode:: bash

    var s = "Hello"
    println("\(s)")

.. sourcecode:: bash

    > xcrun swift Hello.swift 
    Hello
    >

Variables are typed (with the type coming after the variable name) and there is no implicit conversion between types (except when doing ``print``).  

We're going to switch filenames now to ``test.swift``

``test.swift``:

.. sourcecode:: bash

    var x: Int = 2
    println(x)
    var s: String = String(x)
    println(s)
    
This works, and prints what you'd expect.  If a value is not going to change (it's constant), use ``let``:

.. sourcecode:: bash

    let s = "Hello"
    println("\(s)")

which also works, and prints what you'd expect.  The reason it works is that the compiler can sometimes infer type information from the context.

Swift has the concept of values that may be ``nil`` or may be something.  Consider the following:

.. sourcecode:: bash

    var s : String = "123"
    let m : Int? = s.toInt()
    var t : String = "123x"
    let n : Int? = t.toInt()
    println(m)
    println(n)

The second conversion ``t.toInt()`` will fail because the value ``"123x"`` can't be converted to an integer.  Nevertheless, the code compiles and when run it prints

    > xcrun swift test.swift 
    Optional(123)
    nil
    >

The value of m and n is an "Optional".

.. sourcecode:: bash

