import 'package:flutter/material.dart';
import '../services/UserSession.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserSession _session = UserSession();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  // Controllers pre-filled with session data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final email = await _session.getEmail();
    final password = await _session.getPassword();
    if (mounted) {
      _emailController.text = email ?? '';
      _passwordController.text = password ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Center(
                  child: Image.asset('assets/images/profil.png', width: 250),
                ),
                const SizedBox(height: 15),

                // Email field — pre-filled, read-only
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: Colors.deepOrange),
                  ),
                ),
                const SizedBox(height: 15),

                // Current password field — pre-filled with saved password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Invalid current password';
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Current password',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                  ),
                ),
                const SizedBox(height: 15),

                // New password field
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Invalid new password';
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'New password',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.deepOrange),
                  ),
                ),
                const SizedBox(height: 15),

                // Address field
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) return 'Invalid address';
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Address',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on, color: Colors.deepOrange),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (_globalKey.currentState!.validate()) {
                        // Save the new password to session
                        await _session.saveSession(
                          _emailController.text,
                          _newPasswordController.text,
                        );
                        // Update current password field to reflect the change
                        _passwordController.text = _newPasswordController.text;
                        _newPasswordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: Colors.deepOrange,
                          ),
                        );
                      }
                    },
                    child: const Text('SAVE'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
