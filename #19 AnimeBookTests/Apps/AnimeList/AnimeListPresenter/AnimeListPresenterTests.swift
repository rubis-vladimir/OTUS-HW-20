//
//  AnimeListPresenterTests.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 07.11.2022.
//

import XCTest
@testable import _19_AnimeBook

final class AnimeListPresenterTests: XCTestCase {
    
    var view: AnimeListViewStub!
    var router: MockAnimeListRouter!
    var dataFetcher: DataFetcherProxySpy!
    var sut: AnimeListPresenter!
    
    override func setUp() {
        super.setUp()
        router = MockAnimeListRouter()
    }
    
    override  func tearDown() {
        view = nil
        router = nil
        dataFetcher = nil
        sut = nil
        super.tearDown()
    }
    
    /// Настроивает модуль в зависимости от case
    func prepareModuleWithCase(success: Bool) {
        if success {
            let animeModels = [AnimeModel(title: "Foo")]
            dataFetcher = DataFetcherProxySpy(animeModels: animeModels)
            view = AnimeListViewStub(titleTest: "Foo")
        } else {
            dataFetcher = DataFetcherProxySpy(error: .failedToLoad)
            view = AnimeListViewStub()
        }
        sut = AnimeListPresenter(router: router,
                                 dataFetcher: dataFetcher)
        sut.delegate = view
    }
    
    func testGetSuccessModelsRandom() {
        //arange
        prepareModuleWithCase(success: true)
        
        //act
        sut.getAnime(with: .random)
        let animeTitle = sut.animeModels.first?.title
        let count = sut.animeModels.count
        
        //assert
        XCTAssertEqual(animeTitle, "Foo")
        XCTAssertEqual(count, 1)
    }
    
    func testGetSuccessModelsSearch() {
        //arange
        prepareModuleWithCase(success: true)
        let parameters: ParametersAnimeRequest = [.letter: "Baz"]
        
        //act
        sut.getAnime(with: .search(with: parameters))
        let animeTitle = sut.animeModels.last?.title
        let count = sut.animeModels.count
        
        //assert
        XCTAssertEqual(animeTitle, "Baz Bar")
        XCTAssertEqual(count, 2)
    }
    
    func testGetFailureRandom() {
        //arange
        prepareModuleWithCase(success: false)
        
        //act
        sut.getAnime(with: .random)
        let animeTitle = sut.animeModels.first?.title
        
        //assert
        XCTAssertNil(animeTitle)
    }
    
    func testViewSuccessSearch() {
        //arange
        prepareModuleWithCase(success: true)
        let parameters: ParametersAnimeRequest = [.letter: "Baz"]
        
        //act
        sut.getAnime(with: .search(with: parameters))
        
        //assert
        do {
            let title = try view.retrieve()
            XCTAssertEqual(title, "Baz")
        } catch {
            XCTFail("Тест не удался")
        }
    }
    
    func testViewFailureRandom() {
        //arange
        prepareModuleWithCase(success: false)
        
        //act
        sut.getAnime(with: .random)
        
        //assert
        XCTAssertThrowsError(try view.retrieve())
    }
    
    func testRouterInteraction() {
        //arange
        prepareModuleWithCase(success: false)
        let anime = AnimeModel(title: "Foo Bar")
        
        //act
        sut.tapAnime(anime)
        let title = router.retrieve()
        
        //assert
        XCTAssertEqual(title, "Foo Bar")
    }
}
