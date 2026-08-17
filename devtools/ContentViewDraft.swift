////
////  ContentView.swift
////  moonshot
////
////  Created by Adam on 13/04/2026.
////
//
//import SwiftUI
//// image size : can't use just .frame(sizes…) :: need to add .clipped() to get sub-chunk @ size
////:: .resizable() and one of :: scaleToFit : whole thing in box, even if whitespace added ; scaleToFill: thing takes up whole box, ignore bits sticking out
//// these work nicely with fixed sizes
//
//// if we want to avoid fixed sizes but have, say 80 percetn of screen, need ContainerRelativeFrame
//
//// eg get 80% width:: .containerRelativeFrame(.horizontal){size, axis in size * 0.8} // size is size of container == parent
//// NavStack adds navBar at top of view as well as allow for screen to screen nav
//
//struct CustomText: View {
//    let text: String
//    var body: some View {
//        Text(text)
//    }
//    init(text: String){
//        print("Creating a new custom text")
//        self.text = text
//    }
//}
//// lazy stacks : don't make stack until about to appear on screen, cf all on load::
//// note that lazy stacks always take up as much space as possible
//struct LazyVStackView: View {
//    var body: some View {
//        ScrollView{
//            LazyVStack(spacing: 10) {
//                ForEach(0..<100) {
////                    Text("Item \($0)").font(.title)
//                    CustomText(text: "Item \($0)").font(.title)
//                }
//            }.frame(maxWidth: .infinity) // set vstack max width to inf to make wide in ScrollView
//        }
//    }
//}
//
//
//struct NavStackView: View {
//    var body: some View{
//        NavigationStack{
//            NavigationLink {
//                Text("Detail View")} label: {
//                    VStack{
//                        Text("this is the label")
//                        Text("So is this")
//                        Image(systemName: "face.smiling")
//                    }
//                }
//            
//                .navigationTitle("Foobar")
//        }
//    }
//}
//
//struct NavStackAndNavLinkView: View{
//    var body: some View{
//        NavigationStack{
//            List(0..<100){ row in
//                // option 1 NavigationLink(textForRow){Text("TextForDestination")}
//                NavigationLink("Row \(row)"){
//                    Text("Detail row number \(row)")
//                }
//                
//            }
//        }.navigationTitle("Foobar")
//
//    }
//    
//}
//
//struct User: Codable {
//    let name: String
//    let address: Address
//}
//
//struct Address: Codable {
//    let street: String
//    let city: String
//}
//
//struct JSONDecodingView: View{
//    @State var displayString: String = "unk"
//    var body: some View{
//        Button("Decode JSON"){
//            let input = """
//            {"name":"Taylor Swift",
//            "address": {
//            "street":"555 Swift Avenue","city":"Nashville"
//                }
//            }           
//            """
//            let data = Data(input.utf8)
//            let decoder = JSONDecoder()
//            if let user = try? decoder.decode(User.self, from: data){
//                displayString = "Decoded data : \(user.address.street)"
//            }
//        }
//        Text(displayString)
//}
//}
//    
//// MARK: Grids : LazyVGrid
//struct LazyVGridView: View{
//    /// option1 : define one axis in layout, here, columns, then use perpendicular stack in LazyGrid, but this is with a fixed size
//    let layout = [
//        GridItem(.fixed(80)),
//        GridItem(.fixed(80)),
//        GridItem(.fixed(80))
//    ]
//    // option 2: define min width and rest is auto
//    let layout1 = [
//        GridItem(.adaptive(minimum: 80))
//    ]
//
//    var body: some View{
//        ScrollView{
//            LazyVGrid(columns: layout1){
//                ForEach(0..<1000){
//                    Text("Item \($0)")
//                }
//            }
//        }
//    }
//}
//
//// MARK: Grids : LazyHGrid
//
//
//struct LazyHGridView: View{
//    /// option1 : define one axis in layout, here, columns, then use perpendicular stack in LazyGrid, but this is with a fixed size
//    let layout = [
//        GridItem(.fixed(80)),
//        GridItem(.fixed(80)),
//        GridItem(.fixed(80))
//    ]
//    // option 2: define min width and rest is auto
//    let layout1 = [
//        GridItem(.adaptive(minimum: 80))
//    ]
//
//    var body: some View{
//        ScrollView(.horizontal){
//            LazyHGrid(rows: layout1){
//                ForEach(0..<1000){
//                    Text("Item \($0)")
//                }
//            }
//        }
//    }
//}
//
////MARK : begin proper
//




//struct ContentView: View{
//    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json") // decode json
//    let missions: [Mission] = Bundle.main.decode("missions.json")
//    
//    let columns = [
//        GridItem(.adaptive(minimum: 150))]
//
//    var body: some View{
//        
//        NavigationStack{
//            ScrollView{
//                LazyVGrid(columns: columns){
//                    ForEach(missions){mission in
//                        NavigationLink{
//                            MissionView(mission: mission, astronauts: astronauts)
//                        } label: {
//                            VStack{
//                                Image(mission.image)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 100, height: 100)
//                                    .padding()
//                                
//                                VStack{
//                                    Text(mission.displayName).font(.headline).foregroundStyle(.white)
//                                    Text(mission.formattedLaunchDate).font(.caption).foregroundStyle(.gray)
//                                }
//                                
//                                .padding(.vertical)
//                                .frame(maxWidth: .infinity)
//                                .background(.lightBackground)
//                            }
//                            .clipShape(.rect(cornerRadius: 10))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10) // add rounded corners to cards
//                                    .stroke(.lightBackground)
//                            )
//                        }
//                    }
//                }.padding([.horizontal, .bottom])
//            }.navigationTitle("Moonshot")
//                .background(.darkBackground)
//                .preferredColorScheme(.dark)
//        }
//    }
//}
//#Preview {
//    ContentView()
//}
//struct MissionView: View {
//    
//    let mission: Mission
//    // struct to merge data from 2 jsonfiles here
//    struct CrewMember: Identifiable {
//        let id = UUID()
//        let role: String
//        let astronaut: Astronaut
//    }
//    let crew: [CrewMember]
//    let backupcrew: [CrewMember]
////    let assignments: [[CrewMember]]
//    var body: some View{
//        ScrollView{
//            VStack {
//                Image(mission.image)
//                    .resizable()
//                    .scaledToFit()
//                    .containerRelativeFrame(.horizontal) {width, axis in
//                        width * 0.6 }
//                VStack(alignment: .leading){
//                    Rectangle()
//                        .frame(height:2)
//                        .foregroundStyle(.lightBackground)
//                        .padding(.vertical)
//                    Text("Mission Highlights").font(.title.bold())
//                        .padding(.bottom, 5)
//                    Text(mission.description)
//                    Rectangle()
//                        .frame(height:2)
//                        .foregroundStyle(.lightBackground)
//                    //.padding(.above)
//                }
//                .padding(.horizontal)
//            }
//            VStack(alignment: .leading){
//                Text("Crew").font(.title3.bold())
//                    .padding(.bottom, 5)
//                    .padding(.leading, 20)
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack{
//                        ForEach(crew, id: \.role) { crewMember in
//                            NavigationLink{
//                                Text("Astronaut details")
//                                AstronautView(astronaut: crewMember.astronaut)
//                            } label: {
//                                HStack {
//                                    Image(crewMember.astronaut.id)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 104, height: 72)
//                                        .clipShape(.capsule)
//                                        .overlay(
//                                            Capsule()
//                                                .strokeBorder(.white, lineWidth: 1)
//                                        )
//                                    VStack(alignment: .leading){
//                                        Text(crewMember.astronaut.name)
//                                            .foregroundStyle(.white)
//                                            .font(.headline)
//                                        Text(crewMember.role)
//                                            .foregroundStyle(.secondary)
//                                    }
//                                    //TODO: add backup crew here
//                                    
//                                }.padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//                Text("Backup Crew").font(.title3.bold())
//                    .padding(.bottom, 5)
//                    .padding(.leading, 20)
//                
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack{
//                        ForEach(backupcrew, id: \.role) { crewMember in
//                            NavigationLink{
//                                Text("Astronaut details")
//                                AstronautView(astronaut: crewMember.astronaut)
//                            } label: {
//                                HStack {
//                                    Image(crewMember.astronaut.id)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 104, height: 72)
//                                        .clipShape(.capsule)
//                                        .overlay(
//                                            Capsule()
//                                                .strokeBorder(.white, lineWidth: 1)
//                                        )
//                                    VStack(alignment: .leading){
//                                        Text(crewMember.astronaut.name)
//                                            .foregroundStyle(.white)
//                                            .font(.headline)
//                                        Text(crewMember.role)
//                                            .foregroundStyle(.secondary)
//                                    }
//                                    //TODO: add backup crew here
//                                    
//                                }.padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//                
//            }.padding(.bottom)
//        }
//        .background(.darkBackground)
//    }
//    init (mission: Mission, astronauts: [String: Astronaut]){
//        self.mission = mission
//        self.crew = mission.crew.map { member in
//            if let astronaut = astronauts[member.name] {
//                return CrewMember(role: member.role, astronaut: astronaut)
//            } else {
//                fatalError("Missing \(member.name)")
//            }
//        }
//        self.backupcrew = mission.backupcrew.map { member in
//            if let astronaut = astronauts[member.name] {
//                return CrewMember(role: member.role, astronaut: astronaut)
//            } else {
//                fatalError("Missing \(member.name)")
//            }
//        }
//        //    self.assignments = [crew, backupcrew]
//    }
//}
//
//#Preview {
//    let missions: [Mission] = Bundle.main.decode("missions.json")
//    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
//    return MissionView(mission: missions[0], astronauts: astronauts)
//        .preferredColorScheme(.dark)
//}
//
// 
//struct AstronautView: View {
//    let missions: [Mission]
//    let astronaut: Astronaut
//    let additionalMissions: [Mission]
//    var body: some View {
//        ScrollView{
//            VStack{
//                Image(astronaut.id)
//                    .resizable()
//                    .scaledToFit()
//                Text(astronaut.description)
//                    .padding(.horizontal)
//                HStack {
//                    Text("Additional assignment1")
//                }
//            }
//        }
//            .background(.darkBackground)
//            .navigationTitle(astronaut.name)
//            .navigationBarTitleDisplayMode(.inline)
//    }
//// initialiser
//    init(astronaut: Astronaut){
//        self.astronaut = astronaut
//        
//        let filteredMissions = missions.filter { mission in
//            mission.crew.contains { crewMember in
//                crewMember.name == astronaut.name
//            }
//        }
//        self.additionalMissions = filteredMissions
//    }
//
//    
//        
//
//    
//}
////
////#Preview{
////    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
////    return AstronautView(astronaut: astronauts["pogue"]!)
////        .preferredColorScheme(.dark)
////    
////    
////}
//
//import SwiftUI
//
//struct Response: Codable{
//    var results: [Result]
//}
//
//struct Result: Codable{
//    var trackId: Int
//    var trackName: String
//    var collectionName: String
//}
//
//struct testView: View{
//    @State private var results = [Result]()
//    
//    var body: some View{
//        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 5) // get image from url string - no mods re scale, so @source size :: until we add the scale factor : not sensitive to frame, resizable::
//        // to get more nuanced control:: use closure with args to get image in
//        AsyncImage(url: URL(string:"https://hws.dev/img/logo.png")) {image in
//            image
//                .resizable()
//                .scaledToFit()
//        } placeholder: {
//            Color.red // added to make placeholder more easily visible as it flashes in
//            // or ProgressView()
//        }
//        .frame(width:200, height: 200) // now th eframe applies to the image returned, rather than the call to get the image
//
//        AsyncImage(url: URL(string:"https://hws.dev/img/logo.png")) {phase in
//            if let image = phase.image {
//                image
//                    .resizable()
//                    .scaledToFit()
//            } else if phase.error != nil{
//                Text("There was an error")
//            } else {ProgressView()}
//         //3 use phrase to keep tabs:: if image, show scaled, if error, print, if downloading, show Progress
//        }.frame(width: 250, height:250)
//        
//        List(results, id:\.trackId){ item in
//            VStack(alignment: .leading){
//                Text(item.trackName).font(.headline)
//                Text(item.collectionName)
//            }
//        }
//        .task {
//            await loadData() //human tells machine that this thing might be asleep…
//        }
//    }
//    // here's a function that might not be instant in giving a response
//    func loadData() async {
//        // url making :: attentio to API which was throwing wobblies in april 2026
//        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
//            print("Invalid URL")
//            return
//        }
//        do{
//            // get the data, dump the metadata that comes from request
//            let (data, _) = try await URLSession.shared.data(from: url)
//            // do more stuff here
//            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
//                results = decodedResponse.results
//            }
//        } catch {
//            print("Bad data")
//        }
//    }
//}
//
////#Preview{
////    testView()
////}
//
//struct FormView: View {
//    @State private var username = ""
//    @State private var email = ""
//    
//    var disableForm: Bool{
//        username.count < 5 || email.count < 5 || !email.contains("@") || !email.contains(".")
//    }
//    var body: some View{
//        Form{
//            Section{
//                TextField("Username", text:$username)
//                TextField("Email", text:$email)
//            }
//            
//            Section{
//                // button with a disable modifier, cf a simple hide
//                Button("Create account"){
//                    print("Creating account")
//                }
//                //            }.disabled(username.isEmpty || email.isEmpty)
//            }.disabled(disableForm)
//        }
//    }
//}
////#Preview{
////    FormView()
////}
//
//// adding codable conformance to @Observer class and haptics
//
//// for codable conformance
//@Observable
//class User: Codable {
//    enum CodingKeys: String, CodingKey {
//        case _name = "name" // ''computer, when you see _name, use this value instead: "name", or "moo", or "foo_bar2"
//    }
//    var name = "Taylor"
//}
//
//struct ObserverCodableView: View{
//    @State private var counter = 0
//    var body: some View{
//        Button("Encode Taylor", action: encodeTaylor)
//        
//        Button("Tap Count: \(counter)"){
//            counter += 1
//        }.sensoryFeedback(.increase, trigger: counter)
//            // lots of builtin feedback variants, be v wary about changing (ie swapping success to fail…) : against user expectations, unless they changed it themselves
//            .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)// can add lots of diff combinations
//    } // coreHaptics can be used, but vv detailed
//
//    // for codable conformance
//    func encodeTaylor(){
//        let data = try! JSONEncoder().encode(User())
//        let str = String(decoding: data, as: UTF8.self) // get the json in string form
//        print(str)
//        // what gets printed is {"_$observationRegistrar":{},"_name":"Taylor"}
//        // this is because Observable macro is rewriting, _ are behind the scenes: _name, etc
//        // to get things out cleanly, add code to class def :: use enum of coding keys : enum must be called CodingKeys, protocol is CodingKey :> returns {"name":"Taylor"}
//    }
//}
//
//#Preview{
//    ObserverCodableView()
//}
//
//import CoreHaptics
//struct HapticsView: View {
//    @State private var hapticCounter = 0
//    @State private var engine: CHHapticEngine?
//    
//    var body: some View{
//        Button("NormalbuttonTap Count: \(hapticCounter)"){
//            hapticCounter += 1
//        }.sensoryFeedback(.increase, trigger: hapticCounter)
//
//        Button("Play custom hapric"){
//            complexSuccess()
//        }.onAppear(perform: prepareHaptics)
//
//    }
//    func prepareHaptics(){
//        // check device can deal with haptics
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return }
//        do {
//            engine = try CHHapticEngine()
//            try engine?.start()
//        } catch {
//            print("There was an error with the haptic engine: \(error.localizedDescription)")
//        }
//    }
//    func complexSuccess(){
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return }
//        
//        var events = [CHHapticEvent]()
//        for i in stride(from:0, to:1, by:0.1){
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
//            events.append(event)
//        }
//        for i in stride(from:0, to:1, by:0.1){
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1-i))
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1-i))
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1-i)
//            events.append(event)
//        }
//        do {
//            let pattern = try CHHapticPattern(events: events, parameters: [])
//            let player = try engine?.makePlayer(with: pattern)
//            try player?.start(atTime: 0)
//        } catch {
//            print("failed in complexsuccess")
//        }
//        
//        
//    }
//        
//}
//#Preview{
//    HapticsView()
//}
