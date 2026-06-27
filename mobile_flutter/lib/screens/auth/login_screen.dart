import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  final _formKey =
  GlobalKey<FormState>();

  @override
  Widget build(
      BuildContext context) {

    final auth =
    context.watch<AuthProvider>();

    return Scaffold(

      appBar: AppBar(
        title:
        const Text(
          'Login',
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(
          20,
        ),

        child: Form(

          key:
          _formKey,

          child:
          Column(

            children: [

              TextFormField(

                controller:
                _emailController,

                decoration:
                const InputDecoration(
                  labelText:
                  'Email',
                ),

                validator:
                    (value) {

                  if (value ==
                      null ||
                      value
                          .isEmpty) {

                    return 'Email obligatoire';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height:
                20,
              ),

              TextFormField(

                controller:
                _passwordController,

                obscureText:
                true,

                decoration:
                const InputDecoration(
                  labelText:
                  'Password',
                ),

                validator:
                    (value) {

                  if (value ==
                      null ||
                      value
                          .isEmpty) {

                    return 'Mot de passe obligatoire';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height:
                30,
              ),

              ElevatedButton(

                onPressed:
                auth.isLoading
                    ? null
                    : () async {

                  if (!_formKey
                      .currentState!
                      .validate()) {

                    return;
                  }

                  try {

                    await auth
                        .login(

                      email:
                      _emailController.text,

                      password:
                      _passwordController.text,
                    );

                    if (
                    context.mounted) {

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(

                        const SnackBar(

                          content:
                          Text(
                            'Login success',
                          ),
                        ),
                      );
                    }

                  } catch (
                  e) {

                    if (
                    context.mounted) {

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(

                        SnackBar(

                          content:
                          Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  }
                },

                child:
                auth.isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                  'Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}