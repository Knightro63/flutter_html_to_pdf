import FlutterMacOS
import AppKit

public class FlutterHtmlToPdfPlugin: NSObject, FlutterPlugin{
    var urlObservation: NSKeyValueObservation?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_html_to_pdf", binaryMessenger: registrar.messenger)
        let instance = FlutterHtmlToPdfPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
      }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "convertHtmlToPdf":
        let args = call.arguments as? [String: Any]
        let html = args!["html"] as? String ?? ""
        let margin = args!["margin"] as? [String:Double] ?? ["top":20,"rigth":20,"bottom":20,"left":20]
        let size = args!["size"] as? [String:Double] ?? ["width":570,"height":740]
        
        result(makePDF(html, margin, size))

    default:
        result(FlutterMethodNotImplemented)
    }
  }
    
    func makePDF(_ markup: String, _ margin: [String:Double], _ size: [String:Double]) -> NSMutableData? {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let printOpts: [NSPrintInfo.AttributeKey: Any] = [NSPrintInfo.AttributeKey.jobDisposition: NSPrintInfo.JobDisposition.save, NSPrintInfo.AttributeKey.jobSavingURL: directoryURL]
        let printInfo = NSPrintInfo(dictionary: printOpts)
        printInfo.horizontalPagination = NSPrintInfo.PaginationMode.automatic
        printInfo.verticalPagination = NSPrintInfo.PaginationMode.automatic
        printInfo.paperSize = NSSize(width: 8.5*72, height: 11*72)
        printInfo.topMargin = CGFloat(margin["top"]!) //20.0
        printInfo.leftMargin = CGFloat(margin["left"]!)
        printInfo.rightMargin = CGFloat(margin["right"]!)
        printInfo.bottomMargin = CGFloat(margin["bottom"]!)

        let view = NSView(frame: NSRect(x: 0, y: 0, width: size["width"]!, height: size["height"]!))

        if let htmlData = markup.data(using: String.Encoding.utf8) {//NSDocumentTypeDocumentAttribute
            if let attrStr = NSAttributedString(html: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                let frameRect = NSRect(
                    x: 0,
                    y: 0,
                    width: size["width"]!,
                    height: size["height"]!
                )
                let textField = NSTextField(frame: frameRect)
                textField.attributedStringValue = attrStr
                view.addSubview(textField)
                let data:NSMutableData = NSMutableData.init();
                let printOperation = NSPrintOperation.pdfOperation(with: view,inside: frameRect,to: data,printInfo: printInfo)
                printOperation.showsPrintPanel = true
                printOperation.showsProgressPanel = false
                printOperation.canSpawnSeparateThread = true
                printOperation.run()
                
                return data;
            }
        }
        
        return nil;
    }
}
