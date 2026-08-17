
//
//  StageDetailView.swift
//  moonshot
//
//  Created by Adam on 09/06/2026.
//

import SwiftUI
import MapKit

//TODO: add locaiton for lunar impacts by mission:: LM upper, sIVb

struct StageDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var displayMode: String = "serial"

    let mission: Mission
    let component: IdentifiedComponent

    var componentPhases: [LaunchPhase] {
        var internalList: [LaunchPhase] = []
        if let launchPhases = mission.launchPhases{
            internalList = launchPhases.filter {$0.description == component.description}
        }
     return internalList
    }
    
    var componentLabels: [String] {
        if mission.program == "Apollo" || mission.program == "Apollo Applications" {
            ["LES", "CM", "SM", "SLA", "IU", "Third Stage", "Second Stage", "First Stage"]
        }
        else
            {
                ["Spacecraft", "Second Stage", "First Stage", "Launch Vehicle"]
            }
    }
    let targetComponents = ["First Stage", "Second Stage", "Third Stage", "LES", "SLA", "SM","LM", "IU", "CM"]
    let burnStages = ["First Stage", "Second Stage", "Third Stage", "SM"]
    var ascentStageProperties: [(label: String, value: Int)] { [
        ("Fuel", component.ascentFuel),
        ("Oxidiser", component.ascentOxidiser),
        ("Propellants", component.ascentPropellantTotal),
        ("Dry Mass", component.ascentStageDryMass),
        ("Launch Mass", component.ascentStageDryMass! + component.ascentPropellantTotal!)
    ].compactMap { label, optionalValue in
        if let value = optionalValue { return (label, value) }
        return nil
        }
    }
    var descentStageProperties: [(label: String, value: Int)] {[
        ("Fuel", component.descentFuel),
        ("Oxidiser", component.descentOxidiser),
        ("Propellants", component.descentPropellantTotal),
        ("Dry Mass", component.descentStageDryMass),
        ("Launch Mass", component.descentStageDryMass! + component.descentPropellantTotal!)
    ].compactMap { label, optionalValue in
        if let value = optionalValue { return (label, value) }
        return nil
        }
    }
    var massProperties: [(label: String, value: Int)] { [
        ("Oxidiser", component.oxidiser),
        ("Fuel", component.fuel),
        ("Dry Mass", component.dryMass),
        ("Overall Mass", component.mass)
    ].compactMap { label, optionalValue in
        if let value = optionalValue { return (label, value) }
        return nil
        }
    }
//    var paPairs: [(Int, Int)] {
//        let paPairs: [(Int, Int)]
//        if ["apollo7", "skylab2", "skylab3", "skylab4"].contains(mission.name){
//            paPairs = [(0,1), (1,4)]
//        } else {
//                paPairs = [(0,1), (1,4), (4,7)]
//            }
//        return paPairs
//    }
//
//    var apexPairs: [(Int, Int)] {
//        let apexPairs: [(Int, Int)]
//        if ["apollo7", "skylab2", "skylab3", "skylab4"].contains(mission.name){
//            apexPairs = [(1,2)]
//        } else {
//            apexPairs = [(1,2), (4,5)]
//            }
//        return apexPairs
//    }
//
//    var impactPairs: [(Int, Int)] {
//        let impactPairs: [(Int, Int)]
//        if ["apollo7", "skylab2", "skylab3", "skylab4"].contains(mission.name){
//            impactPairs = [(2,3)]
//        } else {
//            impactPairs = [(2,3), (5,6)]
//            }
//        return apexPairs
//    }
    
    var cutoffPropertiesV2:[(item:String, label:String)]{
        let burnPhase = componentPhases.filter {$0.type == "Powered Ascent"}[0]
        var internalList: [(item: String, label:String)] = [
            (String(burnPhase.get) + " s"  , "Cutoff GET"),
            (mission.getMeasurementString(thisInt: Int(burnPhase.altitude), type: .length, sourceUnit: burnPhase.altitudeUnit, distAsKM: true), "Altitude"),
             (mission.getMeasurementString(thisInt: Int(burnPhase.range), type: .length, sourceUnit: burnPhase.rangeUnit, distAsKM: true),"Distance from launch"),
             (mission.getMeasurementString(thisInt: Int(burnPhase.velocity), type: .length, sourceUnit: burnPhase.velocityUnit, distAsKM: false),"Cutoff velocity"),
             (String(burnPhase.burnDuration ?? 0) + " s"  , "Burn duration"),

        ].compactMap {optionalValue, label in
            if let value = optionalValue {return (value, label)}
            return nil
        }
        
        return internalList
    }
    
    var apexPropertiesUpdate: [(item: String, label: String)] {
        if let lvtype = mission.saturnType{
            let svList = ["First Stage", "Second Stage"]
            let ibList = ["First Stage"]
            let useList = lvtype == "v" ? svList : ibList
            if useList.contains(component.description) == false {return [(item: String, label: String)]() }
            else {
                
                let apexPhase = componentPhases.filter {$0.type == "Apex"}[0]
                let internalData:[(item: String, label: String)] =
                [
                    (mission.getMeasurementString(thisInt: Int(apexPhase.altitude), type: .length, sourceUnit: apexPhase.altitudeUnit, distAsKM: true), "Altitude"),
                    (String(apexPhase.get) + " s"  , "GET"),
                    (mission.getMeasurementString(thisInt: Int(apexPhase.range), type: .length, sourceUnit: apexPhase.rangeUnit, distAsKM: true),"Distance from launch")
                ].compactMap {optionalValue, label in
                    if let value = optionalValue {return (value, label)}
                    return nil
                    
                }
                
                return internalData
            }
        } else {
            return [(item: String, label: String)]()
        }
    }
    
    var impactPropertiesUpdate:[(item: String, label: String)]{
        
        if ["First Stage", "Second Stage"].contains (component.description) {
            
            let impactPhase = componentPhases.filter {$0.type == "Impact"}[0]
            let internalData: [(String, String)] = [
                (String(impactPhase.get) + " s"  , "GET"),
                (mission.getMeasurementString(thisInt: Int(impactPhase.range), type: .length, sourceUnit: impactPhase.rangeUnit, distAsKM: true), "Distance from launchsite")
                
            ].compactMap { value, label in
                guard let value = value else { return nil }
                return (value, label)
            }
            return internalData
        } else {
            return [(item: String, label: String)]()
        }
    }
    
    var lmDryMass: Int {
        var dryMass: Int = 0
        if let dMass = component.descentStageDryMass{
            if let aMass = component.ascentStageDryMass{
                dryMass = dMass + aMass
            }
        }
        return dryMass
    }

    var lmPropMass: Int {
        var propMass: Int = 0
        if let dMass = component.descentPropellantTotal{
            if let aMass = component.ascentPropellantTotal{
                propMass = dMass + aMass
            }
        }
        return propMass
    }

    var body: some View {

        if component.description == "Launch Vehicle"{
            List{
                if let allComponents = mission.identifiedComponents{
//                    Text("Launch vehicle selected")
//                    Text("\(allComponents.count) components")
                    ForEach(componentLabels, id: \.self) { label in
                        if let component = allComponents.first(where: { $0.description == label }),
                           let mass = component.mass {
                            StatsRepeatableElement(
                                item: mission.getMeasurementString(thisInt: Int(mass), type: .mass, sourceUnit: mission.programDefaultMass),
                                label: label
                            )
                        }
                    }
                }
            }
        }
        
        else if targetComponents.contains(component.description) {
            Text(component.serial)

            List{
                if component.description != "LM"{
                    Section("Mass"){
                        ForEach(massProperties, id: \.label) { property in
                            StatsRepeatableElement(
                                item: mission.getMeasurementString(thisInt: property.value, type: .mass, sourceUnit: mission.programDefaultMass),
                                label: property.label
                            )
                        }
                    }
                    // burn, apex,
                    if burnStages.contains(component.description) && component.description != "SM" {
                        Text("phases \(componentPhases.count)")
                        Section("Cutoff"){
                            ForEach(cutoffPropertiesV2, id:\.label){entry in
                                StatsRepeatableElement(
                                    item: entry.label == "cutoffV" ? entry.item + "/s" : entry.item,
                                   label: entry.label)
                            }
                        }
                    }
                    
                    if apexPropertiesUpdate.count > 0 {
                        Section("ApeV2x"){
                            ForEach(apexPropertiesUpdate, id:\.label){ entry in
                                StatsRepeatableElement(item: entry.item, label: entry.label)
                            }
                        }
                    }

                    if impactPropertiesUpdate.count > 0 {
                        Section("Impact"){
                            ForEach(impactPropertiesUpdate, id:\.label){entry in
                                StatsRepeatableElement(item: entry.item, label: entry.label)
                            }
                        }
                    }
                } // end not lm
                
                if component.description == "LM"{   //get LM
                    var dryMassTotal: Int = 0
                    var propellantQuantity: Int = 0
                    
                    Section("Descent stage"){
                        ForEach(descentStageProperties, id: \.label) { property in
                            StatsRepeatableElement(
                                item: mission.getMeasurementString(thisInt: property.value, type: .mass, sourceUnit: mission.programDefaultMass),
                                label: property.label
                            )
                        }
                    }
                    Section("Ascent stage"){
                        ForEach(ascentStageProperties, id: \.label) { property in
                            StatsRepeatableElement(
                                item: mission.getMeasurementString(thisInt: property.value, type: .mass, sourceUnit: mission.programDefaultMass),
                                label: property.label
                            )
                        }
                    }
                    Section("LM total"){
                        if let mass = component.mass{
                            if let massUnit = component.massUnit{
                                StatsRepeatableElement(item: mission.getMeasurementString(thisInt: Int(mass), type: .mass, sourceUnit: massUnit), label: "Total Mass")
                            }
                        }
                        if lmDryMass > 0{
                            StatsRepeatableElement(item: mission.getMeasurementString(thisInt: lmDryMass, type: .mass, sourceUnit: "lb"), label: "Total Dry mass")
                        }
                        if lmPropMass > 0{
                            StatsRepeatableElement(item: mission.getMeasurementString(thisInt: lmPropMass, type: .mass, sourceUnit: "lb"), label: "Total propellant")
                        }
                    }
                }
                    
                if ["First Stage", "Second Stage", "Third Stage"].contains(component.description){
                    Section{
                        ParentFlightDashboardView(mission: mission)//.environmentObject(spaceDataStore)
                            .frame(height: 400) // Give it your solid height constraint
                            .listRowInsets(EdgeInsets())
                        // 2. Clear out the default row background tint if needed
                            .listRowBackground(Color.clear)
                    }
                }
            }
        }
    }
}

#Preview {
        let previewStore = SpaceDataStore()
        let theseMissions = previewStore.missions.filter {mission in
            mission.displayName.contains("Apollo 17")}
    if theseMissions.count > 0 {
        if let theseComs = theseMissions[0].identifiedComponents{
            let thisComponent = theseComs.filter({$0.description == "First Stage"})
                StageDetailView(mission: theseMissions[0], component: thisComponent[0]
                ).environmentObject(previewStore)
        }
    }
    else {
            Text("No missions found in preview store.")
        }
}
