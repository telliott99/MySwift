.. _files:

###############
File Operations
###############

.. sourcecode:: bash

    import Foundation

    var path = "y.txt"    // full path not needed
    var error: NSError?
    var text:String? = String.stringWithContentsOfFile(
        path, encoding:NSUTF8StringEncoding, error: &error)
    if error != nil { println(error) }
    else {
        var a = text!.componentsSeparatedByString(" ")
        println(a)
        var b = text!.componentsSeparatedByCharactersInSet(
            NSCharacterSet (charactersInString: " \n"))
        println(b)
    }

.. sourcecode:: bash

    > xcrun swift test.swift xcrun swift test.swift
    [1, 2, 3
    4
    ]
    [1, 2, 3, 4, ]
    > xcrun swift test.swift
    Optional(Error Domain=NSCocoaErrorDomain \
    Code=260 "The file “y.txt” couldn’t be opened because there is no such file."\
    UserInfo=0x7feb33fdfb80 \
    {NSFilePath=y.txt, \
    NSUnderlyingError=0x7feb33fcb0e0 
    "The operation couldn’t be completed. No such file or directory"})
    >