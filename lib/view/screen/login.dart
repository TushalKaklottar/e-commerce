
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        _singInWithGoogle(),
                      ],
                    )
                  ],
                ),
              )
        )
      ),
    );
  }
  Widget _singInWithGoogle(){
    return MaterialButton(
        splashColor: Colors.transparent,
        minWidth: double.infinity,
        height: 50,
        color: Colors.grey[500],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.google, color: Colors.white,),
            SizedBox(width: 15),
            Text('Singn in with Google', style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
            )
          ],
        ),
        onPressed: () async {
          print("--------- Google auth start ---------");
          singWithGoogle();
          print("--------- Google data store start ---------");
          storeDataWithGoogle();
          print("--------- Google  end ---------");
        }
    );
  }

  void singWithGoogle () {
    final ap = Provider.of<AuthProvider>(context as BuildContext, listen: false);
    ap.signInWithGoogle(context as BuildContext);
  }
  void storeDataWithGoogle() {
    final ap = Provider.of<AuthProvider>(context as BuildContext, listen: false);
    ap.storeDataWithGoogle(context as BuildContext);
  }


}












