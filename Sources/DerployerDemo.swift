// DerployerDemo.swift Created by mason on 2017-01-31. 

import Foundation

/// A set of sample values that can be used for an interactive demo, and also as a kind of test fixture.

public struct DerployerDemo {
    
    public static var introMenu: Menu {
        
        let menu = Menu(title: "DERPloyer 2017.01.25")
        menu.headers = [
            "🐒\n ⌇\n 💩  DERP!!",
            "Hi, I'm DERPloyer. I can help you deploy things."
        ]
        return menu
    }
    
    public static var deployPhases: [DeployPhase] {
        
        let phase1 = DeployPhase(menuItems: [
            MenuItem("foo", value: "bar", type: .predefined, predefinedValues: ["bar", "hoge"]),
            MenuItem("whatever", value: "derp_derp_derp")
            
        ])
        let phase2 = DeployPhase(menuItems:[
            MenuItem("foo", value: "true", type: .boolean),
            MenuItem("bar", value: "true", type: .boolean),
            MenuItem("baz", value: "true", type: .boolean),
            MenuItem("hoge", value: "true", type: .boolean),
            MenuItem("hogehoge", value: "true", type: .boolean)
        ])
        return [phase1, phase2]
    }
}
