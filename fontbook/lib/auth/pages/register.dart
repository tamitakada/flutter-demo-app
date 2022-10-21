import 'package:flutter/material.dart';
import 'package:fontbook/auth/forms/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.cancel_outlined, color: Colors.black, size: 28,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("REGISTER", style: Theme.of(context).textTheme.headline1,),
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: RegisterForm()
              ),
            ),
          ],
        )
    );
  }
}
