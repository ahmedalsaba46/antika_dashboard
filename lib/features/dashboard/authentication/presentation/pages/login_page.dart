import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../widget/base_flushbar.dart';
import '../widget/input_box_column.dart';
import '../widget/base_app_bar.dart';
import '../widget/base_button.dart';
import '../widget/base_progress_indicator.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  bool isLoging = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state to ensure it's properly initialized
    final authState = ref.watch(authStateProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'تسجيل دخول'),
        body: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('خطأ في تحميل البيانات'),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(authStateProvider),
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
          data: (user) => _buildLoginForm(context),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              InputBoxColumn(
                label: 'البريد الإلكتروني',
                hintText: 'example@gmail.com',
                suffixIconData: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator:
                    (p0) =>
                        emailController.text.isNotEmpty &&
                                emailController.text.contains('@')
                            ? null
                            : 'يرجى إدخال بريد إلكتروني صحيح',
              ),
              InputBoxColumn(
                label: 'كلمة المرور',
                hintText: '***************',
                suffixIconData: Icons.lock,
                obscureText: true,
                controller: passwordController,
                validator:
                    (p0) =>
                        passwordController.text.length >= 8
                            ? null
                            : 'يجب أن لا تقل كلمة المرور عن 8 أحرف',
              ),
              SizedBox(height: 40.h),
              isLoging
                  ? const BaseProgressIndicator()
                  : BaseButton(
                    text: 'تسجيل الدخول',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoging = true;
                        });

                        try {
                          final authNotifier = ref.read(
                            authStateProvider.notifier,
                          );
                          final success = await authNotifier.login(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          if (success) {
                            // Login successful - redirect to dashboard
                            if (mounted) {
                              context.go('/');
                            }
                          } else {
                            // Login failed - show specific error message
                            String errorMessage;
                            switch (authNotifier.lastLoginError) {
                              case 'user_not_found':
                              case 'invalid_password':
                                errorMessage =
                                    'خطأ في البريد الإلكتروني أو كلمة المرور!';
                                break;
                              case 'not_admin':
                                errorMessage =
                                    'هذا الحساب غير مخول للوصول إلى لوحة التحكم. يجب أن تكون مديراً للدخول.';
                                break;
                              case 'user_blocked':
                                errorMessage = 'تم حظر حسابك من قبل الإدارة.';
                                break;
                              case 'user_pending':
                                errorMessage =
                                    'حسابك قيد المراجعة من الإدارة. لا يمكنك تسجيل الدخول الآن.';
                                break;
                              case 'user_inactive':
                                errorMessage =
                                    'حسابك غير نشط. يرجى الاتصال بالإدارة.';
                                break;
                              case 'system_error':
                                errorMessage =
                                    'حدث خطأ في النظام. يرجى المحاولة مرة أخرى.';
                                break;
                              default:
                                errorMessage = 'حدث خطأ أثناء تسجيل الدخول!';
                            }

                            if (mounted) {
                              buildBaseFlushBar(
                                context: context,
                                message: errorMessage,
                              );
                            }
                            setState(() {
                              isLoging = false;
                            });
                          }
                        } catch (e) {
                          if (mounted) {
                            buildBaseFlushBar(
                              context: context,
                              message: 'حدث خطأ أثناء تسجيل الدخول!',
                            );
                          }
                          setState(() {
                            isLoging = false;
                          });
                        }
                      } else {
                        buildBaseFlushBar(
                          context: context,
                          message: 'يجب تعبئة الحقول بشكل صحيح!',
                        );
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
