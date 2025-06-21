//
//  _UIExample.swift
//  ObjeKitTest
//
//  Created by Alex Nadzharov on 26/05/2025.
//

//class MaxViewModel: ObservableObject {
//    @Published var value: Int = 0
//
//    func updateFromDSP(_ newVal: Int) {
//        DispatchQueue.main.async {
//            self.value = newVal
//        }
//    }
//}
//
//struct MaxView: View {
//    @ObservedObject var model: MaxViewModel
//
//    var body: some View {
//        Text("Value: \(model.value)").padding(150)
//    }
//}

//        let content = MaxView(model: MaxViewModel())
//
//        let hostingController = NSHostingController(rootView: content)
//        let window = NSWindow(contentViewController: hostingController)
//        window.title = "Max UI"
//        window.setContentSize(NSSize(width: 300, height: 200))
//        window.makeKeyAndOrderFront(nil)
