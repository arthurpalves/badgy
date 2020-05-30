//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import SwiftCLI
import PathKit

extension Factory {
    func resize(filename: Path) {
        let sizes = [20, 29, 40, 50, 57, 58, 60, 72, 76, 80, 87, 100, 114, 120, 144, 152, 180, 167, 180]
        let bareFilename = Path("\(filename.parent())/\(filename.lastComponentWithoutExtension)")
        sizes.forEach {
            let size = "\($0)x\($0)"
            Logger.shared.logInfo("Resizing to: ", item: size, color: .purple)
            do {
                try Task.run(
                    "convert", filename.absolute().description,
                    "-resize", size,
                    "\(bareFilename)_\($0).png"
                )
            } catch {
                Logger.shared.logError("Error: ", item: "Failed to resize icon to \(size)", color: .red)
            }
        }
    }
}
