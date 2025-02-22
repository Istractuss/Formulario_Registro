import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistroUsuario(),
    ); 
  }
}

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _apiUrl = "https://us-central1-sistemapiscicola.cloudfunctions.net/usuarios";

  Future<void> _registrarUsuario() async {
    if (_nombreController.text.isEmpty || _emailController.text.isEmpty) { 
      print("faltan campos");
      return;
    }

    final Map<String, dynamic> datosUsuario = {
      'nombre': _nombreController.text,
      'email': _emailController.text,
      'telefono': _telefonoController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosUsuario),
      );

      if (response.statusCode == 200) {
        print("Usuario registrado: ${response.body}");
        _nombreController.clear();
        _emailController.clear();
        _telefonoController.clear();
        _passwordController.clear();
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Telefono'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'contrasena'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarUsuario,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}