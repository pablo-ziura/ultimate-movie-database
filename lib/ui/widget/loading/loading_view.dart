import 'package:flutter/material.dart';

class LoadingView {
  static bool _isLoading = false;
  static BuildContext? _dialogContext;

  static show(BuildContext context) {
    if (_isLoading) return;

    showDialog(
        context: context,
        builder: (dialogContext) {
          _dialogContext = dialogContext;

          return const PopScope(
            canPop: false,
            child: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
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
