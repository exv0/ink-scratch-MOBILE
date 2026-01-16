// lib/features/auth/presentation/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/features/auth/presentation/view_model/auth_viewmodel_provider.dart';
import 'login_page.dart';
import 'package:ink_scratch/features/dashboard/presentation/pages/dashboard_page.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _selectedGender = 'male'; // ✅ Changed default to lowercase

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ NEW: Helper to convert display gender to backend format
  String _getBackendGender(String displayGender) {
    switch (displayGender) {
      case 'Male':
        return 'male';
      case 'Female':
        return 'female';
      case 'Other':
      default:
        return 'other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.read(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.isAuthenticated && next.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else if (next.error != null && !next.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.book_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join us and start your reading journey",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest.withAlpha(30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Please enter your full name"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        // Username
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest.withAlpha(30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a username";
                            }
                            if (value.length < 3) {
                              return "Username must be at least 3 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "you@example.com",
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest.withAlpha(30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone Number (Optional)",
                            hintText: "+1234567890",
                            prefixIcon: const Icon(Icons.phone_outlined),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest.withAlpha(30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ✨ Gender Chip Selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                bottom: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.transgender,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Gender",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildGenderChip(
                                  context,
                                  label: 'Male',
                                  icon: Icons.male,
                                  isSelected: _selectedGender == 'Male',
                                ),
                                _buildGenderChip(
                                  context,
                                  label: 'Female',
                                  icon: Icons.female,
                                  isSelected: _selectedGender == 'Female',
                                ),
                                _buildGenderChip(
                                  context,
                                  label: 'Other',
                                  icon: Icons.help_outline,
                                  isSelected: _selectedGender == 'Other',
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outlined),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest.withAlpha(30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest.withAlpha(30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // ✅ Convert display gender to backend format
                                final backendGender = _getBackendGender(
                                  _selectedGender,
                                );

                                authVM.register(
                                  fullName: _fullNameController.text,
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  phoneNumber: _phoneController.text.isEmpty
                                      ? null
                                      : _phoneController.text,
                                  gender: backendGender, // ✅ Send lowercase
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Gender Chip Builder
  Widget _buildGenderChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = label;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
