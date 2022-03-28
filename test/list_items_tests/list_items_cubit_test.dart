import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_challege/items_list/cubits/items_list_cubit.dart';
import 'package:flutter_challege/items_list/repositories/items_list_repository.dart';
import 'package:flutter_challege/models/complete_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ItemsListRepositoryMock extends Mock implements ItemsListRepository {}

main() {
  late ItemsListRepositoryMock itemsListRepositoryMock;

  late ItemsListCubit itemsListCubit;

  setUp(() {
    itemsListRepositoryMock = ItemsListRepositoryMock();
    itemsListCubit = ItemsListCubit(itemsListRepositoryMock);
  });

  tearDown(() {
    itemsListCubit.close();
  });

  test('bloc should have initial state as [InitialState]', () {
    expect(itemsListCubit.state.items, []);
  });

  blocTest(
      'should emit [LoadingItemsState, LoadedItemsState] state when get items',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [];
        when(() => itemsListRepositoryMock.getItems.call())
            .thenAnswer((_) async => []);

        bloc.getItems();
      },
      expect: () => [
            isA<LoadingItemsState>(),
            isA<LoadedItemsState>(),
          ],
      verify: (_) {
        verify(() => itemsListRepositoryMock.getItems()).called(1);
      });

  blocTest(
      'should emit [LoadingItemsState, ErrorState] state when get items and repository fails',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [];
        when(() => itemsListRepositoryMock.getItems.call())
            .thenThrow(Exception());

        bloc.getItems();
      },
      expect: () => [
            isA<LoadingItemsState>(),
            isA<ErrorState>(),
          ],
      verify: (_) {
        verify(() => itemsListRepositoryMock.getItems()).called(1);
      });

  blocTest('should not emit anything if list is empty when organizing items',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [];
        bloc.organizeItems([]);
      },
      verify: (_) {
        verifyNever(() => itemsListRepositoryMock.getItems());
      });

  blocTest('should emit [ItemsRearrangedState] state when rearrange items',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        bloc.rearrange(0, 0, 0);
      },
      expect: () => [
            isA<ItemsRearrangedState>(),
          ],
      verify: (_) {
        verifyNever(() => itemsListRepositoryMock.getItems());
      });

  blocTest('should emit [DeletedItemState] state when item is deleted',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        when(() => itemsListRepositoryMock.deleteItem.call('', ''))
            .thenAnswer((_) async {});

        bloc.deleteItem(CompleteItemModel(
            category: '', name: '', imageUrl: '', isFavorite: false));
      },
      expect: () => [
            isA<DeletedItemState>(),
          ],
      verify: (_) {
        verify(() => itemsListRepositoryMock.deleteItem(any(), any()))
            .called(1);
      });

  blocTest('should emit [DeletedCategoryState] state when category is deleted',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        when(() => itemsListRepositoryMock.deleteItem.call('', ''))
            .thenAnswer((_) async {});
        when(() => itemsListRepositoryMock.deleteCategory.call(''))
            .thenAnswer((_) async {});

        bloc.deleteCategory('');
      },
      expect: () => [
            isA<DeletedCategoryState>(),
          ],
      verify: (_) {
        verify(() => itemsListRepositoryMock.deleteCategory(any())).called(1);
        verify(() => itemsListRepositoryMock.deleteItem(any(), any()))
            .called(1);
      });

  blocTest(
    'should emit [SearchedState] state when a word is searched',
    build: () => itemsListCubit,
    act: (ItemsListCubit bloc) {
      bloc.state.items = [
        [
          CompleteItemModel(
              category: '', name: '', imageUrl: '', isFavorite: false)
        ]
      ];
      bloc.state.searchedList = [];

      bloc.search('');
    },
    expect: () => [
      isA<SearchedState>(),
    ],
  );

  blocTest(
    'should emit [LoadedItemsState] state when search is closed',
    build: () => itemsListCubit,
    act: (ItemsListCubit bloc) {
      bloc.state.items = [
        [
          CompleteItemModel(
              category: '', name: '', imageUrl: '', isFavorite: false)
        ]
      ];
      bloc.state.searchedList = [];

      bloc.closeSearch();
    },
    expect: () => [
      isA<LoadedItemsState>(),
    ],
  );

  blocTest('should emit [AlreadyFavoriteErrorState] state when favorite is already added',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: true)
          ]
        ];

        bloc.addToFavorite(CompleteItemModel(
            category: '', name: '', imageUrl: '', isFavorite: true), 0);
      },
      expect: () => [
        isA<AlreadyFavoriteErrorState>(),
      ],
      verify: (_) {
        verifyNever(() => itemsListRepositoryMock.addToFavorite(any()));
      });

  blocTest('should emit [AddedToFavorites] state when an item is added to favorites',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        when(() => itemsListRepositoryMock.addToFavorite.call(''))
            .thenAnswer((_) async {});

        bloc.addToFavorite(CompleteItemModel(
            category: '', name: '', imageUrl: '', isFavorite: false), 0);
      },
      expect: () => [
        isA<AddedToFavorites>(),
      ],
      verify: (_) {
        verify(() => itemsListRepositoryMock.addToFavorite(any())).called(1);
      });

  blocTest('should emit [ErrorState] state when an item is added to favorites',
      build: () => itemsListCubit,
      act: (ItemsListCubit bloc) {
        bloc.state.items = [
          [
            CompleteItemModel(
                category: '', name: '', imageUrl: '', isFavorite: false)
          ]
        ];
        when(() => itemsListRepositoryMock.addToFavorite.call(''))
            .thenThrow(Exception());

        bloc.addToFavorite(CompleteItemModel(
            category: '', name: '', imageUrl: '', isFavorite: false), 0);
      },
      expect: () => [
        isA<ErrorState>(),
      ],
      verify: (_) {
        verify(() => itemsListRepositoryMock.addToFavorite(any())).called(1);
      });
}

