//
//  PDFViewerViewController.swift
//  WoundCarePros
//
//  Created by Vasundhara Parakh on 8/22/19.
//  Copyright © 2019 Ratnesh Swarnkar. All rights reserved.
//

import UIKit
import PDFKit
import MessageUI
class PDFViewerViewController: BaseViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    let pdfView = PDFView()
    var pdfUrl : String?
    var mailAttachmentURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        self.addBackButton()

        self.setupPDFViewer()
        // Do any additional setup after loading the view.
    }
    
    func setupPDFViewer(){
        self.showActivityLoader()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pdfView)
        //self.showLoader()
        pdfView.frame = CGRect(x: 0, y: 84, width: Screen.width, height: Screen.height - 84)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadPDF(urlString: self.pdfUrl ?? ReportConstants.dummyReportUrl)
        }
       // self.btnShare.isHidden = true

    }
       
        
    

    func loadPDF(urlString : String){
        if let document = PDFDocument(url: URL(string: urlString)!) {
            self.pdfView.document = document
            //self.hideLoader()
            self.hideActivityLoader()
        }
    }
    
    //MARK:- Activity Loaders
    func showActivityLoader(){
//        self.btnShare.isHidden = true
//        self.loadingIndicator.isHidden = false
//        self.loadingIndicator.startAnimating()
//        self.loadingIndicator.color = Color.HighlightTextLPN
        
    }
    
    func hideActivityLoader(){
//        self.btnShare.isHidden = false
//        self.loadingIndicator.isHidden = true
//        self.loadingIndicator.stopAnimating()
    }
    
    //MARK:- IBAction Methods
    @IBAction func btnBack_Action(_ sender: Any) {
    }
    
    @IBAction func btnShare_Action(_ sender: Any) {
        if let url = self.pdfUrl{
            self.savePdf(urlString: url ?? "", fileName: ReportConstants.reportName)
        }
    }
    
  
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = ReportConstants.reportName
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                debugPrint("pdf successfully saved!")
                
                self.sendMail(pdfPath: resourceDocPath.absoluteString)
                
                
            } catch {
                debugPrint("Pdf could not be saved")
            }
        }
    }
    
    func showSavedPdf(url:String, fileName:String) {
        DispatchQueue.main.async {
            
            if #available(iOS 10.0, *) {
                do {
                    let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                    for url in contents {
                        if url.description.contains(ReportConstants.reportName) {
                            // its your file! do what you want with it!
                            if( MFMailComposeViewController.canSendMail()){
                                debugPrint("Can send email.")
                                
                                let mailComposer = MFMailComposeViewController()
                                mailComposer.mailComposeDelegate = self
                                
                                
                                //Set the subject
                                mailComposer.setSubject("Report")
                                let strBody = "This is test message"
                                    /*
                                """
                                Dear,
                                
                                Thank you for selecting my services.
                                Kindly refer the attached progress report of patient,\(patientName).
                                
                                Thanks,
                                \(wccName)
                                Sent from \()
                                """*/
                                //set mail body
                                mailComposer.setMessageBody(strBody, isHTML: false)
                                let pathPDF = url
                                do {
                                    let attachmentData = try Data(contentsOf: url)
                                    mailComposer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "Report")
                                    mailComposer.mailComposeDelegate = self
                                    self.present(mailComposer, animated: true) {
                                        //self.hideLoader()
                                    }
                                } catch let error {
                                    debugPrint("We have encountered error \(error.localizedDescription)")
                                }             }
                            else
                            {
                                debugPrint("email is not supported")
                            }
                        }
                    }
                } catch {
                    debugPrint("could not locate pdf file !!!!!!!")
                }
            }
        }
    }
    
    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        //if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains(ReportConstants.reportName) {
                        status = true
                    }
                }
            } catch {
                debugPrint("could not locate pdf file !!!!!!!")
            }
        //}
        return status
    }
    
    
}

//MARK:- MFMailComposeViewControllerDelegate
extension PDFViewerViewController : MFMailComposeViewControllerDelegate {
    
    func sendMail(pdfPath : String) {
        //self.showLoader()
        self.showSavedPdf(url: pdfPath, fileName: ReportConstants.reportName)
    }
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        self.dismiss(animated: true, completion: nil)
        //self.hideLoader()
        switch result {
        case .cancelled:
            debugPrint("Mail cancelled")
        case .saved:
            debugPrint("Mail saved")
        case .sent:
            debugPrint("Mail sent")
            //TODO: ADD SUCCESS MESSAGE ALERT
        case .failed:
            debugPrint("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        
    }
}
