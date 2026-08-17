//
//  moonshotv2.swift
//  moonshot
//
//  Created by Adam on 15/04/2026.
//

import Foundation
import SwiftUI
import MapKit


// mainAPP
@main
struct moonshotApp: App {
    @StateObject var spaceDataStore = SpaceDataStore()   // make state object from class instance
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Missions", systemImage: "book.pages.fill" ){
                    ContentView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Astronauts", systemImage: "person" ){
                    AstronautListView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Spacecraft", image: "rocket" ){
                    SpacecraftListView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Map", systemImage: "globe" ){
                    AllMapView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                                    }
                Tab("Expeditions", systemImage: "sum" ){
                    ExpeditionListView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Program", systemImage: "p.square.fill" ){
                    ProgramListView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                                    }
//                Tab("Dev", systemImage: "triangle" ){
//                    dev_scratchView()
//                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
//                                    }
                Tab("Annot", systemImage: "triangle" ){
                    AnnotatedTextView()
                }
                        

                Tab("UD test", systemImage: "triangle" ){
                    UDTestView() // add datastore to environemnt, so directly callable from all views
                                    }
                Tab("Conll test", systemImage: "triangle" ){
                    SentenceInputView()}
//                        
//
//                        conllSentObject:
//                                            makeConllSent(conllLines:
//                                                            makeConllLinesFromRaw(rawConllString: "# sent_id = 1\n1\tParis\tParis\tPROPN\t_\t_\t4\tnsubj\t_\t_\n2\test\têtre\tAUX\t_\tMood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin\t4\tcop\t_\t_\n3\tla\tle\tDET\t_\tDefinite=Def|Gender=Fem|Number=Sing|PronType=Art\t4\tdet\t_\t_\n4\tcapitale\tcapitale\tNOUN\t_\tNumber=Sing\t0\troot\t_\t_\n5\tfrançaise\tfrançais\tADJ\t_\tGender=Fem|Number=Sing\t4\tamod\t_\t_\n6\t.\t.\tPUNCT\t_\t_\t4\tpunct\t_\t_\n")))
//                        
//                     // add datastore to environemnt, so directly callable from all views
//                                    }

                
                Tab("Traj", systemImage: "triangle" ){
                    let previewStore = SpaceDataStore()
                    let theseMissions = previewStore.missions.filter {$0.name == "apollo17"}
                    if theseMissions.count > 0
                    {if let components = theseMissions[0].identifiedComponents{
//                        MapTrajectoryView3D( mission: theseMissions[0]).environmentObject(previewStore)
// for non v2file
                                                MapTrajectoryView3D( mission: theseMissions[0], targetComponents: components).environmentObject(previewStore)
                    }
                    }
                    else {Text("No missions found")}

                }
            }
        }
    }
}



