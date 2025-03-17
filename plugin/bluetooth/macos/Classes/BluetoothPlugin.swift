import Cocoa
import FlutterMacOS

public class BluetoothPlugin: NSObject {
    
    public static let shared = BluetoothPlugin()
    override private init() {}
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      BluetoothManager.shared.delegate = ApiBluetoothListener(binaryMessenger: registrar.messenger)
      ApiBluetoothSetup.setUp(binaryMessenger: registrar.messenger, api: BluetoothManager.shared)
  }

}
