.. _enum:

############
Enumerations
############

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
