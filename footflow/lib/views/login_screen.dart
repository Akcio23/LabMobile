import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.mail_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 16.0),
              const Text('Acesso ao Sistema', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8.0),
              const Text('Gestão de Pedidos da Fábrica', style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 48.0),
              TextFormField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              Consumer<LoginController>(
                builder: (context, loginController, child) {
                  return Column(
                    children: [
                      if (loginController.loginFailed)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'E-mail ou senha inválidos!',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                             FirebaseAnalytics.instance.logEvent(
                                name: 'btn_login_clicado',
                                parameters: {'teclado_tipo': 'phone'} 
                            );
                            await loginController.login(userController.text, passwordController.text);
                            if (loginController.isLoggedIn) {
                              Navigator.pushReplacementNamed(context, '/dashboard');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Ainda não tem cadastro? ', style: TextStyle(color: Colors.black54)),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Registrar', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}