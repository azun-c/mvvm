//
//  BaseTestCase.swift
//  mvvmTests
//
//  Created by azun on 21/07/2023.
//

import XCTest
import Combine

class BaseTestCase: XCTestCase {
    var disposeBag = Set<AnyCancellable>()
}
