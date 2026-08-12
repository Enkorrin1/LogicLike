import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

enum _AccountMode { signIn, createAccount }

Future<void>? _googleSignInInitialization;

Future<void> _ensureGoogleSignInInitialized() {
  return _googleSignInInitialization ??= GoogleSignIn.instance.initialize();
}

class AccountSignInScreen extends StatefulWidget {
  const AccountSignInScreen({
    required this.profile,
    super.key,
  });

  final FamilyProfile profile;

  @override
  State<AccountSignInScreen> createState() => _AccountSignInScreenState();
}

class _AccountSignInScreenState extends State<AccountSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _AccountMode _mode = _AccountMode.signIn;
  _AccountSession? _session;
  bool _rememberDevice = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountTitle),
      ),
      body: PlayfulBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SignInCard(
                profile: widget.profile,
                formKey: _formKey,
                mode: _mode,
                session: _session,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                rememberDevice: _rememberDevice,
                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,
                isSubmitting: _isSubmitting,
                onModeChanged: (mode) {
                  setState(() {
                    _mode = mode;
                  });
                },
                onRememberDeviceChanged: (value) {
                  setState(() {
                    _rememberDevice = value;
                  });
                },
                onPasswordVisibilityChanged: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                onConfirmPasswordVisibilityChanged: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                onSubmit: _submitEmailForm,
                onGooglePressed: _handleGoogleSignIn,
                onApplePressed: _showAppleState,
                onForgotPasswordPressed: _showResetDialog,
                onRestorePurchasesPressed: _showRestoreState,
                onSignOutPressed: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitEmailForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      _session = _AccountSession(
        providerLabel: context.l10n.accountProviderEmail,
        email: _emailController.text.trim(),
      );
    });

    _showSnack(context.l10n.accountDemoSnack);
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _ensureGoogleSignInInitialized();
      if (!mounted) {
        return;
      }

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        _showSnack(context.l10n.accountGoogleUnsupportedSnack);
        return;
      }

      final account = await GoogleSignIn.instance.authenticate();
      if (!mounted) {
        return;
      }

      setState(() {
        _session = _AccountSession(
          providerLabel: context.l10n.accountProviderGoogle,
          email: account.email,
          displayName: account.displayName,
        );
      });

      _showSnack(context.l10n.accountGoogleSuccessSnack);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        _showSnack(context.l10n.accountGoogleCanceledSnack);
      } else if (error.code ==
              GoogleSignInExceptionCode.clientConfigurationError ||
          error.code == GoogleSignInExceptionCode.providerConfigurationError) {
        _showSnack(context.l10n.accountGoogleConfigSnack);
      } else {
        _showSnack(
          context.l10n.accountGoogleErrorSnack(
            error.description ?? error.code.name,
          ),
        );
      }
    } catch (error) {
      _showSnack(context.l10n.accountGoogleErrorSnack(error.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showAppleState() {
    _showSnack(context.l10n.accountAppleSnack);
  }

  void _showRestoreState() {
    _showSnack(context.l10n.accountRestoreSnack);
  }

  Future<void> _signOut() async {
    setState(() {
      _session = null;
    });

    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // The session may have been created through email/password, or Google
      // Sign-In may not have been initialized on this platform yet.
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showResetDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;

        return AlertDialog(
          title: Text(l10n.accountResetDialogTitle),
          content: Text(l10n.accountResetDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.accountResetDialogAction),
            ),
          ],
        );
      },
    );
  }
}

class _AccountSession {
  const _AccountSession({
    required this.providerLabel,
    required this.email,
    this.displayName,
  });

  final String providerLabel;
  final String email;
  final String? displayName;
}

class _SignInCard extends StatelessWidget {
  const _SignInCard({
    required this.profile,
    required this.formKey,
    required this.mode,
    required this.session,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.rememberDevice,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isSubmitting,
    required this.onModeChanged,
    required this.onRememberDeviceChanged,
    required this.onPasswordVisibilityChanged,
    required this.onConfirmPasswordVisibilityChanged,
    required this.onSubmit,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onForgotPasswordPressed,
    required this.onRestorePurchasesPressed,
    required this.onSignOutPressed,
  });

  final FamilyProfile profile;
  final GlobalKey<FormState> formKey;
  final _AccountMode mode;
  final _AccountSession? session;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool rememberDevice;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isSubmitting;
  final ValueChanged<_AccountMode> onModeChanged;
  final ValueChanged<bool> onRememberDeviceChanged;
  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onConfirmPasswordVisibilityChanged;
  final Future<void> Function() onSubmit;
  final Future<void> Function() onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onRestorePurchasesPressed;
  final Future<void> Function() onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final creatingAccount = mode == _AccountMode.createAccount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AccountHero(
          childName: profile.childName,
          status: session?.providerLabel ?? l10n.accountStatusGuest,
          isSignedIn: session != null,
        ),
        const SizedBox(height: 18),
        Text(
          l10n.accountEmailTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppPalette.ink,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 10),
        _ProviderButtons(
          isSubmitting: isSubmitting,
          googleLabel: l10n.accountProviderGoogle,
          appleLabel: l10n.accountProviderApple,
          onGooglePressed: onGooglePressed,
          onApplePressed: onApplePressed,
        ),
        const SizedBox(height: 18),
        PlayfulCard(
          padding: const EdgeInsets.all(16),
          color: Colors.white.withValues(alpha: 0.94),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<_AccountMode>(
                style: ButtonStyle(
                  minimumSize:
                      const WidgetStatePropertyAll(Size.fromHeight(48)),
                  visualDensity: VisualDensity.standard,
                ),
                segments: [
                  ButtonSegment(
                    value: _AccountMode.signIn,
                    label: Text(l10n.accountSignInTab),
                    icon: const Icon(Icons.login_rounded),
                  ),
                  ButtonSegment(
                    value: _AccountMode.createAccount,
                    label: Text(l10n.accountCreateTab),
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (selection) {
                  onModeChanged(selection.first);
                },
              ),
              const SizedBox(height: 12),
              if (session != null) ...[
                _SignedInBanner(
                  session: session!,
                  onSignOutPressed: onSignOutPressed,
                ),
                const SizedBox(height: 12),
              ],
              AutofillGroup(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.accountEmailLabel,
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (!email.contains('@') || !email.contains('.')) {
                            return l10n.accountEmailError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        autofillHints: const [AutofillHints.password],
                        obscureText: obscurePassword,
                        textInputAction: creatingAccount
                            ? TextInputAction.next
                            : TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: l10n.accountPasswordLabel,
                          prefixIcon: const Icon(Icons.password_rounded),
                          suffixIcon: IconButton(
                            onPressed: onPasswordVisibilityChanged,
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          if (!creatingAccount) {
                            onSubmit();
                          }
                        },
                        validator: (value) {
                          if ((value ?? '').length < 6) {
                            return l10n.accountPasswordError;
                          }
                          return null;
                        },
                      ),
                      if (creatingAccount) ...[
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: confirmPasswordController,
                          autofillHints: const [AutofillHints.newPassword],
                          obscureText: obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.accountConfirmPasswordLabel,
                            prefixIcon: const Icon(Icons.verified_user_rounded),
                            suffixIcon: IconButton(
                              onPressed: onConfirmPasswordVisibilityChanged,
                              icon: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (_) => onSubmit(),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return l10n.accountPasswordMismatch;
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onRememberDeviceChanged(!rememberDevice),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Checkbox(
                        value: rememberDevice,
                        activeColor: AppPalette.teal,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) =>
                            onRememberDeviceChanged(value ?? false),
                      ),
                      Expanded(
                        child: Text(
                          l10n.accountRememberDevice,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppPalette.ink,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: isSubmitting ? null : () => onSubmit(),
                icon: isSubmitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        creatingAccount
                            ? Icons.person_add_alt_1_rounded
                            : Icons.login_rounded,
                      ),
                label: Text(
                  isSubmitting
                      ? l10n.accountAuthLoading
                      : creatingAccount
                          ? l10n.accountSubmitCreate
                          : l10n.accountSubmitSignIn,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onForgotPasswordPressed,
                      child: Text(l10n.accountForgotPassword),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: onRestorePurchasesPressed,
                      child: Text(l10n.accountRestorePurchases),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountHero extends StatelessWidget {
  const _AccountHero({
    required this.childName,
    required this.status,
    required this.isSignedIn,
  });

  final String childName;
  final String status;
  final bool isSignedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5F9FF), Color(0xFFFFF7D8)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppPalette.sky.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar_lion.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              childName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          InfoPill(
            icon: isSignedIn ? Icons.verified_user_rounded : Icons.lock_rounded,
            label: status,
            color: isSignedIn ? AppPalette.mint : Colors.white,
          ),
        ],
      ),
    );
  }
}

class _ProviderButtons extends StatelessWidget {
  const _ProviderButtons({
    required this.isSubmitting,
    required this.googleLabel,
    required this.appleLabel,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  final bool isSubmitting;
  final String googleLabel;
  final String appleLabel;
  final Future<void> Function() onGooglePressed;
  final VoidCallback onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: Colors.white,
            ),
            onPressed: isSubmitting ? null : () => onGooglePressed(),
            icon: const Icon(Icons.g_mobiledata_rounded),
            label: Text(googleLabel),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.ink,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: isSubmitting ? null : onApplePressed,
            icon: const Icon(Icons.apple),
            label: Text(appleLabel),
          ),
        ),
      ],
    );
  }
}

class _SignedInBanner extends StatelessWidget {
  const _SignedInBanner({
    required this.session,
    required this.onSignOutPressed,
  });

  final _AccountSession session;
  final Future<void> Function() onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayName = session.displayName;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.mint.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(
            icon: Icons.verified_rounded,
            color: AppPalette.teal,
            iconColor: Colors.white,
            size: 36,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountSignedInTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  displayName == null || displayName.isEmpty
                      ? session.email
                      : '$displayName - ${session.email}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSignOutPressed,
            child: Text(l10n.accountSignOut),
          ),
        ],
      ),
    );
  }
}
