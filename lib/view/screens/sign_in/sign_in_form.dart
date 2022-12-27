import 'package:e_commerce/common/size_config.dart';
import 'package:e_commerce/cubit/general_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import '../../../common/app_style.dart';
import '../../../common/constants.dart';
import '../../../common/widgets.dart';
import '../../../components/form_error.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool value = false;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  late String email;
  late String password;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Artboard? _riverArtboard;
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
        setState(() => _riverArtboard = artboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralCubit, GeneralState>(
      listener: (context, state) {
        if (state is UserSignInErrorState) {
          showToast(error: state.error, context: context);
        }
        if (state is UserSignInLoadingState) {
          _progress!.value++;
        }
        if (state is UserSignInSucssesState) {
          print('Login Succsefully');
          Navigator.of(context).pushNamed(
            'HomeScreen',
          );
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     'HomeScreen', (Route<dynamic> route) => false);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              buildEmailFormField(),
              buildHeightSpace(8),
              buildPasswordFormField(),
              buildHeightSpace(1),
              Container(
                  margin: const EdgeInsets.only(left: 3, top: 10),
                  child: FormError(errors: errors)),
              Row(
                children: [
                  Checkbox(
                    value: value,
                    activeColor: kPrimaryColor,
                    onChanged: (remember) {
                      setState(() {
                        value = remember!;
                      });
                    },
                  ),
                  const Text('Remember me', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'ForgetPasswordScreen');
                    },
                    child: const Text('Forget password !',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 13)),
                  )
                ],
              ),
              buildHeightSpace(5),
              state is UserSignInLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : defaultButton(
                      onPressed: () {
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     'HomeScreen', (Route<dynamic> route) => false);

                        print(emailController.text);
                        if (_formKey.currentState!.validate() &&
                            emailValidatorRegExp
                                .hasMatch(emailController.text)) {
                          // lkd l ekdkf  cmdlmflk kd,m ,ldfm,mfv dlkv dfllmm
                          _formKey.currentState!.save();
                          //jlikl

                          BlocProvider.of<GeneralCubit>(context).userSignIn(
                            emailController.text,
                            passwordController.text,
                          );
                          // state is UserSignInSucssesState
                          //     ? Navigator.of(context).pushNamedAndRemoveUntil(
                          //         'HomeScreen', (Route<dynamic> route) => false)
                          //     : null;
                        }
                      },
                      text: 'Login',
                    ),
            ],
          ),
        );
      },
    );
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

  Widget buildEmailFormField() {
    // print('who called method:===>${StackTrace.current}');
    return SizedBox(
      width: getResponsiveScreenHeight(40),
      height: getResponsiveScreenHeight(7),
      child: TextFormField(
        controller: emailController,
        onSaved: ((newValue) => email = newValue!),
        validator: (value) {
          // email = value;
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
          // contentPadding: const EdgeInsets.symmetric(horizontal: 40 ),
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
        controller: passwordController,
        onSaved: ((newValue) => password = newValue!),
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
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: customSuffixIcon(
            svgIcon: 'assets/images/lock-security-open-svgrepo-com.svg',
          ),
        ),
      ),
    );
  }
}
