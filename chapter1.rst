.. _chapter1:

############
Basic syntax
############


.. _compiling_swift:

***************
Compiling Swift
***************

In order to compile Swift programs, you need Xcode.  I got Xcode6-Beta5.app (and now -Beta6).  I set it as the default (since I also have Xcode5):

.. sourcecode:: bash

    sudo xcode-select -s /Applications/Xcode6-Beta5.app/Contents/Developer
    
Then, the following method will work.  

With this file on the Desktop

``Hello.swift``:

.. sourcecode:: bash

    println("Hello Swift world")

.. sourcecode:: bash

    > xcrun swift Hello.swift
    Hello Swift world
    >

Some other options are to run swift as an "interpreter" by just doing ``xcrun swift`` and then try out some code, or to place this as the first line in your code ``#! /usr/bin/xcrun swift``.  Make the file executable before running it:

.. sourcecode:: bash

    > chmod u+x Hello.swift
    > ./Hello.swift 
    Hello Swift world
    >

Another possibility is to use a "playground" in Xcode.  And finally, one can compile and then run a file of swift code:

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift
    > ./test

or both steps at once

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift && ./test
    
I have observed a few constructs that work correctly by this last method and not by my standard one.

As shown above, a basic print statement is ``println("a string")`` or ``print("a string")``.  Notice the absence of semicolons.

One can also do variable substitution, like this

``Hello.swift``:

.. sourcecode:: bash

    var n = "Tom"
    println("Hello \(n)")

.. sourcecode:: bash

    > xcrun swift Hello.swift 
    Hello Tom
    >

Variables are *typed* (with the type coming after the variable name) and there is no implicit conversion between types (except when doing ``print(anInt)`` or ``print(anArray)``).  

We're going to switch filenames now to

``test.swift``:

.. sourcecode:: bash

    var x: Int = 2
    println(x)
    var s: String = String(x)
    println(s)
    
This works, and prints what you'd expect.  If a value is not going to change (a constant), use ``let``:

.. sourcecode:: bash

    let s = "Hello"
    println("\(s)")

which also works, and prints what you'd expect.  

The reason it works (without the ``:String`` type declaration is that the compiler can almost always infer type information from the context.

The usual Swift style would be:

.. sourcecode:: bash

    var x = 2
    var f = 1.23e4
    println(f)
    // prints:  12300

.. _strings:

*******
Strings
*******

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

.. _characters:

**********
Characters
**********

A character is a type in Swift and may be output as ``'a'`` for example, with single quotes, representing the single character a.  But as a programmer, you will not initialize a character with a literal character.  Instead do this:

.. sourcecode:: bash

    let c: Character = "a"
    
which converts the string ``"a"`` to the corresponding character.  Or, when iterating through a string, we get characters with the for-in construct:

.. sourcecode:: bash

    for c in "abc":  println(c)
    
To put a character back into a String, you can do this:

.. sourcecode:: bash

    var s = ""
    let c: Character = "a"
    s.append(c)
    println(s)  // a
    
As of recently, the ``+=`` operator is only for "concatenate", so this doesn't work any more:

.. sourcecode:: bash

    let c: Character = "a"
    s += c
    
     String and Character have been revised to follow the changes to Array, which clarifies that the + operator is only for "concatenation", not "append”. Therefore String + Character, Character + String, and String += Character, as well as the analogous Array + Element combinations, have been removed.
     
A concatenation example:

.. sourcecode:: bash

    let c1: Character = "a"
    let c2: Character = "b"
    let a = [c1,c2]
    println(a)

    let s = "" + a
    println(s)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [a, b]
    ab
    >
    
Again, the type of ``c`` is Character.


Unicode
-------

Swift is very modern when it comes to Unicode, even more so than NSString.

In Unicode (virtually) every character that can be written is represented as a "code point", which is essentially just aa mapping between numbers and glyphs.  Originally it was thought that 2e16, or two bytes (more than one million), was enough to represent them all.  

Now some values are as much as three bytes.

A unicode code point comes in both decimal and binary equivalents, though binary is more usual.  From the docs:

    A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive. Unicode scalars do not include the Unicode surrogate pair code points in the range U+D800 to U+DFFF inclusive.

The question then becomes, how to represent Unicode characters in memory and on disk.  The apparent two byte limit argued for a two byte representation, but there are two different orders for the pair of single bytes, leading to big- and little-endian UTF-16 encoding.

It may be that since we managed pretty well with characters represented in a single byte (or even just 7 bits with ASCII)

http://en.wikipedia.org/wiki/ASCII

it was natural to develop the UTF-8 encoding.  UTF-8 is a variable length encoding, often taking only a single byte (when sufficient), but extending to two or three (or four) bytes when necessary.  It is much more compact, yet flexible.

http://en.wikipedia.org/wiki/UTF-8

So really the first issue that comes up with Unicode, after realizing that the representation is critical, is how to count length correctly as characters rather than as bytes when we have variable length, multibyte characters.

The second issue is that the same character may be formed in different ways (admittedly, this is fairly rare), and we would like those two representations to compare as equal.

Let's look at length first.  

Here is an example of a String literal (``blackHeart``) formed from a Unicode scalar

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    println("I " + blackHeart " you")
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    I ♥ you
    >

To keep things simple, I will copy this character and paste it into the Python interpreter:

.. sourcecode:: bash

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'

The default encoding here when we do the paste is UTF-8.  The hex value ``e2 99 a5`` is the UTF-8 encoded value of the code point known as "BLACK HEART SUIT" (hex 2665, decimal 9829).  

.. sourcecode:: bash

    >>> h = '0x2665'
    >>> int(h,16)
    9829
    >>>

To specify it in a Swift String, one way is to recall (or look up) its Unicode scalar value, which is typically written ``U+2665``.  Python again:

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'
    >>> unicode(s,'utf-8')
    u'\u2665'
    >>> s.decode('utf-8')
    u'\u2665'
    >>>

In order to interpret these three bytes, one must know the encoding (for say, two bytes, the result will be much different for UTF-16 versus UTF-8).

One could also write the data to disk and use ``hexdump``

.. sourcecode:: bash

    >>> s = "♥"
    >>> FH = open('x.txt','w')
    >>> FH.write(s)
    >>> FH.close()
    >>> 
    [2]+  Stopped                 python
    > hexdump -C x.txt
    00000000  e2 99 a5                                              
    |...|
    00000003
    >

As mentioned above, the official name for this character is:  "Unicode Character 'BLACK HEART SUIT' (U+2665)".  In html you can write it either as ``&#9829`` or ``&#x2665``.

Similarly, the "White smiling face"  ☺ is ``9786`` in Unicode, which in hexadecimal is ``U+263A``.

In Python, if I have the character as Unicode I convert it to UTF-8 before writing to disk:

.. sourcecode:: bash

    >>> u = unichr(9786)
    >>> u
    u'\u263a'
    >>> ord(u)
    9786
    >>> print u
    ☺
    >>> s = u.encode('utf-8')
    >>> s
    '\xe2\x98\xba'
    >>> FH = open('x.txt','w')
    >>> FH.write(s + "\n")
    >>> FH.close()
    >>> 
    [1]+  Stopped                 python
    > cat x.txt
    ☺
    >

In Swift, this is done as follows with ``.utf8``:

.. sourcecode:: bash

    let smiley = "\u{263a}"
    for codeUnit in smiley.utf8 {
        print("\(codeUnit) ")
    }
    print("\n")

.. sourcecode:: bash

    > xcrun swift test.swift 
    226 152 186 
    >
    
``226`` is the decimal value equal to ``e2``, and so on.  Python again:

.. sourcecode:: bash

    >>> hex(226)
    '0xe2'
    >>> hex(152)
    '0x98'
    >>> hex(186)
    '0xba'
    >>>
    

Counting characters
-------------------

And now, the big question is, how many characters are there in ``blackHeart``?  

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    print(blackHeart + " ")
    println(countElements(blackHeart))
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    ♥ 1
    >

Three bytes in memory and on disk, but one character according to ``countElements``.

Expand the example:

.. sourcecode:: bash

    import Foundation

    let blackHeart = "\u{2665}"
    print(blackHeart + " ")
    println(countElements(blackHeart))

    var str = NSString.stringWithString(blackHeart)
    println(str.length)
    println(str.characterAtIndex(0))
    
NSString says:

.. sourcecode:: bash

    > xcrun swift test.swift 
    ♥ 1
    1
    9829
    >

Seems like NSString counts correctly too, in this case, though when it yields the character it gives us back the decimal value of the Unicode code point.

Here is another example, from the docs, where the same character can be formed in two different ways:

.. sourcecode:: bash

    // é
    let eAcute: Character = "\u{E9}"
    // e followed by ́
    let combinedEAcute: Character = "\u{65}\u{301}"

    let s1 = "" + eAcute
    let s2 = "" + combinedEAcute
    println(countElements(s1))
    println(countElements(s2))
    println(eAcute == combinedEAcute)

.. sourcecode:: bash

    > xcrun swift test.swift 
    1
    1
    true
    >

Now try the same thing with NSString:

.. sourcecode:: bash

    let s3 = NSString.stringWithString(s1)
    let s4 = NSString.stringWithString(s2)
    println("\(s3.length)")
    println("\(s4.length)")
    println(s3.isEqualTo(s4))

.. sourcecode:: bash

    > xcrun swift test.swift 
    1
    1
    true
    1
    2
    false
    >

So, the problem (solved by Swift and not by NSString) is how to deal with "extended grapheme clusters".  Such a cluster is a single character composed of multiple graphemes, such as ``"\u{65}\u{301}"``.

.. _range:

******************
Range and Interval
******************

Swift has the notions of intervals, ranges, and strides.

It also has both a closed or half-open intervals and ranges.  A closed interval includes both endpoints, and a half-open one extends up to but does not include the top value.

An interval "contains" the values between two endpoints, but it does not know anything about iterating through the values or incrementing them.  An interval can even extend between one (or two) *non-integer* values, and a value of interest can then be tested for inclusion in the interval.

From StackOverflow

http://stackoverflow.com/questions/25308978/what-are-intervals-in-swift-ranges

    A Range type is optimized for generating values that increment through the range, and works with types that can be counted and incremented.

    An Interval type is optimized for testing whether a given value lies within the interval. It works with types that don't necessarily need a notion of incrementing, and provides [other] operations

    Because the ``..<`` and ``...`` operators have two forms each--one that returns a Range and one that returns an Interval--type inference automatically uses the right one based on context.

Here the type information isn't required, but I want to tell the compiler what we expect:

.. sourcecode:: bash

    let i1: ClosedInterval = 1...5
    i1.contains(3)
    i1.contains(3.14159265)
    // both are true

A new operator ``~=`` can be used to test for this:

.. sourcecode:: bash

    i1 ~= 6
    // false

The operators for ranges and intervals are the same.

.. sourcecode:: bash

    let r1: Range = 1...5
    let r2: Range = 1..<6
    if r1 == r2 { }
    // true

(The previously used half-open notation ``..`` has been replaced by ``..<``, which is definitely clearer).

To reverse a range, use ``reverse``

.. sourcecode:: bash

    for i in reverse(1...3) { print(String(i) + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    3 2 1
    >

There is also ``stride``, sort of like ``range`` in Python with the optional third argument.  In Swift:

.. sourcecode:: bash

    for i in stride(from: 0, through: -4, by: -2) {
      print(i)
    }
    println

.. sourcecode:: bash

     > xcrun swift test.swift
    0 -2 -4
    >

.. sourcecode:: bash

    for i in lazy(0...5).reverse() {
        print(String(i) + " ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    5 4 3 2 1 0 
    >

(Sequences can be generated lazily).

And finally:

.. sourcecode:: bash

    let x = 6
    switch (x) {
        case (5...10):
            println("OK")
        default:
            println("not in interval")
    }
    // OK

.. sourcecode:: bash

    let x = 6
    let y = 5

    switch (x,y) {
        case (5...10, 3...6):
            println("OK")
        default:
            println("not in interval")
    }
    // also OK

.. _loops:

*****
Loops
*****

We are going to use some arrays below, even though they haven't been introduced yet.  I hope what we're doing is fairly obvious, if not, see :ref:`arrays`.

.. sourcecode:: bash

    var intList = [2,4,6]
    for x in intList { print(String(x) + " ")}
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    2 4 6 
    >

Here we need the explicit conversion to String, because the first thing that is evaluated inside ``print()`` is the addition of ``x`` to the String ``" "``.

We can get a range of values (including 3)

.. sourcecode:: bash

    var i:Int
    for i in 1...3 { print(String(i) + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    1 2 3 
    >

.. sourcecode:: bash

    import Foundation

    let s = "Tom,Sean,Joan"
    let names = s.componentsSeparatedByString(",")
    println(names[0..<2])

.. sourcecode:: bash

    > xcrun swift x.swift
    [Tom, Sean]
    >

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

And a traditional loop

.. sourcecode:: bash

    var count = 0
    for i = 0; i < 3; ++i {
        count += 1
    }
    println(count)

.. sourcecode:: bash

    > xcrun swift test.swift
    3
    >

If you want to access the value of ``i`` after the loop terminates, you must declare it outside the loop as ``var i: Int``.

.. sourcecode:: bash

    var i: Int
    for i = 0; i < 3; ++i {
        ..
    }
    println(i)
    // i == 3  !!!

An odd way to do something ``n`` times.  Notice the``_`` variable (a way of saying we will ignore this value, and it's not available inside the loop)

.. sourcecode:: bash

    let base = 2
    let power = 10
    var result = 1
    for _ in 1...power {
        result *= base
    }
    // result == 1024
    
This is legal!

.. sourcecode:: bash

    var i: Int
    ifeellikeit = true
    for i = 0; i < 10; i++ {
        print("\(i)) "
        if ifeellikeit {
            i += 7
        }
        println
    }
    \\ prints 0 9 10

.. _optionals:

*********
Optionals
*********

It's useful to allow an operation that may or may not succeed, and if it doesn't work, just deal with it.  Swift is strongly typed, but to deal with this situation it has values called "Optionals" that may either be ``nil`` or may have a value including a basic type like Int or String.  Consider the following:

.. sourcecode:: bash

    var s: String = "123"
    let m: Int? = s.toInt()
    s += "x"
    let n: Int? = s.toInt()
    println(m)
    println(n)

The second conversion ``s.toInt()`` will fail because the value ``"123x"`` can't be converted to an integer.  Nevertheless, the code compiles and when run it prints

.. sourcecode:: bash

    > xcrun swift test.swift 
    Optional(123)
    nil
    >

The values ``m`` and ``n`` are "Optionals".  Test for ``nil`` by doing either of the following:

.. sourcecode:: bash

    let m: Int? = "123x".toInt()
    let n = "123".toInt()
    // "forced unwrapping"
    if m != nil { println("m = toInt() worked: \(m!)") }
    if n != nil { println("n = toInt() worked: \(n!)") }
    if let o = "123".toInt() {  println("really") }
    
.. sourcecode:: bash

    > xcrun swift test.swift
    n = toInt() worked: 123
    really
    >
    
Use of the ! symbol in ``n!`` forces the value of ``n`` as an Int to be used, which is fine, once we know for sure that it is not ``nil``.

.. sourcecode:: bash
    
    import Foundation
    func getOptional() -> Int? {
        let r = Int(arc4random_uniform(10))
        if r < 5 {
            return nil
        }
        return r*10
    }

    var n: Int?
    for i in 1...10 {
        n = getOptional()
        if (n != nil) { 
            println("\(i): \(n!)")
        }
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    1: 80
    2: 60
    7: 50
    8: 70
    10: 70
    >

Another idiom in Swift is "optional binding"

.. sourcecode:: bash

    if let n = dodgyNumber.toInt() {
        println("\(dodgyNumber) has an integer value of \(n)")
           } 
    else {
        println("\(dodgyNumber) could not be converted to an integer")
    }

Normally one has to use a Boolean value in an ``if`` construct, but here we're allowed to use an optional.  If it evaluates to ``nil`` we do the ``else``, otherwise ``n`` has an Int value and we can use it.
