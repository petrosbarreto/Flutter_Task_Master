/// Configuração centralizada do Supabase
/// Use estas variáveis para conectar ao seu projeto Supabase
class SupabaseConfig {
  /// URL do seu projeto Supabase
  static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  
  /// Chave pública (anon key) do seu projeto
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
  
  /// Nome do banco de dados
  static const String databaseName = 'postgres';
}

/// Tabelas principais
class SupabaseTables {
  static const String users = 'users';
  static const String tasks = 'tasks';
  static const String categories = 'categories';
}

/// Buckets de storage
class SupabaseBuckets {
  static const String taskImages = 'task-images';
}
