class TaskValidator{
  validateTaskName(String taskName){
    if(taskName.isEmpty || taskName.trim() == '')
    {
      return 'Title is required.';
    }
    return null;
  }

  validateTaskDescription(String taskDescription){
    if(taskDescription.isEmpty || taskDescription.trim() == '')
    {
      return 'Description is required.';
    }
    return null;
  }
}