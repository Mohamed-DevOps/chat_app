import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? email;
String? password;

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController messageController = TextEditingController();
final GlobalKey<FormState> formKeyRegister = GlobalKey();
final GlobalKey<FormState> formKeyLogIn = GlobalKey();
bool isLoading = false;

final CollectionReference users =
    FirebaseFirestore.instance.collection(kUsersCollections);
final CollectionReference messages =
    FirebaseFirestore.instance.collection(kMessagesCollections);

// final Stream<QuerySnapshot> messagesStream =
//     FirebaseFirestore.instance.collection(kMessagesCollections).snapshots();

Future<void> registerUser() async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email!,
    password: password!,
  );

  users.add({
    'email': email!,
  });
}

Future<void> logInUser() async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email!,
    password: password!,
  );
}

Future<void> logOutUser() async {
  await FirebaseAuth.instance.signOut();
}

Future<void> addMessage(value, email) {
  return messages.add({
    kMessage: value,
    kCreatedAt: DateTime.now(),
    'id': email,
  });
  // .then((value) => print("Message Added"))
  // .catchError((error) => print("Failed to add Message: $error"));
}



// Future<void> registerUser(BuildContext context) async {
//   if (formKey.currentState!.validate()) {
//     isLoading = true;

//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       if (!context.mounted) return;
//       showSnackBar(
//         context,
//         message: 'Account created successfully!',
//         color: Colors.green,
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         if (!context.mounted) return;
//         showSnackBar(
//           context,
//           message: 'The password provided is too weak.',
//           color: Colors.orange,
//         );
//       } else if (e.code == 'email-already-in-use') {
//         if (!context.mounted) return;
//         showSnackBar(
//           context,
//           message: 'The account already exists for that email.',
//           color: Colors.lightBlue,
//         );
//       }
//     } catch (e) {
//       if (!context.mounted) return;
//       showSnackBar(
//         context,
//         message: e.toString(),
//         color: Colors.red,
//       );
//     }

//     isLoading = false;
//   } else {}
// }
