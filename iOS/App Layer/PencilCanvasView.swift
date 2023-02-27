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
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: ViewController, context: Context) {
        print ("Coordinator: Update drawing")
        context.coordinator.isBlocked = true
        controller.setDrawing(drawing: drawing)
        controller.centerDrawing(at: center)
        controller.setLineGridMode(mode: background)
        controller.setPageFormat(format: format)
        context.coordinator.isBlocked = false
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    typealias UIViewControllerType = ViewController

    @Binding var drawing: PKDrawing
    @Binding var center: CGPoint
    @State var background: Background
    @State var format: PageFormat
}

extension PencilCanvasView {
    final class Coordinator: NSObject {
        var isBlocked = false
        var view: PencilCanvasView

        func drawingDidChange(_ controller: ViewController, drawing: PKDrawing) {
            guard !isBlocked, drawing != view.drawing else { return }
            print ("Coordinator: Drawing did change")
            view.drawing = drawing
        }

        func centerDidChange(_ controller: ViewController, center: CGPoint) {
            guard !isBlocked, center != view.center else { return }
            print ("Coordinator: Center did change")
            view.center = center
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
        lazy var contentView: View = {
            let this = View()
            return this
        }()

        lazy var toolPicker: PKToolPicker = {
            let this = PKToolPicker()
            return this
        }()

        private let canvasSize = CGSize(width: 1_000_000, height: 1_000_000)
        var delegate: Coordinator?

        var contentNeedsBeingCentered = true
        var isDrawing: Bool = false

        override func loadView() {
            view = contentView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            toolPicker.addObserver(contentView.canvasView)
            contentView.canvasView.delegate = self
            contentView.canvasView.contentSize = canvasSize
            endDrawing()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            contentView.gridView.frame = contentView.canvasView.frame
            contentView.gridView.setNeedsDisplay()
            if contentNeedsBeingCentered {
                centerDrawing()
            }
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            beginDrawing()
//            delegate?.isReadyToWork(self)
        }

        func centerDrawing() {
            let drawing = contentView.canvasView.drawing
            if drawing.strokes.isEmpty {
                let contentSize = contentView.canvasView.contentSize
                centerDrawing(at: CGPoint(x: contentSize.width / 2, y: contentSize.height / 2))
            } else {
                centerDrawing(at: CGPoint(x: drawing.bounds.midX, y: drawing.bounds.midY))
            }
        }

        func centerDrawing(at position: CGPoint) {
            let canvasView = contentView.canvasView
            let gridView = contentView.gridView

            let viewBounds = canvasView.bounds
            let zoomScale = canvasView.zoomScale

            let offsetX = position.x * zoomScale - viewBounds.width / 2
            let offsetY = position.y * zoomScale - viewBounds.height / 2
            let offset = CGPoint(x: offsetX, y: offsetY)

            canvasView.contentOffset = offset
            gridView.offset = offset
            contentNeedsBeingCentered = false
        }

        func setDrawing(drawing: PKDrawing) {
            if drawing.strokes.isEmpty, contentView.canvasView.drawing.strokes.isEmpty {
                print("Drawing empty")
                contentNeedsBeingCentered = true
            } else if drawing != contentView.canvasView.drawing {
                contentNeedsBeingCentered = contentView.canvasView.drawing.strokes.isEmpty

                contentView.canvasView.drawing = drawing

                print("Drawing accepted")
            } else {
                //            contentNeedsBeingCentered = false
                print("Drawing ignored")
            }
        }

        func setLineGridMode(mode: Background) {
            contentView.gridView.mode = mode
        }

        func setPageFormat(format: PageFormat) {
            contentView.gridView.page = format
        }

        //    func centerContent () {
        //        let viewBounds = contentView.canvasView.bounds
        //        guard !viewBounds.isEmpty else { return }
        //
        //        let contentBounds = CGRect(origin: CGPoint.zero, size: contentView.canvasView.contentSize)
        //        let drawingBounds = contentView.canvasView.drawing.bounds
        //        let bounds = drawingBounds.isEmpty ? contentBounds : drawingBounds
        //
        //
        //        let centerX = (contentSize.width - viewSize.width) / 2
        //        let centerY = (contentSize.height - viewSize.height) / 2
        //
        //        contentView.canvasView.contentOffset = CGPoint(x: centerX, y: centerY)
        //        contentView.gridView.offset = contentView.canvasView.contentOffset
        //        contentView.gridView.zoomScale = contentView.canvasView.zoomScale
        //        contentNeedsBeingCentered = false
        //        print("Content centered")
        //    }

        //    func centerDrawingObsolet() {
        //        let canvasView = contentView.canvasView
        //
        //        let contentCenterX = canvasView.contentSize.width / 2
        //        let contentCenterY = canvasView.contentSize.height / 2
        //
        //        let drawingCenterX = canvasView.drawing.bounds.midX
        //        let drawingCenterY = canvasView.drawing.bounds.midY
        //
        //        let transform = CGAffineTransform(translationX: contentCenterX - drawingCenterX, y: contentCenterY - drawingCenterY)
        //
        //        canvasView.drawing.transform(using: transform)
        //        print("Drawing centered")
        //        centerContent()
        //    }

        func beginDrawing() {
            guard !isDrawing else { return }
            let canvasView = contentView.canvasView

            //        guard !canvasView.drawingGestureRecognizer.isEnabled else { return }

            canvasView.drawingGestureRecognizer.isEnabled = true
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            if !canvasView.isFirstResponder { canvasView.becomeFirstResponder() }
            isDrawing = true
        }

        func endDrawing() {
            //        guard isDrawing else { return }

            let canvasView = contentView.canvasView

            //        guard canvasView.drawingGestureRecognizer.isEnabled else { return }

            canvasView.drawingGestureRecognizer.isEnabled = false
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            isDrawing = false
            //        if canvasView.isFirstResponder { canvasView.resignFirstResponder() }
        }

        func _centerContent() {
            let contentSize = contentView.canvasView.contentSize
            let viewSize = contentView.canvasView.bounds

            guard !viewSize.isEmpty else { return }

            let centerX = (contentSize.width - viewSize.width) / 2
            let centerY = (contentSize.height - viewSize.height) / 2

            contentView.canvasView.contentOffset = CGPoint(x: centerX, y: centerY)
            contentView.gridView.offset = contentView.canvasView.contentOffset
            contentView.gridView.zoomScale = contentView.canvasView.zoomScale
            contentNeedsBeingCentered = false
            print("Content centered")
        }

        func showFullDrawing() {
            let canvasView = contentView.canvasView
            let gridView = contentView.gridView

            let drawing = canvasView.drawing
            let drawingBounds = drawing.bounds

            guard !drawingBounds.isEmpty else { return }

            let drawingSize = drawingBounds.size
            let viewSize = canvasView.bounds.size

            let widthScale = viewSize.width / drawingSize.width
            let heightScale = viewSize.height / drawingSize.height
            let scale = min(min(widthScale, heightScale), 1)

            let scaledOffset = CGPoint(
                x: drawingBounds.minX * scale + (drawingSize.width * scale - viewSize.width) / 2,
                y: drawingBounds.minY * scale + (drawingSize.height * scale - viewSize.height) / 2
            )

            canvasView.minimumZoomScale = min(canvasView.minimumZoomScale, scale)
            canvasView.zoomScale = scale
            gridView.zoomScale = scale
            canvasView.contentOffset = scaledOffset
            gridView.offset = scaledOffset
        }

        func resetZoom() {
            contentView.canvasView.zoomScale = 1
            contentView.gridView.zoomScale = 1
        }

        var scaledDrawingBounds: CGRect {
            let scale = contentView.canvasView.zoomScale
            let drawing = contentView.canvasView.drawing
            return CGRect(x: drawing.bounds.minX * scale, y: drawing.bounds.minY * scale, width: drawing.bounds.width * scale, height: drawing.bounds.height * scale)
        }

        func moveToEdge(horizontal: Int, vertical: Int) {
            let canvasView = contentView.canvasView
            let gridView = contentView.gridView

            guard !scaledDrawingBounds.isEmpty else { return }

            let viewSize = canvasView.bounds.size

            let scaledOffsetX: CGFloat
            let scaledOffsetY: CGFloat

            switch horizontal {
            case 0:
                scaledOffsetX = scaledDrawingBounds.minX - viewSize.width * 0.05
            case 1:
                scaledOffsetX = scaledDrawingBounds.minX + (scaledDrawingBounds.size.width - viewSize.width) / 2
            case 2:
                scaledOffsetX = scaledDrawingBounds.minX + (scaledDrawingBounds.size.width - viewSize.width) + viewSize.width * 0.05
            default:
                return
            }

            switch vertical {
            case 0:
                scaledOffsetY = scaledDrawingBounds.minY - viewSize.height * 0.05
            case 1:
                scaledOffsetY = scaledDrawingBounds.minY + (scaledDrawingBounds.size.height - viewSize.height) / 2
            case 2:
                scaledOffsetY = scaledDrawingBounds.minY + (scaledDrawingBounds.size.height - viewSize.height) + viewSize.height * 0.05
            default:
                return
            }

            let scaledOffset = CGPoint(x: scaledOffsetX, y: scaledOffsetY)

            canvasView.contentOffset = scaledOffset
            gridView.offset = scaledOffset
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            updatePositionIndicators()
            guard let delegate = delegate else { return }

            delegate.drawingDidChange(self, drawing: canvasView.drawing)
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            contentView.gridView.zoomScale = scrollView.zoomScale
            notifyCenterHasChanged()
            updatePositionIndicators()
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentNeedsBeingCentered = false

            contentView.gridView.offset = scrollView.contentOffset
            notifyCenterHasChanged()
            updatePositionIndicators()
        }

        func notifyCenterHasChanged() {
            guard let delegate = delegate else { return }

            let offset = contentView.canvasView.contentOffset
            let viewBounds = contentView.canvasView.bounds
            let zoomScale = contentView.canvasView.zoomScale
            let center = CGPoint(x: (offset.x + viewBounds.width / 2) / zoomScale, y: (offset.y + viewBounds.height / 2) / zoomScale)
            //        let center = CGPoint(x: unscaledOffset.x + contentView.canvasView.bounds.width / 2, y: unscaledOffset.y + contentView.canvasView.bounds.height / 2)
            delegate.centerDidChange(self, center: center)
        }

        func updatePositionIndicators() {
            let drawingBounds = contentView.canvasView.drawing.bounds
            let viewBounds = contentView.bounds

            guard !drawingBounds.isEmpty, !viewBounds.isEmpty else { return }
            let offset = contentView.canvasView.contentOffset

            let minWidth: CGFloat = 12
            let zoomScale = contentView.canvasView.zoomScale
            let zoomedDrawingBounds = CGRect(x: drawingBounds.minX * zoomScale, y: drawingBounds.minY * zoomScale, width: drawingBounds.width * zoomScale, height: drawingBounds.height * zoomScale)

            let horizontalLeading = viewBounds.minX - (zoomedDrawingBounds.minX - offset.x)
            let horizontalLeadingRatio = horizontalLeading / zoomedDrawingBounds.width
            let horizontalLeadingOffset = viewBounds.minX + viewBounds.width * horizontalLeadingRatio

            let horizontalTrailing = (zoomedDrawingBounds.maxX - offset.x) - viewBounds.maxX
            let horizontalTrailingRatio = horizontalTrailing / zoomedDrawingBounds.width
            let horizontalTrailingOffset = viewBounds.maxX - viewBounds.width * horizontalTrailingRatio

            contentView.topHorizontalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: viewBounds.width, height: minWidth)
            contentView.topHorizontalIndicatorView.setThumb(start: horizontalLeadingOffset, end: horizontalTrailingOffset)

            //        contentView.bottomHorizontalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.maxY - minWidth, width: viewBounds.width, height: minWidth)
            //        contentView.bottomHorizontalIndicatorView.setThumb(start: horizontalLeadingOffset, end: horizontalTrailingOffset)

            let verticalLeading = viewBounds.minY - (zoomedDrawingBounds.minY - offset.y)
            let verticalLeadingRatio = verticalLeading / zoomedDrawingBounds.height
            let verticalLeadingOffset = viewBounds.minY + viewBounds.height * verticalLeadingRatio

            let verticalTrailing = (zoomedDrawingBounds.maxY - offset.y) - viewBounds.maxY
            let verticalTrailingRatio = verticalTrailing / zoomedDrawingBounds.height
            let verticalTrailingOffset = viewBounds.maxY - viewBounds.height * verticalTrailingRatio

            contentView.leftVerticalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: minWidth, height: viewBounds.height)
            contentView.leftVerticalIndicatorView.setThumb(start: verticalLeadingOffset, end: verticalTrailingOffset)

            //        contentView.rightVerticalIndicatorView.frame = CGRect(x: viewBounds.maxX - minWidth, y: viewBounds.minY, width: minWidth, height: viewBounds.height)
            //        contentView.rightVerticalIndicatorView.setThumb(start: verticalLeadingOffset, end: verticalTrailingOffset)
        }
    }
}
