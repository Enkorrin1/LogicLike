import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

enum _AccountMode { signIn, createAccount }

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
  bool _rememberDevice = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _AccountHeroCard(profile: widget.profile),
              const SizedBox(height: 16),
              _SignInCard(
                formKey: _formKey,
                mode: _mode,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                rememberDevice: _rememberDevice,
                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,
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
                onApplePressed: _showAppleState,
                onForgotPasswordPressed: _showResetDialog,
                onRestorePurchasesPressed: _showRestoreState,
              ),
              const SizedBox(height: 16),
              const _AccountBenefitsCard(),
            ],
          ),
        ),
      ),
    );
  }

  void _submitEmailForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.accountDemoSnack)),
    );
  }

  void _showAppleState() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.accountAppleSnack)),
    );
  }

  void _showRestoreState() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.accountRestoreSnack)),
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

class _AccountHeroCard extends StatelessWidget {
  const _AccountHeroCard({
    required this.profile,
  });

  final FamilyProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PlayfulCard(
      padding: EdgeInsets.zero,
      borderColor: Colors.white,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFEAF7FF),
          Color(0xFFEDEAFF),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppMark(size: 64),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountHeroTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.accountHeroBody,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InfoPill(
                        icon: Icons.person_rounded,
                        label: profile.childName,
                        color: AppPalette.mint,
                      ),
                      InfoPill(
                        icon: Icons.cloud_off_rounded,
                        label: l10n.accountStatusGuest,
                        color: const Color(0xFFFFE7A8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInCard extends StatelessWidget {
  const _SignInCard({
    required this.formKey,
    required this.mode,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.rememberDevice,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onModeChanged,
    required this.onRememberDeviceChanged,
    required this.onPasswordVisibilityChanged,
    required this.onConfirmPasswordVisibilityChanged,
    required this.onSubmit,
    required this.onApplePressed,
    required this.onForgotPasswordPressed,
    required this.onRestorePurchasesPressed,
  });

  final GlobalKey<FormState> formKey;
  final _AccountMode mode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool rememberDevice;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final ValueChanged<_AccountMode> onModeChanged;
  final ValueChanged<bool> onRememberDeviceChanged;
  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onConfirmPasswordVisibilityChanged;
  final VoidCallback onSubmit;
  final VoidCallback onApplePressed;
  final VoidCallback onForgotPasswordPressed;
  final VoidCallback onRestorePurchasesPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final creatingAccount = mode == _AccountMode.createAccount;

    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: l10n.accountEmailTitle,
            trailing: InfoPill(
              icon: Icons.lock_rounded,
              label: l10n.accountStatusGuest,
              color: AppPalette.surfaceBlue,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.ink,
              foregroundColor: Colors.white,
            ),
            onPressed: onApplePressed,
            icon: const Icon(Icons.apple),
            label: Text(l10n.accountAppleButton),
          ),
          const SizedBox(height: 14),
          SegmentedButton<_AccountMode>(
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
          const SizedBox(height: 14),
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
                  const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
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
          const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: rememberDevice,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppPalette.teal,
              title: Text(
                l10n.accountRememberDevice,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              onChanged: (value) => onRememberDeviceChanged(value ?? false),
            ),
          ),
          const SizedBox(height: 6),
          FilledButton.icon(
            onPressed: onSubmit,
            icon: Icon(
              creatingAccount
                  ? Icons.person_add_alt_1_rounded
                  : Icons.login_rounded,
            ),
            label: Text(
              creatingAccount
                  ? l10n.accountSubmitCreate
                  : l10n.accountSubmitSignIn,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              TextButton.icon(
                onPressed: onForgotPasswordPressed,
                icon: const Icon(Icons.help_outline_rounded),
                label: Text(l10n.accountForgotPassword),
              ),
              TextButton.icon(
                onPressed: onRestorePurchasesPressed,
                icon: const Icon(Icons.workspace_premium_rounded),
                label: Text(l10n.accountRestorePurchases),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.accountPrivacyNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AccountBenefitsCard extends StatelessWidget {
  const _AccountBenefitsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PlayfulCard(
      color: const Color(0xFFFFFAEF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BenefitRow(
            icon: Icons.sync_rounded,
            color: AppPalette.teal,
            title: l10n.accountBenefitSyncTitle,
            body: l10n.accountBenefitSyncBody,
          ),
          const SizedBox(height: 10),
          _BenefitRow(
            icon: Icons.apple,
            color: AppPalette.ink,
            title: l10n.accountBenefitAppleTitle,
            body: l10n.accountBenefitAppleBody,
          ),
          const SizedBox(height: 10),
          _BenefitRow(
            icon: Icons.workspace_premium_rounded,
            color: AppPalette.mango,
            title: l10n.accountBenefitPurchaseTitle,
            body: l10n.accountBenefitPurchaseBody,
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBadge(
          icon: icon,
          color: color.withValues(alpha: 0.16),
          iconColor: color,
          size: 42,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
