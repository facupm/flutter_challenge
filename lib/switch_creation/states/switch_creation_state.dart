part of '../cubits/switch_creation_cubit.dart';

abstract class SwitchCreationState {
  late bool itemScreen;
  late String pageTitle;
}

class InitialState extends SwitchCreationState {
  InitialState() {
    itemScreen = true;
    pageTitle = "Create Item";
  }
}

class ChangedToItem extends SwitchCreationState {
  ChangedToItem() {
    itemScreen = true;
    pageTitle = "Create Item";
  }
}

class ChangeToCategory extends SwitchCreationState {
  ChangeToCategory() {
    itemScreen = false;
    pageTitle = "Create Category";
  }
}