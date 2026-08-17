//
//  ProgramListView.swift
//  moonshot
//
//  Created by Adam on 13/05/2026.
//

import SwiftUI

struct ProgramListView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let allPrograms = spaceProgramsUSA + spaceProgramsRU + ["Shenzhou"]
    var body: some View{
        NavigationStack{
            List{
                ForEach(allPrograms.sorted {$0.lowercased() < $1.lowercased()}, id:\.self) {program in
                    NavigationLink {
                        ProgramView(thisProgram: program)}
                    label: {
                        Text(program)
                    }
                    .frame(maxHeight: 20)
                }
            }.navigationTitle("Programs")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    ProgramListView().environmentObject(SpaceDataStore())
}
