.. _files:

###############
File Operations
###############

Reading

.. sourcecode:: bash

    import Foundation
    let fn = Process.arguments[1]
    var error: NSError?
    var text:String? = String.stringWithContentsOfFile(
        fn, 
        encoding:NSUTF8StringEncoding, 
        error: &error)
    if error != nil { 
        println(error) 
    }
    else {
        var a = text!.componentsSeparatedByString(" ")
        println(a)
        var b = text!.componentsSeparatedByCharactersInSet(
            NSCharacterSet (charactersInString: " \n"))
        println(b)
    }

.. sourcecode:: bash

    > xcrun swift test.swift x.txt
    [abc
    def]
    [abc, def]

.. sourcecode:: bash

    > xcrun swift test.swift y.txt
    Optional(Error Domain=NSCocoaErrorDomain \
    Code=260 "The file “y.txt” couldn’t be opened because \
    there is no such file." \
    UserInfo=0x7f95907576b0 {NSFilePath=y.txt, \
    NSUnderlyingError=0x7f959079d090 \
    "The operation couldn’t be completed. \
    No such file or directory"})
    >

and writing:

``test.swift``

.. sourcecode:: bash

    import Foundation

    let s = "my data\n"
    let path = "x.txt"
    var error: NSError?
    s.writeToFile(path, 
        atomically:true, 
        encoding:NSUTF8StringEncoding, 
        error: &error)
    if error != nil { 
        println(error) 
    }

.. sourcecode:: bash

    > cat x.txt
    my data
    >

