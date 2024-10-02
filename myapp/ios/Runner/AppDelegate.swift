import UIKit
import Flutter

@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

// Método main() para iniciar a aplicação
func main() {
    UIApplicationMain(
        CommandLine.argc,
        CommandLine.unsafeArgv,
        nil, // O nome da classe do aplicativo pode ser especificado aqui se necessário.
        NSStringFromClass(AppDelegate.self) // Classe AppDelegate
    )
}

// Chame o método main() para iniciar a aplicação
main()
