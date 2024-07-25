import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false, // Optional: Hide debug banner
  ));
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Stack(
          children: [
            const LoginTitle(),
            LoginInputFields(
              usernameController: usernameController,
              passwordController: passwordController,
            ),
            LoginButton(
              usernameController: usernameController,
              passwordController: passwordController,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150.0,
      left: 20.0,
      right: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo/Management.png', width: 50.0),
          const SizedBox(width: 20.0),
          const Text(
            'SmartStock',
            style: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8162FF),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginInputFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginInputFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 250.0,
      left: 20.0,
      right: 20.0,
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 420.0,
      left: 20.0,
      right: 20.0,
      child: Center(
        child: SizedBox(
          width: 250.0,
          height: 60.0,
          child: ElevatedButton(
            onPressed: () {
              final username = usernameController.text;
              final password = passwordController.text;
              // ignore: avoid_print
              print('Username: $username');
              // ignore: avoid_print
              print('Password: $password');

              Navigator.pushNamed(context, '/nabvbar'); // Ensure NavigationMenu is correctly imported and defined
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8162FF),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
