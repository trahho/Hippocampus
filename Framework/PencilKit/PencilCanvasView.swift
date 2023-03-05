//
//  PencilCanvasView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import Foundation
import PencilKit
import SwiftUI

struct PencilCanvasView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let controller = ViewController()
        controller.coordinator = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: ViewController, context: Context) {
        guard !context.coordinator.isSending else { return }
        context.coordinator.isBlocked = true
        print("Drawing View -> Controller")
        controller.drawing = drawing
        if center != .zero {
            print("Center View -> Controller")
            controller.center = center
        }
        print("PageFormat View -> Controller")
        controller.pageFormat = pageFormat
        print("Background View -> Controller")
        controller.background = background
        context.coordinator.isBlocked = false
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    typealias UIViewControllerType = ViewController

    @Binding var drawing: PKDrawing
    @Binding var center: CGPoint
    @State var background: Background
    @State var pageFormat: PageFormat
    var isBlocked = false
}

extension PencilCanvasView {
    final class Coordinator: NSObject {
        var isBlocked = true
        var isSending = false
        var view: PencilCanvasView

        func drawingDidChange(_ controller: ViewController, drawing: PKDrawing) {
            guard !isBlocked else { return }
            isSending = true
            print("Drawing Controller -> View")
            view.drawing = drawing
            isSending = false
        }

        func centerDidChange(_ controller: ViewController, center: CGPoint) {
            guard !isBlocked else { return }
            isSending = true
            print("Center Controller -> View")
            view.center = center
            isSending = false
        }

        init(_ view: PencilCanvasView) {
            self.view = view
        }
    }
}

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

            //        horizontalIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            //        horizontalIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            //        horizontalIndicatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            //        horizontalIndicatorView.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: 7)
        }
    }

    //    protocol ViewControllerDelegate {
    //        func drawingDidChange(_ controller: ViewController, drawingData: Data)
    //        func centerHasChanged(_ controller: ViewController, center: CGPoint)
    //        func isReadyToWork(_ controller: ViewController)
    //    }
}

extension PencilCanvasView {
    final class ViewController: UIViewController, PKCanvasViewDelegate {
        lazy var drawingView: View = .init()
        lazy var toolPicker: PKToolPicker = .init()

        private let canvasSize = CGSize(width: 1_000_000, height: 1_000_000)

        var coordinator: Coordinator?

        // MARK: - - View setup

        override func loadView() {
            view = drawingView
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            toolPicker.addObserver(drawingView.canvasView)
            drawingView.canvasView.delegate = self
            drawingView.canvasView.contentSize = canvasSize
            disableDrawing()
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            enableDrawing()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            drawingView.gridView.frame = drawingView.canvasView.frame
            drawingView.gridView.setNeedsDisplay()
            if contentNeedsBeingCentered {
                centerDrawing()
            }
        }

        // MARK: - - Drawing

        var contentNeedsBeingCentered = true

        var drawing: PKDrawing {
            get { drawingView.canvasView.drawing }
            set {
                let currentValue = drawingView.canvasView.drawing
                if newValue.strokes.isEmpty, currentValue.strokes.isEmpty {
                    print("Drawing still empty")
                    contentNeedsBeingCentered = true
                } else if newValue != currentValue {
                    contentNeedsBeingCentered = currentValue.strokes.isEmpty
                    drawingView.canvasView.drawing = newValue
                    print("Drawing accepted")
                } else {
//                    print("Drawing ignored")
                }
            }
        }

        var center: CGPoint {
            get {
                let canvasView = drawingView.canvasView
                let offset = canvasView.contentOffset
                let viewBounds = canvasView.bounds
                let zoomScale = canvasView.zoomScale
                return CGPoint(x: (offset.x + viewBounds.width / 2) / zoomScale, y: (offset.y + viewBounds.height / 2) / zoomScale)
            }
            set {
                let canvasView = drawingView.canvasView
                let gridView = drawingView.gridView

                let viewBounds = canvasView.bounds
                let zoomScale = canvasView.zoomScale

                let offsetX = newValue.x * zoomScale - viewBounds.width / 2
                let offsetY = newValue.y * zoomScale - viewBounds.height / 2
                let offset = CGPoint(x: offsetX, y: offsetY)

                canvasView.contentOffset = offset
                gridView.offset = offset
                contentNeedsBeingCentered = false
            }
        }

        func centerDrawing() {
            let canvasView = drawingView.canvasView
            let drawing = canvasView.drawing
            if drawing.strokes.isEmpty {
                let contentSize = canvasView.contentSize
                center = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
            } else {
                center = CGPoint(x: drawing.bounds.midX, y: drawing.bounds.midY)
            }
        }

        // MARK: - - Activation

        private var drawingEnabled: Bool = false
        var isActive: Bool {
            get { drawingEnabled }
            set(newState) {
                if !drawingEnabled && newState == true {
                    enableDrawing()
                } else if drawingEnabled && newState == false {
                    disableDrawing()
                }
            }
        }

        private func enableDrawing() {
            guard !drawingEnabled else { return }
            let canvasView = drawingView.canvasView
            canvasView.drawingGestureRecognizer.isEnabled = true
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            if !canvasView.isFirstResponder { canvasView.becomeFirstResponder() }
            drawingEnabled = true
        }

        func disableDrawing() {
            guard drawingEnabled else { return }
            let canvasView = drawingView.canvasView
            canvasView.drawingGestureRecognizer.isEnabled = false
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            drawingEnabled = false
        }

        // MARK: - - Grid properties

        var background: Background {
            get { drawingView.gridView.mode }
            set {
                guard drawingView.gridView.mode != newValue else { return }
                drawingView.gridView.mode = newValue
            }
        }

        var pageFormat: PageFormat {
            get { drawingView.gridView.page }
            set {
                guard drawingView.gridView.page != newValue else { return }
                drawingView.gridView.page = newValue
            }
        }

        // MARK: - - PKCanvasDelegate

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            updatePositionIndicators()
            guard let coordinator else { return }
            coordinator.drawingDidChange(self, drawing: canvasView.drawing)
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            drawingView.gridView.zoomScale = scrollView.zoomScale
            notifyCenterHasChanged()
            updatePositionIndicators()
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentNeedsBeingCentered = false
            drawingView.gridView.offset = scrollView.contentOffset
            notifyCenterHasChanged()
            updatePositionIndicators()
        }

        func notifyCenterHasChanged() {
            guard let coordinator else { return }
            coordinator.centerDidChange(self, center: center)
        }

        func updatePositionIndicators() {
            let drawingBounds = drawing.bounds
            let viewBounds = drawingView.bounds
            let canvasView = drawingView.canvasView

            guard !drawingBounds.isEmpty, !viewBounds.isEmpty else { return }
            let offset = canvasView.contentOffset

            let minWidth: CGFloat = 12
            let zoomScale = canvasView.zoomScale
            let zoomedDrawingBounds = CGRect(x: drawingBounds.minX * zoomScale, y: drawingBounds.minY * zoomScale, width: drawingBounds.width * zoomScale, height: drawingBounds.height * zoomScale)

            let horizontalLeading = viewBounds.minX - (zoomedDrawingBounds.minX - offset.x)
            let horizontalLeadingRatio = horizontalLeading / zoomedDrawingBounds.width
            let horizontalLeadingOffset = viewBounds.minX + viewBounds.width * horizontalLeadingRatio

            let horizontalTrailing = (zoomedDrawingBounds.maxX - offset.x) - viewBounds.maxX
            let horizontalTrailingRatio = horizontalTrailing / zoomedDrawingBounds.width
            let horizontalTrailingOffset = viewBounds.maxX - viewBounds.width * horizontalTrailingRatio

            drawingView.topHorizontalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: viewBounds.width, height: minWidth)
            drawingView.topHorizontalIndicatorView.setThumb(start: horizontalLeadingOffset, end: horizontalTrailingOffset)

            let verticalLeading = viewBounds.minY - (zoomedDrawingBounds.minY - offset.y)
            let verticalLeadingRatio = verticalLeading / zoomedDrawingBounds.height
            let verticalLeadingOffset = viewBounds.minY + viewBounds.height * verticalLeadingRatio

            let verticalTrailing = (zoomedDrawingBounds.maxY - offset.y) - viewBounds.maxY
            let verticalTrailingRatio = verticalTrailing / zoomedDrawingBounds.height
            let verticalTrailingOffset = viewBounds.maxY - viewBounds.height * verticalTrailingRatio

            drawingView.leftVerticalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: minWidth, height: viewBounds.height)
            drawingView.leftVerticalIndicatorView.setThumb(start: verticalLeadingOffset, end: verticalTrailingOffset)

            drawingView.gridView.setNeedsDisplay()
        }

        var scaledDrawingBounds: CGRect {
            let scale = drawingView.canvasView.zoomScale
            return CGRect(x: drawing.bounds.minX * scale, y: drawing.bounds.minY * scale, width: drawing.bounds.width * scale, height: drawing.bounds.height * scale)
        }
    }

//    final class OldViewController: UIViewController, PKCanvasViewDelegate {
//
//
//
//
//        func _centerContent() {
//            let contentSize = contentView.canvasView.contentSize
//            let viewSize = contentView.canvasView.bounds
//
//            guard !viewSize.isEmpty else { return }
//
//            let centerX = (contentSize.width - viewSize.width) / 2
//            let centerY = (contentSize.height - viewSize.height) / 2
//
//            contentView.canvasView.contentOffset = CGPoint(x: centerX, y: centerY)
//            contentView.gridView.offset = contentView.canvasView.contentOffset
//            contentView.gridView.zoomScale = contentView.canvasView.zoomScale
//            contentNeedsBeingCentered = false
//            print("Content centered")
//        }
//
//        func showFullDrawing() {
//            let canvasView = contentView.canvasView
//            let gridView = contentView.gridView
//
//            let drawing = canvasView.drawing
//            let drawingBounds = drawing.bounds
//
//            guard !drawingBounds.isEmpty else { return }
//
//            let drawingSize = drawingBounds.size
//            let viewSize = canvasView.bounds.size
//
//            let widthScale = viewSize.width / drawingSize.width
//            let heightScale = viewSize.height / drawingSize.height
//            let scale = min(min(widthScale, heightScale), 1)
//
//            let scaledOffset = CGPoint(
//                x: drawingBounds.minX * scale + (drawingSize.width * scale - viewSize.width) / 2,
//                y: drawingBounds.minY * scale + (drawingSize.height * scale - viewSize.height) / 2
//            )
//
//            canvasView.minimumZoomScale = min(canvasView.minimumZoomScale, scale)
//            canvasView.zoomScale = scale
//            gridView.zoomScale = scale
//            canvasView.contentOffset = scaledOffset
//            gridView.offset = scaledOffset
//        }
//
//        func resetZoom() {
//            contentView.canvasView.zoomScale = 1
//            contentView.gridView.zoomScale = 1
//        }
//
//
//
//        func moveToEdge(horizontal: Int, vertical: Int) {
//            let canvasView = contentView.canvasView
//            let gridView = contentView.gridView
//
//            guard !scaledDrawingBounds.isEmpty else { return }
//
//            let viewSize = canvasView.bounds.size
//
//            let scaledOffsetX: CGFloat
//            let scaledOffsetY: CGFloat
//
//            switch horizontal {
//            case 0:
//                scaledOffsetX = scaledDrawingBounds.minX - viewSize.width * 0.05
//            case 1:
//                scaledOffsetX = scaledDrawingBounds.minX + (scaledDrawingBounds.size.width - viewSize.width) / 2
//            case 2:
//                scaledOffsetX = scaledDrawingBounds.minX + (scaledDrawingBounds.size.width - viewSize.width) + viewSize.width * 0.05
//            default:
//                return
//            }
//
//            switch vertical {
//            case 0:
//                scaledOffsetY = scaledDrawingBounds.minY - viewSize.height * 0.05
//            case 1:
//                scaledOffsetY = scaledDrawingBounds.minY + (scaledDrawingBounds.size.height - viewSize.height) / 2
//            case 2:
//                scaledOffsetY = scaledDrawingBounds.minY + (scaledDrawingBounds.size.height - viewSize.height) + viewSize.height * 0.05
//            default:
//                return
//            }
//
//            let scaledOffset = CGPoint(x: scaledOffsetX, y: scaledOffsetY)
//
//            canvasView.contentOffset = scaledOffset
//            gridView.offset = scaledOffset
//        }
//
//
//    }
}
