import 'package:test/test.dart';

import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/course.dart';
import 'package:learning_hub/objects/event.dart';
import 'package:learning_hub/objects/notice.dart';
import 'package:learning_hub/objects/customUser.dart';
import 'package:learning_hub/objects/question.dart';
import 'package:learning_hub/objects/attachment.dart';

void main() {
  group('Assignments', () {
    test('Assignment should be serialized from JSON', () {
      /*  String courseName,
      String platform,
      Map<String, dynamic> assignmentJson,
      Map<String, dynamic> submissionJson*/

      //Submission response:
      //https://classroom.googleapis.com//v1/courses/$courseId/courseWork/$assignmentId/studentSubmissions?fields=studentSubmissions(assignmentSubmission,assignedGrade,late,state,id,shortAnswerSubmission,multipleChoiceSubmission)

      //Assignment response:
      //https://classroom.googleapis.com//v1/courses/$courseId/courseWork/$assignmentId

      //For testing:
      //https://developers.google.com/classroom/reference/rest/v1/courses.courseWork/get

      Map<String, dynamic> assignmentJson = {};
      Map<String, dynamic> submissionJson = {};

      final targetAssignment = new Assignment();

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
    });
  });
}
