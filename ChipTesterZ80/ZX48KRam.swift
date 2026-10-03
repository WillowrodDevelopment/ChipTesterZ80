//
//  ZX48KRam.swift
//  ChipTesterZ80
//
//  Created by mike on 28/09/2025.
//
import FAC_Z80

final class ZX48KRam: MemoryDelegate {
    func fetchBatch(from: Int, size: Int) -> [UInt8] {
        return []
    }
    
    var ram: [UInt8] = Array(repeating: 0x00, count: 0x010000)
    
    func write(to: UInt16, value: UInt8) {
        ram[Int(to)] = value
    }
    
    func read(from: UInt16) -> UInt8 {
        return ram[Int(from)]
    }
    
    func writeWord(to: UInt16, value: UInt16) {
        write(to: to, value: value.lowByte())
        write(to: (to &+ 1), value: value.highByte())
    }
    
    func readWord(from: UInt16) -> UInt16 {
        let low = read(from: from)
        let high = read(from: (from &+ 1))
        return (UInt16(high) * 256) + UInt16(low)
    }
    
    public func get48kMemory() -> [UInt8] {
        return ram
    }
    
    public func get48kRam() -> [UInt8] {
        return Array(ram[0x4000...])
    }
    
    func writeRom(rom: [UInt8]) {
        for (index, value) in rom.enumerated() {
            ram[index] = value
        }
    }
    
    func screenRam() -> [UInt8] {
        return Array(ram[0x4000...0x57FF])
    }
    
    func attributeRam() -> [UInt8] {
        return Array(ram[0x5800...0x5AFF])
    }
    
}