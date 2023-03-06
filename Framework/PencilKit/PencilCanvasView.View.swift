//
//  PencilCanvasView.View.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Foundation
import PencilKit
import UIKit

extension PencilCanvasView {
    final class View: UIView {
        lazy var canvasView: PKCanvasView = {
            let this = PKCanvasView()
            this.translatesAutoresizingMaskIntoConstraints = false
            this.backgroundColor = .clear
            this.minimumZoomScale = 0.01
            this.maximumZoomScale = 3
            this.showsVerticalScrollIndicator = false
            this.showsHorizontalScrollIndicator = false
            return this
        }()
        
        lazy var gridView: BackgroundView = {
            let this = BackgroundView()
            this.canvas = canvasView
            this.backgroundColor = .systemBackground
            return this
        }()
        
        lazy var topHorizontalIndicatorView: ScrollIndicatorView = {
            let this = ScrollIndicatorView()
            this.mode = .horizontal
            this.backgroundColor = .secondarySystemFill
            this.tintColor = .systemFill
            return this
        }()
        
        lazy var bottomHorizontalIndicatorView: ScrollIndicatorView = {
            let this = ScrollIndicatorView()
            this.mode = .horizontal
            this.backgroundColor = .secondarySystemFill
            this.tintColor = .systemFill
            return this
        }()
        
        lazy var leftVerticalIndicatorView: ScrollIndicatorView = {
            let this = ScrollIndicatorView()
            this.mode = .vertical
            this.backgroundColor = .secondarySystemFill
            this.tintColor = .systemFill
            return this
        }()
        
        lazy var rightVerticalIndicatorView: ScrollIndicatorView = {
            let this = ScrollIndicatorView()
            this.mode = .vertical
            this.backgroundColor = .secondarySystemFill
            this.tintColor = .systemFill
            return this
        }()
        
        init() {
            super.init(frame: .zero)
            setupView()
            setupLayout()
        }
        
        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupView() {
            backgroundColor = .systemBackground
            addSubview(canvasView)
            addSubview(topHorizontalIndicatorView)
            addSubview(bottomHorizontalIndicatorView)
            addSubview(leftVerticalIndicatorView)
            addSubview(rightVerticalIndicatorView)
            addSubview(gridView)
            sendSubviewToBack(gridView)
        }
        
        func setupLayout() {
            canvasView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            canvasView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            canvasView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            canvasView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
