//
//  ViewController.swift
//  TLVParser_Swift
//
//  Created by F. and Code Different on 22.05.18.
//  Copyleft © 2018 F. All rights reserved.
//

import Cocoa

// https://stackoverflow.com/questions/26501276/converting-hex-string-to-nsdata-in-swift/26503955
extension Data {
    
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}
//  Usage:
//  let data = Data(hexString: "0A1b3c4DFFAA")

class ViewController: NSViewController {
    @objc var tlvNodes: [TLVNode]!
    
    @IBAction func ParseAction(_ sender: Any) {
        /*
         let data = Data(bytes:
         [   0xe1,0x35,
         0x9f,0x1e,0x08,0x31,0x36,0x30,0x32,0x31,0x34,0x33,0x37,
         0xef,0x12,
         0xdf,0x0d,0x08,0x4d,0x30,0x30,0x30,0x2d,0x4d,0x50,0x49,
         0xdf,0x7f,0x04,0x31,0x2d,0x32,0x32,
         0xef,0x14,
         0xdf,0x0d,0x0b,0x4d,0x30,0x30,0x30,0x2d,0x54,0x45,0x53,0x54,0x4f,0x53,
         0xdf,0x7f,0x03,0x36,0x2d,0x35,
         0xe1,0x2F,
         0x9f,0x1e,0x08,0x31,0x36,0x30,0x32,0x31,0x34,0x33,0x37,
         0xef,0x12,
         0xdf,0x0d,0x08,0x4d,0x30,0x30,0x30,0x2d,0x4d,0x50,0x49,
         0xdf,0x7f,0x04,0x31,0x2d,0x32,0x32,
         0xef,0x0e,
         0xdf,0x0d,0x0b,0x4d,0x30,0x30,0x30,0x2d,0x54,0x45,0x53,0x54,0x4f,0x53,
         // A repeat of the data above
         0xe1,0x2F,
         0x9f,0x1e,0x08,0x31,0x36,0x30,0x32,0x31,0x34,0x33,0x37,
         0xef,0x12,
         0xdf,0x0d,0x08,0x4d,0x30,0x30,0x30,0x2d,0x4d,0x50,0x49,
         0xdf,0x7f,0x04,0x31,0x2d,0x32,0x32,
         0xef,0x0e,
         0xdf,0x0d,0x0b,0x4d,0x30,0x30,0x30,0x2d,0x54,0x45,0x53,0x54,0x4f,0x53,
         //
         0x57,0x11,0x54,0x13,0x33,0x00,0x89,0x60,0x00,0x69,0xd2,0x51,0x22,0x26,0x01,0x23,0x40,0x91,0x72,
         0x50,0x0f,0x50,0x50,0x43,0x20,0x4d,0x43,0x44,0x20,0x30,0x36,0x20,0x76,0x32,0x20,0x33,
         0x5f,0x34,0x01,0x01,
         0x9f,0x06,0x07,0xa0,0x00,0x00,0x00,0x04,0x10,0x10,
         0x9f,0x07,0x02,0xff,0x00,
         0x9f,0x0d,0x05,0x00,0x00,0x00,0x00,0x00,
         0x9f,0x0e,0x05,0x00,0x00,0x00,0x00,0x00,
         0x9f,0x0f,0x05,0x00,0x00,0x00,0x00,0x00,
         0x5a,0x08,0x54,0x13,0x33,0x00,0x89,0x60,0x00,0x69,
         0x9f,0x26,0x08,0xb3,0x2b,0x76,0xcd,0x27,0x65,0x83,0x5e,
         0x82,0x02,0x58,0x80,
         0x9f,0x36,0x02,0x00,0x01,
         0x9f,0x27,0x01,0x80,
         0x84,0x07,0xa0,0x00,0x00,0x00,0x04,0x10,0x10,
         0x9f,0x10,0x12,0x01,0x10,0xa0,0x00,0x09,0x24,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff,
         0x9f,0x02,0x06,0x00,0x00,0x00,0x00,0x67,0x67,
         0x9f,0x03,0x06,0x00,0x00,0x00,0x00,0x00,0x00,
         0x9f,0x09,0x02,0x00,0x02,
         0x9f,0x34,0x03,0x3f,0x00,0x01,
         0x9f,0x1e,0x08,0x36,0x43,0x41,0x30,0x30,0x31,0x32,0x37,
         0x9f,0x33,0x03,0x60,0x60,0x08,
         0x9f,0x1a,0x02,0x06,0x16,
         0x9f,0x35,0x01,0x22,
         0x95,0x05,0x80,0x00,0x80,0x80,0x00,
         0x5f,0x2a,0x02,0x09,0x85,
         0x9a,0x03,0x18,0x05,0x15,
         0x9c,0x01,0x00,
         0x9f,0x37,0x04,0xf0,0xf5,0x11,0x4c,
         0x8a,0x02,0x00,0x00,
         0x9f,0x39,0x01,0x07,
         0x9f,0x40,0x05,0x60,0x00,0xb0,0x10,0x01,
         0x4f,0x07,0xa0,0x00,0x00,0x00,0x04,0x10,0x10,
         0x8f,0x01,0xf1,
         0x9f,0x53,0x01,0x00,
         0x9f,0x34,0x03,0x3f,0x00,0x01
         ])
         */
        let str = textField.stringValue.uppercased()
        
        // Remove all "0X", "\X" and "," and whitespace from hex string
        let str1 = str.replacingOccurrences(of: "0X", with: "")
        // let str2 = str1.replacingOccurrences(of: "\\X", with: "")
        // let str3 = str2.replacingOccurrences(of: "X", with: "")
        // let str4 = str3.replacingOccurrences(of: ",", with: "")
        // let cleanString = str4.components(separatedBy: .whitespacesAndNewlines).joined()
        //
        // limit to only hex chars
        let hexOnly = NSCharacterSet(charactersIn:"0123456789ABCDEF").inverted
        let cleanString = str1.components(separatedBy: hexOnly).joined()
        
        // padding
        if cleanString.count % 2 != 0
        {
            return
        }
        
        
        print ("cleanString = \(cleanString)")
        
        let data = Data(hexString: cleanString)
        if data != nil {
            print ("data =        \(data! as NSData)")
        }
        textField.stringValue = cleanString
        
        if data != nil {
            // The Tree Controller won't know when we assign `tlvNode` to
            // an entirely new object. So we need to give it a notification
            let nodes = TLVNode.create(from: data!)
            self.willChangeValue(forKey: "tlvNodes")
            self.tlvNodes = nodes
            self.didChangeValue(forKey: "tlvNodes")
            
            // expand everything
            outlineView.expandItem(nil, expandChildren: true)
            // scroll at beginning = 0 here end:
            let index = outlineView.numberOfRows - 1
            outlineView.scrollRowToVisible(index)
        }
    }
    
    @IBAction func AddAction(_ sender: Any) {
        
    }
    
    @IBAction func RemoveAction(_ sender: Any) {
    }
    
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    @IBOutlet weak var textField: NSTextField!
    
    override func viewDidLoad() {
        textField.stringValue = "copy hexstring (0x9f,0x02, \\xAA\\xFF )here ..."
        super.viewDidLoad()
        
        
    }
}
