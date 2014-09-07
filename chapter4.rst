.. _chapter4:

###############
Swift and Xcode
###############

.. _files:

***************
File Operations
***************

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

*******
Dialogs
*******
-----------
NSOpenPanel
-----------

.. sourcecode:: bash

    import Cocoa

    var op = NSOpenPanel()
    op.prompt = "Open File:"
    op.title = "A title"
    op.message = "A message"
    // op.canChooseFiles = true  // default
    // op.worksWhenModal = true  // default
    op.allowsMultipleSelection = false
    // op.canChooseDirectories = true  // default
    op.resolvesAliases = true
    op.allowedFileTypes = ["txt"]

    let home = NSHomeDirectory()
    let d = home.stringByAppendingString("/Desktop/")
    op.directoryURL = NSURL(string: d)

    var readError: NSError?
    op.runModal()
    // op.orderOut()

    // op.URL contains the user's choice
    let s = NSString(
        contentsOfURL:op.URL,
        encoding:NSUTF8StringEncoding,
        error: &readError)

    if readError != nil {
        let e = readError!
        let msg = e.localizedDescription
        println("read failure: \(msg)")
        // return nil
    }
    else {
        let str = s as String
        println("str = \(str)*")
    }
    
    // NSFileHandlingPanelOKButton
    // [savePanel orderOut:nil]

.. sourcecode:: bash

    > echo "abc" > x.txt
    > xcrun swift test.swift
    str = abc
    *
    >
    
.. image:: /figures/open_panel.png
   :scale: 100 %

***********************
Translating Objective-C
***********************

Here is an example of translating Objective C code to Swift.  (There are more in :ref:`files`).

The exercise is from Hillegass, Objective C.  We load all the propernames from a file (without error checking), and do a case-insensitive search for ``"AA"``.

``test.m``

.. sourcecode:: bash

    #import <Foundation/Foundation.h>

    int main (int argc, const char * argv[]){
        @autoreleasepool {
            NSString *p = @"/usr/share/dict/propernames";
            NSString *s = [NSString stringWithContentsOfFile:p
                    encoding:NSUTF8StringEncoding
                    error:NULL];
            NSString *nl = @"\n";
            NSLog(@"%lu", s.length );
            NSArray *names = [s componentsSeparatedByString:nl];
            for (NSString *n in names) {
                NSRange r = [n rangeOfString:@"AA"
                    options:NSCaseInsensitiveSearch];
                if (r.location != NSNotFound){
                    NSLog(@"%@", n);
                }
            }
        }
    }

.. sourcecode:: bash

    > clang test.m -o prog -framework Foundation
    > ./prog
    2014-09-01 08:20:15.692 prog[857:507] 8546
    2014-09-01 08:20:15.696 prog[857:507] Aaron
    2014-09-01 08:20:15.696 prog[857:507] Isaac
    2014-09-01 08:20:15.697 prog[857:507] Lievaart
    2014-09-01 08:20:15.697 prog[857:507] Maarten
    2014-09-01 08:20:15.697 prog[857:507] Raanan
    2014-09-01 08:20:15.698 prog[857:507] Saad
    2014-09-01 08:20:15.698 prog[857:507] Sjaak
    > 

Here is my Swift translation.  We see the way to handle ``NSError`` again here.  We use NSString interchangeably with String, but ``componentsSeparatedByString`` returns an ``[AnyObject]``, so we cast it as we want it.

Normally we would pass ``NSCaseInsensitiveSearch`` as an option (as in the Objective C version above).  But I am getting "unresolved identifier" as the error.  So instead, each string is converted to its ``uppercaseString``.

.. sourcecode:: bash

    import Foundation

    let p = "/usr/share/dict/propernames"
    var e: NSError?
    var s = NSString.stringWithContentsOfFile(p,
                encoding:NSUTF8StringEncoding,
                error:&e)
    let nl = "\n"
    println(s.length)

    let names = s.componentsSeparatedByString(nl) as [String]
    for n in names {
        let s1 = n.uppercaseString
        if let r = s1.rangeOfString("AA",options: nil) {
            println(n)
        }
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    8546
    Aaron
    Isaac
    Lievaart
    Maarten
    Raanan
    Saad
    Sjaak
    >

*****************
Importing Modules
*****************

This section is about building and importing modules in Swift.  It's easy to do in Xcode.  Make a new project for a command line tool (or a Cocoa application, whatever).  

Do File > New > File and add a new Swift file in the project.  (Alternatively, drag an existing file into the project's FileView).

That file should have some code, like this:

.. sourcecode:: bash

    class C { var x = 5 }

``main.swift`` as generated by Xcode has ``println("Hello, World!")``, now add this:

.. sourcecode:: bash

    let c = C()
    println("c: " + String(c.x))
    
Build and run, and the console shows:

.. sourcecode:: bash

    Hello, World!
    c: 5
    Program ended with exit code: 0

No import statement is needed!
 
Really, you're supposed to use Xcode, but from the command line it isn't hard to compile and then import an Objective C module.

http://stackoverflow.com/questions/24131476/compiling-and-linking-swift-plus-objective-c-code-from-the-os-x-command-line

``C.h``

.. sourcecode:: bash

    #import <Cocoa/Cocoa.h>
    @interface C : NSObject
    @property (retain) NSString *c;
    @end

``C.m``

.. sourcecode:: bash

    import "C.h"

    @implementation C
    - (id)init {
      self = [super init];
      self.c = @"Hello world!";
      return self;
    }
    @end

.. sourcecode:: bash

    > xcrun clang C.m -o C.o -c
    >

clang (with the ``-c`` flag) gives us ``C.o``.  Now we write our Swift code:

``S.swift``

.. sourcecode:: bash

    let c = C()
    println(c.c)

To compile ``S.swift``, we need to do this:

.. sourcecode:: bash

    >xcrun swiftc -c S.swift -import-objc-header C.h\
     -F /System/Library/Frameworks -I/usr/include
 
The Framework is for ``Cocoa.h``.  I think the ``-I`` is for something that can generate the "bridging header" from ``C.h``.  What is emitted by the compiler is ``S.o``.  Now we just need to link and run:

.. sourcecode:: bash

    > xcrun swiftc -o app C.o S.o
    > ./app
    Hello world!
    >

So now the question becomes, is it possible to do this for a swift module?  So far I haven't found a way.  

And the second question is, using Xcode and making a Swift framework, can we do things that way?  So far, I haven't found a way to do that, either.

**********************
Swift from Objective C
**********************

When I saw the syntax of the Swift Programming Language, I immediately liked it.  More like Python, and not at all like Objective C.  However, looks can be deceptive, Objective C is fairly simple, while Swift is surprisingly complex.

http://www.bignerdranch.com/blog/ios-developers-need-to-know-objective-c/

I wanted to implement an example of a class written in Swift, but called from an Objective C class.  This required a few key points that I didn't quite get from the Apple docs, so here they are.

Create a new Xcode project, a Cocoa Application

.. image:: /figures/swift1.png
   :scale: 75 %

and call it "MyProject".

.. image:: /figures/swift2.png
   :scale: 75 %

Accept the defaults (Cocoa Application, files in the Document directory).

Under File > New > File, add a new Swift File

.. image:: /figures/swift3.png
   :scale: 75 %

and name it "MyFile.swift".  

.. image:: /figures/swift4.png
   :scale: 75 %

When asked if you want to create headers, say yes.

.. image:: /figures/swift5.png
   :scale: 75 %

Check by building and running, yep, it still works.  Now, add some code to 

``MyFile.swift``:

.. sourcecode:: bash

    import Foundation

    @objc class MySwiftClass : NSObject {
        func myFunc() -> String {
            return "hello"
        }
    
    }

    func test() {
        var obj = MySwiftClass()
        println(obj.myFunc())
    }

    test()

You can test a version of it from the command line (with the code saved in ``test.swift``) by

.. sourcecode:: bash

    > xcrun swift test.swift
    hello
    >

Before going any further, comment out the last line:  ``// test()``.

Notice two crucial features, we have "decorated" (if that's the right word in Swift) our class ``MySwiftClass`` with ``@objc``.  And this class inherits from ``NSObject`` (hence the ``import Foundation``).

Now switch the editor to ``AppDelegate.h``.  

Just after the line ``#import <Cocoa/Cocoa.h>`` put this:

.. sourcecode:: bash

    #import "MyProject-Swift.h"

    @class MySwiftClass;

and then after that should come what was already there, ``@interface`` and the rest of it.

Finally, add this to ``applicationDidFinishLaunching``:

.. sourcecode:: bash

    NSLog(@"Got here!");
    MySwiftClass* obj = [[MySwiftClass alloc] init];
    NSString* s = [obj myFunc];
    NSLog(@"%@", s);

If you have any issues, try "clean".  For me, the console prints:

.. sourcecode:: bash

    014-08-18 19:31:45.903 MyProject[2698:303] Got here!
    2014-08-18 19:31:45.903 MyProject[2698:303] hello

This only took me 4 or 5 hours to figure to get working.  I'm not sure yet that I have it really figured out.  One of the problems is that I couldn't find a model as simple as this on the web or in the Apple docs.

The other is something you just have to get used to with a compiler that is sophisticated as what is in Xcode.  The error messages are often downright misleading.  I didn't save them but I was told repeatedly that ``[[MySwiftClass alloc] init];`` was just *wrong*, and yet look, there it is in the final product.

The key sticking points were

    - the decorator @objc
    - inheriting from NSObject (to get alloc and init)
    - ``@class MySwiftClass;`` in the Objective C header
    
Only this part (``#import "MyProject-Swift.h"``) was clear from quick reading of the docs.

**************************
Cocoa Application in Swift
**************************

Fire up Xcode and just choose to make a Swift-based application.

Xcode will generate the files for you.

.. sourcecode:: bash

    import Cocoa

    class AppDelegate: NSObject, NSApplicationDelegate {
                            
        @IBOutlet weak var window: NSWindow!

        func applicationDidFinishLaunching(aNotification: NSNotification?) {
            // Insert code here to initialize your application
            println("Got here!")
        }

        func applicationWillTerminate(aNotification: NSNotification?) {
            // Insert code here to tear down your application
        }

We get a hint from this how to deal with an IBOutlet.  

Notice the lack of header files, the only visible code file is ``AppDelegate.swift``.  (There are others to be seen if you expand the folders).

For an IBAction like a button push, just add something like this:

.. sourcecode:: bash

    @IBAction func buttonMashed(sender: AnyObject) {
        println("button mashed!")      
    }

For Objective C we would do

.. sourcecode:: objective-c

    - (IBAction)buttonMashed:(id)sender{

but ``id`` is replaced here by ``AnyObject``

Hook the button up to the ``AppDelegate`` in ``MainMenu.xib`` in the usual way.  Remember to first click on the window icon in the palette in the left center.  The main window for the application will become visible, so then drag a button onto the window and re-label it.  CTL-drag from the button to the AppDelegate icon.  CMD-R to build and run.  Push the button and observe in the console:

.. sourcecode:: bash

    button mashed!
    
We can find out a little about the ``sender``:

.. sourcecode:: bash

    println("\(sender.cell())")

prints

.. sourcecode:: bash

    <NSButtonCell: 0x6000000f3780>

Buttons really aren't that interesting.  Here we do what we can, by changing the title that is displayed, alternating between "Push" and "Pull" each time the button is pushed:

.. sourcecode:: bash

    @IBAction func buttonMashed(sender: NSButton) {
        println("button mashed!")
        var t = sender.title
        println(t)
        if t == "Push me" {
            sender.title = "Pull me"
        }
        else {
            sender.title = "Push me"
        }
    }

In order to use ``title`` we have to explicitly set the class of sender to ``NSButton``.
    
Here is something a little more sophisticated.  

.. image:: /figures/swiftapp3.png
   :scale: 75 %

This project has the class of the main window's view set to be ``MyView``.  Just click on the window icon in the palette on the left, then on the window itself, until the class name as shown in the upper right in the "Identity Inspector" is ``NSView``.  Edit it.

Add a new swift file to the project, with the same name.  Here is the code:

.. sourcecode:: bash

    import Cocoa

    class MyView : NSView {
    
        override func drawRect(dirtyRect: NSRect) {
            NSColor.lightGrayColor().set()
            NSRectFill(self.bounds)
        
            var r = NSMakeRect(50,50,50,50)
            var path = NSBezierPath(rect: r)
            NSColor.redColor().set()
            path.fill()
        
            var s = "abc"
            var f = NSFont(name: "Arial", size: 48.0)
            // necessary to put diverse objects into the dict
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            D[NSForegroundColorAttributeName] = NSColor.whiteColor()
            var p = NSMakePoint(50,150)
            s.drawAtPoint(p, withAttributes: D)
        
            let img = NSImage(named: "moon.png")
            let sz = img.size
            let p2 = NSMakePoint(75,75)
            let r2 = NSMakeRect(150,100,sz.width,sz.height)
            img.drawInRect(r2)
        }
    }

It can be hard to figure out what the new name of a function is, many of them are changed in Swift compared to what's in the docs, e.g. ``NSBezierPath(rect: r)``.  I paid attention to the suggestions that Xcode made as I was typing, and that helped.

There is a trick with the dictionary definition ``var D: [String: AnyObject]``.

I added an image to the project by just drag and drop onto the file view (I think it's called a source list) at the very left, and then, with the file name selected, do File > Add, etc.  

.. image:: /figures/swiftapp2.png
   :scale: 75 %

The fancy image display function

.. sourcecode:: bash

    img.drawAtPoint(point: p2, fromRect: r2,
    operation: NSCompositeCopy, fraction: 1.0)

doesn't work because the symbol ``NSCompositeCopy`` (and its cousins), can't be found, yet are one of the required arguments.

*******************
Table View in Swift
*******************

The docs don't seem to be completely up-to-date for Swift and Cocoa.  Translating methods from Objective C to Swift can be a challenge.  

An NSTableView or subclass (using old style non-"view-based" table views) needs a dataSource, and that class *must* implement two methods:

.. sourcecode:: objective-c

    -(int) numberOfRowsInTableView:
    -(id) tableView:objectValueForTableColumn:row:

Translating the first method is fairly easy.  We just do

.. sourcecode:: bash

    func numberOfRowsInTableView(tv: NSTableView) -> Int {

The method name is the same, we've just added ``func`` and an explicit return type, given the type for the single argument.

The other method takes some thought.  Here it is:

.. sourcecode:: bash

    func tableView(objectValueForTableColumn: NSTableColumn, 
        row: Int) -> String {

So, here is the code to add to ``AppDelegate.swift`` for our first example of a table view:

.. sourcecode:: bash

    func numberOfRowsInTableView(tv: NSTableView!) -> Int {
            return 3  // change this later
        }
    
        func tableView(tv: NSTableView!, objectValueForTableColumn tc: NSTableColumn,
                row: Int) -> String {
                    var D0, D1: Dictionary<Int,String>
                    D0 = [0:"a",1:"b",2:"c"]
                    D1 = [0:"x",1:"y",2:"z"]
                    var D: [String: Dictionary<Int,String>]
                    D = ["0":D0, "1":D1]
                    let dict = D[tc.identifier]
                    if let value = dict![row] {
                        return value }
                    return ""
            }

I am not quite together with the ``!`` idiom yet.  When we do ``dict = D[tc.identifier]``, the compiler seems to think there is the possibility that we won't get anything back from the dictionary ``D``, hence out value is an Optional.  In the next line ``if let value = dict![row]``, we're forcing the actual value of ``dict`` to yield its object for the key ``row``.  For some reason we don't need ``value!`` when we do the return (and it's an error).

In ``MainMenu.xib``, drag a table view out onto the window and then CTL-drag from the table view to the icon for the AppDelegate in the palette.  Set the AppDelegate as the dataSource for the table view.  Set the identifier for the table columns to be 0 and 1.  These will come into the AppDelegate as Strings.  That's it.

.. image:: /figures/tableview.png
   :scale: 125 %

A second version moves the data to a class variable.

.. sourcecode:: bash

    var D: [String: Dictionary<Int,String>]
    override init() {
        var D0, D1: Dictionary<Int,String>
        D0 = [0:"a",1:"b",2:"c"]
        D1 = [0:"x",1:"y",2:"z"]
        self.D = ["0":D0, "1":D1]
        super.init()
    }
    
The compiler requires the ``override`` and that ``super.init()`` come after the initialization of the variable ``D``.  The only other change is to modify ``let dict = self.D[tc.identifier]``.

Here is the entire listing:

.. sourcecode:: bash

    import Cocoa

    class AppDelegate: NSObject, NSApplicationDelegate {

        @IBOutlet weak var window: NSWindow!

        var D: [String: Dictionary<Int,String>]
        var D0, D1: Dictionary<Int,String>
        override init() {
            self.D0 = [0:"a",1:"b",2:"c"]
            self.D1 = [0:"x",1:"y",2:"z"]
            self.D = ["0": self.D0, "1": self.D1]
            super.init()
        }

        func numberOfRowsInTableView(tv: NSTableView!) -> Int {
            let dict = self.D0
            return dict.count
            //return 3
        }

        func tableView(tv: NSTableView!,
            objectValueForTableColumn tc: NSTableColumn,
            row: Int) -> String {
                let dict = self.D[tc.identifier]
                if let value = dict![row] {
                    return value }
                return ""
        }
    }
    
*****************
File Ops in Swift
*****************

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

*****************
NSCoding protocol
*****************

This works, but I have to run it in a special way.

http://stackoverflow.com/questions/25701476/how-to-implement-nscoding

.. sourcecode:: bash

    import Foundation

    class C: NSObject, NSCoding {
        var n: String = ""

        override init() {
            super.init()
            n = "instance of class C"
        }

        convenience init(_ name: String) {
            self.init()
            n = name
        }

        required init(coder: NSCoder) {
            n = coder.decodeObjectForKey("name") as String
        }

        func encodeWithCoder(coder: NSCoder) {
            coder.encodeObject(n, forKey:"name")
        }

        override var description: String {
            get { return "C instance: \(n)" }
        }
    }

    let c = C("Tom")
    println(c)
    if NSKeyedArchiver.archiveRootObject(c, toFile: "demo") {
        println("OK")
    }
    let c2: C = NSKeyedUnarchiver.unarchiveObjectWithFile("demo") as C
    println(c2)
    

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc coder.swift && ./coder
    C instance: Tom
    OK
    C instance: Tom
    >

.. _swift_view:

**************************
Problem with View in Swift
**************************

I'm having trouble updating the data used to draw a View in Swift---the problematic classes are in the folder labeled ``notworking``  :)  .  Here is an attempt at a minimal example, but it does in fact work as intended.  Also, it demonstrates the use of font attributes.

Set up a new project in Xcode in the usual way, with Swift code.  Add a Cocoa class MyView and change the class of the window's ___ view in the nib to be MyView.

For the code use this:

.. sourcecode:: objective-c

    import Cocoa

    class MyView: NSView {
    
        var x: Int = 1
        override func drawRect(dirtyRect: NSRect) {
            super.drawRect(dirtyRect)
            var r: NSRect = self.bounds
            NSColor.whiteColor().set()
            NSRectFill(r)
            let s = String(x)
        
            let f = NSFont(name: "Arial", size: 48.0)
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            // https://github.com/robb/swamp/blob/master/swamp.swift
            let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy()
                as NSMutableParagraphStyle!
            paragraphStyle.alignment = NSTextAlignment.CenterTextAlignment
            D[NSParagraphStyleAttributeName] = paragraphStyle
            s.drawInRect(r, withAttributes:D)
        }
    
        override func mouseDown(theEvent: NSEvent) {
            x *= 2
            println(x)
            self.display()  // necessary
        }
    
    }

Here is a screenshot after I've clicked on the window a few times:

.. image:: /figures/binary_view.png
    :scale: 75 %
    
Here is another test that works:

.. sourcecode:: objective-c

    import Cocoa

    class MyView: NSView {
        var a :[Int] = [1,2,3]
    
        override func drawRect(dirtyRect: NSRect) {
            super.drawRect(dirtyRect)
            if a[1] % 2 == 0 {
                NSColor.purpleColor().set()
            }
            else {
                NSColor.yellowColor().set()
            }
            NSRectFill(self.bounds)
        }
    
        override func mouseDown(theEvent: NSEvent) {
            a[1] += 1
            println(a[1])
            self.display()
        }
    }

**************
Fifteen Puzzle
**************

Here is the Swift code for a puzzle app called Fifteen.  It looks like this:

.. image:: /figures/fifteen.png
    :scale: 75 %
    
Its previous incarnation is here:

http://telliott99.blogspot.com/2011/02/fifteen.html

There is a single subclass of ``NSView``, set up in the usual way.  The idea is that each of the sixteen squares occupies a fixed position in an array (indexed 0...15 as usual).  To make a move, we exchange the ``title`` attributes of the current black square with the one that's been chosen to be next.

One issue is that it is possible to make puzzles that can't be solved.  I forget at the moment what the invariant is, but the way I solve it here is to make 500 legal moves at random, starting from a solved position.  The Xcode project is in the ``projects`` folder.

.. sourcecode:: objective-c

    import Cocoa

    struct S {
        let i: Int
        var title: String
        let r: NSRect
        mutating func changeTitle(s: String) {
            title = s
        }
    }

    class MyView: NSView {
        var a = Array<S>()
        var blank = 16
    
        override func awakeFromNib() {
            setUpSquares()
            for i in 1...500 { shuffle() }
        }
    
        func shuffle() {
            let near = adjacentSquares(blank)  // 1-based
            let r = arc4random_uniform(UInt32(near.count)) // 0-based
            let next = near[Int(r)]            // 1-based
            switchSquares(next,j:blank)        // 1-based
        }
    
        func setUpSquares() {
            let wd = self.bounds.width
            let ht = self.bounds.height
            let offset = CGFloat(20)
            let sq = min(wd,ht) - 2 * offset
            let u = sq/4
            var tmp = [S]()
            for i in 1...16 {
                let col = (i - 1) % 4
                let row = (16 - i) / 4
                let x = CGFloat(col) * u + offset
                let y = CGFloat(row) * u + offset
                let r = NSMakeRect(x,y,u,u)
            
                var s: String
                if i != blank { s = String(i) }
                else { s = "" }
                var st = S(i:i, title:s, r:r)
            
                tmp.append(st)
            }
            a = tmp
        }
    
        func prettyPrint(s:String, a: [S]) {
            var t = ""
            for st in a {
                let title = st.title
                if title == "" { t += "* " }
                else { t +=  st.title + " " }
            }
            println(s + t)
        }

        override func drawRect(dirtyRect: NSRect) {
            NSColor.whiteColor().set()
            NSRectFill(self.bounds)
            //println("drawRect")
            var tmp = a
            for (i,st) in enumerate(tmp) {
                NSColor.redColor().set()
                let p = NSBezierPath(rect: st.r)
                p.stroke()
                drawInRect(st)
            }
        }
    
        func drawInRect(st: S) {
            let s = st.title
            let r = st.r
            let f = NSFont(name: "Arial", size: 48.0)
            // necessary to put diverse objects into the dict
            var D: [String: AnyObject] = [NSFontAttributeName: f]
            let t = st.title
            var color = NSColor.blackColor()
            let n = t.toInt()
            if n != nil {
                if n! % 2 == 0 { color = NSColor.redColor() }
            }
            D[NSForegroundColorAttributeName] = color
        
            // https://github.com/robb/swamp/blob/master/swamp.swift
            let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy()
                as NSMutableParagraphStyle!
            paragraphStyle.alignment = NSTextAlignment.CenterTextAlignment
            D[NSParagraphStyleAttributeName] = paragraphStyle
            let r2 = NSMakeRect(r.origin.x, r.origin.y - 15,
                r.width, r.height)
            s.drawInRect(r2, withAttributes: D)
        
        }
    
        override func mouseDown(theEvent: NSEvent) {
            for st in a {
                if NSPointInRect(theEvent.locationInWindow, st.r) {
                    handleClick(st)
                return
                }
            }
        }
    
        func handleClick(st: S) {
            println("mouseDown: \(st.i) \(st.title)")
            // 1-based indexing everywhere in this function !!
            // i is index of Struct.rect with mouse event
            let i = st.i
            // j is index of Struct.rect with blank title
            let j = blank
            // test whether we allow switch:
            let adj = adjacentSquares(i)
            println("\(i) \(j) \(adj) \(contains(adj,j))")
            if !contains(adj,j) {
                println("not adjacent: \(i) \(j)")
                return
            }
            switchSquares(i, j:j)
        }
    
        // note:  index of blank square must be j not i
        func switchSquares(i: Int, j: Int) {
            // i,j come in as 1-based indexing
            // switch here to 0-based indexing of a
            var next = a[i-1]
            var title = next.title
            var curr = a[j-1]
        
            curr.changeTitle(title)
            next.changeTitle("")
        
            a[i-1] = next
            a[j-1] = curr
        
            // switch back to 1-based for blank
            blank = i
            display()
        }
    
        func adjacentSquares(i:Int) -> [Int] {
            if i == 1  { return [2,5] }
            if i == 2  { return [1,3,6] }
            if i == 3  { return [2,4,7] }
            if i == 4  { return [3,8] }
            if i == 5  { return [1,6,9] }
            if i == 6  { return [2,5,7,10] }
            if i == 7  { return [3,6,8,11] }
            if i == 8  { return [4,7,12] }
            if i == 9  { return [5,10,13] }
            if i == 10 { return [6,9,11,14] }
            if i == 11 { return [7,10,12,15] }
            if i == 12 { return [8,11,16] }
            if i == 13 { return [9,14] }
            if i == 14 { return [10,13,15] }
            if i == 15 { return [11,14,16] }
            if i == 16 { return [12,15] }
            return []
        }
    }
   
   