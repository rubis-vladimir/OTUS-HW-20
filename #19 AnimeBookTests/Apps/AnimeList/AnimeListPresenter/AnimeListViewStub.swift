//
//  AnimeListViewStub.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 07.11.2022.
//

import Foundation
@testable import _19_AnimeBook

final class AnimeListViewStub: AnimeListPresenterDelegate {
    private var titleTest: String?
    private var retrieveError: Error?
    
    init(titleTest: String? = nil) {
        self.titleTest = titleTest
    }
    
    func updateUI() {
        self.titleTest = "Baz"
    }
    
    func showError(_ rError: _19_AnimeBook.RecoverableError) {
        self.retrieveError = rError.error
    }
    
    func retrieve() throws -> String? {
        if let error = retrieveError {
            throw error
        } else {
            return titleTest
        }
    }
}
