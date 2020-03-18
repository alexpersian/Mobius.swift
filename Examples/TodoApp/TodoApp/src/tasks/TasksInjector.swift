//
//  TasksInjector.swift
//  TodoApp
//
//  Created by Alexander Persian on 3/17/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import MobiusCore
import MobiusExtras

final class TasksInjector {

    func createController(effectHandler: ConsumerTransformer<TasksListEffect, TasksList>,
                          eventSource: EventSource<TasksListEffect>,
                          defaultModel: TasksListModel) -> MobiusController<TasksListModel, TasksListEvent> {
        return MobiusController(builder: <#T##Mobius.Builder<_, _, _>#>, defaultModel: defaultModel)
    }

    private func createLoop(eventSource: EventSource<TasksListEvent>,
                            effectHandler: ConsumerTransformer<TasksListEffect, TasksListEvent>) -> Mobius.Builder<TasksListModel, TasksListEvent, TasksListEffect> {
        
    }
}
