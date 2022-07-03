class TaskTable{
  static const String tableName = "tasks";
  static const String columnTaskId = "taskId";
  static const String columnTaskName = "taskName";
  static const String columnTaskDescription = "taskDescription";
  static const String columnDateCreated = "dateCreated";
  static const String columnDateModified = "dateModified";
  static const String columnDateFinished = "dateFinished";
  static const String columnStatus = "status";

  static const String createQuery = "CREATE TABLE IF NOT EXISTS $tableName("
      "$columnTaskId TEXT PRIMARY KEY NOT NULL,"
      "$columnTaskName TEXT NOT NULL,"
      "$columnTaskDescription TEXT NOT NULL,"
      "$columnDateCreated TEXT,"
      "$columnDateModified TEXT,"
      "$columnDateFinished TEXT,"
      "$columnStatus INTEGER NOT NULL"
  ")";
}