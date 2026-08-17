//
//  MissionDetailView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//
//TODO: function to show the total and average number of spaceflights per crew member for each flight
// display landing date
import SwiftUI
import MapKit
//MARK: MissionDetailView
struct MissionView: View {
    
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    let astronauts: [String: Astronaut]
    let columnsetA = Array(
        repeating: GridItem(.flexible(minimum: 70), spacing: 8),
        count: 4
    )

    let columnsetB = Array(
        repeating: GridItem(.flexible(minimum: 58), spacing: 8),
        count: 5
    )
    
    let missionDetailSections: [String] = ["Spacecraft", "LaunchVehicle", "Landing", "Statistics"]
    var spacecraft: Spacecraft {
        spaceDataStore.spacecrafts[mission.spacecraft]!
    }
    var body: some View{
        NavigationStack{
            ScrollView{
//                MARK : Sequences
//                VStack{
//                    if let azimuth = mission.flightAzimuth{
//                        Text("Launch azimuth \(azimuth)")
//                    }
//                    if let landingdate = mission.landingDate{
//                        Text("landingdate = \( mission.getFormattedDate(inputDate: mission.landingDate))")
//                    }
//
//
//                }
                //MARK: mission patch section
                VStack {
                    MissionDetailPatchSection(mission: mission)
                    MissionDetailTextSection(mission: mission)
                    //MARK: crew segment
                    MissionDetailCrewSection(mission: mission, astronauts: spaceDataStore.astronauts)
                    //MARK: Spacecraft picture
                    MissionDetailSpacecraftSection(mission: mission, showLocation: false)
                                        
                    //MARK: mission location for lunar modules::
                    if [ "apollo11", "apollo12", "apollo14", "apollo15", "apollo16", "apollo17"].contains(mission.name){
                        // show location for lunar landing using image
                        
                        let subspacecraft = spaceDataStore.subsidiarySpaceCrafts[mission.name]!
                        let targetImage = subspacecraft.spacecraft + "Location"
                        Text("Lunar Module descent stage location:")
                        Image(targetImage)
                            .resizable()
                            .scaledToFit()
                    }
                }.containerRelativeFrame(.horizontal) {width, axis in
                    width * 1.0 }

                //MARK: tiles for specific views::
                NavigationStack{

                    LazyVGrid(columns: columnsetB, spacing: 8){
                        NavigationLink{
                            LaunchVehicleView(mission: mission)
                        } label: {
                            MissionDetailTile(text: "Launch", useImage: "rocket", imgSource: "assets")
                        }
                        NavigationLink{
                            OrbitDetailView(mission: mission)
                        } label: {
                            MissionDetailTile(text: "Orbit", useImage: "network")//"location.circle.fill")
                        }
                        NavigationLink{
                            LandingDetailView(mission: mission)
                        } label: {
                            MissionDetailTile(text: "Landing", useImage: "mappin.and.ellipse.circle.fill")//"location.circle.fill")
                        }
                        NavigationLink{
                            MissionStatisticsView(mission: mission)
                        } label: {
                            MissionDetailTile(text: "Stats", useImage: "chart.bar.horizontal.page.fill")
                        }
                        NavigationLink{
                            SpacewalkDetailView(mission: mission)
                        } label: {
                            MissionDetailTile(text: "EVAS", useImage: "figure.walk")
                        }
                    }.foregroundStyle(.primary)
                }
                .navigationTitle(mission.displayName)
            }.padding(.bottom) // scrollview
                .background(.darkBackground)
                .preferredColorScheme(.dark)
        }
    } // body
}// view


#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("Apollo 16")}
    if theseMissions.count > 0 {
    MissionView(mission: theseMissions[0], astronauts: previewStore.astronauts).environmentObject(previewStore)
            } else {
                Text("No missions found in preview store.")
    }
}
