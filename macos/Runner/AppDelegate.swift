import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel.init(name: "com.github.kurotu.tiny_vcc/platform", binaryMessenger: controller.engine.binaryMessenger)
    channel.setMethodCallHandler({
      (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
        switch call.method {
          case "moveToTrash":
            let arguments = call.arguments
            let path = arguments as! String
            do {
              try moveToTrash(path:path)
              result(nil)
            } catch {
              result(FlutterError(code: "MoveToTrash", message: error.localizedDescription, details: "\(error)"))
            }
          default:
            result(FlutterMethodNotImplemented)
        }
    });
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
