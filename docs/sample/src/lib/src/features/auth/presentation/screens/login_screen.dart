import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qrino_admin/src/core/constants/status.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/middleware.dart';
import 'package:qrino_admin/src/redux/app_state.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ログイン')),
        body: Center(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
              ),
              child: StoreConnector<AppState, _ViewModel>(
                converter: (store) => _ViewModel(
                  status: store.state.authState.status,
                  error: store.state.authState.failure?.message,
                  dispatch: store.dispatch,
                ),
                builder: (context, vm) {
                  return FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (vm.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              vm.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        FormBuilderTextField(
                          name: 'email',
                          decoration: const InputDecoration(
                            labelText: 'メールアドレス',
                            border: OutlineInputBorder(),
                            helperText: 'メールアドレスを入力してください',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'メールアドレスを入力してください';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: const InputDecoration(
                            labelText: 'パスワード',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'パスワードを入力してください';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: vm.status == Status.loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    final formData = _formKey.currentState!.value;
                                    vm.dispatch(
                                      loginThunk(
                                        formData['email'],
                                        formData['password'],
                                      ),
                                    );
                                  }
                                },
                          child: const Text('ログイン'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final Status status;
  final String? error;
  final void Function(dynamic action) dispatch;

  _ViewModel({
    required this.status,
    this.error,
    required this.dispatch,
  });
}