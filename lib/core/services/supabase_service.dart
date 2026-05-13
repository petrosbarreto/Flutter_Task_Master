import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço centralizado para interações com Supabase
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  
  factory SupabaseService() {
    return _instance;
  }
  
  SupabaseService._internal();
  
  /// Getter para o cliente Supabase
  SupabaseClient get client => Supabase.instance.client;
  
  /// Getter para o usuário autenticado atual
  User? get currentUser => client.auth.currentUser;
  
  /// Stream de mudanças no estado de autenticação
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  /// Verifica se o usuário está autenticado
  bool get isAuthenticated => currentUser != null;
  
  /// Faz login com email e senha
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Registra um novo usuário
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  /// Faz logout do usuário atual
  Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  /// Obtém uma tabela do banco de dados
  PostgrestListResponse getTable(String tableName) {
    return client.from(tableName).select();
  }
  
  /// Upload de arquivo para o bucket de storage
  Future<String> uploadFile({
    required String bucketName,
    required String filePath,
    required List<int> fileBytes,
  }) async {
    final String fileName = filePath.split('/').last;
    await client.storage.from(bucketName).uploadBinary(
      fileName,
      fileBytes,
    );
    return client.storage.from(bucketName).getPublicUrl(fileName);
  }
}
