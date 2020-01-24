// Copyright (c) 2019 Spotify AB.
//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import MobiusCore
import Nimble
import Quick

// swiftlint:disable type_body_length file_length

private typealias Event = ()

private enum Effect: Equatable {
    case justEffect
    case effectWithString(String)
    case effectWithTuple(left: String, right: Int)
}

private indirect enum List: Equatable {
    case singleton(String)
}

private func unwrap<Input, Payload, Output>(
    effect: Input,
    usingRoute partialRouter: PartialEffectRouter<Input, Payload, Output>
) -> Payload? {
    var payload: Payload?
    let handler = partialRouter
        .to { unwrappedPayload in
            payload = unwrappedPayload
        }
        .asConnectable
        .connect { _ in }

    handler.accept(effect)
    handler.dispose()
    return payload
}

class PayloadExtractionRouteTests: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        context("Different types of enums being unwrapped") {
            it("supports routing to an effect with nothing to unwrap") {
                let route = EffectRouter<Effect, Never>()
                    .routeCase(Effect.justEffect)

                let result: Void? = unwrap(effect: .justEffect, usingRoute: route)

                expect(result).to(beVoid())
            }

            it("supports unwrapping an effect with a string") {
                let route = EffectRouter<Effect, Never>()
                    .routeCase(Effect.effectWithString)

                let result = unwrap(effect: .effectWithString("test"), usingRoute: route)

                expect(result).to(equal("test"))
            }

            it("supports unwrapping an effect with a tuple") {
                let route = EffectRouter<Effect, Never>()
                    .routeCase(Effect.effectWithTuple)

                if let (leftUnwrapped, rightUnwrapped) = unwrap(
                    effect: .effectWithTuple(left: "Test", right: 1),
                    usingRoute: route
                ) {
                    expect(leftUnwrapped).to(equal("Test"))
                    expect(rightUnwrapped).to(equal(1))
                } else {
                    fail("Unable to unwrap containing a tuple.")
                }
            }

            it("supports unwrapping an indirect type") {
                let route = EffectRouter<List, Never>()
                    .routeCase(List.singleton)

                let result = unwrap(effect: .singleton("Test"), usingRoute: route)

                expect(result).to(equal("Test"))
            }
        }
    }
}