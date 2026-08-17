//
//  ApolloSplashdownView.swift
//  moonshot
//
//  Created by Adam on 02/06/2026.
//

import SwiftUI

struct ApolloSplashdownView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission

    var landingType: String {
        ["Mercury","Gemini","Apollo","Apollo Applications","Commercial Crew"].contains(mission.program) ? "Splashdown" : "Landing"
    }
    var body: some View {
        OptionalMissionLocationView<Any>( locationType: "landing", location: spaceDataStore.landingSites[mission.landingSite ?? "x"],
                                          mission: mission)
        
        List{
            Section("Reentry"){

                
                if let eiTime = mission.timeEI{
                    StatsRepeatableElement(item: eiTime,  label: "GET at Entry interface")
                    }
            
                if let reentryAngle = mission.reentryAngle{
                    StatsRepeatableElement(
                        item: reentryAngle,
                        label: "Reentry angle",
                            append: "˚",
                            appendWithBrackets: false,
                            withSeparator: false,
                    )
                }

                if let reentryHeading = mission.reentryHeading{
                    StatsRepeatableElement(
                        item: reentryHeading,
                        label: "Reentry heading",
                            append: "˚",
                            appendWithBrackets: false,
                            withSeparator: false,
                    )
                }
                if let reentryMass = mission.massCMEntry{
                    if let thisUnit = mission.massCMEntryUnit{
                        StatsRepeatableElement(item:
                            mission.getMeasurementString(
                                thisInt: reentryMass,
                                type: .mass,
                                sourceUnit: thisUnit
                            ),
                            label: "Mass at entry interface"
                        )
                    }
                }
                if let interfaceV = mission.reentryInterface_v_fps{
                    if let convertedValue = mission.getMeasurementString(
                        thisInt: interfaceV,
                        type: .length, sourceUnit: "feet") {
                        StatsRepeatableElement(item: convertedValue, label: "Reentry Interface velocity", append: "/s", withSeparator: false)
                    }
                }
            if let LOS = mission.blackoutStart{
                    StatsRepeatableElement(item: LOS, label: "LOS")
            }
            if let AOS = mission.blackoutEnd{
                    StatsRepeatableElement(item: AOS, label: "AOS")
            }

            if let maxG = mission.maxG{
                    StatsRepeatableElement(item: maxG, label: "Peak g-load",
                           append: " g",
                           appendWithBrackets: false,
                           withSeparator: false,
                    )
                }
                
            if let reentryRange = mission.reentryRange{
                if let thisUnit = mission.reentryRangeUnit{
                    StatsRepeatableElement(item: mission.getMeasurementString(thisInt:reentryRange , type: .length, sourceUnit: thisUnit, distAsKM: true), label: "Reentry range")
                }
            }
                if let eiToSplashdown = mission.sEIToSplashdown{
                    StatsRepeatableElement(item:  eiToSplashdown, label: "EI to splashdown",
                               append :"s",
                               withSeparator:true)
                    }
                if let drogueTime = mission.drogue{
                    StatsRepeatableElement(item:  drogueTime, label: "Drogue deploy")
                    }
                if let mainChuteTime = mission.main{
                    StatsRepeatableElement(item:  mainChuteTime, label: "Main chute deploy")
                    }

            }
            Section("Splashdown"){
                if let splashDate = mission.landingDate {
                    StatsRepeatableElement(
                        item: mission.getFormattedDate(inputDate: splashDate),
                        label: "\(landingType) date")
                }
                if let splashTimeGET = mission.landingGET{
                    StatsRepeatableElement(item: splashTimeGET, label: "Splashdown GET")
                }
                if let splashdownRange = mission.splashdownRange {
                    StatsRepeatableElement(item: mission.getMeasurementString(thisInt: splashdownRange, type: .length, sourceUnit: mission.splashdownRangeUnit ?? mission.programDefaultLength, distAsKM: true), label: "Range ")
                }
                if let distanceTravelled = mission.distance, let distSourceUnit = mission.distanceUnit {
                    if let thisDouble = Double(distanceTravelled)  {
                        let thisInteger = Int(thisDouble * 1000000)
                            StatsRepeatableElement(item:
                                                    mission.getMeasurementString(thisInt: thisInteger, type: .length, sourceUnit: distSourceUnit, distAsKM: true)
                                                   , label: "Distance travelled")
                    }
                }
                StatsRepeatableElement(
                    item: mission.flotationAttitude,
                    label: "Flotation attitude"
                )
                if let minsToUpright = mission.minutesToUpright{
                    StatsRepeatableElement(
                        item: minsToUpright,
                        label: "Time to Stable-1",
                        append: "min", withSeparator: true)
                }
                if let landingMass = mission.landingMass{
                    if let landingMassUnit = mission.landingMassUnit{
                        if let tidyValue = mission.getMeasurementString(
                            thisInt: landingMass,
                            type: .mass, sourceUnit: landingMassUnit)
                        {
                            StatsRepeatableElement(item: tidyValue,
                                                   label: "\(landingType) mass")
                        }
                    }
                } else {
                    StatsRepeatableElement(item: "Unknown",
                                           label: "\(landingType) mass")
                }
                StatsRepeatableElement(
                    item: mission.splashdown_NM_to_target,
                    label: "Distance from target point",
                    append: "nm", appendWithBrackets: false
                )
                StatsRepeatableElement(
                    item: mission.splashdownNM_to_recoveryShip,
                    label: "Distance to carrier", append:"nm"
                )
                StatsRepeatableElement(
                    item: mission.minutesToCarrier,
                    label: "Astronauts onboard carrier", append:"min"
                )

            }
        }.frame(minHeight: 360)

    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let thisValue = "Apollo 14"
    let thisMission: [Mission] = previewStore.missions.filter {mission in
        mission.displayName.contains(thisValue)}
    if thisMission.count > 0
    { ApolloSplashdownView(mission: thisMission[0]).environmentObject(previewStore)
    } else {
        Text("error")
    }
}
