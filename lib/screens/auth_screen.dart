import 'dart:io';
import 'dart:ui';
import 'package:expense_tracker/helpers/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _name = '';
  var _email = '';
  var _password = '';
  var loading = false;

  void _showMessageDialog(message, color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        elevation: 10,
        duration: const Duration(seconds: 5),
        backgroundColor: color,
      ),
    );
  }

  void _resetPassword() async {
    if (_email.isEmpty) {
      _showMessageDialog('Please enter your email address!',
          Theme.of(context).colorScheme.error);
      return;
    }
    try {
      await _firebase.sendPasswordResetEmail(email: _email);
      _showMessageDialog(
          'If the email exists in our system, a password reset link has been sent to it.',
          Theme.of(context).colorScheme.primary);
    } on FirebaseAuthException catch (e, stackTrace) {
      var message = 'An error occurred, please try again!';
      if (e.message != null) {
        message = e.message!;
      }
      _showMessageDialog(message, Theme.of(context).colorScheme.error);
      Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      _showMessageDialog('An error occurred, please try again!',
          Theme.of(context).colorScheme.error);
      Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      loading = true;
    });
    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (userCredentials.user != null) {
          final displayName = _name
              .split(' ')
              .map((word) => Helper().capitalize(word))
              .join(' ');
          await userCredentials.user!.updateDisplayName(displayName);
          _showMessageDialog('User created successfully. Welcome!',
              Theme.of(context).colorScheme.primary);
        }
      }
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e, stackTrace) {
      var message = 'An error occurred, please check your credentials!';
      setState(() {
        loading = false;
      });
      if (e.message != null) {
        message = e.message!;
      }
      _showMessageDialog(message, Theme.of(context).colorScheme.error);
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      setState(() {
        loading = false;
      });
      _showMessageDialog('An error occurred, please check your credentials!',
          Theme.of(context).colorScheme.error);
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //name field
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (!_isLogin &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your name.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _name = value!;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _email = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              obscureText: true,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _password = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Repeat Password',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (!_isLogin &&
                                      (value == null || value != _password)) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
                              ),
                            if (!_isLogin) const SizedBox(height: 16),
                            if (loading)
                              const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            if (!loading && Platform.isIOS)
                              CupertinoButton(
                                onPressed: _submit,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                child: Text(
                                  (_isLogin ? 'Login' : 'Sign up'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            if (!loading)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    //reset form
                                    _formKey.currentState!.reset();
                                  });
                                },
                                child: Text(
                                  (_isLogin
                                      ? 'Create new account'
                                      : 'I already have an account'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (_isLogin && !loading)
                              TextButton(
                                onPressed: () {
                                  _resetPassword();
                                },
                                child: const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
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
