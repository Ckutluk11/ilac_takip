import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_providers.dart';
import '../services/auth_service.dart';
import '../services/validators.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';
import '../widgets/header_band.dart';
import '../widgets/message_box.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';

/// Kartın, üstteki bandın üzerine ne kadar bineceği.
const double _cardOverlap = 48;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Hatalar ilk denemeden sonra gösterilir; kullanıcı daha yazmadan
  // kırmızı uyarı görmesin. "Şifremi unuttum" yalnızca e-postayı doğrular.
  bool _validateEmail = false;
  bool _validatePassword = false;

  bool _isLoading = false;
  bool _isSendingReset = false;
  String? _formError;
  String? _successMessage;

  String? get _emailError =>
      _validateEmail ? Validators.email(_emailController.text) : null;

  String? get _passwordError =>
      _validatePassword ? Validators.password(_passwordController.text) : null;

  bool get _isBusy => _isLoading || _isSendingReset;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _validateEmail = true;
      _validatePassword = true;
      _formError = null;
      _successMessage = null;
    });
    if (_emailError != null || _passwordError != null) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authServiceProvider)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Başarılı: AuthGate ana ekrana kendisi geçer.
    } on AuthException catch (e) {
      if (mounted) setState(() => _formError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _formError = 'Giriş yapılamadı. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _validateEmail = true;
      _formError = null;
      _successMessage = null;
    });
    if (_emailError != null) return;

    final email = _emailController.text.trim();
    setState(() => _isSendingReset = true);
    try {
      await ref.read(authServiceProvider).sendPasswordReset(email);
      if (mounted) {
        setState(
          () => _successMessage =
              // Firebase, güvenlik gereği adresin kayıtlı olup olmadığını
              // söylemez; mesaj bu yüzden "kayıtlıysa" diye başlıyor.
              'Bu adres kayıtlıysa $email adresine şifre sıfırlama bağlantısı '
              'gönderildi. Gelen kutunuzu ve gereksiz (spam) klasörünü '
              'kontrol edin.',
        );
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _formError = e.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _formError =
              'Sıfırlama bağlantısı gönderilemedi. Lütfen tekrar deneyin.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingReset = false);
    }
  }

  void _openRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RegisterScreen()));
  }

  /// İlk denemeden sonra, yazdıkça hata mesajlarını güncelle.
  void _onChanged(String _) {
    if (_validateEmail || _validatePassword) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderBand(
              bottomPadding: _cardOverlap + 32,
              child: AppLogo(),
            ),
            // Kart, bandın alt kısmının üzerine biner.
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(child: _buildForm(textTheme)),
                      const SizedBox(height: 28),
                      Text(
                        'Hesabınız yok mu?',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _isBusy ? null : _openRegister,
                        icon: const Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 28,
                        ),
                        label: const Text('Kayıt olun'),
                      ),
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

  Widget _buildForm(TextTheme textTheme) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Giriş yapın', style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Hesabınızın bilgilerini girin.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'E-posta',
            icon: Icons.mail_outline_rounded,
            hintText: 'ornek@eposta.com',
            controller: _emailController,
            errorText: _emailError,
            enabled: !_isBusy,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            onChanged: _onChanged,
          ),
          const SizedBox(height: AppSizes.fieldSpacing),
          PasswordField(
            label: 'Şifre',
            controller: _passwordController,
            errorText: _passwordError,
            enabled: !_isBusy,
            textInputAction: TextInputAction.done,
            onChanged: _onChanged,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isBusy ? null : _forgotPassword,
              child: Text(
                _isSendingReset ? 'Gönderiliyor…' : 'Şifremi unuttum',
              ),
            ),
          ),
          AnimatedMessage(
            message: _successMessage,
            type: MessageType.success,
            topSpacing: 4,
          ),
          AnimatedMessage(message: _formError, topSpacing: 4),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Giriş Yap',
            loadingLabel: 'Giriş yapılıyor…',
            isLoading: _isLoading,
            onPressed: _isSendingReset ? null : _submit,
          ),
        ],
      ),
    );
  }
}
