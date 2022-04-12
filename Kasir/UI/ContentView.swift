import SwiftUI

extension Color {
    static let lightGray = Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255)
}

struct ContentView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
            VStack(alignment: .center) {
                TabView() {
                    HistoryView()
                     .tabItem {
                         Image(systemName: "timer")
                         Text("Riwayat")
                     }.tag(1)
                    CashierView().tabItem {
                        Image(systemName: "dollarsign.square")
                        Text("Kasir")
                     }.tag(1)
                    InventoryView().tabItem {
                       Image(systemName: "list.bullet")
                       Text("Inventori")
                    }.tag(1).background(.white).padding()
                }.background(.white)
            }.onAppear{
                //ItemDBManager().deleteDatabase()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
.previewInterfaceOrientation(.landscapeLeft)
    }
}
