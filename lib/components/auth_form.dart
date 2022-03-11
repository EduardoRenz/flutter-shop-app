import 'package:flutter/material.dart';

enum AuthMode { login, signup }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _submit() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();

    if (_isLogin()) {
      // _login();
    } else {
      //_signup();
    }

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: 400,
      width: deviceSize.width * 0.75,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  if (_email == null) {
                    return 'Please enter a valid email';
                  }
                  // regex to match valid email
                  final regex = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!regex.hasMatch(_email)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                controller: _passwordController,
                validator: (_password) => (_password != null &&
                        (_password.isEmpty || _password.length < 6))
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              if (_isSignup())
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          if (_password != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: deviceSize.width * 0.7,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(_authMode.name.toUpperCase()),
                  ),
                ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _authMode = _authMode == AuthMode.login
                          ? AuthMode.signup
                          : AuthMode.login;
                    });
                  },
                  child: Text(_isLogin() ? 'Signup' : 'Login')),
            ]),
          ),
        ),
      ),
    );
  }
}