import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/pages/Home/landing.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  LoginPage({required this.toggleView, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String error = '';

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      await widget._googleSignIn.signIn();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In Successful!")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Gradient Header
            Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF27EF9E),
                    Color(0xFF0BB4E3)
                  ], // Updated gradient
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
              child: Form(
                key: widget._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Welcome Message
            const Text(
              "Hi, Welcome Back! 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Remember Me & Forgot Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text("Remember Me"),
                    ],
                  ),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if (widget._formKey.currentState!.validate()) {
                    dynamic result = await widget._auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = 'Could not sign in with those credentials');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Landing()),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27EF9E), // Same gradient color
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Or With Separator
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or With"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 15),
            // Social Login Button (Google)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () => _handleGoogleSignIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                  height: 20,
                ),
                label: const Text(
                  "Login with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Don't Have an Account? Sign Up
            TextButton(
              onPressed: () {
                widget.toggleView();
              },
              child: const Text.rich(
                TextSpan(
                  text: "Don’t have an account? ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}