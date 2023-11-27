import 'package:chat_app/components/custom_button.dart';
import 'package:chat_app/components/custom_text_form_field.dart';
import 'package:chat_app/components/info_message.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Form(
                key: formKeyLogIn,
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
                          'Log In',
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
                      title: 'Log In',
                      onTap: () async {
                        if (formKeyLogIn.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});

                          try {
                            await logInUser();

                            emailController.clear();
                            passwordController.clear();

                            if (!context.mounted) return;
                            showSnackBar(
                              context,
                              message: 'Log In successfully!',
                              color: Colors.green,
                            );

                            Navigator.pushReplacementNamed(
                              context,
                              'ChatPage',
                              arguments: email,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              if (!context.mounted) return;
                              showSnackBar(
                                context,
                                message: 'No user found for that email.',
                                color: Colors.lightBlue,
                              );
                            } else if (e.code == 'wrong-password') {
                              if (!context.mounted) return;
                              showSnackBar(
                                context,
                                message:
                                    'Wrong password provided for that user.',
                                color: Colors.red,
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
                      message: "Don't have an account?",
                      linkName: 'Register',
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'RegisterPage');
                      },
                    ),
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
