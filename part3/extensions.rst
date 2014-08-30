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
        subscript(i: Int) -> Character {
            let index = advance(startIndex, i)
            return self[index]
        }
        subscript(r: Range<Int>) -> String {
            let start = advance(startIndex, r.startIndex)
            let end = advance(startIndex, r.endIndex)
            return self[start..<end]
        }
    }

.. sourcecode:: bash

    var s = "Hello, world"
    println(s[4])
    println(s[0...4])
    

What is going on here is that the language does not provide the facility to just index into a String.  Instead, being prepared to deal gracefully with all the complexity of Unicode means that we are supposed to let the compiler generate a valid range for us.

Since ``r`` is a ``Range<Int>``, ``r.startIndex`` is just the first Int in the range.  However, the string indices are not Int values.  Hence, we ask for the ``self.startIndex`` and then advance it to where we want to be.  And after that we advance it to where we want to stop.

Let's use the extension to develop a global function ``lstrip``

.. sourcecode:: bash

    extension String {
        subscript(i: Int) -> Character {
            let index = advance(startIndex, i)
            return self[index]
        }
        subscript(r: Range<Int>) -> String {
            let start = advance(startIndex, r.startIndex)
            let end = advance(startIndex, r.endIndex)
            return self[start..<end]
        }

    }

    func lstrip(str: String) -> String {
        let space: Character = " "
        var i = 0
        for c in str {
            if c == space { 
                i += 1
            }
            else { break }
        }
        var j = 0
        for c in str { j += 1 }
        return str[i..<j]
    }

    func reversed(str: String) -> String {
        var c: Character
        var s = ""
        for c in reverse(str) {
            s += c
        }
        return s
    }

    func rstrip(str: String) -> String {
        var s = reversed(str)
        s = lstrip(s)
        return reversed(s)
    }

    func strip(str: String) -> String {
        return rstrip(lstrip(str))
    }

    var s = "  abc   "
    println("*\(lstrip(s))*")
    println("*\(rstrip(s))*")
    println("*\(strip(s))*")

.. sourcecode:: bash

    > xcrun swift test.swift 
    *abc   *
    *  abc*
    *abc*
    >
