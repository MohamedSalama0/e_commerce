// ignore_for_file: avoid_print

import 'package:e_commerce/cubit/general_cubit.dart';

import 'package:e_commerce/view/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import '../../../common/constants.dart';
import '../../../common/size_config.dart';
import '../../../common/widgets.dart';
import '../../../components/form_error.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  late String email;
  late String password;
  late String confirmPassword;

  /// emailValidatorRegExp => it's stamp type to check on input
  /// hasMatch => for comparison between input and stamp
  /// emailController.text => that argument it will be the input in
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool _showPass1 = false;
  Artboard? riverArtboard;
  SMIInput<double>? _progress;
  StateMachineController? controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load("assets/images/liquid_download.riv").then((value) {
      final file = RiveFile.import(value);
      final artboard = file.mainArtboard;
      controller = StateMachineController.fromArtboard(artboard, 'Guido SM');
      if (controller != null) {
        artboard.addController(controller!);
        _progress = controller!.findInput('input');
        setState(() => riverArtboard = artboard);
        print('riverArtboard => $riverArtboard');
        
      }
    });
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error!);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralCubit, GeneralState>(
      listener: (context, state) {
        if (state is UserRegisterErrorState) {
          showToast(context: context, error: state.error);
        }
        if (state is CreateUserSuccessState) {
          print('User created succsesfully');
        }
        if (state is UserRegisterloadingState) {
          _progress!.value + 1;
          // print(_progress!.value++);
          // for (var i = 0; _progress!.value < 100; i++) {
          //   _progress!.value++;
          // }

          // print(_progress!.value);
        }
        if (state is CreateUserErrorState) {
          print('Create problem');
          showToast(context: context, error: state.error);
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<GeneralCubit>(context);
        return Form(
          key: _formKey,
          child: Column(
            children: [
              buildHeightSpace(12),
              buildEmailFormField(),
              buildHeightSpace(12),
              buildPasswordFormField(),
              buildHeightSpace(7),

              // buildConfirmPasswordFormField(),
              Container(
                  margin: const EdgeInsets.only(left: 1, top: 5),
                  child: FormError(errors: errors)),
              buildHeightSpace(7),
              state is! UserRegisterloadingState
                  ? defaultButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            emailValidatorRegExp
                                .hasMatch(emailController.value.text)) {
                          _formKey.currentState!.save();
                          cubit.userRegister(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          state is CreateUserSuccessState
                              ? Navigator.of(context).pushNamed(
                                  'SignInScreen',
                                )
                              : const Text('');
                        } else {
                          print('invalid email');
                        }
                      },
                      text: 'Continue',
                    )
                  : riverArtboard == null
                      ? const SizedBox()
                      : Container(
                          height: 100,
                          width: 100,
                          color: Colors.red,
                          // padding: EdgeInsets.all(2),
                          child: const RiveAnimation.asset(
                            'assets/images/liquid_download.riv',
                            alignment: Alignment.center,
                            // artboard: riverArtboard!,
                            fit: BoxFit.contain,

                            // useArtboardSize: true,
                          ),
                        ),
              buildHeightSpace(7),
              
            ],
          ),
        );
      },
    );
  }

  Widget buildEmailFormField() {
    return SizedBox(
      width: getResponsiveScreenHeight(40),
      height: getResponsiveScreenHeight(7),
      child: TextFormField(
        controller: emailController,
        onSaved: ((newValue) => email = newValue!),
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kEmailNullError);
          } else if (!emailValidatorRegExp.hasMatch(value) &&
              !errors.contains(kEmailNullError)) {
            addError(error: kInvalidEmailError);
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: getResponsiveScreenWidth(3.0)),
          labelText: "Email",
          hintText: "Enter your email",
          suffixIcon: customSuffixIcon(
            svgIcon: 'assets/images/envelop-mail-closed-svgrepo-com.svg',
          ),
        ),
      ),
    );
  }

  Widget buildPasswordFormField() {
    return SizedBox(
      width: getResponsiveScreenHeight(40),
      height: getResponsiveScreenHeight(7),
      child: TextFormField(
        onSaved: ((newValue) => password = newValue!),
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
          } else if (value.length < 8 && !errors.contains(kPassNullError)) {
            addError(error: kShortPassError);
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          } else if (value.length >= 8) {
            removeError(error: kShortPassError);
          }
          password = value;
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: _showPass1 == false ? true : false,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: getResponsiveScreenWidth(2.8),
              fontWeight: FontWeight.w100),
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                value: _showPass1,
                onChanged: (value) {
                  setState(() {
                    _showPass1 = value!;
                  });
                },
              ),
              customSuffixIcon(
                svgIcon: 'assets/images/lock-security-open-svgrepo-com.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
