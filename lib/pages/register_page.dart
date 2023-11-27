import 'package:chat_app/components/custom_button.dart';
import 'package:chat_app/components/custom_text_form_field.dart';
import 'package:chat_app/components/info_message.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var emailArgs = ModalRoute.of(context)!.settings.arguments;

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Form(
                key: formKeyRegister,
                child: ListView(
                  children: [
                    const SizedBox(height: 75),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(kLogo),
                        const Text(
                          kAppName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: kFontPacifico,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 75),
                    Column(
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          onChanged: (data) {
                            email = data;
                          },
                          labelText: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          onChanged: (data) {
                            password = data;
                          },
                          labelText: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      title: 'Register',
                      onTap: () async {
                        if (formKeyRegister.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});

                          try {
                            await registerUser();
                            emailController.clear();
                            passwordController.clear();

                            if (!context.mounted) return;
                            showSnackBar(
                              context,
                              message: 'Account created successfully!',
                              color: Colors.green,
                            );

                            Navigator.pushReplacementNamed(
                              context,
                              'ChatPage',
                              arguments: email,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              if (!context.mounted) return;
                              showSnackBar(
                                context,
                                message: 'The password provided is too weak.',
                                color: Colors.orange,
                              );
                            } else if (e.code == 'email-already-in-use') {
                              if (!context.mounted) return;
                              showSnackBar(
                                context,
                                message:
                                    'The account already exists for that email.',
                                color: Colors.lightBlue,
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            showSnackBar(
                              context,
                              message: e.toString(),
                              color: Colors.red,
                            );
                          }

                          isLoading = false;
                          setState(() {});
                        } else {}
                      },
                    ),
                    InfoMessage(
                      message: "You have an account?",
                      linkName: 'Log In',
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'LogInPage');
                      },
                    ),
                    // const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
