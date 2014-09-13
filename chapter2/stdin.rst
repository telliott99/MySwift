.. _stdin:

#####
StdIn
#####

Here is an example of reading data from a file input on the command line in swift.  We first compile the swift code, and then execute it.  The listing for 

``test.swift``

.. sourcecode:: bash

    import Foundation

    func readIntsFromStdIn() -> [Int]? {
        let stdin = NSFileHandle.fileHandleWithStandardInput()
        let data: NSData = stdin.availableData
        let s: String = NSString.init(data: data, 
            encoding:NSUTF8StringEncoding)
        let cs = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let sa: [String] = s.componentsSeparatedByCharactersInSet(cs)
        var a: [Int] = Array<Int>()
        for c in sa {
            if let n = c.toInt() {
                a.append(n)
            }
        }
        if a.count == 0 { return nil }
        return a
    }

    let arr = readIntsFromStdIn()
    if arr != nil {
        println("\(arr!)")
    }
    
Since we might not read any ``Int`` data, I made the return type an Optional.

The data we will read looks like this:

``x.txt``

.. sourcecode:: bash

    43 39 65
    22	102

When examined with ``hexdump`` we see that in addition to the newline (``\x0a``) and spaces (``\x20``), the data also has one tab (``\x09``):

.. sourcecode:: bash

    > hexdump -C x.txt
    00000000  34 33 20 33 39 20 36 35  0a 32 32 09 31 30 32     |43 39 65.22.102|
    0000000f
    >

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift
    > ./test < x.txt
    [43, 39, 65, 22, 102]
    >

Looks like it's working fine.