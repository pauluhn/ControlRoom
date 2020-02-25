//
//  CreateSimulatorActionSheet.swift
//  ControlRoom
//
//  Created by Dave DeLong on 2/15/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

struct CreateSimulatorActionSheet: View {
    let controller: SimulatorsController

    @State var deviceType: DeviceType
    @State var runtime: Runtime
    @State var name: String = ""

    init(controller: SimulatorsController) {
        self.controller = controller
        _deviceType = State(initialValue: controller.deviceTypes[0])
        _runtime = State(initialValue: controller.runtimes[0])
    }

    private var canCreate: Bool {
        return name.isNotEmpty && warning == nil
    }

    private var warning: String? {
        let supportedFamilies = runtime.supportedFamilies
        if supportedFamilies.contains(deviceType.family) { return nil }

        let familyList = ListFormatter().string(from: supportedFamilies.map { $0.displayName })!
        return "\(runtime.name) can only be used with \(familyList) devices."
    }

    var body: some View {
        SimulatorActionSheet(icon: (deviceType.modelTypeIdentifier ?? .defaultiPhone).icon,
                             message: "Create Simulator",
                             informativeText: "Choose the device type and operating system for the new simulator",
                             confirmationTitle: "Create",
                             confirm: self.confirm,
                             canConfirm: canCreate,
                             content: {
                                Form {
                                    TextField("Name", text: $name)

                                    Picker("Device", selection: $deviceType) {
                                        ForEach(controller.deviceTypes) {
                                            Text($0.name).tag($0)
                                        }
                                    }

                                    Picker("System", selection: $runtime) {
                                        ForEach(controller.runtimes) {
                                            Text($0.name).tag($0)
                                        }
                                    }

                                    if warning != nil {
                                        HStack(alignment: .top) {
                                            Image(nsImage: NSImage(named: NSImage.cautionName)!)
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(width: 18)
                                            Text(warning!)
                                        }
                                    }
                                }
        })
    }

    private func confirm() {
        SimCtl.create(name: name, deviceType: deviceType, runtime: runtime)
    }
}

struct CreateSimulatorActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateSimulatorActionSheet(controller: SimulatorsController())
    }
}