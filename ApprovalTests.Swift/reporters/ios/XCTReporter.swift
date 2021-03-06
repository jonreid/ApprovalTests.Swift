import Foundation
import XCTest

#if os(iOS)

class XCTReporter: ApprovalFailureReporter {
    
    func report(received: String, approved: String) {
        // read the files into strings
        let approvedUrl = URL(fileURLWithPath: approved)
        let receivedUrl = URL(fileURLWithPath: received)
        
        var aText = ""
        var rText = ""
        do {
            aText = try String(contentsOf: approvedUrl)
            rText = try String(contentsOf: receivedUrl)
        } catch { }

        let workingReceived = cleanPathString(received)
        let workingApproved = cleanPathString(approved)
        
        let command: String = String(format: "mv %@ %@", workingReceived, workingApproved )

        // copy to pasteboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = command
        
        // send command to system out
        let approveCommand = "To approve run : " + command
        print(approveCommand);
        XCTAssertEqual(aText, rText)
    }
    
    private func cleanPathString(_ pathString: String) -> String {
        var workingPathString = pathString

        let removedColons = workingPathString.replacingOccurrences(of: ":::", with: "")
        workingPathString = removedColons

        let escapedSpaces = workingPathString.replacingOccurrences(of: " ", with: "\\ ")
        workingPathString = escapedSpaces
        
        return workingPathString
    }
}

#endif
