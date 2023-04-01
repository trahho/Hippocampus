//
//  Document.Presentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation

extension Document {
    class Presentation: ObservableObject {
        @Observed private var propertiesContainer: PersistentContainer<Properties>
        
    }
}
