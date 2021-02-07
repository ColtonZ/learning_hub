import 'package:test/test.dart';

import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/course.dart';
import 'package:learning_hub/objects/event.dart';
import 'package:learning_hub/objects/notice.dart';
import 'package:learning_hub/objects/customUser.dart';
import 'package:learning_hub/objects/question.dart';
import 'package:learning_hub/objects/attachment.dart';

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

void main() {
  group('Assignment', () {
    test('Basic assignment without submission', () {
      Map<String, dynamic> assignmentJson = {
        "courseId": "88841605159",
        "id": "268022314872",
        "title": "Week 3 26/01/2021",
        "description": "Database questions.  Please work through and submit.",
        "materials": [
          {
            "driveFile": {
              "driveFile": {
                "id": "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                "title": "[Template] Database Question (U8th).pdf",
                "alternateLink":
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                "thumbnailUrl":
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
              },
              "shareMode": "STUDENT_COPY"
            }
          }
        ],
        "state": "PUBLISHED",
        "alternateLink":
            "https://classroom.google.com/c/ODg4NDE2MDUxNTla/a/MjY4MDIyMzE0ODcy/details",
        "creationTime": "2021-01-25T14:13:05.494Z",
        "updateTime": "2021-01-26T08:59:11.760Z",
        "workType": "ASSIGNMENT",
        "submissionModificationMode": "MODIFIABLE_UNTIL_TURNED_IN",
        "creatorUserId": "116159270767164612305",
      };

      Map<String, dynamic> submissionJson = {};

      final targetAssignment = Assignment(
          courseId: "88841605159",
          id: "268022314872",
          title: "Week 3 26/01/2021",
          description: "Database questions.  Please work through and submit.",
          status: "PUBLISHED",
          creationTime: new DateTime(2021, 1, 25, 14, 13, 05, 494),
          updateTime: new DateTime(2021, 1, 26, 08, 59, 11, 760),
          type: "ASSIGNMENT",
          creatorId: "116159270767164612305",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/ODg4NDE2MDUxNTla/a/MjY4MDIyMzE0ODcy/details",
          state: "MODIFIABLE_UNTIL_TURNED_IN",
          attachments: [
            new Attachment(
                id: "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                title: "[Template] Database Question (U8th).pdf",
                link:
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                thumbnail:
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
                type: "FILE")
          ],
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      identical(testAssignment, targetAssignment);
    });
    test('Basic assignment with submission', () {
      Map<String, dynamic> assignmentJson = {
        "courseId": "88841605159",
        "id": "268022314872",
        "title": "Week 3 26/01/2021",
        "description": "Database questions.  Please work through and submit.",
        "materials": [
          {
            "driveFile": {
              "driveFile": {
                "id": "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                "title": "[Template] Database Question (U8th).pdf",
                "alternateLink":
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                "thumbnailUrl":
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
              },
              "shareMode": "STUDENT_COPY"
            }
          }
        ],
        "state": "PUBLISHED",
        "alternateLink":
            "https://classroom.google.com/c/ODg4NDE2MDUxNTla/a/MjY4MDIyMzE0ODcy/details",
        "creationTime": "2021-01-25T14:13:05.494Z",
        "updateTime": "2021-01-26T08:59:11.760Z",
        "workType": "ASSIGNMENT",
        "submissionModificationMode": "MODIFIABLE_UNTIL_TURNED_IN",
        "creatorUserId": "116159270767164612305",
      };

      Map<String, dynamic> submissionJson = {
        "assignmentSubmission": {
          "attachments": [
            {
              "driveFile": {
                "driveFile": {
                  "id": "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                  "title": "[Template] Database Question (U8th).pdf",
                  "alternateLink":
                      "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                  "thumbnailUrl":
                      "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
                },
                "shareMode": "STUDENT_COPY"
              }
            }
          ],
        },
        "assignedGrade": 20,
        "late": false,
        "state": "TURNED_IN",
        "id": "224376012615",
        "shortAnswerSubmission": null,
        "multipleChoiceSubmission": null
      };

      final targetAssignment = Assignment(
          courseId: "88841605159",
          id: "268022314872",
          title: "Week 3 26/01/2021",
          description: "Database questions.  Please work through and submit.",
          status: "PUBLISHED",
          creationTime: new DateTime(2021, 1, 25, 14, 13, 05, 494),
          updateTime: new DateTime(2021, 1, 26, 08, 59, 11, 760),
          type: "ASSIGNMENT",
          creatorId: "116159270767164612305",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/ODg4NDE2MDUxNTla/a/MjY4MDIyMzE0ODcy/details",
          state: "MODIFIABLE_UNTIL_TURNED_IN",
          attachments: [
            new Attachment(
                id: "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                title: "[Template] Database Question (U8th).pdf",
                link:
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                thumbnail:
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
                type: "FILE")
          ],
          submissionAttachments: [
            new Attachment(
                id: "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                title: "[Template] Database Question (U8th).pdf",
                link:
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                thumbnail:
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
                type: "FILE")
          ],
          grade: 20,
          isLate: false,
          submissionId: "224376012615",
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      identical(testAssignment, targetAssignment);
    });
    test('Multiple choice assignment without submission', () {
      Map<String, dynamic> assignmentJson = {
        "courseId": "88841605159",
        "id": "185646400661",
        "title": "Week 15 15/12/2020",
        "description":
            "Please read the chapters in the PG book you have at home on IP Addresses (Chapter 60 page 307) and Client-Server systems (Chapter 61 page 313).\n\nDepartmental revision page link:\nhttps://intranet.stpaulsschool.org.uk/computing/exams/christmas-remedy-revision\n\nI'll be online if you have any questions.  Otherwise, have a good break and I'll see you next term.",
        "state": "PUBLISHED",
        "alternateLink":
            "https://classroom.google.com/c/ODg4NDE2MDUxNTla/mc/MTg1NjQ2NDAwNjYx/details",
        "creationTime": "2020-12-14T08:23:05.576Z",
        "updateTime": "2020-12-15T07:51:59.512Z",
        "workType": "MULTIPLE_CHOICE_QUESTION",
        "submissionModificationMode": "MODIFIABLE_UNTIL_TURNED_IN",
        "multipleChoiceQuestion": {
          "choices": ["I'm here & I'm working on it."]
        },
        "creatorUserId": "116159270767164612305",
        "topicId": "135456087316"
      };

      Map<String, dynamic> submissionJson = {
        "multipleChoiceSubmission": {"answer": null}
      };

      final targetAssignment = Assignment(
          courseId: "88841605159",
          id: "185646400661",
          title: "Week 15 15/12/2020",
          description:
              "Please read the chapters in the PG book you have at home on IP Addresses (Chapter 60 page 307) and Client-Server systems (Chapter 61 page 313).\n\nDepartmental revision page link:\nhttps://intranet.stpaulsschool.org.uk/computing/exams/christmas-remedy-revision\n\nI'll be online if you have any questions.  Otherwise, have a good break and I'll see you next term.",
          status: "PUBLISHED",
          creationTime: new DateTime(2020, 12, 14, 8, 23, 5, 576),
          updateTime: new DateTime(2020, 12, 15, 7, 51, 59, 512),
          type: "MULTIPLE_CHOICE_QUESTION",
          creatorId: "116159270767164612305",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/ODg4NDE2MDUxNTla/mc/MTg1NjQ2NDAwNjYx/details",
          state: "MODIFIABLE_UNTIL_TURNED_IN",
          question: new Question(
              options: ["I'm here & I'm working on it."],
              type: "Multiple Choice"),
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      identical(testAssignment, targetAssignment);
    });
    test('Multiple choice assignment with submission', () {
      Map<String, dynamic> assignmentJson = {
        "courseId": "88841605159",
        "id": "185646400661",
        "title": "Week 15 15/12/2020",
        "description":
            "Please read the chapters in the PG book you have at home on IP Addresses (Chapter 60 page 307) and Client-Server systems (Chapter 61 page 313).\n\nDepartmental revision page link:\nhttps://intranet.stpaulsschool.org.uk/computing/exams/christmas-remedy-revision\n\nI'll be online if you have any questions.  Otherwise, have a good break and I'll see you next term.",
        "state": "PUBLISHED",
        "alternateLink":
            "https://classroom.google.com/c/ODg4NDE2MDUxNTla/mc/MTg1NjQ2NDAwNjYx/details",
        "creationTime": "2020-12-14T08:23:05.576Z",
        "updateTime": "2020-12-15T07:51:59.512Z",
        "workType": "MULTIPLE_CHOICE_QUESTION",
        "submissionModificationMode": "MODIFIABLE_UNTIL_TURNED_IN",
        "multipleChoiceQuestion": {
          "choices": ["I'm here & I'm working on it."]
        },
        "creatorUserId": "116159270767164612305",
        "topicId": "135456087316"
      };

      Map<String, dynamic> submissionJson = {
        "assignmentSubmission": null,
        "assignedGrade": 10,
        "late": true,
        "state": "TURNED_IN",
        "id": "224376012615",
        "shortAnswerSubmission": null,
        "multipleChoiceSubmission": {"answer": "I'm here & I'm working on it."}
      };

      final targetAssignment = Assignment(
          courseId: "88841605159",
          id: "185646400661",
          title: "Week 15 15/12/2020",
          description:
              "Please read the chapters in the PG book you have at home on IP Addresses (Chapter 60 page 307) and Client-Server systems (Chapter 61 page 313).\n\nDepartmental revision page link:\nhttps://intranet.stpaulsschool.org.uk/computing/exams/christmas-remedy-revision\n\nI'll be online if you have any questions.  Otherwise, have a good break and I'll see you next term.",
          status: "PUBLISHED",
          creationTime: new DateTime(2020, 12, 14, 8, 23, 5, 576),
          updateTime: new DateTime(2020, 12, 15, 7, 51, 59, 512),
          type: "MULTIPLE_CHOICE_QUESTION",
          creatorId: "116159270767164612305",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/ODg4NDE2MDUxNTla/mc/MTg1NjQ2NDAwNjYx/details",
          state: "MODIFIABLE_UNTIL_TURNED_IN",
          question: new Question(
              options: ["I'm here & I'm working on it."],
              type: "MULTIPLE__CHOICE_QUESTION"),
          grade: 10,
          isLate: true,
          submissionId: "224376012615",
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      identical(testAssignment, targetAssignment);
    });
    test('Short answer assignment without submission', () {
      Map<String, dynamic> assignmentJson = {
        "courseId": "158174911786",
        "id": "268704103186",
        "title": "Y532, June 18, what was your score out of 60?",
        "state": "PUBLISHED",
        "alternateLink":
            "https://classroom.google.com/c/MTU4MTc0OTExNzg2/sa/MjY4NzA0MTAzMTg2/details",
        "creationTime": "2021-02-02T10:05:20.508Z",
        "updateTime": "2021-02-02T10:06:06.022Z",
        "maxPoints": 60,
        "workType": "SHORT_ANSWER_QUESTION",
        "submissionModificationMode": "MODIFIABLE_UNTIL_TURNED_IN",
        "creatorUserId": "102799471922458712560",
        "topicId": "245920849126"
      };

      Map<String, dynamic> submissionJson = {
        "shortAnswerSubmission": {"answer": null}
      };

      final targetAssignment = Assignment(
          courseId: "158174911786",
          id: "268704103186",
          title: "Y532, June 18, what was your score out of 60?",
          status: "PUBLISHED",
          creationTime: new DateTime(2021, 2, 2, 10, 5, 20, 508),
          updateTime: new DateTime(2021, 2, 2, 10, 6, 6, 22),
          type: "SHORT_ANSWER_QUESTION",
          points: 60,
          creatorId: "102799471922458712560",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/MTU4MTc0OTExNzg2/sa/MjY4NzA0MTAzMTg2/details",
          state: "MODIFIABLE_UNTIL_TURNED_IN",
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      identical(testAssignment, targetAssignment);
    });
    test('Short answer assignment with submission', () {
      Map<String, dynamic> assignmentJson = {
        "courseId": "158174911786",
        "id": "268704103186",
        "title": "Y532, June 18, what was your score out of 60?",
        "state": "PUBLISHED",
        "alternateLink":
            "https://classroom.google.com/c/MTU4MTc0OTExNzg2/sa/MjY4NzA0MTAzMTg2/details",
        "creationTime": "2021-02-02T10:05:20.508Z",
        "updateTime": "2021-02-02T10:06:06.022Z",
        "maxPoints": 60,
        "workType": "SHORT_ANSWER_QUESTION",
        "submissionModificationMode": "MODIFIABLE_UNTIL_TURNED_IN",
        "creatorUserId": "102799471922458712560",
        "topicId": "245920849126"
      };

      Map<String, dynamic> submissionJson = {
        "assignmentSubmission": null,
        "assignedGrade": 53,
        "late": false,
        "state": "TURNED_IN",
        "id": "224376012615",
        "shortAnswerSubmission": {"answer": "53"},
        "multipleChoiceSubmission": null,
      };

      final targetAssignment = Assignment(
          courseId: "158174911786",
          id: "268704103186",
          title: "Y532, June 18, what was your score out of 60?",
          status: "PUBLISHED",
          creationTime: new DateTime(2021, 2, 2, 10, 5, 20, 508),
          updateTime: new DateTime(2021, 2, 2, 10, 6, 6, 22),
          type: "SHORT_ANSWER_QUESTION",
          points: 60,
          creatorId: "102799471922458712560",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/MTU4MTc0OTExNzg2/sa/MjY4NzA0MTAzMTg2/details",
          state: "MODIFIABLE_UNTIL_TURNED_IN",
          grade: 53,
          isLate: false,
          submissionId: "224376012615",
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      identical(testAssignment, targetAssignment);
    });
  });
}
