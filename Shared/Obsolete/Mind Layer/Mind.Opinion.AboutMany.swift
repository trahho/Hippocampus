//
//  Mind.Opinion.AboutMany.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.09.22.
//

import Foundation

extension Mind.Opinion {
    class AboutMany: Mind.Opinion {
        @Serialized var opinions: [Mind.Opinion]

        required init() {}

        init(_ opinions: [Mind.Opinion]) {
            super.init()
            self.opinions = opinions
        }

        class Some: AboutMany {
            override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
                let agreement = opinions.reduce((matches: false, perspectives: Set<Perspective>())) { agreement, opinion in
                    let acceptance = opinion.take(for: information)
                    return (agreement.matches || acceptance.matches, agreement.perspectives.union(acceptance.perspectives))
                }
                return agreement
            }
        }

        class All: AboutMany {
            override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
                let agreement = opinions.reduce((matches: false, perspectives: Set<Perspective>())) { agreement, opinion in
                    let acceptance = opinion.take(for: information)
                    return (agreement.matches && acceptance.matches, agreement.perspectives.union(acceptance.perspectives))
                }
                return agreement.matches ? agreement : (false, [])
            }
        }

        class First: AboutMany {
            override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
                return opinions.map { $0.take(for: information) }.first { $0.matches } ?? (false, [])
            }
        }
    }
}
