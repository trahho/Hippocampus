//
//  Structure.Aspect.DrawingView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.02.23.
//

import Combine
import Foundation
import PencilKit
import SwiftUI

extension Structure.Aspect.Representation {
    struct DrawingView: View {
        @ObservedObject var item: Information.Item
        @EnvironmentObject var document: Document
        
        var aspect: Structure.Aspect
        var editable: Bool
        
        //        init(item: Information.Item, aspect: Structure.Aspect, editable: Bool) {
        //            self.item = item
        //            self.aspect = aspect
        //            self.editable = editable
        //            let dataUrl = document.url.appending(components: "drawing", "\(item.id)--\(aspect.id).persistentdrawing")
        //            self.data = PersistentContainer(url: dataUrl, content: PersistentDrawing())
        //        }
        
        var body: some View {
            let dataUrl = document.url.appending(components: "drawing", "\(item.id)--\(aspect.id)")
            let data = PersistentData(url: document.url)
            CanvasHostView(data: data, editable: editable)
        }
        
        struct CanvasHostView: View {
            @ObservedObject var data: PersistentData
            
            var editable: Bool
            
            var body: some View {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 100, height: 100)
            }
        }
    }
}
