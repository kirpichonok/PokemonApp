import XCTest

final class PokemonListViewModelTests: XCTestCase
{
    var viewModel: PokemonListViewModel!
    var fetchPokemonsUseCase: FetchPokemonsPageUseCaseMock!
    var coordinator: CoordinatorMock!

    override func setUp()
    {
        super.setUp()
        fetchPokemonsUseCase = FetchPokemonsPageUseCaseMock()
        coordinator = CoordinatorMock()
        viewModel = PokemonListViewModel(
            fetchPokemonsUseCase: fetchPokemonsUseCase,
            coordinator: coordinator
        )
    }

    override func tearDown()
    {
        viewModel = nil
        fetchPokemonsUseCase = nil
        coordinator = nil
        super.tearDown()
    }

    func testFetchPokemonsPageInitial() async
    {
        await viewModel.currentTask?.value
        await viewModel.fetchPokemonsPage(.initial)

        XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
        XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 2)
        XCTAssertEqual(viewModel.pageViewModel.currentPageNumber, 1)
    }

    func testFetchPokemonsPageNextIncreasesCurrentPageNumber() async
    {
        await viewModel.currentTask?.value
        await viewModel.fetchPokemonsPage(.next)

        XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
        XCTAssertEqual(viewModel.requestState, .success)
        XCTAssertEqual(viewModel.pageViewModel.currentPageNumber, 2)
    }

    func testFetchPokemonsPagePreviousOnInitialPageDoesNotChangePage() async
    {
        await viewModel.currentTask?.value
        await viewModel.fetchPokemonsPage(.previous)

        XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
        XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 1)
        XCTAssertEqual(viewModel.requestState, .success)
        XCTAssertEqual(viewModel.pageViewModel.currentPageNumber, 1)
    }

    func testFetchPokemonsPagePreviousDecreasesPageNumber() async
    {
        await viewModel.currentTask?.value
        await viewModel.fetchPokemonsPage(.next)
        await viewModel.fetchPokemonsPage(.previous)

        XCTAssertEqual(viewModel.requestState, .success)
        XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
        XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 3)
        XCTAssertEqual(viewModel.pageViewModel.currentPageNumber, 1)
    }

    func testReload() async
    {
        let initialCurrentPageNumber = viewModel.pageViewModel.currentPageNumber
        await viewModel.currentTask?.value
        await viewModel.reload()

        XCTAssertTrue(fetchPokemonsUseCase.fetchPokemonListCalled)
        XCTAssertEqual(fetchPokemonsUseCase.fetchPokemonListCalledCount, 2)
        XCTAssertEqual(viewModel.pageViewModel.currentPageNumber, initialCurrentPageNumber)
    }

    func testDidSelectReturnsWhenCurrentPageIsNil() async throws
    {
        await viewModel.currentTask?.value
        viewModel.didSelectRow(index: 0)
        let destination = try XCTUnwrap(coordinator.destination)

        XCTAssertTrue(coordinator.pushCalled)
        XCTAssertEqual(destination, .detailView(of: DummyData.testPokemonPreview))
    }
}
