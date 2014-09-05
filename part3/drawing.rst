.. _drawing:

#######
Drawing
#######

This is just for fun.  I wrote a ``Sorter`` class that generates an array of random values (either seeded or not), which I thought I might extend later to try out various sorting algorithms.

Then, I remembered a post (stimulated by a great site I found on the web)

http://telliott99.blogspot.com/2012/05/view-with-no-window.html

that implements drawing to a pdf without actually having a window on-screen.  So that's where the second class (``MyView``) comes from.  

As it grew, it got a bit complicated.  To just have a view and write to the file, you don't need to ``override init``.  But I wanted to pass in the data upon initialization, so there is a convenience initializer.  And having done that, the compiler required the ``init(coder: NSCoder)``, even though we don't really implement it correctly.  Also, I'm having trouble initializing the instance variables properly when ``init`` is there, so I just zero them all out at first, and then set the correct values later.

It's not really the best code, but it generates an image.

Here is the resulting figure:

.. image:: /figures/x.png
   :scale: 75 %

.. sourcecode:: bash

    import Cocoa

    class MyView : NSView {
        var data: [Int] = [Int]()
        var maxValue: Int = 0
        var width: Int = 0
        var height: Int = 0
        override init(frame: NSRect) {
            super.init(frame: frame)
        }
        required init(coder: NSCoder) {
            super.init(coder: coder)
        }
        convenience init(data: [Int], maxValue: Int) {
            let frame = NSRect(x:0, y:0, 
                        width:400, height:300)
            self.init(frame: frame)
            self.data = data
            self.maxValue = maxValue
            width = 400
            height = 300
        }
        override func drawRect(dirtyRect: NSRect) {
            NSColor.whiteColor().set()
            NSRectFill(self.bounds)
            //let maxValue = data.reduce(Int.min, { max($0,$1) })

            var num = Double(maxValue)
            var den = Double(height-20)
            let f = num/den * 1.8

            var x: Int = 20
            let y: Int = 20

            let maxw = Int(Double(width - 100)/Double(data.count))
            let w = min(10, maxw)

            let pad = 5 // padding between rects
            for v in data {
                let h = Int(Double(v)*f)
                let r = NSRect(x:x, y:y, width:w, height:h)
                var col: NSColor
                let c = 1.0 - CGFloat(v)/CGFloat(maxValue)
                col = NSColor(calibratedWhite:c, alpha:1.0)
                col.set()
                NSRectFill(r)
                let p = NSBezierPath(rect:r)
                NSColor.blackColor().set()
                p.stroke()
                x += w + pad
            }
        }
        func plotData(fn: String) {
            self.display()
            let data = self.dataWithPDFInsideRect(frame)
            data.writeToFile(fn, atomically: true)
        }
    }

    class Sorter: Printable {
        var data: [Int] = [Int]()
        var N: Int
        var n: Int
        //let seed = 1337
        init(_ maxValue: Int, _ numValues: Int) {
            N = maxValue
            n = numValues
            resetNonRandom()
        }
        func resetNonRandom(seed: Int = 137){
            srand(UInt32(seed))
            var b: [Int] = [Int]()
            var r: Int
            for i in 0...n-1 {
                r = Int(rand())
                let f = Double(r) / Double(Int32.max)
                r = Int(f*Double(N)) + 1
                b.append(r)
            }
            data = b
        } 
        func resetRandom() {
            var b: [Int] = [Int]()
            var r: Int
            for i in 0...n-1 {
                let t = UInt32(N)
                r = Int(arc4random_uniform(t))
                // no duplicates
                while contains(data, r) {
                    r = Int(arc4random_uniform(t))
                }
                b.append(r+1)
            }
            data = b
        }
        var description: String {
            var s = ""
            for (i,r) in enumerate(data) {
                s += String(r)
                if !(i == countElements(data) - 1) {
                    s += " "
                }
            }
            return s
        }
        func test() {
            println("\(sb)")
            sb.resetRandom()
            println("\(sb)")
            sb.resetRandom()
            println("\(sb)")
            sb.resetNonRandom()
            println("\(sb)")
            // let t = UnsafeMutablePointer(null())
            // sb.resetNonRandom(seed: time(t))
            // println("\(sb)")
        }
        func plotData(fn: String) {
            let view = MyView(data: data, maxValue: N)
            view.plotData(fn)
        }
        func sort() {
            data.sort(<)
        }
    }

    var sb = Sorter(200, 20)
    sb.resetRandom()
    // sb.sort()
    sb.plotData("x.pdf")
    
