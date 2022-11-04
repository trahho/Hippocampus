//
//  Brain.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Combine
import Foundation

protocol CompletelyObservableObject: ObservableObject {
    associatedtype ObjectDidChangePublisher: Publisher = ObservableObjectPublisher
}

final class Brain: Serializable, ObservableObject {
    typealias Dream = () throws -> ()

    enum InformationChange {
        case neuronCreated(Neuron)
        case synapseCreated(Synapse)
        case modified(Information, Date)
    }

    @Serialized private var informationId: Information.ID = 0
    @Serialized private(set) var neurons: [Information.ID: Neuron] = [:]
    @Serialized private(set) var synapses: [Information.ID: Synapse] = [:]

    func recover() {
        neurons.values.forEach { neuron in
            neuron.brain = self
        }
        synapses.values.forEach { synapse in
            synapse.brain = self
            synapse.connect()
        }
    }

    var currentMoment: Date?
    var dreaming = false

    func dream(_ dream: Dream) {
        remember(moment: Date())
        dreaming = true
        do {
            try dream()
        } catch {
            forget()
        }
        awaken()
    }
    
    func dream() {
        remember(moment: Date())
        dreaming = true
    }


    func remember(moment: Date) {
        guard !dreaming, moment <= Date() else { return }
        objectWillChange.send()
        dreaming = false
        currentMoment = moment
    }

    func awaken() {
        guard currentMoment != nil else { return }
        objectWillChange.send()
        dreaming = false
        currentMoment = nil
        informationChanges = []
    }

    func forget() {
        guard dreaming else { return }
        for change in informationChanges {
            switch change {
            case let .neuronCreated(neuron):
                neurons.removeValue(forKey: neuron.id)
            case let .synapseCreated(synapse):
                synapse.disconnect()
                synapses.removeValue(forKey: synapse.id)
            case let .modified(information, moment):
                information.forget(moment: moment)
            }
        }
        informationChanges = []
    }

    private var informationChanges: [InformationChange] = []

    func addChange(_ change: InformationChange) {
        informationChanges.append(change)
    }

    func add(neuron: Neuron) {
        guard dreaming, neurons[neuron.id] == nil else { return }
        if neuron.id == 0 {
            informationId += 1
            neuron.id = informationId
        }
        neurons[neuron.id] = neuron
        addChange(.neuronCreated(neuron))
    }

    func add(synapse: Synapse) {
        guard dreaming, synapses[synapse.id] == nil else { return }
        if synapse.id == 0 {
            informationId += 1
            synapse.id = informationId
        }
        synapses[synapse.id] = synapse
        add(neuron: synapse.emitter)
        add(neuron: synapse.receptor)
        addChange(.synapseCreated(synapse))
    }
}
