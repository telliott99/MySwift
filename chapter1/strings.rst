.. _strings:

#######
Strings
#######

I don't have much to put here at the moment, but this is a good thing to remember:

    Swift’s String type is bridged seamlessly to Foundation’s NSString class. If you are working with the Foundation framework in Cocoa or Cocoa Touch, the entire NSString API is available to call on any String value you create, in addition to the String features described in this chapter. You can also use a String value with any API that requires an NSString instance.

This helped me to finally figure out some things that had been confusing.  Without being explicit about the problems, the answer is that NSString methods are available to String variables, but *only if* we've done ``import Foundation``.

.. sourcecode:: bash

    import Foundation 

    let s = "Tom,Sean,Joan"
    let names = s.componentsSeparatedByString(",")
    println(names)

.. sourcecode:: bash

    > xcrun swift test.swift 
    [Tom, Sean, Joan]
    >

Not only is the ``NSString`` method called, but the type that is returned is a Swift ``[String]`` (also known as ``Array<String>``) rather than an Objective C NSArray with NSString objects.

Another useful thing is that one can go back and forth between String and NSString pretty easily:

.. sourcecode:: bash

    import Foundation 

    let s: NSString = "supercalifragilistic"
    let r = NSRange(location:0,length:5)
    println(s.substringWithRange(r))

.. sourcecode:: bash

    > xcrun swift test.swift 
    super
    >

.. sourcecode:: bash

    let s: NSString = "supercalifragilistic"
    println(s.rangeOfString("cali"))

.. sourcecode:: bash

    > xcrun swift test.swift 
    (5,4)
    >
    
The location is 5 and the length is 4.

Basic methods:

    - init(count sz: Int, repeatedValue c: Character)
    - ``isEmpty: Bool { get }``
    - ``hasPrefix(s) -> Bool``
    - ``hasSuffix(s) -> Bool``
    - ``toInt -> Int?``
    - ``isEqual(s) -> Bool``
    
To check identity, use the operator ``===``.  (And we'll have more to say about the ``Int?`` type, see :ref:`optionals`)

Operators 
    - ``+``
    - ``+=``
    - ``==``
    - ``<``

-----------------
Splitting strings
-----------------

If you need to split on a single character (like a space) use ``componentsSeparatedByString(" ")``.  But if you need to split on whitespace, see :ref:`stdin`
