.. _chapter4:

#######
Objects
#######

*******
Structs
*******

Here is a Swift Struct

.. sourcecode:: bash

    struct Point { var x = 0, y = 1 }
    var p = Point()
    p.y = 100
    println("\(p.x) \(p.y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    0 100
    >

Structs are passed by value.

.. sourcecode:: bash

    struct Point { var x = 0, y = 1 }
    var p = Point()
    p.y = 100
    println("\(p.x) \(p.y)")

    var q = p
    q.x = 90
    println("\(p.x) \(p.y)")
    println("\(q.x) \(q.y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    0 100
    0 100
    90 100
    >

The Struct ``p`` is not affected by what happens to ``q`` after the copy is made.

Structs are substantially more complex in Swift than in C.  What structs can do:

    - define properties to store values
    - define methods 
    - define subscripts to provide access
    - define initializers to set up their initial state
    - be extended
    - conform to a protocol

Classes are still more powerful, though.  Things that classes can do that structs cannot:

    - have more than a single instance
    - inherit from superclasses
    - check type at runtime
    - de-initialize
    - be reference counted

That's a lot, even for structs!  Let's see what we can demonstrate.

A property (a "stored property")

    is a constant or variable that is stored as part of an instance of a particular class or structure. Stored properties can be either variable stored properties (introduced by the var keyword) or constant stored properties (introduced by the let keyword).

We saw properties in the first example.  On the other hand, properties can be more sophisticated.  A property may be "only calculated when it is needed".

A method (just like in a class)

.. sourcecode:: bash

    struct S {
        var n: Int
        var description() : String {
            get {
                return "\(n)"
            }
        }
    }

An initializer is exactly as you would expect, if you imagined making a struct more like a class:

.. sourcecode:: bash

    struct Fahrenheit {
        var temperature: Double
        init() {
            temperature = 32.0
        }
    }

Not complicated.  Let's leave subscripts, extension and protocols for later.

It is possible to print out a nice (programmer-designed) string to describe a struct or class.  ``description`` is a variable (not a method), which must implement ``get``.  It looks like this:

.. sourcecode:: bash

    var description: String {
        get {
            return "my string with some variable:  \(v)"
        }
    }

This wasn't working for me, but I discovered that my standard compilation method fails in some cases where other approaches (such as Playgrounds) work.  To make this work compile it as follows:

.. sourcecode:: bash

    xcrun -sdk macosx swiftc codefile.swift

One more thing about structs.

    By default, the properties of a value type cannot be modified from within its instance methods.  
    
    In the following code, in ``mutating func changeIt``, the ``mutating`` is required, it declares to the compiler we are going to not do the default thing and allow this function to change properties of the struct.

.. sourcecode:: bash

    struct S {
        var x = 42
        mutating func changeIt() {
            x = 43
        }
    }

    var s = S()
    println(s.x)
    s.changeIt()
    println(s.x)
    if (s.x == 43) { println("OK") }

Here it is in an Xcode "playground"

.. image:: /figures/struct_pg.png
    :scale: 75 %

*******
Classes
*******

.. sourcecode:: bash

    class Obj {
        var name: String
        init(name: String) {
            self.name = name
        }
        var description: String {
            get {
                return "Obj: \(self.name)"
            }
        }
    }

    var o = Obj(name: "Tom")
    println(o.name)
    println(o.description())

.. sourcecode:: bash

    > xcrun swift test.swift 
    Tom
    Obj: Tom
    >

My favorite simple example of a class is one which keeps track of the count of instances.  The docs say to do this with a ``class`` variable, but the compiler says this is not implemented *yet*.  So we'll use a global

.. sourcecode:: bash

    var count = 0
    class O {
        // not implemented yet!
        // class var count = 0
        var name: String
        init(s: String) {
            count += 1
            name = s
        }
    }

    var o1: O = O(s: "Tom")
    println("name: \(o1.name), \(count)")
    var o2: O = O(s: "Joan")
    println("name: \(o1.name), \(count)")
    println("name: \(o2.name), \(count)")
    

.. sourcecode:: bash

    > xcrun swift test.swift
    name: Tom, 1
    name: Tom, 2
    name: Joan, 2
    >

************
Enumerations
************

.. sourcecode:: objective-c

    // one-liner variant
    enum CoinFlip { case Heads, Tails }

    var flip = CoinFlip.Heads
    flip = .Tails
    if flip == .Tails { println("tails") }
    
.. sourcecode:: objective-c

    > xcrun swift test.swift 
    tails
    > 

If the definition is multiple lines, it's slightly different:

.. sourcecode:: objective-c

    enum CompassPoint {
        case North
        case South
        case East
        case West
    }

    var directionToHead = CompassPoint.West
    directionToHead = .South

    switch directionToHead {
    case .North:
        println("Lots of planets have a north")
    case .South:
        println("Watch out for penguins")
    case .East:
        println("Where the sun rises")
    case .West:
        println("Where the skies are blue")
    }

.. sourcecode:: objective-c

    > xcrun swift test.swift 
    Watch out for penguins
    >
    
If you see a leading period on something (like ``.None``), it's an enumeration.

Enumerations in Swift are much more sophisticated than what you might be used to from other languages.

Here is an example based on the fact that bar-codes can be an array of 4 integers (UPCA) or a graphic that can be converted to a potentially very long String.  See the docs for details.

.. sourcecode:: objective-c

    enum Barcode {
        case UPCA(Int, Int, Int, Int)
        case QRCode(String)
    }

    var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)
    productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

    switch productBarcode {
        case .UPCA(let numberSystem, let manufacturer, let product, let check):
            println("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
        case .QRCode(let productCode):
            println("QR code: \(productCode).")
    }
    
.. sourcecode:: objective-c

    > xcrun swift test.swift 
    QR code: ABCDEFGHIJKLMNOP.
    >

Here are some other enum definitions from the docs that I haven't really made into full examples yet:

.. sourcecode:: objective-c

    enum ASCIIControlCharacter: Character {
        case Tab = "\t"
        Case LineFeed = "\n"
        Case CarriageReturn = "\r"
    }

    enum Planet: Int {
        case Mercury = 1, Venus, Earth, Mars, 
                          Jupiter, Saturn, Uranus, Neptune 
    }

And one of mine.

.. sourcecode:: objective-c

    enum Vector {
        case _3D(Int, Int, Int)
        case _2D(Int, Int)
        case _1D(Int)
    }

********
Closures
********

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
    
You can omit the return type because it is also obvious (but you must omit the ``-> Int``, the variable ``result`` and the ``return`` statement).

.. sourcecode:: bash
    
    var a = [20, 19, 7, 12]
    let result = a.map({
        number in 3 * number
        })

Similarly, for the other example this works:

.. sourcecode:: bash

    var a = ["a","b","c"]
    let result = a.map({ s in s + "*" })
    println(result)
        
        
        
