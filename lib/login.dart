import 'package:fakeflix/user_notifier.dart';
import 'package:fakeflix/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;

  // Future<bool> _login() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     try {
  //       String token = await UserService().signIn(_emailController.text, _passwordController.text);
  //       if (token.isNotEmpty) {
  //         return true;
  //       }
  //       return false;
  //     } catch (e) {
  //       print('Login Failed: $e');
  //     } finally {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/fakeflix-typo.png'),
                  Text(
                    'Veuillez vous identitifer',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          style: GoogleFonts.oswald(color: Colors.white),
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.oswald(color: Colors.white),
                            labelText: 'Email',
                            fillColor: Colors.red,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          style: GoogleFonts.oswald(color: Colors.white),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.oswald(color: Colors.white),
                            labelText: 'Mot de passe',
                            fillColor: Colors.red,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () async {
                                  // bool loginSuccess = await _login();
                                  UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
                                  UserService userService = UserService(userNotifier: userNotifier);
                                  await userService.signIn(_emailController.text, _passwordController.text);

                                  if (userNotifier.isAuthenticated) {
                                    context.go('/home');
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Connexion error'),
                                          content: const Text('Login incorrect, please try again.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(), 
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Text('Login',
                                  style: GoogleFonts.oswald(color: Colors.black, fontSize: 15),
                                ),
                              ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text("Don't have an account? Sign up"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
