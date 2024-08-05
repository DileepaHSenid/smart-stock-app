import 'package:flutter/material.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import '../../controllers/login_controller.dart';

void main() {
  runApp(const MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
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
  final LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
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
              loginController: loginController,
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
  final LoginController loginController;

  const LoginButton({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.loginController,
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
            onPressed: () async {
              final username = usernameController.text;
              final password = passwordController.text;

              if (username.isEmpty) {
                _showSnackbar(context, "Username cannot be empty", Colors.red);
                return;
              }

              if (password.isEmpty) {
                _showSnackbar(context, "Password cannot be empty", Colors.red);
                return;
              }

              try {
                await loginController.login(username, password);
                _showSnackbar(context, "Login success", const Color(0xFF2BED9D));
                Navigator.pushNamed(context, '/navbar');
              } catch (e) {
                _showSnackbar(context, loginController.error ?? "Failed to sign in", const Color(
                    0xFFBF7066));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8162FF),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    DelightToastBar(
      builder: (context) {
        return ToastCard(
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          color: color,
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
    ).show(context);
  }
}
