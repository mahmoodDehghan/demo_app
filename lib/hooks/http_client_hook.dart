import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';

class _HttpClientHook extends Hook<http.Client> {
  @override
  HookState<http.Client, Hook<http.Client>> createState() => _HttpClientState();
}

class _HttpClientState extends HookState<http.Client, _HttpClientHook> {
  late http.Client _client;
  @override
  void initHook() {
    super.initHook();
    _client = http.Client();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  http.Client build(BuildContext context) {
    return _client;
  }
}

http.Client useHttpClientHook(BuildContext context) {
  return use(_HttpClientHook());
}
