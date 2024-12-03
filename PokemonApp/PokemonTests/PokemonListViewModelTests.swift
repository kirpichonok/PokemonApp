@testable import Pokemon
import XCTest

final class PokemonListViewModelTests: XCTestCase {
   var viewModel: PokemonListView.ViewModel<FetchPokemonsPageUseCaseMock, CoordinatorMock>!
   var fetchPokemonsUseCase: FetchPokemonsPageUseCaseMock!
   var coordinator: CoordinatorMock!

   override func setUp() {
       super.setUp()
       fetchPokemonsUseCase = FetchPokemonsPageUseCaseMock()
       coordinator = CoordinatorMock()
       viewModel = PokemonListView.ViewModel(
           fetchPokemonsUseCase: fetchPokemonsUseCase,
           coordinator: coordinator
       )
   }

   override func tearDown() {
       viewModel = nil
       fetchPokemonsUseCase = nil
       coordinator = nil
       super.tearDown()
   }

   func testFetchPokemonsPageInitial() async {
       await viewModel.currentTask.values.first?.value
       await viewModel.switchTo(page: .initial)

       XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
       XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 2)
       XCTAssertEqual(viewModel.currentPageNumber, 1)
   }

   func testFetchPokemonsPageNextIncreasesCurrentPageNumber() async {
       await viewModel.currentTask.values.first?.value
       await viewModel.switchTo(page: .next)

       XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
       XCTAssertEqual(viewModel.requestState, .success)
       XCTAssertEqual(viewModel.currentPageNumber, 2)
   }

   func testFetchPokemonsPagePreviousOnInitialPageDoesNotChangePage() async {
       await viewModel.currentTask.values.first?.value
       await viewModel.switchTo(page: .previous)

       XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
       XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 1)
       XCTAssertEqual(viewModel.requestState, .success)
       XCTAssertEqual(viewModel.currentPageNumber, 1)
   }

   func testFetchPokemonsPagePreviousDecreasesPageNumber() async {
       await viewModel.currentTask.values.first?.value
       await viewModel.switchTo(page: .next)
       await viewModel.switchTo(page: .previous)

       XCTAssertEqual(viewModel.requestState, .success)
       XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
       XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 3)
       XCTAssertEqual(viewModel.currentPageNumber, 1)
   }

   func testReload() async {
       let initialCurrentPageNumber = viewModel.currentPageNumber
       await viewModel.currentTask.values.first?.value
       await viewModel.reload()

       XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
       XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 2)
       XCTAssertEqual(viewModel.currentPageNumber, initialCurrentPageNumber)
   }

   func testDidSelectReturnsWhenCurrentPageIsNil() async throws {
       await viewModel.currentTask.values.first?.value
       viewModel.didSelectRow(index: 0)
       let destination = try XCTUnwrap(coordinator.destination)

       XCTAssertTrue(coordinator.pushCalled)
       XCTAssertEqual(destination, .detailView(of: DummyData.testPokemonPreview))
   }
}
