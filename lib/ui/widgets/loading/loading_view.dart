import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView {
  static bool _isLoading = false;
  static BuildContext? _dialogContext;

  static show(BuildContext context) {
    if (_isLoading) return;

    showDialog(
        context: context,
        builder: (dialogContext) {
          _dialogContext = dialogContext;
          return PopScope(
            canPop: false,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Lottie.asset(
                      'assets/animations/loading_lottie_animation.json'),
                ),
              ),
            ),
          );
        });

    _isLoading = true;
  }

  static hide() {
    if (!_isLoading) return;

    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
    }

    _isLoading = false;
  }
}
