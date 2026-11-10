import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_providers.dart';
import '../services/auth_service.dart';
import '../services/validators.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/header_band.dart';
import '../widgets/message_box.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';

/// Kartın, üstteki bandın üzerine ne kadar bineceği.
const double _cardOverlap = 40;

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _accepted = false;
  bool _submitted = false; // hatalar ilk denemeden sonra gösterilir
  bool _isLoading = false;
  String? _formError;

  String? get _nameError =>
      _submitted ? Validators.required(_nameController.text) : null;
  String? get _emailError =>
      _submitted ? Validators.email(_emailController.text) : null;
  String? get _passwordError =>
      _submitted ? Validators.password(_passwordController.text) : null;
  String? get _confirmError => _submitted
      ? Validators.confirmPassword(
          _confirmController.text,
          _passwordController.text,
        )
      : null;
  String? get _consentError =>
      _submitted && !_accepted ? Validators.consentMessage : null;

  bool get _hasErrors =>
      _nameError != null ||
      _emailError != null ||
      _passwordError != null ||
      _confirmError != null ||
      _consentError != null;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _submitted = true;
      _formError = null;
    });
    if (_hasErrors) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authServiceProvider)
          .signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Bu ekran giriş ekranının üstüne açıldı. AuthGate ana ekrana geçti;
      // bu ekranı kapatıp ana ekranı görünür yapıyoruz.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthException catch (e) {
      if (mounted) setState(() => _formError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _formError = 'Kayıt yapılamadı. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onChanged(String _) {
    if (_submitted) setState(() {});
  }

  void _toggleAccepted() {
    if (_isLoading) return;
    setState(() => _accepted = !_accepted);
  }

  Future<void> _showKvkkText() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KVKK Aydınlatma Metni'),
        content: const SingleChildScrollView(
          // TODO: Gerçek KVKK aydınlatma metni eklenecek.
          child: Text('KVKK metni buraya eklenecek.'),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBand(
              bottomPadding: _cardOverlap + 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Geri',
                    iconSize: 32,
                    color: AppColors.onPrimary,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(
                        AppSizes.minTouchTarget,
                        AppSizes.minTouchTarget,
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    header: true,
                    child: Text(
                      'Hesap oluşturun',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Birkaç bilgiyle hemen başlayın.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -_cardOverlap),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: Column(
                    children: [
                      AppCard(child: _buildForm()),
                      SizedBox(
                        height: MediaQuery.paddingOf(context).bottom + 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Adınız',
            icon: Icons.person_outline_rounded,
            hintText: 'Örnek: Ayşe Yılmaz',
            controller: _nameController,
            errorText: _nameError,
            enabled: !_isLoading,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            onChanged: _onChanged,
          ),
          const SizedBox(height: AppSizes.fieldSpacing),
          AppTextField(
            label: 'E-posta',
            icon: Icons.mail_outline_rounded,
            hintText: 'ornek@eposta.com',
            controller: _emailController,
            errorText: _emailError,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            onChanged: _onChanged,
          ),
          const SizedBox(height: AppSizes.fieldSpacing),
          PasswordField(
            label: 'Şifre (en az 6 karakter)',
            controller: _passwordController,
            errorText: _passwordError,
            enabled: !_isLoading,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: _onChanged,
          ),
          const SizedBox(height: AppSizes.fieldSpacing),
          PasswordField(
            label: 'Şifre tekrarı',
            controller: _confirmController,
            errorText: _confirmError,
            enabled: !_isLoading,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: _onChanged,
          ),
          const SizedBox(height: 24),
          _ConsentRow(
            value: _accepted,
            hasError: _consentError != null,
            onToggle: _toggleAccepted,
          ),
          AnimatedMessage(message: _consentError),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _showKvkkText,
              icon: const Icon(Icons.description_outlined, size: 28),
              label: const Text('KVKK metnini oku'),
            ),
          ),
          AnimatedMessage(message: _formError),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Kayıt Ol',
            loadingLabel: 'Kayıt yapılıyor…',
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

/// Büyük onay kutusu. Yalnızca kutuya değil, satırın tamamına dokunmak yeterli.
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.value,
    required this.hasError,
    required this.onToggle,
  });

  final bool value;
  final bool hasError;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError
        ? AppColors.error
        : value
        ? AppColors.primary
        : AppColors.border;

    return MergeSemantics(
      child: Material(
        // İşaretliyken zemin de değişir; tik işaretine ek bir ipucu.
        color: value ? AppColors.primaryContainer : AppColors.surface,
        animationDuration: AppTheme.animationDuration(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          side: BorderSide(color: borderColor, width: hasError ? 3 : 2),
        ),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: value,
                    onChanged: (_) => onToggle(),
                    side: BorderSide(color: borderColor, width: 2.5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Bu uygulamanın tıbbi tavsiye vermediğini anladım, '
                      'KVKK metnini okudum.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
