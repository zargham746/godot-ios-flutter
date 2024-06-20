import Flutter
import UIKit
import Foundation
import SwiftGodotKit
import SwiftGodot

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    let METHOD_CHANNEL_NAME = "dev.com/godot-channel"
    let godotChannel = FlutterMethodChannel(
      name: METHOD_CHANNEL_NAME,
      binaryMessenger: controller.binaryMessenger
    )

    godotChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "getgodot":
        guard let args = call.arguments as? [String:String] else {return}
        let name = args["name"]!
        self.load()
      default:
      result(FlutterMethodNotImplemented)
        
      }
    })



    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  private func receiveBatteryLevel() -> Int {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true

    if (device.batteryState == UIDevice.BatteryState.unknown) {
      return -1
    } else {
      return Int(device.batteryLevel * 100)
    }
  }
}



func loadScene (scene: SceneTree) {
    let rootNode = Node3D()
    let camera = Camera3D ()
    camera.current = true
    camera.position = Vector3(x: 0, y: 0, z: 2)
    
    rootNode.addChild(node: camera)
    
    func makeCuteNode (_ pos: Vector3) -> Node {
        let n = SpinningCube()
        n.position = pos
        return n
    }
    rootNode.addChild(node: makeCuteNode(Vector3(x: 1, y: 1, z: 1)))
    rootNode.addChild(node: makeCuteNode(Vector3(x: -1, y: -1, z: -1)))
    rootNode.addChild(node: makeCuteNode(Vector3(x: 0, y: 1, z: 1)))
    scene.root?.addChild(node: rootNode)
}


class SpinningCube: Node3D {
    required init (nativeHandle: UnsafeRawPointer) {
        super.init (nativeHandle: nativeHandle)
    }
    
    required init () {
        super.init ()
        let meshRender = MeshInstance3D()
        meshRender.mesh = BoxMesh()
        addChild(node: meshRender)
    }
    
    override func _input (event: InputEvent) {
        guard event.isPressed () && !event.isEcho () else { return }
        print ("SpinningCube: event: isPressed ")
    }
    
    public override func _process(delta: Double) {
        rotateY(angle: delta)
    }
}

func registerTypes (level: GDExtension.InitializationLevel) {
    switch level {
    case .scene:
        register (type: SpinningCube.self)
    default:
        break
    }
}

     func load () {
        runGodot(args: [], initHook: registerTypes, loadScene: loadScene, loadProjectSettings: { settings in })
    }
