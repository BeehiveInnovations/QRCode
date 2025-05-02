//
//  ViewController.swift
//  macOS Logo Image Demo
//
//  Created by Darren Ford on 16/11/2022.
//

import Cocoa
import QRCode

class ViewController: NSViewController {

	@IBOutlet weak var qrcodeView: QRCodeDocumentView!
	@IBOutlet weak var qrcodeView2: QRCodeDocumentView!
	@IBOutlet weak var qrcodeView3: QRCodeDocumentView!


	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	override func viewWillAppear() {
		super.viewWillAppear()

		do {
			let doc = try! QRCode.Document(
				utf8String: "https://support.apple.com/en-au/repair",
				errorCorrection: .high
			)

			let p = CGPath(ellipseIn: CGRect(x: 0.60, y: 0.60, width: 0.40, height: 0.40), transform: nil)
			let logoTemplate = QRCode.LogoTemplate(
				image: NSImage(named: "logo")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: p,
				inset: 16
			)
			doc.logoTemplate = logoTemplate

			let pdfData = try! doc.pdfData(dimension: 512)
			try! pdfData.write(to: URL(string: "file:///tmp/output.pdf")!)

			let svg = try! doc.svg(dimension: 512)
			try! svg.write(to: URL(string: "file:///tmp/output.svg")!, atomically: true, encoding: .utf8)

			qrcodeView.document = doc

			let ssss = try! doc.svg(dimension: 512)
			try! ssss.write(to: URL(string: "file:///tmp/logotype1.svg")!, atomically: true, encoding: .utf8)

			try! doc.jsonData().write(to: URL(string: "file:///tmp/logotype1.jsontemplate")!)
		}

		do {
			let doc = try! QRCode.Document(utf8String: "https://developer.apple.com/forums/", errorCorrection: .high)
			doc.design.backgroundColor(CGColor(red: 0.149, green: 0.137, blue: 0.208, alpha: 1.000))
			doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000)

			doc.design.style.eye   = QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000)
			doc.design.style.pupil = QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000)

			doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

			// Centered square logo
			doc.logoTemplate = QRCode.LogoTemplate(
				image: NSImage(named: "apple")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: CGPath(rect: CGRect(x: 0.50, y: 0.4, width: 0.45, height: 0.22), transform: nil),
				inset: 4
			)

			qrcodeView2.document = doc

			let ssss = try! doc.svg(dimension: 512)
			try! ssss.write(to: URL(string: "file:///tmp/logotype2.svg")!, atomically: true, encoding: .utf8)
		}

		do {
			let doc = try! QRCode.Document(utf8String: "The rect will not be painted, however. Instead its pixel data will be used to determine, which pixels of the circle 'make it' to the final rendering. Since the rectangle covers only the upper half of the circle, the lower half of the circle will vanish", errorCorrection: .high)
			doc.design.backgroundColor(CGColor(red: 0.149, green: 0.137, blue: 0.208, alpha: 1.000))

			let gradient = try! DSFGradient(
				pins: [
					DSFGradient.Pin(CGColor(red: 0.149, green: 0.137, blue: 0.208, alpha: 1.000), 0),
					DSFGradient.Pin(CGColor(red: 0.059, green: 0.216, blue: 0.055, alpha: 1.000), 1),
				]
			)
			doc.design.style.background = QRCode.FillStyle.LinearGradient(
				gradient,
				startPoint: CGPoint(x: 0, y: 1),
				endPoint: CGPoint(x: 1, y: 1)
				)

			doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 1, hasInnerCorners: true)
			doc.design.style.onPixels = QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000)

			doc.design.style.eye   = QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000)
			doc.design.style.pupil = QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000)

			doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()

			// Centered square logo
			doc.logoTemplate = QRCode.LogoTemplate(
				image: NSImage(named: "instagram-icon")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
				path: CGPath(ellipseIn: CGRect(x: 0.35, y: 0.35, width: 0.3, height: 0.3), transform: nil),
				inset: 4
			)

			qrcodeView3.document = doc

			let ssss = try! doc.svg(dimension: 512)
			try! ssss.write(to: URL(string: "file:///tmp/logotype3.svg")!, atomically: true, encoding: .utf8)

			let ssss2 = try! doc.pdfData(dimension: 512)
			try! ssss2.write(to: URL(string: "file:///tmp/logotype3.pdf")!)
		}
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.setupVCardQRCode()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
      self?.setupCalendarEventQRCode()
    }
	}
  
  func setupVCardQRCode() {
    // Create a simple vCard
    let vCardString = """
    BEGIN:VCARD
    VERSION:3.0
    N:Doe;John;;;
    FN:John Doe
    ORG:BusyContacts Inc.
    TITLE:Software Engineer
    TEL;TYPE=CELL:+1-555-123-4567
    EMAIL:john.doe@example.com
    ADR;TYPE=WORK:;;123 Business St;San Francisco;CA;94107;USA
    URL:https://busymac.com
    END:VCARD
    """
    
    do {
      // Create QR code document from vCard string
      let doc = try QRCode.Document(utf8String: vCardString, errorCorrection: .high)
      
      // Customize appearance
      doc.design.backgroundColor(CGColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0))
      
      // Set pixel shape (rounded squares)
      doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.8)
      
      // Main QR color
      doc.design.style.onPixels = QRCode.FillStyle.Solid(0.15, 0.15, 0.58, alpha: 1.0)
      
      // Eye styling
      doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
      doc.design.style.eye = QRCode.FillStyle.Solid(0.15, 0.15, 0.58, alpha: 1.0)
      doc.design.style.pupil = QRCode.FillStyle.Solid(0.15, 0.15, 0.58, alpha: 1.0)
      
      // Optional: Add a contact photo as logo
      if let contactImage = NSImage(named: "logo") {
        // Create circular mask for the image
        doc.logoTemplate = QRCode.LogoTemplate(
          image: contactImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
          path: CGPath(ellipseIn: CGRect(x: 0.35, y: 0.35, width: 0.3, height: 0.3), transform: nil),
          inset: 8
        )
      }
      
      // Assign to the QR code view
      qrcodeView3.document = doc
      
      // Optionally export to file
      let svgData = try doc.svg(dimension: 512)
      try svgData.write(to: URL(string: "file:///tmp/vcard_qrcode.svg")!, atomically: true, encoding: .utf8)
      
      let pdfData = try doc.pdfData(dimension: 512)
      try pdfData.write(to: URL(string: "file:///tmp/vcard_qrcode.pdf")!)
      
      // For easy testing with a phone, also save as PNG
      if let cgImage = try? doc.cgImage(CGSize(width: 512, height: 512)) {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
          try pngData.write(to: URL(string: "file:///tmp/vcard_qrcode.png")!)
        }
      }
    }
    catch {
      print("Error generating vCard QR code: \(error)")
    }
  }
  
  func setupCalendarEventQRCode() {
    // Get the current date for use in the event
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime]
    
    let now = Date()
    let calendar = Calendar.current
    
    // Create start time (next Monday at 10:00 AM)
    var startDateComponents = calendar.dateComponents([.year, .month, .day], from: now)
    let currentWeekday = calendar.component(.weekday, from: now)
    let daysToAdd = (9 - currentWeekday) % 7 // Calculate days until next Monday (weekday 2)
    startDateComponents.day! += daysToAdd
    startDateComponents.hour = 10
    startDateComponents.minute = 0
    startDateComponents.second = 0
    
    let startDate = calendar.date(from: startDateComponents)!
    
    // Create end time (1 hour later)
    let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate)!
    
    // Format the dates
    let startDateString = dateFormatter.string(from: startDate)
    let endDateString = dateFormatter.string(from: endDate)
    let currentTimeString = dateFormatter.string(from: now)
    
    // Create a unique identifier
    let uuid = UUID().uuidString
    
    // Create the iCalendar content
    let icsString = """
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//BusyApps//BusyCal 2025.2.1//EN
    CALSCALE:GREGORIAN
    BEGIN:VEVENT
    DTSTART;VALUE=DATE:20250507
    DTEND;VALUE=DATE:20250510
    SUMMARY:New Banner
    UID:1B6247EA-41BD-46EC-BF1F-1245972B682B
    DTSTAMP:20250502T122901Z
    CREATED:20250502T122856Z
    TRANSP:TRANSPARENT
    LAST-MODIFIED:20250502T122857Z
    BEGIN:VALARM
    UID:DF9A3EB9-ED15-4740-9514-1BAD68E34E2D
    TRIGGER;VALUE=DURATION:-PT14H
    X-BUSYMAC-DEFAULT-ALARM:TRUE
    ACTION:AUDIO
    ATTACH;VALUE=URI:Doors
    END:VALARM
    BEGIN:VALARM
    UID:39236369-0FDB-48CE-9B29-D0161E73E863
    TRIGGER;VALUE=DURATION:PT14H
    X-BUSYMAC-DEFAULT-ALARM:TRUE
    ACTION:AUDIO
    ATTACH;VALUE=URI:Hero
    END:VALARM
    BEGIN:VALARM
    UID:7D7E8502-8789-49BE-AAB0-AFFFAE4B9F83
    TRIGGER;VALUE=DURATION:-PT6H
    X-BUSYMAC-DEFAULT-ALARM:TRUE
    ACTION:AUDIO
    ATTACH;VALUE=URI:Doors
    END:VALARM
    END:VEVENT
    END:VCALENDAR
    """
    
    do {
      // Create QR code document from the iCalendar string
      let doc = try QRCode.Document(utf8String: icsString, errorCorrection: .high)
      
      // Customize appearance
      doc.design.backgroundColor(CGColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0))
      
      // Set pixel shape (rounded squares)
      doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath(cornerRadiusFraction: 0.8)
      
      // Main QR color
      doc.design.style.onPixels = QRCode.FillStyle.Solid(0.0, 0.4, 0.8, alpha: 1.0)
      
      // Eye styling
      doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
      doc.design.style.eye = QRCode.FillStyle.Solid(0.0, 0.4, 0.8, alpha: 1.0)
      doc.design.style.pupil = QRCode.FillStyle.Solid(0.0, 0.4, 0.8, alpha: 1.0)
      
      // Add a calendar icon as logo
      if let calendarImage = NSImage(named: "apple") {
        doc.logoTemplate = QRCode.LogoTemplate(
          image: calendarImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!,
          path: CGPath(ellipseIn: CGRect(x: 0.35, y: 0.35, width: 0.3, height: 0.3), transform: nil),
          inset: 8
        )
      }
      
      // Assign to the QR code view
      qrcodeView3.document = doc
      
      // Optionally export to file
      let svgData = try doc.svg(dimension: 512)
      try svgData.write(to: URL(string: "file:///tmp/calendar_event_qrcode.svg")!, atomically: true, encoding: .utf8)
      
      let pdfData = try doc.pdfData(dimension: 512)
      try pdfData.write(to: URL(string: "file:///tmp/calendar_event_qrcode.pdf")!)
      
      // For easy testing with a phone, also save as PNG
      if let cgImage = try? doc.cgImage(CGSize(width: 512, height: 512)) {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
          try pngData.write(to: URL(string: "file:///tmp/calendar_event_qrcode.png")!)
        }
      }
      
      print("Calendar event QR code generated successfully!")
    }
    catch {
      print("Error generating calendar event QR code: \(error)")
    }
  }
}

