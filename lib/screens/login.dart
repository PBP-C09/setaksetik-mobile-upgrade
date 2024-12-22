import 'package:setaksetikmobile/main.dart';
import 'package:setaksetikmobile/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:setaksetikmobile/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      body: Container(
        color: Color(0xFF6D4C41),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5DC),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/landing-image-0.png',
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'SetakSetik',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        Text(
                          'Welcomes You Back!',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF842323),
                          ),
                        ),
                        SizedBox(height: 32),
                        
                        // Login Form
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextField(
                                controller: _usernameController,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3E2723),
                                  fontSize: 16.0,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Color(0xFF3E2723)),
                                  prefixIcon: Icon(Icons.account_circle, color: Color(0xFF3E2723)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF3E2723)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF842323), width: 2),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                style: TextStyle(color: Color(0xFF3E2723)),
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Color(0xFF3E2723)),
                                  prefixIcon: Icon(Icons.lock, color: Color(0xFF3E2723)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF3E2723)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Color(0xFF842323), width: 2),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () async {
                                  String username = _usernameController.text;
                                  String password = _passwordController.text;

                                  final response = await request.login(
                                      "https://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/login-mobile/", {
                                    'username': username,
                                    'password': password,
                                  });

                                  if (request.loggedIn) {
                                    String message = response['message'];
                                    Map<String, dynamic> data = {
                                      "username": response['username'],
                                      "full_name": response['full_name'],
                                      "role": response['role'],
                                      "claim" : response['claim']
                                    };
                                    UserProfile.login(data);
                                    if (context.mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RootPage(fullName: data['full_name']),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Oh no :('),
                                          content: Text(response['message']),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Color(0xFFF5F5DC),
                                  backgroundColor: Color(0xFF842323),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: Text(
                            'Don\'t have an account? Register',
                            style: TextStyle(
                              color: Color(0xFF842323),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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