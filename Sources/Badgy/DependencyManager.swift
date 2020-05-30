//
//  Badgy
//
//  Created by Arthur Alves on 30/05/2020.
//

import PathKit

class DependencyManager {
    func areDependenciesInstalled() -> Bool {
        let convertExecutablePath = Path("/usr/local/bin/convert")
        return convertExecutablePath.exists && convertExecutablePath.isExecutable
    }
}
