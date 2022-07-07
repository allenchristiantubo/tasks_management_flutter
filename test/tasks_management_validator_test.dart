import 'package:tasks_management/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late String? taskName;
  late String? taskDescription;
  TaskValidator validator = TaskValidator();
  group('Validate Task Name', (){
    test('Task name is whitespace must return error message that title is required.', (){
      //Act
      final actualResult = validator.validateTaskName("                 ");

      //Assert
      expect(actualResult, 'Title is required.');
    });

    test('Task name is empty string must return error message that title is required.', (){
      //Act
      final actualResult = validator.validateTaskName("");

      //Assert
      expect(actualResult, 'Title is required.');
    });

    test('Task name is a valid task name must return null', () {
      //Act
      final actualResult = validator.validateTaskName("Study about flutter");

      //Assert
      expect(actualResult, null);
    });
  });

  group('Validate Task Description', (){
    test('Task description is whitespace must return error message that description is required.', (){
      //Act
      final actualResult = validator.validateTaskDescription("                 ");

      //Assert
      expect(actualResult, 'Description is required.');
    });

    test('Task description is empty string must return error message that description is required.', (){
      //Act
      final actualResult = validator.validateTaskDescription("");

      //Assert
      expect(actualResult, 'Description is required.');
    });

    test('Task description is a valid task name must return null', () {
      //Act
      final actualResult = validator.validateTaskDescription("Read some documentation about flutter");

      //Assert
      expect(actualResult, null);
    });
  });
}