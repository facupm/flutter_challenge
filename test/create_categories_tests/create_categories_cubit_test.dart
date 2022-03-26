import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challege/create_categories/cubits/create_category_cubit.dart';
import 'package:flutter_challege/create_categories/repositories/create_category_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CreateCategoryRepositoryMock extends Mock
    implements CreateCategoryRepository {}

main() {
  late CreateCategoryRepositoryMock createCategoryRepositoryMock;

  late CreateCategoryCubit createCategoryCubit;

  setUp(() {
    createCategoryRepositoryMock = CreateCategoryRepositoryMock();
    createCategoryCubit = CreateCategoryCubit(createCategoryRepositoryMock);
  });

  tearDown(() {
    createCategoryCubit.close();
  });

  test('bloc should have initial state as [InitialState]', () {
    expect(createCategoryCubit.state.name, "");
    expect(createCategoryCubit.state.color, Colors.redAccent);
  });

  blocTest(
    'should emit [ColorChangeState] state when color changes',
    build: () => createCategoryCubit,
    act: (CreateCategoryCubit bloc) {
      bloc.changeColor(Colors.black54);
    },
    expect: () => [isA<ColorChangeState>()],
  );

  blocTest(
    'should emit [NameErrorState] state when name to change is empty',
    build: () => createCategoryCubit,
    act: (CreateCategoryCubit bloc) {
      bloc.changeName("");
    },
    expect: () => [isA<NameErrorState>()],
  );

  blocTest(
    'should emit [SuccessState] state when name is changed',
    build: () => createCategoryCubit,
    act: (CreateCategoryCubit bloc) {
      bloc.changeName("name");
    },
    expect: () => [isA<SuccessState>()],
  );

  blocTest(
      'should emit [CreatingState, CreatedSuccessfullyState] state when item is created successfully',
      build: () => createCategoryCubit,
      act: (CreateCategoryCubit bloc) {
        bloc.state.name = "name";
        bloc.state.color = Colors.redAccent;
        when(() =>
                createCategoryRepositoryMock.createCategory.call(any(), any()))
            .thenAnswer((_) async {});

        bloc.submit();
      },
      expect: () => [
            isA<CreatingState>(),
            isA<CreatedSuccessfullyState>(),
          ],
      verify: (_) {
        verify(() => createCategoryRepositoryMock.createCategory(any(), any()))
            .called(1);
      });

  blocTest(
      'should emit [CreatingState, ErrorState] state when repository cant create an item',
      build: () => createCategoryCubit,
      act: (CreateCategoryCubit bloc) {
        bloc.state.name = "name";
        bloc.state.color = Colors.redAccent;
        when(() =>
                createCategoryRepositoryMock.createCategory.call(any(), any()))
            .thenThrow(Exception());

        bloc.submit();
      },
      expect: () => [
            isA<CreatingState>(),
            isA<ErrorState>(),
          ],
      verify: (_) {
        verify(() => createCategoryRepositoryMock.createCategory(any(), any()))
            .called(1);
      });

  blocTest('should emit [CreatingState, ErrorState] state when image is null',
      build: () => createCategoryCubit,
      act: (CreateCategoryCubit bloc) {
        bloc.state.name = "";
        bloc.state.color = Colors.redAccent;

        bloc.submit();
      },
      expect: () => [
            isA<CreatingState>(),
            isA<ErrorState>(),
          ],
      verify: (_) {
        verifyNever(
            () => createCategoryRepositoryMock.createCategory(any(), any()));
      });

  blocTest('should emit [CreatingState, ErrorState] state when name is empty',
      build: () => createCategoryCubit,
      act: (CreateCategoryCubit bloc) {
        bloc.state.name = "name";
        bloc.state.color = null;

        bloc.submit();
      },
      expect: () => [
            isA<CreatingState>(),
            isA<ErrorState>(),
          ],
      verify: (_) {
        verifyNever(
            () => createCategoryRepositoryMock.createCategory(any(), any()));
      });
}
