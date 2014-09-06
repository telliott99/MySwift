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
        let wd = self.bounds.width
        let ht = self.bounds.height
        let offset = CGFloat(20)
        let sq = min(wd,ht) - 2 * offset
        let u = sq/4
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
            a.append(st)
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        NSColor.whiteColor().set()
        NSRectFill(self.bounds)
        for (i,st) in enumerate(a) {
            println("\(st.i) \(st.title)")
            NSColor.redColor().set()
            let p = NSBezierPath(rect: st.r)
            p.stroke()
            NSColor.blackColor().set()
            drawStringInRect(st.title,r:st.r)
        }
    }
    
    func drawStringInRect(s: String, r: NSRect) {
        var f = NSFont(name: "Arial", size: 48.0)
        // necessary to put diverse objects into the dict
        var D: [String: AnyObject] = [NSFontAttributeName: f]
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
        // println(theEvent)
        for st in a {
            if NSPointInRect(theEvent.locationInWindow, st.r) {
                handleEvent(st)
            }
        }
    }
    
    func handleEvent(st: S) {
        println("mouseDown \(st.i)")
        var curr = a[blank-1]  // 0-based indexing
        // test function needed here
        var next = a[st.i-1]
        println("\(curr.i) \(next.i)")
        curr.changeTitle(next.title)
        next.changeTitle("")
        for st in a { println(String(st.i) + " ") }
        println()
        for st in a { println(st.title + " ") }
        println()
        blank = st.i
        self.display()
    }
    
}
