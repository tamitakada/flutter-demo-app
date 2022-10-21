import 'package:flutter/material.dart';
import 'package:fontbook/auth/mixins/auth.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> with Auth {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              controller: emailController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  labelText: "EMAIL",
                  labelStyle: Theme.of(context).textTheme.bodyText2
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              controller: passwordController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  labelText: "PASSWORD",
                  labelStyle: Theme.of(context).textTheme.bodyText2
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool loggedIn = await createUser(
                      emailController.text,
                      passwordController.text
                  );
                  if (loggedIn) {
                    Navigator.of(context).popAndPushNamed('/');
                  }
                }
              },
              child: Text('SUBMIT', style: Theme.of(context).textTheme.bodyText2,),
            ),
          ),
        ],
      ),
    );
  }
}