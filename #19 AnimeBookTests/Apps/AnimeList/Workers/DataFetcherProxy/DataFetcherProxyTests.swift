//
//  DataFetcherProxyTests.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 07.11.2022.
//

import XCTest
@testable import _19_AnimeBook

final class DataFetcherProxyTests: XCTestCase {
    
    var sut: DataFetcherProxy!
    var translateManager: TranslateManagerStub!
    var dataFetcher: DataFetcherStub!
    var animeAdapter: MockAnimeCellAdapter!
    
    override func setUp() {
        super.setUp()
        animeAdapter = MockAnimeCellAdapter()
    }
    
    override func tearDown() {
        translateManager = nil
        dataFetcher = nil
        animeAdapter = nil
        sut = nil
        super.tearDown()
    }
    
    /// Настроивает модуль в зависимости от case
    func prepareModuleWithCase(one: Bool, two: Bool) {
        if one {
            dataFetcher = DataFetcherStub(randomAnime: RandomAnime(data: AnimeData(title: "Foo", images: AnimeData.Image(jpg: AnimeData.Image.JPG(imageUrl: "Baz")))),
                                          anime: Anime(data: []))
        } else {
            dataFetcher = DataFetcherStub(retrieveError: .failedToLoad)
        }
        
        if two {
            translateManager = TranslateManagerStub()
        } else {
            translateManager = TranslateManagerStub(retrieveError: .failedToTranslate)
        }
        
        sut = DataFetcherProxy(translateManager: translateManager,
                               dataFetcher: dataFetcher,
                               animeAdapter: animeAdapter)
    }
    
    func testSuccessRandomFailureTranslate() {
        //arange
        prepareModuleWithCase(one: true, two: false)
    
        //act & assert
        sut.fetchAnime(with: .random) { result in
            switch result {
            case .success(let animeModels):
                let title = animeModels.first?.title
                XCTAssertEqual(title, "Foo")
                XCTAssertEqual(animeModels.count, 1)
            case .failure(let error):
                XCTAssertEqual(error, .failedToTranslate)
            }
        }
    }
    
    func testSuccessSearchSuccessTranslate() {
        //arange
        let parameters: ParametersAnimeRequest = [.limit: "5", .letter: "Fo"]
        prepareModuleWithCase(one: true, two: true)
        
        //act & assert
        sut.fetchAnime(with: .search(with: parameters)) { result in
            switch result {
            case .success(let animeModels):
                let title = animeModels.first?.title
                XCTAssertEqual(title, "Перевод слова FoBar удался")
                XCTAssertEqual(animeModels.count, 5)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFailureRandomSuccessTranslate() {
        //arange
        prepareModuleWithCase(one: false, two: true)
        
        //act & assert
        sut.fetchAnime(with: .random) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .failedToLoad)
            }
        }
    }
}
