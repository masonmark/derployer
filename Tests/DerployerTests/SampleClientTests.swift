// SampleClientTests.swift Created by mason on 2017-01-25. 

import XCTest
@testable import Derployer


class SampleClientTests: XCTestCase {
    
    /// Intended to kind of simulate what a real client app might do.

    func test_example() {
        
        let derp = Derployer()
        
        derp.deployPhases = [
            phaseOneDeployValues,
            phaseTwoDeployValues
        ]
        
        derp.run()
        
        do {
            print("OBJECT VALUES:")
            print("\(try derp.targetHostValues.serialize())")
            print("\(try derp.deployPhases[0].serialize())")
            print("\(try derp.deployPhases[1].serialize())")

            print("JSON:")
            print("\(derp.targetHostValues.JSON)")
            print("\(derp.deployPhases[0].JSON)")
            print("\(derp.deployPhases[1].JSON)")
        } catch {
            print("RED 🐞 ALERT: FUBAR OCCURRED: ", error)
        }
        
    }
    
    var phaseOneDeployValues: DeployPhase {
        let vals = [
            MenuItem("updated_base_system", type: .boolean),
            MenuItem("mason_linux_core_packages", type: .boolean),
            MenuItem("java", type: .boolean),
            MenuItem("scala", type: .boolean),
            MenuItem("docker", type: .boolean),
            MenuItem("swift", type: .boolean),
            MenuItem("vmware_tools", type: .boolean),
        ]
        return DeployPhase(menuItems: vals)
    }
    
    var phaseTwoDeployValues: DeployPhase {
        let vals = [
            MenuItem("foo", value: "hoge"),
            MenuItem("bar", value: "ホゲ"),
            MenuItem("baz", value: "ほげ"),
        ]
        return DeployPhase(menuItems: vals)
    }
}


extension SampleClientTests {
    
    static var allTests : [(String, (SampleClientTests) -> () throws -> Void)] {
        return [
            ("test_example", test_example),
        ]
    }
}
