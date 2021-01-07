//
//  PDFGenerator.swift
//  PDFRenderer
//
//  Created by Matheus Francisco da Silva Lima Gomes on 06/01/21.
//  Copyright © 2021 Matheus Francisco da Silva Lima Gomes. All rights reserved.
//

import UIKit
protocol NavigationDelegate: AnyObject {
    func render(in context: CGContext, with url: URL)
}
protocol PDFGeneratorFailed {
    func showError()
}
struct PDFGenerator {
    private var navigationDelegate: NavigationDelegate?
    private var pdfGeneratorError: PDFGeneratorFailed?
    
    init(delegate: NavigationDelegate, pdfGeneratorError: PDFGeneratorFailed) {
        self.navigationDelegate = delegate
        self.pdfGeneratorError = pdfGeneratorError
    }
    func generate(with frame: CGRect) {
        let renderer = UIGraphicsPDFRenderer(bounds: frame)
        let url = getURLName(from: "file")
        do {
            try renderer.writePDF(to: url, withActions: { (context) in
                    context.beginPage()
                self.navigationDelegate?.render(in: context.cgContext, with: url)
            })
        } catch {
            self.pdfGeneratorError?.showError()
        }
    }
    func getURLName(from newFile: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent("\(newFile).pdf")
    }
}
