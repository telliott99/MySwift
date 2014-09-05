.. _swift_file:

#################
File Ops in Swift
#################

Here is a demo of an NSOpenPanel in Swift.  What's amazing is that it works from the command line!

In the first part, we construct an open panel and set its various properties.

.. sourcecode:: bash

    import Cocoa
    var op = NSOpenPanel()
    op.prompt = "Open"
    op.title = "A title"
    op.message = "A message"

    // op.canChooseFiles = true
    // op.worksWhenModal = true
    op.allowsMultipleSelection = false
    // op.canChooseDirectories = false
    op.resolvesAliases = true

    let home = NSHomeDirectory()
    let d = home.stringByAppendingString("/Desktop/")
    op.directoryURL = NSURL(string: d)
    op.allowedFileTypes = ["txt"]

    var readError: NSError?
    op.runModal()
    var s = NSString(
        contentsOfURL:op.URL,
        encoding:NSUTF8StringEncoding, 
        error: &readError)
    
    if readError != nil {
        let e = readError!
        let msg = e.localizedDescription
        println("read failure: \(msg!)")
    }
    else {          
        println(s)
    }

Here is the open file dialog:

.. image:: /figures/fileread.png
   :scale: 75 %
   
And here is the data read from the file:

.. sourcecode:: bash

    > xcrun swift test.swift 
    abc
    >
