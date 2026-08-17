//
//  OrbitDetailView.swift
//  moonshot
//
//  Created by Adam on 03/06/2026.
//

import SwiftUI
internal import _LocationEssentials

struct OrbitDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    let addLunarOrbit: [String ] = ["Apollo 8", "Apollo 10", "Apollo 11", "Apollo 12", "Apollo 14", "Apollo 15", "Apollo 16", "Apollo 17"]
    var firstSectionTitle: String {
        addLunarOrbit.contains(mission.displayName) ? "Earth Parking orbit" : "Earth orbit"
    }
    var body: some View {
        VStack{
            List{
                Section(firstSectionTitle){
                    
                    StatsRepeatableElement(item: mission.orbitalInclination, label: "Inclination", append: "˚", appendWithBrackets: false, withSeparator: false)
                    if let smaj = mission.orbitSmaj{
                        StatsRepeatableElement(
                            item:
                                mission.getMeasurementString(
                                    thisInt: Int(smaj),
                                    type: .length,
                                    sourceUnit: mission.orbitSmajUnit ??  mission.programDefaultLength, distAsKM: true),
                            label: "Semi-major axis")
                    }
                if let smin = mission.orbitSmin{
                    StatsRepeatableElement(
                        item:
                            mission.getMeasurementString(
                                thisInt: Int(smin),
                                type: .length,
                                sourceUnit: mission.orbitSminUnit ??  mission.programDefaultLength, distAsKM: true),
                        label: "Semi-minor axis")
                }
                if let orbitCount = mission.orbits{
                    StatsRepeatableElement(item: orbitCount, label: "Orbits")
                }
                if let distance = mission.distance{
                    
                    StatsRepeatableElement(item: mission.getMeasurementString(thisInt: Int(distance), type: .length, sourceUnit: mission.distanceUnit ?? mission.programDefaultLength), label: "Distance")
                }
                    StatsRepeatableElement(item: mission.durationLEO, label: "Duration in LEO")
                    if let vEOI = mission.vEOI, let vEOIUnit = mission.vEOIUnit{
                        StatsRepeatableElement(
                            item: mission.getMeasurementString(thisInt: vEOI, type: .length, sourceUnit: vEOIUnit), label: "Orbital velocity", append: "/s", withSeparator: false
                        )
                    }
                    
                        // need speed here

        } // end Earth orbit section
                if addLunarOrbit.contains(mission.displayName){
                    Section("TLI"){
                        if let cutoffTimeDbl = mission.tlicutoffTime{
                            let cutoffTimeInt = Int(cutoffTimeDbl)
                                StatsRepeatableElement(item: cutoffTimeInt, label: "TLI burn duration", append: "s", withSeparator: false)
                            
                    }
                        if let tliV = mission.tliV{
                            let tliVint = Int(tliV)
                            StatsRepeatableElement(
                                item: mission.getMeasurementString(thisInt: tliVint, type:.length, sourceUnit: "feet"),
                               label: "TLI Velocity", append: "/s", withSeparator: false)
                    }

                        
                        
                        if let coastTLI = mission.tliCoastDuration{
                            StatsRepeatableElement(item: coastTLI, label: "TLI coast time")
                    }
                    
                        
                    }
                    Section("LOI"){
                        if let vLOICutoff = mission.vLOICutoff, let vLOIIgnition = mission.vLOIIgnition, let loicutoffTime = mission.loicutoffTime{
                            
                            StatsRepeatableElement(item: mission.getMeasurementString(thisInt: vLOIIgnition, type: .length, sourceUnit: "fps"), label: "Initial velocity", append: "/s", withSeparator: false)
                            StatsRepeatableElement(item: loicutoffTime, label: "LOI burn duration", append: "s", withSeparator: false)
                            StatsRepeatableElement(item: mission.getMeasurementString(thisInt: vLOICutoff, type: .length, sourceUnit: "fps"), label: "LOI velocity", append: "/s", withSeparator: false)

                        }
                    }

                    Section("Lunar orbit"){
                        
                        StatsRepeatableElement(
                            item: makeDisplayItem(stringIn: mission.aposeleneKM ?? "-1", type: .length, sourceUnit: "km", distAsKM: true),
                            label: "Semi-major axis")

                        StatsRepeatableElement(
                            item: makeDisplayItem(stringIn: mission.periseleneKM ?? "-1", type: .length, sourceUnit: "km", distAsKM: true),
                            label: "Semi-minor axis")
                        StatsRepeatableElement(item: mission.inclLunarOrbit, label: "Inclination", append: "º", appendWithBrackets: false, withSeparator: false)
                        StatsRepeatableElement(item: mission.csmLunarOrbits, label: "CSM lunar orbits")
                        StatsRepeatableElement(item: mission.lunarOrbitDuration, label: "Duration in lunar orbit")
                        StatsRepeatableElement(item: mission.undockedTime, label: "Undocked time")

                        
                    }
                    Section("Lunar landing"){
                        if let pdiBurnTime = mission.pdiBurnTime{
                            StatsRepeatableElement(item: pdiBurnTime, label: "PDI burn duration", append:"s")

                        }
                        if let lmHoverTimeRemaining = mission.lmHoverTimeRemaining{
                            StatsRepeatableElement(item: Int(lmHoverTimeRemaining), label: "Hover time remaining", append:"s")
                        }
                        
                            if let lmLandingCoords = mission.makeLocation(lat: String(mission.lmLandingLat ?? 0), long: String(mission.lmLandingLong ?? 0), displayName: "_", type: "X"
                            ){
                                let thisText = "Lat. " +
                                String(format: "%.2f", lmLandingCoords.coordinate.latitude) + " Long. " + String(format: "%.2f", lmLandingCoords.coordinate.longitude)

                                StatsRepeatableElement(item: thisText, label: "Landing site")
                            }

                        if let dFromTarget = mission.lmDFromTarget{
                            
                            StatsRepeatableElement(item: mission.getMeasurementString(thisInt: Int(dFromTarget), type: .length, sourceUnit: "feet", distAsKM: false)
                                                   , label: "Distance from target")
                        }

                        StatsRepeatableElement(item: mission.lunarSurfaceTime, label: "Surface time") //
                        if let surfaceEVATime = mission.surfaceEVATime{
                            StatsRepeatableElement(item: surfaceEVATime, label: "EVA time")
                        }
                        if let massToSurface = mission.landingMassLM {
                            StatsRepeatableElement(item:
                                    mission.getMeasurementString(thisInt: massToSurface, type: .mass, sourceUnit: "lb"),
                                                   label: "Landing mass")
                        }
                                
                        
                    }
                    if addLunarOrbit.contains(mission.displayName){
                        Section("TEI"){
                            if let vTEICutoff = mission.vTEICutoff, let vTEIIgnition = mission.vTEIIgnition, let teicutoffTime = mission.teicutoffTime{
                                
                                StatsRepeatableElement(item: mission.getMeasurementString(thisInt: vTEIIgnition, type: .length, sourceUnit: "fps"), label: "Initial velocity", append: "/s", withSeparator: false)
                                StatsRepeatableElement(item: teicutoffTime, label: "TEI burn duration", append: "s", withSeparator: false)
                                StatsRepeatableElement(item: mission.getMeasurementString(thisInt: vTEICutoff, type: .length, sourceUnit: "fps"), label: "TEI velocity", append: "/s", withSeparator: false)

                            }
                            if let coastTLI = mission.teiCoastDuration{
                                StatsRepeatableElement(item: coastTLI, label: "TEI coast time")
                        }
                        
                        }
                        }
                     }
            }
        }.navigationTitle(mission.displayName)
            .background(.darkBackground)
            .preferredColorScheme(.dark)
    }
    func makeDisplayItem(stringIn: String, type: Mission.ConversionType, sourceUnit: String, distAsKM: Bool) -> String{
        if let outputString = mission.getMeasurementString(
            thisInt: mission.roundStringNumToInt(inputString: stringIn ?? "-1"),
            type: .length, sourceUnit: sourceUnit, distAsKM: distAsKM)
        {
            return outputString
        }
        else {
            return "error"
        }
    }
    
}
#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("Gemini 12")}
    if theseMissions.count > 0
    {
        OrbitDetailView(mission: theseMissions[0]).environmentObject(previewStore)
    }
}


