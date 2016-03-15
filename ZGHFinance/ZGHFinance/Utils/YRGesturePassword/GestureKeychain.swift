//
//  GestureKeychain.swift
//  YRGesturePasswordView
//
//  Created by zhangyr on 16/1/13.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

private let GesturePath                                        = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!).URLByAppendingPathComponent("gesture").URLByAppendingPathComponent("keychain")

class GestureKeychain: NSObject {
    
    static var keychain : GestureKeychain = GestureKeychain()
    var keys            : Array<GestureKeyData>?
    
    class func getValueForKey(key : String) -> String? {
        loadKeychain()
        if keychain.keys != nil {
            for k in keychain.keys! {
                if k.key == key {
                    return k.value
                }
            }
        }
        return nil
    }
    
    class func addObject(key : String , value : String) {
        loadKeychain()
        if keychain.keys != nil {
            for k in keychain.keys! {
                if k.key == key {
                    k.value = value
                    GestureKeychain.saveKeychainToFile()
                    return
                }
            }
        }else{
            keychain.keys        = Array()
        }
        let keyData     = GestureKeyData()
        keyData.key     = key
        keyData.value   = value
        keychain.keys?.append(keyData)
        GestureKeychain.saveKeychainToFile()
    }
    
    class func deleteObject(key : String) {
        loadKeychain()
        if keychain.keys != nil {
            for index in 0 ..< keychain.keys!.count {
                let k = keychain.keys![index]
                if k.key == key {
                    keychain.keys?.removeAtIndex(index)
                    GestureKeychain.saveKeychainToFile()
                    return
                }
            }
        }
    }
    
    private class func loadKeychain() {
        if let obj = GestureKeychain.loadKeychainFromFile() {
            keychain.keys    = obj as? Array
        }else{
            keychain.keys    = Array()
        }
    }
    
    private class func loadKeychainFromFile(path : String = GesturePath.resourceSpecifier) -> AnyObject? {
        let fileManager             = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path)
        {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        }
        return nil
    }
    
    private class func saveKeychainToFile(path : String = GesturePath.resourceSpecifier) -> Bool {
        let fileManager             = NSFileManager.defaultManager()
        let dir                     = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!).URLByAppendingPathComponent("gesture")
        
        var isDic : ObjCBool        = true
        if !fileManager.fileExistsAtPath(String(dir), isDirectory: &isDic)
        {
            do
            {
                try fileManager.createDirectoryAtPath(dir.resourceSpecifier, withIntermediateDirectories: true, attributes: nil)
            }catch
            {
                return false
            }
        }
        
        if fileManager.fileExistsAtPath(path)
        {
            do
            {
                try fileManager.removeItemAtPath(path)
            }catch
            {
                return false
            }
        }
        
        let hasCreateFile           = fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        
        if !hasCreateFile
        {
            return false
        }
        return NSKeyedArchiver.archiveRootObject(keychain.keys!, toFile: path)
    }
    
}

class GestureKeyData : NSObject , NSCoding {
    var key     : String!
    var value   : String!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        key                     = aDecoder.decodeObjectForKey("gestureKey") as? String
        value                   = aDecoder.decodeObjectForKey("gestureValue") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(key, forKey: "gestureKey")
        aCoder.encodeObject(value, forKey: "gestureValue")
    }
}
