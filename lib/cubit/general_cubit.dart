import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/create_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(GeneralInitial());

  Future<void> userSignIn(email, password) async {
    emit(UserSignInLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(UserSignInSucssesState());
      print(value.user!.uid);
    }).catchError(
      (error) {
        emit(UserSignInErrorState(error.toString()));
      },
    );
  }

  Future<void> userRegister({
    required email,
    required password,
  }) async {
    emit(UserRegisterloadingState());
    await Future.delayed(const Duration(seconds: 7));
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      createUser(
        email: email,
        password: password,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(UserRegisterErrorState(error.toString()));
    });
  }

  // Save user in firestore
  void createUser({
    required email,
    required password,
    required uId,
  }) {
    CreateUserModel model = CreateUserModel(
      email: email,
      password: password,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
