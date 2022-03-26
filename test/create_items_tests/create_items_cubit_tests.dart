import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_challege/create_items/cubits/create_item_cubit.dart';
import 'package:flutter_challege/create_items/repositories/create_item_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CreateItemRepositoryMock extends Mock implements CreateItemRepository {}

main() {
  late CreateItemRepositoryMock createItemRepositoryMock;

  late CreateItemCubit createItemCubit;

  setUp(() {
    createItemRepositoryMock = CreateItemRepositoryMock();
    createItemCubit = CreateItemCubit(createItemRepositoryMock);
  });

  tearDown(() {
    createItemCubit.close();
  });

  test('bloc should have initial state as [InitialState]', () {
    expect(createItemCubit.state.name, "");
    expect(createItemCubit.state.image, null);
    expect(createItemCubit.state.categories, []);
    expect(createItemCubit.state.selectedCategory, "");
  });

  blocTest('should emit [CategoriesLoaded] state when categories are got',
      build: () => createItemCubit,
      act: (CreateItemCubit bloc) {
        when(() => createItemRepositoryMock.getCategories.call())
            .thenAnswer((_) async => ["category1", "category2"]);

        bloc.getCategories();
      },
      expect: () => [isA<CategoriesLoaded>()],
      verify: (_) {
        verify(() => createItemRepositoryMock.getCategories()).called(1);
      });

  blocTest(
    'should emit [CategoryErrorState] state when category name to change is empty',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.changeCategory("");
    },
    expect: () => [isA<CategoryErrorState>()],
  );

  blocTest(
    'should emit [CategoryLoaded] state when category is changed',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.changeCategory("categoryName");
    },
    expect: () => [isA<CategoryLoaded>()],
  );

  blocTest(
    'should emit [ImageErrorState] state when image to change is null',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.changeImage(null);
    },
    expect: () => [isA<ImageErrorState>()],
  );

  blocTest(
    'should emit [SuccessState] state when image is changed',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.changeImage(File(''));
    },
    expect: () => [isA<SuccessState>()],
  );

  blocTest(
    'should emit [NameErrorState] state when name to change is empty',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.changeName("");
    },
    expect: () => [isA<NameErrorState>()],
  );

  blocTest(
    'should emit [SuccessState] state when name is changed',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.changeName("name");
    },
    expect: () => [isA<SuccessState>()],
  );

  blocTest(
      'should emit [CreatingState, CreatedSuccessfullyState] state when item is created successfully',
      build: () => createItemCubit,
      act: (CreateItemCubit bloc) {
        bloc.state.name = "name";
        bloc.state.selectedCategory = "categoryName";
        bloc.state.image = File("");
        when(() =>
                createItemRepositoryMock.createItem.call(any(), any(), any()))
            .thenAnswer((_) async {});

        bloc.submit();
      },
      expect: () => [
            isA<CreatingState>(),
            isA<CreatedSuccessfullyState>(),
          ],
      verify: (_) {
        verify(() => createItemRepositoryMock.createItem(any(), any(), any()))
            .called(1);
      });

  blocTest(
      'should emit [CreatingState, ErrorState] state when repository cant create an item',
      build: () => createItemCubit,
      act: (CreateItemCubit bloc) {
        bloc.state.name = "name";
        bloc.state.selectedCategory = "categoryName";
        bloc.state.image = File("");
        when(() =>
            createItemRepositoryMock.createItem.call(any(), any(), any()))
            .thenThrow(Exception());

        bloc.submit();
      },
      expect: () => [
        isA<CreatingState>(),
        isA<ErrorState>(),
      ],
      verify: (_) {
        verify(() => createItemRepositoryMock.createItem(any(), any(), any()))
            .called(1);
      });

  blocTest(
      'should emit [CreatingState, ErrorState] state when image is null',
      build: () => createItemCubit,
      act: (CreateItemCubit bloc) {
        bloc.state.name = "name";
        bloc.state.selectedCategory = "categoryName";
        bloc.state.image = null;

        bloc.submit();
      },
      expect: () => [
        isA<CreatingState>(),
        isA<ErrorState>(),
      ],
      verify: (_) {
        verifyNever(() => createItemRepositoryMock.createItem(any(), any(), any()));
      });

  blocTest(
    'should emit [CreatingState, ErrorState] state when name is empty',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.state.name = "";
      bloc.state.selectedCategory = "categoryName";
      bloc.state.image = File('');

      bloc.submit();
    },
    expect: () => [
      isA<CreatingState>(),
      isA<ErrorState>(),
    ],
      verify: (_) {
        verifyNever(() => createItemRepositoryMock.createItem(any(), any(), any()));
      });

  blocTest(
    'should emit [CreatingState, ErrorState] state when selectedCategory is empty',
    build: () => createItemCubit,
    act: (CreateItemCubit bloc) {
      bloc.state.name = "name";
      bloc.state.selectedCategory = "";
      bloc.state.image = File('');

      bloc.submit();
    },
    expect: () => [
      isA<CreatingState>(),
      isA<ErrorState>(),
    ],
      verify: (_) {
        verifyNever(() => createItemRepositoryMock.createItem(any(), any(), any()));
      });
}
