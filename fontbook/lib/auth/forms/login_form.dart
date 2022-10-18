import 'package:flutter/material.dart';
import 'package:fontbook/auth/mixins/auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> with Auth {
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
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  labelText: "EMAIL",
                  labelStyle: Theme.of(context).textTheme.headline2
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
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  labelText: "PASSWORD",
                  labelStyle: Theme.of(context).textTheme.headline2
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
                  bool loggedIn = await login(emailController.text, passwordController.text);
                  if (loggedIn) {
                    Navigator.of(context).popAndPushNamed('/favorites');
                  }
                }
              },
              child: Text('LOGIN', style: Theme.of(context).textTheme.bodyText2,),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/register');
            },
            child: Text('REGISTER', style: Theme.of(context).textTheme.bodyText2,),
          )
        ],
      ),
    );
  }
}