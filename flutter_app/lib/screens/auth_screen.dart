import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {{
  const AuthScreen({{Key? key}}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}}

class _AuthScreenState extends ConsumerState<AuthScreen> {{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {{
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }}

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleAuth,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isLogin ? 'Acceder' : 'Registrarse'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {{
                setState(() => _isLogin = !_isLogin);
              }},
              child: Text(
                _isLogin
                    ? '¿No tienes cuenta? Regístrate'
                    : '¿Ya tienes cuenta? Accede',
              ),
            ),
          ],
        ),
      ),
    );
  }}

  Future<void> _handleAuth() async {{
    // TODO: Implementar autenticación
  }}
}}
