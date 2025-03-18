//
//  TestModel.swift
//  FakeAChipTests
//
//  Created by Mike Hall on 28/05/2023.
//

import Foundation

struct TestModel: Codable {
    let name: String
        let initial: TestState
        let final: TestState
        let cycles: [[Cycle]]
        let ports: [[Port]]?
    
    func log() {
        print("Name: \(name)\nInitial state:")
        initial.log()
        print("Expected final state:")
        final.log()
        print("Ports:")
        ports?.forEach {pt in
            print("\(pt[0].fetchUInt16().hex()) : \(pt[1].fetchUInt8().hex())")
        }
        
    }
}

struct TestState: Codable {
    let pc: UInt16
    let sp: UInt16
    let a: UInt8
    let b: UInt8
    let c: UInt8
    let d: UInt8
    let e: UInt8
    let f: UInt8
    let h: UInt8
    let l: UInt8
    let i: UInt8
    let r: UInt8
    let ei: UInt8
    let wz: UInt16
    let ix: UInt16
    let iy: UInt16
    let af_: UInt16
    let bc_: UInt16
    let de_: UInt16
    let hl_: UInt16
    let im: UInt8
    let p: UInt8
    let q: UInt8
    let iff1: UInt8
    let iff2: UInt8
    let ram: [[Int]]
    
    func log() {
        var logString = ""
        logString += log("PC", word: pc)
        logString += log("SP", word: sp)
        logString += log("AF", high: a, low: f)
        logString += log("BC", high: b, low: c)
        logString += log("DE", high: d, low: e)
        logString += log("HL", high: h, low: l)
        logString += log("IX", word: ix)
        logString += log("IY", word: iy)
        logString += log("_AF", word: af_)
        logString += log("_BC", word: bc_)
        logString += log("_DE", word: de_)
        logString += log("_HL", word: hl_)
        logString += log("IR", high: i, low: r)
        logString += "\n\nRAM: "
        let ramStruct = ram.map{RamStruct(location: UInt16($0[0]), value: UInt8($0[1]))}
        ramStruct.forEach{ r in
            logString += "\nLocation: \(r.location.toLog()) Value: \(r.value.toLog())"
        }
        print(logString)
    }
    
    struct RamStruct {
        let location: UInt16
        let value: UInt8
    }
    
    func log(_ name: String, high: UInt8, low: UInt8) -> String {
        return "\n\(name):\n0x\(high.hex())\(low.hex()) (\(high) \(low))\nHigh: \(high.bin())\nLow: \(low.bin())"
    }
    
    func log(_ name: String, word: UInt16) -> String {
        return "\n\(name): 0x\(word.hex()) (\(word))"
    }
}

enum Cycle: Codable {
   case integer(Int)
   case string(String)
   case null

   init(from decoder: Decoder) throws {
       let container = try decoder.singleValueContainer()
       if let x = try? container.decode(Int.self) {
           self = .integer(x)
           return
       }
       if let x = try? container.decode(String.self) {
           self = .string(x)
           return
       }
       if container.decodeNil() {
           self = .null
           return
       }
       throw DecodingError.typeMismatch(Cycle.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Cycle"))
   }

   func encode(to encoder: Encoder) throws {
       var container = encoder.singleValueContainer()
       switch self {
       case .integer(let x):
           try container.encode(x)
       case .string(let x):
           try container.encode(x)
       case .null:
           try container.encodeNil()
       }
   }
}

enum Port: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Port.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Port"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }

    func fetchString() -> String {
        switch self {
        case .integer(let v):
            return String(v)
        case .string(let v):
            return v
        }
    }

    func fetchUInt8() -> UInt8 {
        switch self {
        case .integer(let v):
            return UInt8(v)
        case .string(_):
            return 0x00
        }
    }

    func fetchUInt16() -> UInt16 {
        switch self {
        case .integer(let v):
            return UInt16(v)
        case .string(_):
            return 0x00
        }
    }
}
