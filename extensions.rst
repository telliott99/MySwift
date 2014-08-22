.. _extensions:

##########
Extensions
##########
    
In this section I want to develop some extensions on the String type.  Currently, the syntax 

.. sourcecode:: bash

    var s = "Hello, world"
    println(s[0...4])

doesn't work.  We can fix that with the following code:

.. sourcecode:: bash

    extension String {
        subscript (r: Range<Int>) -> String {
            get {
                var begin = advance(self.startIndex, r.startIndex)
                var end = advance(begin, r.endIndex)
                return self[Range(start: begin, end: end)]
            }
        }
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    Hello
    >

What is going on here is that we are not supposed to just index into a String.  Instead, to deal gracefully with all the complexity of Unicode, we are supposed to let the compiler generate a valid range for us.

Since ``r`` is a ``Range<Int>``, ``r.startIndex`` is just the first Int in the range.  However, the string indices are not Int values.  Hence, we ask for the ``s.startIndex`` and then advance it to where we want to be.  Then advance that to where we want to stop.

Another extension which I've developed in the past (as a category on NSString) is ``lstrip`` and ``rstrip``.  Here is an extension that adds this capability to Swift.  Curiously, the index notation, which would've been helpful, is not available from within the extension definition, or even a second one coming right after.  So:

.. sourcecode:: bash

    extension String {
        func lstrip() -> String {
            var s = self
            while s.hasPrefix(" ") { 
                s = s.substringFromIndex(
                    advance(s.startIndex,1)) 
            }
            return s
        }
        
        func reversed() -> String {
            var c: Character
            var s = ""
            for c in reverse(self) {
                s += c
            }
            return s
        }
    
        func rstrip() -> String {
            return self.reversed().lstrip().reversed()
        }

        func strip() -> String {
            return self.lstrip().rstrip()
        }
    }

    var s = "Hello, world"
    println("*" + "  Tom  ".lstrip() + "*")
    println("*" + "  Tom  ".rstrip() + "*")
    println("*" + "  Tom  ".strip() + "*")

.. sourcecode:: bash

    > xcrun swift test.swift
    Hello
    *Tom  *
    *  Tom*
    *Tom*
    >

This last example doesn't work yet.

.. sourcecode:: bash

    func lstrip(s: String) -> String {
        var i = s.startIndex
        var j = s.endIndex
        var r = Range<String.Index>(start: s.startIndex, end: s.endIndex)
        while s.substringWithRange(r).startsWith(" ") {
            advance(i,1)
        }
        return s.substringWithRange(i)
    }

    println(lstrip("*  Tom*"))
