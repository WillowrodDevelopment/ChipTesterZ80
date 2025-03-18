//
//  Z80Test.swift
//  ChipTesterZ80
//
//  Created by Mike Hall on 16/03/2025.
//

import Testing
import Foundation
@testable import ChipTesterZ80
import FAC_Common

var testID = "FD 76"
let checkFlags3And5 = false

struct _Z80Test {
    
    let ignoreHP = ["ED B2", "ED B3", "ED BA", "ED BB"]
    
    @Test func runSpecificTest() async throws {
        let testJSON = """
{"name":"FD 76 0002","initial":{"pc":32083,"sp":39710,"a":160,"b":40,"c":226,"d":95,"e":61,"f":20,"h":56,"l":190,"i":72,"r":107,"ei":1,"wz":42514,"ix":52655,"iy":12358,"af_":60903,"bc_":2751,"de_":49568,"hl_":49795,"im":2,"p":0,"q":0,"iff1":0,"iff2":1,"ram":[[32083,253],[32084,118]]},"final":{"a":160,"b":40,"c":226,"d":95,"e":61,"f":20,"h":56,"l":190,"i":72,"r":109,"af_":60903,"bc_":2751,"de_":49568,"hl_":49795,"ix":52655,"iy":12358,"pc":32085,"sp":39710,"wz":42514,"iff1":0,"iff2":1,"im":2,"ei":0,"p":0,"q":0,"ram":[[32083,253],[32084,118]]},"cycles":[[32083,null,"----"],[32083,null,"r-m-"],[18539,253,"----"],[18539,null,"----"],[32084,null,"----"],[32084,null,"r-m-"],[18540,118,"----"],[18540,null,"----"]]}

"""
        
        let test = try JSONDecoder().decode(TestModel.self, from: Data(testJSON.utf8))
        test.log()
        let cpu = CPU_Z80()
        cpu.PC = test.initial.pc
        cpu.SP = test.initial.sp
        cpu.A = test.initial.a
        cpu.F = test.initial.f
        cpu.B = test.initial.b
        cpu.C = test.initial.c
        cpu.D = test.initial.d
        cpu.E = test.initial.e
        cpu.H = test.initial.h
        cpu.L = test.initial.l
        
        cpu.I = test.initial.i
        cpu.R = test.initial.r
        //cpu.L = test.initial.l
        cpu.IX = test.initial.ix
        cpu.IY = test.initial.iy
        cpu.AF2 = test.initial.af_
        cpu.BC2 = test.initial.bc_
        cpu.DE2 = test.initial.de_
        cpu.HL2 = test.initial.hl_
        cpu.iff1 = test.initial.iff1
        cpu.iff2 = test.initial.iff2
//        cpu.L = test.initial.l
//        cpu.L = test.initial.l
//        cpu.L = test.initial.l
//        cpu.L = test.initial.l
        
        
//        let ei: UInt8
//        let wz: UInt16
//        let im: UInt8
//        let p: UInt8
//        let q: UInt8
        
        
        
        
        test.initial.ram.forEach { item in
            let ramAddress = item[0]
            let ramValue = item[1]
            cpu.ram[0][ramAddress] = UInt8(ramValue)
        }
        
        if let ports = test.ports {
            ports.forEach { item in
                let port = item[0]
                let value = item[1]
                cpu.hardwarePorts.writeSinglePort(port: port.fetchUInt16(), value: value.fetchUInt8())
            }
        }
        
        cpu.fetchAndExecute()
        #expect(cpu.A == UInt8(test.final.a))
        mismatch(test.name, "A", cpu.A, test.final.a)
        #expect(cpu.B == UInt8(test.final.b))
        mismatch(test.name, "B", cpu.B, test.final.b)
        #expect(cpu.C == UInt8(test.final.c))
        mismatch(test.name, "C", cpu.C, test.final.c)
        #expect(cpu.D == UInt8(test.final.d))
        mismatch(test.name, "D", cpu.D, test.final.d)
        #expect(cpu.E == UInt8(test.final.e))
        mismatch(test.name, "E", cpu.E, test.final.e)
        if checkFlags3And5 {
            #expect(cpu.F == UInt8(test.final.f))
            mismatchWithBin(test.name, "F", cpu.F, test.final.f)
        } else {
            let fNo35 = cpu.F & 0xD7
            let exFNo35 = test.final.f & 0xD7  //UInt8()
            #expect(fNo35 == exFNo35)
            mismatchWithBin(test.name, "F (Not 3 & 5)", fNo35, exFNo35)
        }
        #expect(cpu.H == UInt8(test.final.h))
        mismatch(test.name, "H", cpu.H, test.final.h)
        #expect(cpu.L == UInt8(test.final.l))
        mismatch(test.name, "L", cpu.L, test.final.l)
        #expect(cpu.PC == test.final.pc)
        mismatch(test.name, "PC", cpu.PC, test.final.pc)
        #expect(cpu.SP == test.final.sp)
        mismatch(test.name, "SP", cpu.SP, test.final.sp)
        #expect(cpu.iff1 == UInt8(test.final.iff1))
        mismatch(test.name, "iff1", cpu.iff1, test.final.iff1)
        #expect(cpu.iff2 == UInt8(test.final.iff2))
        mismatch(test.name, "iff2", cpu.iff2, test.final.iff2)
        #expect(cpu.AF2 == test.final.af_)
        mismatch(test.name, "AF2", cpu.AF2, test.final.af_)
        #expect(cpu.BC2 == test.final.bc_)
        mismatch(test.name, "BC2", cpu.BC2, test.final.bc_)
        #expect(cpu.DE2 == test.final.de_)
        mismatch(test.name, "DE2", cpu.DE2, test.final.de_)
        #expect(cpu.HL2 == test.final.hl_)
        mismatch(test.name, "HL2", cpu.HL2, test.final.hl_)
        #expect(cpu.IX == test.final.ix)
        mismatch(test.name, "IX", cpu.IX, test.final.ix)
        #expect(cpu.IY == test.final.iy)
        mismatch(test.name, "IY", cpu.IY, test.final.iy)
        #expect(cpu.I == UInt8(test.final.i))
        mismatch(test.name, "I", cpu.I, test.final.i)
        #expect(cpu.R == UInt8(test.final.r))
        mismatch(test.name, "R", cpu.R, test.final.r)
        
        test.final.ram.forEach { item in
            let ramAddress = item[0]
            let ramValue = item[1]
            #expect(cpu.ram[0][ramAddress] == UInt8(ramValue))
            mismatchRAM(UInt16(ramAddress), cpu.ram[0][ramAddress], UInt8(ramValue))
        }
        
    }
    
    func mismatch(_ test: String, _ name: String, _ result: UInt8, _ expected: UInt8){
        if result != expected {
            print ("\(test) - \(name) Mismatch : \(result.hex()) (\(result)) != \(expected.hex())(\(expected))")
        }
    }
    
    func mismatchWithBin(_ test: String, _ name: String, _ result: UInt8, _ expected: UInt8){
        if result != expected {
            print ("\(test) - \(name) Mismatch : \(result.hex()) (\(result)) != \(expected.hex())(\(expected))\nRes - \(result.bin())\nExp - \(expected.bin())")
        }
    }
    
    func mismatchRAM(_ name: UInt16, _ result: UInt8, _ expected: UInt8){
        if result != expected {
            print ("RAM address \(name.hex()) Mismatch : \(result.hex()) (\(result)) != \(expected.hex())(\(expected))\nRes - \(result.bin())\nExp - \(expected.bin())")
        }
    }
    
    func mismatch(_ test: String, _ name: String, _ result: UInt16, _ expected: UInt16){
        if result != expected {
            print ("\(test) - \(name) Mismatch : \(result.hex()) (\(result)) != \(expected.hex()) (\(expected))")
        }
    }
    
    
    @Test func runTest() async throws {
        let tests: [TestModel] = await loadJson(testID.lowercased())
        print("Found \(tests.count) tests for \(testID).json")
        let cpu = CPU_Z80()
        tests.forEach{ test in
            cpu.PC = test.initial.pc
            cpu.SP = test.initial.sp
            cpu.A = test.initial.a
            cpu.F = test.initial.f
            cpu.B = test.initial.b
            cpu.C = test.initial.c
            cpu.D = test.initial.d
            cpu.E = test.initial.e
            cpu.H = test.initial.h
            cpu.L = test.initial.l
            
            cpu.I = test.initial.i
            cpu.R = test.initial.r
            //cpu.L = test.initial.l
            cpu.IX = test.initial.ix
            cpu.IY = test.initial.iy
            cpu.AF2 = test.initial.af_
            cpu.BC2 = test.initial.bc_
            cpu.DE2 = test.initial.de_
            cpu.HL2 = test.initial.hl_
            cpu.iff1 = test.initial.iff1
            cpu.iff2 = test.initial.iff2
            
            cpu.isInHaltState = false
    //        cpu.L = test.initial.l
    //        cpu.L = test.initial.l
    //        cpu.L = test.initial.l
    //        cpu.L = test.initial.l
            
            
    //        let ei: UInt8
    //        let wz: UInt16
    //        let im: UInt8
    //        let p: UInt8
    //        let q: UInt8
            
            
            
            
            test.initial.ram.forEach { item in
                let ramAddress = item[0]
                let ramValue = item[1]
                cpu.ram[0][ramAddress] = UInt8(ramValue)
            }
            
            if let ports = test.ports {
                ports.forEach { item in
                    let port = item[0]
                    let value = item[1]
                    cpu.hardwarePorts.writeSinglePort(port: port.fetchUInt16(), value: value.fetchUInt8())
                }
            }
            
            cpu.fetchAndExecute()
            #expect(cpu.A == UInt8(test.final.a))
            mismatch(test.name, "A", cpu.A, test.final.a)
            #expect(cpu.B == UInt8(test.final.b))
            mismatch(test.name, "B", cpu.B, test.final.b)
            #expect(cpu.C == UInt8(test.final.c))
            mismatch(test.name, "C", cpu.C, test.final.c)
            #expect(cpu.D == UInt8(test.final.d))
            mismatch(test.name, "D", cpu.D, test.final.d)
            #expect(cpu.E == UInt8(test.final.e))
            mismatch(test.name, "E", cpu.E, test.final.e)
            if checkFlags3And5 {
                #expect(cpu.F == UInt8(test.final.f))
                mismatchWithBin(test.name, "F", cpu.F, test.final.f)
            } else if ignoreHP.contains(testID.uppercased()) {
                let fNo35 = cpu.F & 0xC3
                let exFNo35 = test.final.f & 0xC3  //UInt8()
                #expect(fNo35 == exFNo35)
                mismatchWithBin(test.name, "F (Not 3 & 5)", fNo35, exFNo35)
            } else {
                let fNo35 = cpu.F & 0xD7
                let exFNo35 = test.final.f & 0xD7  //UInt8()
                #expect(fNo35 == exFNo35)
                mismatchWithBin(test.name, "F (Not 3 & 5)", fNo35, exFNo35)
            }
            #expect(cpu.H == UInt8(test.final.h))
            mismatch(test.name, "H", cpu.H, test.final.h)
            #expect(cpu.L == UInt8(test.final.l))
            mismatch(test.name, "L", cpu.L, test.final.l)
            #expect(cpu.PC == test.final.pc)
            mismatch(test.name, "PC", cpu.PC, test.final.pc)
            #expect(cpu.SP == test.final.sp)
            mismatch(test.name, "SP", cpu.SP, test.final.sp)
            #expect(cpu.iff1 == UInt8(test.final.iff1))
            mismatch(test.name, "iff1", cpu.iff1, test.final.iff1)
            #expect(cpu.iff2 == UInt8(test.final.iff2))
            mismatch(test.name, "iff2", cpu.iff2, test.final.iff2)
            #expect(cpu.AF2 == test.final.af_)
            mismatch(test.name, "AF2", cpu.AF2, test.final.af_)
            #expect(cpu.BC2 == test.final.bc_)
            mismatch(test.name, "BC2", cpu.BC2, test.final.bc_)
            #expect(cpu.DE2 == test.final.de_)
            mismatch(test.name, "DE2", cpu.DE2, test.final.de_)
            #expect(cpu.HL2 == test.final.hl_)
            mismatch(test.name, "HL2", cpu.HL2, test.final.hl_)
            #expect(cpu.IX == test.final.ix)
            mismatch(test.name, "IX", cpu.IX, test.final.ix)
            #expect(cpu.IY == test.final.iy)
            mismatch(test.name, "IY", cpu.IY, test.final.iy)
            #expect(cpu.I == UInt8(test.final.i))
            mismatch(test.name, "I", cpu.I, test.final.i)
            #expect(cpu.R == UInt8(test.final.r))
            mismatch(test.name, "R", cpu.R, test.final.r)
            
            test.final.ram.forEach { item in
                let ramAddress = item[0]
                let ramValue = item[1]
                #expect(cpu.ram[0][ramAddress] == UInt8(ramValue))
                mismatchRAM(UInt16(ramAddress), cpu.ram[0][ramAddress], UInt8(ramValue))
            }
        }
        
    }
    
    
    func loadJson(_ testID: String) async -> [TestModel] {
        let bundle = Bundle(for: BaseTest.self)
        let filename = testID.lowercased()
        guard
            let path = bundle.path(forResource: filename, ofType: "json")
        else {
            return []
        }
        do {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                print("Failed to read data")
                return []
            }
            let json = try JSONDecoder().decode([TestModel].self, from: data) //JSONEncoder().encode(self)
            return json
            
        } catch {
            print("Something bad happened.... \(error.localizedDescription)")
            return []
        }
    }
}

class BaseTest {
    
}
