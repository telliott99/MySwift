.. _characters:

##########
Characters
##########

A character is a type in Swift and may be represented as ``'a'`` for example, with single quotes, representing the single character a.  But you don't initialize a character with a literal character.  Instead do this:

.. sourcecode:: bash

    let c: Character = "a"
    
which converts the string ``"a"`` to the corresponding character.  Or, when iterating through a string, we get characters:

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
    let s = "" + a
    println(a)
    println(s)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [a, b]
    ab
    >
    
Again, the type of ``c`` is Character.

-------
Unicode
-------

Swift is very modern when it comes to Unicode, even more so than NSString.

In Unicode every character that can be written is represented as a "code point", a number.  Originally it was thought that 2e16, or two bytes (more than one million), was enough to represent them all.  

Now some are three bytes.  A unicode code point comes in both decimal and binary equivalents, though binary is probably more usual.  From the docs:

    A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive. Unicode scalars do not include the Unicode surrogate pair code points in the range U+D800 to U+DFFF inclusive.

The question then becomes, how to represent Unicode characters in memory and on in disk.  The apparent two byte limit argued for a two byte representation, but there are two different orders for the single bytes, leading to big- and little-endian UTF-16 encoding.

It may be because we managed pretty well with characters represented in a single byte (or even just 7 bits with ASCII), that the UTF-8 encoding was developed.  UTF-8 is a variable length encoding, usually taking only a single byte, but extending to two or three (or four) bytes when necessary.  It is much more compact, yet flexible.

So really the first issue that comes up with Unicode, after realizing that the representation is critical, is how to count length correctly as characters rather than as bytes when we have variable length, multibyte characters.

The second issue is that the same character may be formed in different ways (admittedly, this is fairly rare), and we would like those two representations to compare as equal.

Let's look at length first.  

Here is an example of a String literal formed from a Unicode scalar

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    println(blackHeart)
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    ♥
    >

To keep things simple, I will copy this character and paste it into the Python interpreter:

.. sourcecode:: bash

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'

The default encoding here when we do the paste is UTF-8.  The hex value ``e2 99 a5`` is the UTF-8 encoded value of the code point known as "BLACK HEART SUIT".  To specify it in a Swift String, one way is to recall (or look up) its Unicode scalar value, which is typically written ``U+2665``.  Python again:

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'
    >>> unicode(s,'utf-8')
    u'\u2665'
    >>> s.decode('utf-8')
    u'\u2665'
    >>>

In order to interpret these three bytes, one must know the encoding.

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

The decimal equivalent is 9829.

.. sourcecode:: bash

    >>> h = '0x2665'
    >>> int(h,16)
    9829
    >>>

The official name for this character is:  "Unicode Character 'BLACK HEART SUIT' (U+2665)".  In html you can write it either as ``&#9829`` or ``&#x2665``.

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
    
-------------------
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

