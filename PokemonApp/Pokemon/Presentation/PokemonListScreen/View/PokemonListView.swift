import SwiftUI

struct PokemonListView: View {
    init(
        useCase:  @escaping () -> DefaultFetchPokemonsPageUseCase,
        coordinator: @autoclosure @escaping () -> AppCoordinator
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                fetchPokemonsUseCase: useCase(),
                coordinator: coordinator()
            )
        )
    }

    @StateObject var viewModel: ViewModel<DefaultFetchPokemonsPageUseCase, AppCoordinator>
}

// MARK: - Body

extension PokemonListView {
    var body: some View {
        ZStack {
            List(
                viewModel.listOfPokemons.indices,
                id: \.self
            ) { index in
                Button {
                    viewModel.didSelectRow(index: index)
                }
                label: {
                    let name = viewModel.listOfPokemons[index]
                    Text(name)
                        .tint(.primary)
                }
            }
            .disabled(viewModel.requestState != .success)
            .blur(radius: viewModel.requestState == .success ? 0 : 4)

            switch viewModel.requestState {
            case let .failed(withError: error):
                ErrorView(
                    error: error,
                    reloadAction: { Task { await viewModel.reload() }}
                )

            case .isLoading: AppProgressView()
            case .success: EmptyView()
            }
        }
        .task { await viewModel.switchTo(page: .initial) }
        .navigationTitle("Pokemons")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                toolbarItems
            }
        }
    }
}

// MARK: - Subviews

private extension PokemonListView {
    @ViewBuilder
    var toolbarItems: some View {
        HStack(spacing: 40) {
            Button {
                Task { await viewModel.switchTo(page: .previous) }
            }
            label: {
                Image(systemName: .SystemImageName.chevronBackwardSquare)
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(viewModel.previousPageDisabled ? .gray : .accentColor)
            .disabled(viewModel.previousPageDisabled)

            Text(viewModel.currentPageNumber.formatted() +
                " / " + viewModel.numberOfPages.formatted())
                .font(.title2)

            Button {
                Task { await viewModel.switchTo(page: .next) }
            }
            label: {
                Image(systemName: .SystemImageName.chevronForwardSquare)
            }
            .font(.title2)
            .buttonStyle(.bordered)
            .foregroundStyle(viewModel.nextPageDisabled ? .gray : .accentColor)
            .disabled(viewModel.nextPageDisabled)
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListView(
            useCase: AppDIContainer().makeFetchPokemonsPageUseCase,
            coordinator: AppCoordinator()
        )
    }
}
