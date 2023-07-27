import Flutter
import UIKit

public class PhonePePgPlugin: NSObject, FlutterPlugin {
    private var getUpiApps: String  = "getUpiApps";
    private var startTransaction = "startTransaction";
    //private var callbackSchema: String = "
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "phone_pe_pg", binaryMessenger: registrar.messenger())
    let instance = PhonePePgPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {
      guard let arguments = call.arguments as? [String: Any?] else {
          result(FlutterError(code: "Invalid Input", message: "The argument was not provider or Failed to parse the argument", details: nil))
          return;
      }
    switch call.method {
    case getUpiApps:
        
        guard let upiAppsInput = arguments["iOSUpiApps"] as? [String] else {
            result(FlutterError(code: "Invalid Input", message: "The provided data is not a valid list of string", details: nil))
            return;
        }
        var upiApps = getInstalledUpiApp(bundleIds: upiAppsInput);
        result(upiApps);
    case startTransaction:
        guard let url = arguments["upi_uri"] as? String else {
            result(FlutterError(code: "Invalid Input", message: "The provided data is not a valid list of string", details: nil))
            return;
        }
    
        startTransaction(url: url, completion: {data in
            print(data);
            result(data)
        })
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    public func getInstalledUpiApp(bundleIds: [String]) -> [String] {
        var installedApps:[String] = [];
        for bundleId in bundleIds {
            if let url = URL(string: "\(bundleId)://") {
                if UIApplication.shared.canOpenURL(url) {
                    installedApps.append(bundleId);
                }
            }
        }
        return installedApps;
    }
    
    private struct UriSchemeConstants {
        static let uriScheme1 = "ppemerchantsdkv1"
        static let uriScheme2 = "ppemerchantsdkv2"
        static let uriScheme3 = "ppemerchantsdkv3"
        static let hyphenation =  "://"
    }
    
    private func isPhonePeInstalled() -> Bool {
        DispatchQueue.main.sync {
            guard let openUrl1 = URL(string: UriSchemeConstants.uriScheme1 + UriSchemeConstants.hyphenation),
                  let openUrl2 = URL(string: UriSchemeConstants.uriScheme2 + UriSchemeConstants.hyphenation),
                  let openUrl3 = URL(string: UriSchemeConstants.uriScheme3 + UriSchemeConstants.hyphenation) else {
                return false
            }
             
            let appInstalled = UIApplication.shared.canOpenURL(openUrl1) ||
                                UIApplication.shared.canOpenURL(openUrl2) ||
                                UIApplication.shared.canOpenURL(openUrl3)
             
            return appInstalled
        }
    }
     
    private func getAppSupportedSchema() -> [String] {
        var supportedAppSchemas: [String] = []
        DispatchQueue.main.sync {
            [UriSchemeConstants.uriScheme1, UriSchemeConstants.uriScheme2, UriSchemeConstants.uriScheme3].forEach { (scheme) in
                 
                if let openUrl = URL(string: scheme + UriSchemeConstants.hyphenation),
                   UIApplication.shared.canOpenURL(openUrl) {
                    supportedAppSchemas.append(scheme)
                }
            }
        }
        return supportedAppSchemas
    }
     
    func getDeviceContext() -> [String: Any] {
        var context: [String: Any] = [:]
         
        context["appSupportedSchemas"] = getAppSupportedSchema()
        context["isPPAppPresent"] = isPhonePeInstalled()
        context["deviceOS"] = "iOS"
         
        //if let schema = callbackSchema {
          //context["merchantCallBackScheme"] = schema
        
         
        return context
    }
    

    
    func startTransaction(url: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: { data in
                completion(data);
           });
        }
    }
    
}
