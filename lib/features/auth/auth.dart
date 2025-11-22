import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/model/user_model.dart';

import '../chat/chat.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool _isSignIn = true;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // Form keys
  final _signInKey = GlobalKey<FormState>();
  final _signUpKey = GlobalKey<FormState>();

  // UI state
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneNumber.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _nameValidator(String? v) {
    if (!_isSignIn && (v == null || v.trim().length < 2)) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _phoneValidator(String? v) {
    if (!_isSignIn && (v == null || v.trim().isEmpty)) {
      return 'Phone number is required';
    }
    final ok = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v!.trim());
    return ok ? null : 'Enter a valid phone number';
  }

  //firebase services
  final _auth = FirebaseAuth.instance;

  void _submit() async {
    try {
      if (_isSignIn) {
        if (_signInKey.currentState!.validate()) {
          await _auth.signInWithEmailAndPassword(
              email: _emailCtrl.text, password: _passCtrl.text);
          // TODO: call your sign-in logic

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const ChatScreen();
          }));
        }
      } else {
        if (_signUpKey.currentState!.validate()) {
          if (_passCtrl.text != _confirmCtrl.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match')),
            );
            return;
          }
          final userCredential = await _auth.createUserWithEmailAndPassword(
              email: _emailCtrl.text, password: _passCtrl.text);

          final newUser = UserModel(
            id: userCredential.user?.uid,
            name: _nameCtrl.text,
            email: _emailCtrl.text,
            phoneNumber: _phoneNumber.text,
            isActive: true,
            profilePictureUrl:
                "https://i.pinimg.com/474x/6e/59/95/6e599501252c23bcf02658617b29c894.jpg",
          );

          await FirebaseFirestore.instance
              .collection("k_k_h")
              .doc("#")
              .collection("users")
              .doc(newUser.id)
              .set(newUser.toJson());

          /// todo navigate to home page after sign up
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creating account...')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // Gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.10),
              cs.secondary.withValues(alpha: 0.10),
              cs.surface.withValues(alpha: 0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App title / branding
                    Text(
                      'Modern Chat',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isSignIn
                          ? 'Welcome back — let’s get you in'
                          : 'Create your account to start chatting',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.65),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),

                    // Glass card
                    _GlassCard(
                      child: ListView(
                        children: [
                          _ModeSwitch(
                            isSignIn: _isSignIn,
                            onChanged: (signIn) {
                              setState(() => _isSignIn = signIn);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Animated forms
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) {
                              // Subtle fade + vertical slide
                              final offsetTween = Tween<Offset>(
                                begin: const Offset(0, 0.06),
                                end: Offset.zero,
                              );
                              return FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: anim.drive(offsetTween),
                                  child: child,
                                ),
                              );
                            },
                            child: _isSignIn
                                ? _SignInForm(
                                    key: const ValueKey('sign-in'),
                                    emailCtrl: _emailCtrl,
                                    passCtrl: _passCtrl,
                                    obscurePass: _obscurePass,
                                    onToggleObscure: () => setState(
                                        () => _obscurePass = !_obscurePass),
                                    emailValidator: _emailValidator,
                                    passwordValidator: _passwordValidator,
                                    onSubmit: _submit,
                                  )
                                : _SignUpForm(
                                    key: const ValueKey('sign-up'),
                                    nameCtrl: _nameCtrl,
                                    emailCtrl: _emailCtrl,
                                    phoneCtrl: _phoneNumber,
                                    passCtrl: _passCtrl,
                                    confirmCtrl: _confirmCtrl,
                                    obscurePass: _obscurePass,
                                    obscureConfirm: _obscureConfirm,
                                    onTogglePass: () => setState(
                                        () => _obscurePass = !_obscurePass),
                                    onToggleConfirm: () => setState(() =>
                                        _obscureConfirm = !_obscureConfirm),
                                    nameValidator: _nameValidator,
                                    emailValidator: _emailValidator,
                                    passwordValidator: _passwordValidator,
                                    phoneValidator: _phoneValidator,
                                    onSubmit: _submit,
                                  ),
                          ),

                          const SizedBox(height: 16),
                          const Spacer(),
                          FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child:
                                Text(_isSignIn ? 'Sign In' : 'Create Account'),
                          ),
                          const SizedBox(height: 10),

                          // Helper row
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                Text(
                                  _isSignIn
                                      ? "Don't have an account?"
                                      : 'Already have an account?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: cs.onSurface
                                              .withValues(alpha: 0.7)),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _isSignIn = !_isSignIn),
                                  child: Text(
                                      _isSignIn ? 'Create one' : 'Sign in'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Tiny footnote
                    Text(
                      'By continuing, you agree to our Terms & Privacy Policy',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Pieces ----------

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = MediaQuery.sizeOf(context).height;
    return Container(
      height: h * 0.589,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
        // Subtle backdrop blur look without actual blur for performance
      ),
      child: child,
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.isSignIn,
    required this.onChanged,
  });

  final bool isSignIn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'Sign In',
              active: isSignIn,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Create',
              active: !isSignIn,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              active ? cs.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.7),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    super.key,
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscurePass,
    required this.onToggleObscure,
    required this.emailValidator,
    required this.passwordValidator,
    required this.onSubmit,
  });

  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscurePass;
  final VoidCallback onToggleObscure;
  final String? Function(String?) emailValidator;
  final String? Function(String?) passwordValidator;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final key = context.findAncestorStateOfType<_AuthPageState>()?._signInKey;

    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            validator: emailValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passCtrl,
            obscureText: obscurePass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                icon:
                    Icon(obscurePass ? Icons.visibility : Icons.visibility_off),
                tooltip: obscurePass ? 'Show' : 'Hide',
              ),
            ),
            validator: passwordValidator,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: forgot password flow
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forgot password tapped')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: cs.primary),
              child: const Text('Forgot password?'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passCtrl,
    required this.confirmCtrl,
    required this.obscurePass,
    required this.obscureConfirm,
    required this.onTogglePass,
    required this.onToggleConfirm,
    required this.nameValidator,
    required this.emailValidator,
    required this.passwordValidator,
    required this.phoneValidator,
    required this.onSubmit,
  });

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController passCtrl;
  final TextEditingController confirmCtrl;
  final bool obscurePass;
  final bool obscureConfirm;
  final VoidCallback onTogglePass;
  final VoidCallback onToggleConfirm;
  final String? Function(String?) nameValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) phoneValidator;
  final String? Function(String?) passwordValidator;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final key = context.findAncestorStateOfType<_AuthPageState>()?._signUpKey;

    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            controller: nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: nameValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            validator: emailValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+201234567890',
              prefixIcon: Icon(Icons.phone),
            ),
            validator: phoneValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passCtrl,
            obscureText: obscurePass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: onTogglePass,
                icon:
                    Icon(obscurePass ? Icons.visibility : Icons.visibility_off),
                tooltip: obscurePass ? 'Show' : 'Hide',
              ),
            ),
            validator: passwordValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: confirmCtrl,
            obscureText: obscureConfirm,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: onToggleConfirm,
                icon: Icon(
                    obscureConfirm ? Icons.visibility : Icons.visibility_off),
                tooltip: obscureConfirm ? 'Show' : 'Hide',
              ),
            ),
            validator: passwordValidator,
            onFieldSubmitted: (_) => onSubmit(),
          ),
        ],
      ),
    );
  }
}
