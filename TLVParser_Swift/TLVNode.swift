//
//  TLVNode.swift
//  TLVParser_Swift
//
//  Created by F. and Code Different on 22.05.18.
//  all hard work below was done be Code Different!
//  see https://stackoverflow.com/questions/50407560/swift4-displaying-parser-result-in-an-nsoutlineview/
//  Copyleft © 2018 F. All rights reserved.
//

import Cocoa

// Since we use Cocoa Bindings, all properties need to be
// dynamically dispatch hence @objCMembers declaration
// Its ability to handle erroneous data is not tested. That
// is left for the OP as an exercise.
@objcMembers class TLVNode: NSObject {
    var tag: Data
    var length: Int
    var value: Data
    var isConstructed: Bool
    var children = [TLVNode]()
    
    // Convert `tag` from Data to a string of hex for display
    var displayTag: String {
        // Pad the hex value with 0 so it outputs `0d` instead of just `d`
        return tag.map { ("0" + String($0, radix: 16)).suffix(2) }.joined()
    }
    
    // Convert `value` from Data to string of hex
    var displayValue: String {
        let hexValues = value.map { ("0" + String($0, radix: 16)).suffix(2) }
        
        var str = ""
        for (index, hex) in hexValues.enumerated() {
            //if index > 0 && index % 4 == 0 {
             //   str += " " + hex
            //} else {
            str += hex
            //}
        }
        
        return str
    }
    
    convenience init?(dataStream: Data) {
        var size = 0
        self.init(dataStream: dataStream, offset: 0, size: &size)
    }
    
    static func create(from dataStream: Data) -> [TLVNode] {
        var size = 0
        var offset = 0
        var nodes = [TLVNode]()
        
        while let node = TLVNode(dataStream: dataStream, offset: offset, size: &size) {
            nodes.append(node)
            offset += size
        }
        return nodes
    }
    
    /// Intialize a TLVNode object from a data stream
    ///
    /// - Parameters:
    ///   - dataStream: The serialized data stream, in TLV encoding
    ///   - offset: The location from which parsing of the data stream starts
    ///   - size: Upon return, the number of bytes that the node occupies
    private init?(dataStream: Data, offset: Int, size: inout Int) {
        // A node must have at least 3 bytes
        guard offset < dataStream.count - 3 else { return nil }
        
        // The number of bytes that `tag` occupies
        let m = dataStream[offset] & 0x1F == 0x1F ?
            2 + dataStream[(offset + 1)...].prefix(10).prefix(while: { $0 & 0x80 == 0x80 }).count : 1
        
        // error checking here:
        guard offset + m < dataStream.count else {
            return nil }
        
        // The number of bytes that `length` occupies
        let n = dataStream[offset + m] & 0x80 == 0x80 ? Int(dataStream[offset + m] & 0x7f) : 1
        guard n <= 3 else { return nil }
        
        // error checking here:
        guard offset + m + n < dataStream.count else {
            return nil }
        
        self.tag           = Data(dataStream[offset ..< (offset + m)])
        self.length        = dataStream[(offset + m) ..< (offset + m + n)].map { Int($0) }.reduce(0) { result, element in result * 0x100 + element }
        
        // error checking here:
        guard offset + m + n + length <= dataStream.count else {
            print("offset + m + n + length = \(offset + m + n + length)")
            return nil }
        
        self.value         = Data(dataStream[(offset + m + n) ..< (offset + m + n + length)])
        self.isConstructed = dataStream[offset] & 0x20 == 0x20
        
        size = m + n + length
        if self.isConstructed {
            var childOffset = 0
            var childNodeSize = 0
            
            while let childNode = TLVNode(dataStream: self.value, offset: childOffset, size: &childNodeSize) {
                self.children.append(childNode)
                childOffset += childNodeSize
            }
        }
    }
    
    private func generateDescription(indentation: Int) -> String {
        return "\(String(repeating: " ", count: indentation))\(tag as NSData) \(length) \(value as NSData)\n"
            + children.map { $0.generateDescription(indentation: indentation + 4) }.joined()
    }
    
    // Use this property when you need to quickly dump something to the debug console
    override var description: String {
        return self.generateDescription(indentation: 0)
    }
    
    // A more detailed view on the properties of the current instance
    // Does not include child nodes.
    override var debugDescription: String {
        return """
        TAG         = \(tag as NSData)
        LENGTH      = \(length)
        VALUE       = \(value as NSData)
        CONSTRUCTED = \(isConstructed)
        """
    }
}
