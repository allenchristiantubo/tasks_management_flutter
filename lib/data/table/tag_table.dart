class TagTable{
  static const String tableName = "tags";
  static const String columnTagId = "tagId";
  static const String columnTagName = "tagName";
  static const String columnTaskId = "taskId";

  static const String createQuery = "CREATE TABLE IF NOT EXISTS $tableName("
      "$columnTagId TEXT PRIMARY KEY NOT NULL,"
      "$columnTagName TEXT NOT NULL,"
      "$columnTaskId TEXT NOT NULL,"
      "CONSTRAINT fk_tasks FOREIGN KEY(taskId) REFERENCES tasks(taskId) ON DELETE CASCADE"
  ")";
}