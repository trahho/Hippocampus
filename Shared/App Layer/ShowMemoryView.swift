////
////  ShowAreaView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 31.07.22.
////
//
//import SwiftUI
//
//struct ShowConsciousnessView: View {
//    @EnvironmentObject var consciousness: Consciousness
//
//    var brain: Brain {
//        consciousness.memory.brain
//    }
//
//    var mind: Mind {
//        consciousness.memory.mind
//    }
//
//    var thoughts: [Mind.Thought] {
//        mind.thoughts.sorted(using: KeyPathComparator(\.designation, order: .forward))
//    }
//
//    @State var thought: Mind.Thought.ID?
//    @State private var visibility: NavigationSplitViewVisibility = .all
//
//    var body: some View {
//        NavigationSplitView(columnVisibility: $visibility) {
//            List(thoughts, selection: $thought) { thought in
//                Text("\(thought.designation)")
//            }
//            .navigationTitle(Text("Thoughts").font(Font.custom("Helvetica", size: 10)))
//#if iOS
//                .navigationBarTitleDisplayMode(.inline)
//#endif
//        }
//        //    content: {
//        //            List {
//        //                ForEach(thoughts) { thought in
//        //                    Text("\(thought.designation)")
//        //                }
//        //            }
//        //            .navigationTitle("Expression")
//        //        }
//    detail: {
//        if let thoughtId = thought, let thought: Mind.Thought = mind[thoughtId] {
//                Text("\(thought.designation)")
//            } else {
//                Text("Choose")
//            }
//        }
//    }
//}
//
//// struct ShowTopicView: View {
////    @ObservedObject var topic: Mind.Topic
////
////    var items: [Mind.Idea] {
////        topic.ideas.sorted(by: { a, b in
////            let aspect = Perspective.thema.name
////            return aspect[a, ""] < aspect[b, ""]
////        })
////    }
////
////    var body: some View {
////        Form {
////            VStack {
////                Text("\(topic.ideas.count)")
////                ForEach(items) { item in
//////                    let aspect = Perspective.thema.name
//////                    aspect.sensation(for: item, variation: .normal)
////                    EmptyView()
////                }
////            }
//////            Text("3")
//////            List {
//////                Text("A")
//////                Text("B")
//////                Text("C")
//////            }
////        }
//////        .frame(width: 400)
////    }
//// }
//
//// struct ShowMemoryView: View {
////    @ObservedObject var brain: Brain
////
////    var body: some View {
////        List(brain.neurons) { neuron in
////            Text("\(neuron.id.hashValue)")
////        }
////    }
//// }
////
//struct ShowConsciousnessView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowConsciousnessView()
//            .environmentObject(Consciousness.preview1)
//    }
//}
