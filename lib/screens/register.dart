import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:setaksetikmobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedRole;
  final List<String> _roles = ['Steak Lover', 'Steakhouse Owner', 'Admin'];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const formStyle = TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w600,
      color: Color(0xFF3E2723),
      fontSize: 16.0,
    );

    return Scaffold(
      body: Container(
        color: Color(0xFF6D4C41),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: EdgeInsets.all(24),
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Register to',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF3E2723),
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'SetakSetik',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF842323),
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            items: _roles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(
                                  role,
                                  // style: TextStyle(color: Color(0xFF3E2723)),
                                  style: formStyle
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Role',
                              labelStyle: TextStyle(color: Color(0xFF3E2723)),
                              prefixIcon: Icon(Icons.person_outline, color: Color(0xFF3E2723)),
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
                          TextFormField(
                            controller: _usernameController,
                            style: formStyle,
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
                          TextFormField(
                            controller: _fullnameController,
                            style: formStyle,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(color: Color(0xFF3E2723)),
                              prefixIcon: Icon(Icons.person, color: Color(0xFF3E2723)),
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
                          TextFormField(
                            controller: _passwordController,
                            style: formStyle,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Color(0xFF3E2723)),
                              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF3E2723)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF3E2723)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF842323), width: 2),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            style: formStyle,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
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
                            obscureText: true,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              String role = _selectedRole?.toLowerCase() ?? '';
                              String username = _usernameController.text;
                              String fullname = _fullnameController.text;
                              String password1 = _passwordController.text;
                              String password2 = _confirmPasswordController.text;

                              final response = await request.postJson(
                                "http://127.0.0.1:8000/register-mobile/",
                                jsonEncode({
                                  "username": username,
                                  "password1": password1,
                                  "password2": password2,
                                  "role": role,
                                  "full_name": fullname,
                                }),
                              );
                              
                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Successfully registered!',
                                        style: TextStyle(color: Color(0xFFF5F5DC)),
                                      ),
                                      backgroundColor: Color(0xFF3E2723),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response['message'],
                                        style: TextStyle(color: Color(0xFFF5F5DC)),
                                      ),
                                      backgroundColor: Color(0xFF842323),
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
                              'Register',
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
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account? Login',
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
            ),
          ),
        ),
      ),
    );
  }
}