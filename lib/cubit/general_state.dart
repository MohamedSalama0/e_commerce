part of 'general_cubit.dart';

@immutable
abstract class GeneralState {}

class GeneralInitial extends GeneralState {}

class UserRegisterloadingState extends GeneralState {}

// class UserRegisterSucssesState extends GeneralState {}

class UserRegisterErrorState extends GeneralState {
  final String error;

  UserRegisterErrorState(this.error);
}

class UserSignInLoadingState extends GeneralState {}

class UserSignInSucssesState extends GeneralState {}

class UserSignInErrorState extends GeneralState {
  final String error;

  UserSignInErrorState(this.error);
}
class CreateUserSuccessState extends GeneralState {}

class CreateUserErrorState extends GeneralState {
  final String error;

  CreateUserErrorState(this.error);
}
