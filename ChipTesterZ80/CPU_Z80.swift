//
//  CPU_Z80.swift
//  ChipTesterZ80
//
//  Created by Mike Hall on 16/03/2025.
//

import FAC_Z80

class CPU_Z80: Z80 {
    override init() {
        super.init()
        ram[0] = Array(repeating: 0x00, count: 0x10000)
    }
    
    override func memoryWrite(to: UInt16, value: UInt8) {
        ram[0][Int(to)] = value
    }
    

    override func memoryRead(from: UInt16) -> UInt8 {
        return ram[0][Int(from)]
    }
}
