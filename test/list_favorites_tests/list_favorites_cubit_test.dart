import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_challege/favorites_list/cubits/favorites_list_cubit.dart';
import 'package:flutter_challege/favorites_list/repositories/favorites_list_repository.dart';
import 'package:flutter_challege/models/complete_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FavoritesListRepositoryMock extends Mock implements FavoritesListRepository {}

main() {
  late FavoritesListRepositoryMock favoritesListRepositoryMock;

  late FavoritesListCubit favoritesListCubit;

  setUp(() {
    favoritesListRepositoryMock = FavoritesListRepositoryMock();
    favoritesListCubit = FavoritesListCubit(favoritesListRepositoryMock);
  });

  tearDown(() {
    favoritesListCubit.close();
  });

  test('bloc should have initial state as [InitialState]', () {
    expect(favoritesListCubit.state.favorites, []);
  });

  blocTest(
      'should emit [LoadingFavoritesState, LoadedFavoritesState] state when get favorites',
      build: () => favoritesListCubit,
      act: (FavoritesListCubit bloc) {
        bloc.state.favorites = [];
        when(() => favoritesListRepositoryMock.getFavorites.call())
            .thenAnswer((_) async => []);

        bloc.getFavorites();
      },
      expect: () => [
        isA<LoadingFavoritesState>(),
        isA<LoadedFavoritesState>(),
      ],
      verify: (_) {
        verify(() => favoritesListRepositoryMock.getFavorites()).called(1);
      });

  blocTest(
      'should emit [LoadingFavoritesState, ErrorState] state when get favorites and repository fails',
      build: () => favoritesListCubit,
      act: (FavoritesListCubit bloc) {
        bloc.state.favorites = [];
        when(() => favoritesListRepositoryMock.getFavorites.call())
            .thenThrow(Exception());

        bloc.getFavorites();
      },
      expect: () => [
        isA<LoadingFavoritesState>(),
        isA<ErrorState>(),
      ],
      verify: (_) {
        verify(() => favoritesListRepositoryMock.getFavorites()).called(1);
      });

  blocTest('should not emit anything if list is empty when organizing favorites',
      build: () => favoritesListCubit,
      act: (FavoritesListCubit bloc) {
        bloc.state.favorites = [];
        bloc.organizeFavorites([]);
      },
      verify: (_) {
        verifyNever(() => favoritesListRepositoryMock.getFavorites());
      });

  blocTest('should emit [FavoritesRearrangedState] state when rearrange favorites',
      build: () => favoritesListCubit,
      act: (FavoritesListCubit bloc) {
        bloc.state.favorites = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        bloc.rearrange(0, 0, 0);
      },
      expect: () => [
        isA<FavoritesRearrangedState>(),
      ],
      verify: (_) {
        verifyNever(() => favoritesListRepositoryMock.getFavorites());
      });

  blocTest('should emit [RemovedToFavorites] state when an item is removed from favorites',
      build: () => favoritesListCubit,
      act: (FavoritesListCubit bloc) {
        bloc.state.favorites = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        when(() => favoritesListRepositoryMock.removeFromFavorites.call(''))
            .thenAnswer((_) async {});

        bloc.removeFromFavorites(CompleteItemModel(
            category: '', name: '', imageUrl: '', isFavorite: false), 0);
      },
      expect: () => [
        isA<RemovedToFavorites>(),
      ],
      verify: (_) {
        verify(() => favoritesListRepositoryMock.removeFromFavorites(any())).called(1);
      });

  blocTest('should emit [ErrorState] state when an item is added to favorites',
      build: () => favoritesListCubit,
      act: (FavoritesListCubit bloc) {
        bloc.state.favorites = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        when(() => favoritesListRepositoryMock.removeFromFavorites.call(''))
            .thenThrow(Exception());

        bloc.removeFromFavorites(CompleteItemModel(
            category: '', name: '', imageUrl: '', isFavorite: false), 0);
      },
      expect: () => [
        isA<ErrorState>(),
      ],
      verify: (_) {
        verify(() => favoritesListRepositoryMock.removeFromFavorites(any())).called(1);
      });
}

