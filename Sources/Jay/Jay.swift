//
//  Jay.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/17/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

//Implemented from scratch based on http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf and https://www.ietf.org/rfc/rfc4627.txt

public struct JayOpts {
    
    //reading options
    
    /// Allows a non Array/Object value to be at the top level, as specified
    /// in RFC7159. Disallowed by default.
    let allowFragments: Bool
    
    //writing options
    
    init(allowFragments: Bool = false) {
        self.allowFragments = allowFragments
    }
}

public struct Jay {
    
    let opts: JayOpts
    
    public init(_ opts: JayOpts = JayOpts()) {
        self.opts = opts
    }
    
    //Parses data into a dictionary [String: Any] or array [Any].
    //Test by conditional casting whether you received what you expected.
    //Throws a descriptive error in case of any problem.
    public func jsonFromData(data: [UInt8]) throws -> Any {
        return try NativeParser(self.opts).parse(data)
    }
    
    //Formats your JSON-compatible object into data or throws an error.
    public func dataFromJson(json: JaySON) throws -> [UInt8] {
        return try self.dataFromAnyJson(json.json)
    }

    public func dataFromJson(json: [String: Any]) throws -> [UInt8] {
        return try self.dataFromAnyJson(json)
    }

    public func dataFromJson(json: [Any]) throws -> [UInt8] {
        return try self.dataFromAnyJson(json)
    }
    
    public func dataFromJson(json: Any) throws -> [UInt8] {
        return try self.dataFromAnyJson(json)
    }

    private func dataFromAnyJson(json: Any) throws -> [UInt8] {
        
        let jayType = try NativeTypeConverter().toJayType(json)
        let data = try jayType.format()
        return data
    }
}

//Typesafe
extension Jay {
    
    //Allows users to get the JSON representation in a typesafe matter.
    //However these types are wrapped, so the user is responsible for
    //manually unwrapping each value recursively. If you just want
    //Swift types with less type-information, use `jsonFromData()` above.
    public func typesafeJsonFromData(data: [UInt8]) throws -> JsonValue {
        return try Parser(self.opts).parseJsonFromData(data)
    }

    //Formats your JSON-compatible object into data or throws an error.
    public func dataFromJson(json: JsonValue) throws -> [UInt8] {
        return try json.format()
    }
}



