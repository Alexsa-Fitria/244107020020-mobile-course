import 'package:dio/dio.dart';
import 'auth_repository.dart';
import 'token_store.dart';

Dio buildApiClient(TokenStore store, AuthRepository auth) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example-campus-api.test'));
  
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final access = await store.readAccess();
      if (access != null) {
        options.headers['Authorization'] = 'Bearer $access';
      }
      handler.next(options);
    },
    onError: (e, handler) async {
      // Jika error 401 (Unauthorized / Token Kadaluarsa)
      if (e.response?.statusCode == 401) {
        final refresh = await store.readRefresh();
        if (refresh == null) return handler.next(e);
        
        try {
          // Coba minta token baru
          final renewed = await auth.refresh(refresh);
          await store.save(access: renewed, refresh: refresh);
          
          // Ulangi request yang tadinya gagal dengan token baru
          final retry = await dio.fetch(
            e.requestOptions..headers['Authorization'] = 'Bearer $renewed',
          );
          return handler.resolve(retry);
        } catch (_) {
          // Kalau refresh token juga mati, paksa logout (hapus token)
          await store.clear();
        }
      }
      handler.next(e);
    },
  ));
  
  return dio;
}