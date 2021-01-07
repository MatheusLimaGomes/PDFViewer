//
//  ViewController.swift
//  PDFRenderer
//
//  Created by Matheus Francisco da Silva Lima Gomes on 06/01/21.
//  Copyright © 2021 Matheus Francisco da Silva Lima Gomes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var pdfGenerator: PDFGenerator?
    
    @IBOutlet weak fileprivate var btnGenerate: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        self.pdfGenerator = PDFGenerator(delegate: self, pdfGeneratorError: self)
        self.btnGenerate?.addTarget(self, action: #selector(generatePDFView), for: .touchUpInside)
    }
    @objc private func generatePDFView() {
        self.pdfGenerator?.generate(with: self.view.bounds)
    }
    private func createAlert(title: String, message: String, to preferredStyle: UIAlertController.Style) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        return alert
    }
}
extension ViewController: NavigationDelegate {
    func render(in context: CGContext, with url: URL) {
        self.view.layer.render(in: context)
        navigateToPDFView(url: url)
    }
}
extension ViewController: PDFGeneratorFailed {
    func showError() {
        let alert = createAlert(title: "Houve um problema",
                                message: "Não foi possível criar o seu arquivo .pdf", to: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
extension ViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    private func navigateToPDFView(url: URL) {
        let documentController = UIDocumentInteractionController(url: url)
        documentController.name = url.lastPathComponent
        documentController.delegate = self
        documentController.presentPreview(animated: true)
        
    }
}

