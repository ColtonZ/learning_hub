import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';

import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/course.dart';
import 'package:learning_hub/objects/question.dart';
import 'package:learning_hub/objects/attachment.dart';
import 'package:learning_hub/objects/event.dart';
import 'mock_classes.dart';

void main() {
  group("Question", () {
    test("From JSON", () {
      Map<String, Object> questionJSON = {
        "choices": ["1", "2"],
      };
      Question targetQuestion =
          new Question(type: "Multiple Choice", options: ["1", "2"]);
      Question testQuestion = Question.fromJson(questionJSON);
      expect(targetQuestion, testQuestion);
    });
    test("From list", () {
      List<String> questionList = ["1", "2"];

      Question targetQuestion =
          new Question(type: "Multiple Choice", options: ["1", "2"]);
      Question testQuestion = Question.fromList(questionList);
      expect(targetQuestion, testQuestion);
    });
  });
  group("Attachment", () {
    test("Student submission file", () {
      Map<String, Object> attachmentJson = {
        "driveFile": {
          "driveFile": {
            "id": "3297086453",
            "title": "Networking Questions.docx",
            "alternateLink":
                "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
            "thumbnailUrl":
                "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
          }
        }
      };
      Attachment targetAttachment = new Attachment(
          id: "3297086453",
          title: "Networking Questions.docx",
          link:
              "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
          thumbnail:
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
          type: "file");
      Attachment testAttachment = Attachment.fromJson(attachmentJson);
      expect(targetAttachment, testAttachment);
    });
    test("Normal file", () {
      Map<String, Object> attachmentJson = {
        "driveFile": {
          "id": "3297086453",
          "title": "[Template] Networking Questions.docx",
          "alternateLink":
              "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
          "thumbnailUrl":
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
        }
      };
      Attachment targetAttachment = new Attachment(
          id: "3297086453",
          title: "[Template] Networking Questions.docx",
          link:
              "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
          thumbnail:
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
          type: "file");
      Attachment testAttachment = Attachment.fromJson(attachmentJson);
      expect(targetAttachment, testAttachment);
    });
    test("Link", () {
      Map<String, Object> attachmentJson = {
        "link": {
          "title": "Google",
          "url": "https://google.com",
          "thumbnailUrl":
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
        }
      };
      Attachment targetAttachment = new Attachment(
          title: "Google",
          link: "https://google.com",
          thumbnail:
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
          type: "link");
      Attachment testAttachment = Attachment.fromJson(attachmentJson);
      expect(targetAttachment, testAttachment);
    });
    test("YouTube", () {
      Map<String, Object> attachmentJson = {
        "youtubeVideo": {
          "id": "38941055478",
          "title": "How To Build a Flutter App",
          "alternateLink": "https://www.youtube.com/watch?v=aiTTClKJbnw",
          "thumbnailUrl":
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
        }
      };
      Attachment targetAttachment = new Attachment(
          id: "38941055478",
          title: "How To Build a Flutter App",
          link: "https://www.youtube.com/watch?v=aiTTClKJbnw",
          thumbnail:
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
          type: "YouTube");
      Attachment testAttachment = Attachment.fromJson(attachmentJson);
      expect(targetAttachment, testAttachment);
    });
    test("Form", () {
      Map<String, Object> attachmentJson = {
        "form": {
          "formUrl": "https://forms.gle/FbqdP74A7mWZfuc37",
          "title": "Timings for the BIO",
          "responseUrl":
              "https://docs.google.com/forms/d/e/1FAIpQLSesnnVgd9lEuTYIvqEn_Vl-i3jfa4MCP7wdRnizXBiQClQvJw/viewform?usp=pp_url&entry.1310310133=5th&entry.1066283423=No&entry.1225213364=Ability+to+see+Google+Classroom+and+Firefly+tasks&entry.1121847520=Ability+to+see+your+timetable&entry.262606151=Ability+to+see+tannoy+notices&entry.459185044=Ability+to+create+personal+tasks&entry.1505050148=Ability+to+add+events+to+your+timetable&entry.1547443054=Ability+to+configure+notifications+before+each+lesson",
          "thumbnailUrl":
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200"
        }
      };
      Attachment targetAttachment = new Attachment(
          title: "Timings for the BIO",
          link: "https://forms.gle/FbqdP74A7mWZfuc37",
          thumbnail:
              "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
          type: "form");
      Attachment testAttachment = Attachment.fromJson(attachmentJson);
      expect(targetAttachment, testAttachment);
    });
  });
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
                "title": "Database Question (U8th).pdf",
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
          attachments: [
            new Attachment(
                id: "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                title: "Database Question (U8th).pdf",
                link:
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                thumbnail:
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
                type: "file")
          ],
          submissionAttachments: [],
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
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
                "title": "Database Question (U8th).pdf",
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
                  "title": "Database Question (U8th).pdf",
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
          state: "TURNED_IN",
          creationTime: new DateTime(2021, 1, 25, 14, 13, 05, 494),
          updateTime: new DateTime(2021, 1, 26, 08, 59, 11, 760),
          type: "ASSIGNMENT",
          creatorId: "116159270767164612305",
          courseName: "Course Name",
          url:
              "https://classroom.google.com/c/ODg4NDE2MDUxNTla/a/MjY4MDIyMzE0ODcy/details",
          attachments: [
            new Attachment(
                id: "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                title: "Database Question (U8th).pdf",
                link:
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                thumbnail:
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
                type: "file")
          ],
          submissionAttachments: [
            new Attachment(
                id: "141iZ4pt87i64FNHnK-3roeS1mvqPcDjy",
                title: "Database Question (U8th).pdf",
                link:
                    "https://drive.google.com/open?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y",
                thumbnail:
                    "https://drive.google.com/thumbnail?id=1Qj41Y0YRpo22ssaK_v_jYhHmvkBdmI7Y&sz=s200",
                type: "file")
          ],
          grade: 20,
          isLate: false,
          submissionId: "224376012615",
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
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
          question: new Question(
              options: ["I'm here & I'm working on it."],
              type: "Multiple Choice"),
          attachments: [],
          submissionAttachments: [],
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
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
          state: "TURNED_IN",
          question: new Question(
              options: ["I'm here & I'm working on it."],
              type: "Multiple Choice"),
          grade: 10,
          isLate: true,
          answer: "I'm here & I'm working on it.",
          submissionId: "224376012615",
          attachments: [],
          submissionAttachments: [],
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
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
          attachments: [],
          submissionAttachments: [],
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
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
          state: "TURNED_IN",
          grade: 53,
          isLate: false,
          submissionId: "224376012615",
          attachments: [],
          submissionAttachments: [],
          answer: "53",
          platform: "GC");

      final testAssignment = Assignment.fromJson(
          "Course Name", "GC", assignmentJson, submissionJson);

      expect(testAssignment, targetAssignment);
    });
    test("Create custom assignment with description & course", () {
      Assignment testAssignment = Assignment.createCustom(
          "Assignment Title",
          "Assignment Description",
          "Assignment Subject",
          new DateTime(2020, 2, 14));
      Assignment targetAssignment = new Assignment(
          platform: "LH",
          title: "Assignment Title",
          description: "Assignment Description",
          courseName: "Personal Task • Assignment Subject",
          dueDate: new DateTime(2020, 2, 14),
          creationTime: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          updateTime: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          type: "PERSONAL");
      expect(targetAssignment, testAssignment);
    });
    test("Create custom assignment with only title", () {
      Assignment testAssignment = Assignment.createCustom(
          "Assignment Title", "", "", new DateTime(2020, 2, 14));
      Assignment targetAssignment = new Assignment(
          platform: "LH",
          title: "Assignment Title",
          courseName: "Personal Task",
          dueDate: new DateTime(2020, 2, 14),
          creationTime: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          updateTime: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          type: "PERSONAL");
      expect(targetAssignment, testAssignment);
    });
    test("Create a full custom assignment from Firestore", () {
      MockDocumentSnapshot mockDocument = new MockDocumentSnapshot(mockData: {
        "courseName": "Personal Task • Maths",
        "creationTime": Timestamp(1612523345, 0),
        "description": "Do maths homework",
        "dueDate": Timestamp(1612609723, 0),
        "platform": "LH",
        "title": "Personal Assignment",
        "type": "PERSONAL",
        "updateTime": Timestamp(1612523345, 0),
      }, id: "docID");
      Assignment testAssignment = Assignment.fromFirestore(mockDocument);
      Assignment targetAssignment = new Assignment(
          title: "Personal Assignment",
          creationTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
          updateTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
          dueDate: new DateTime(2021, 2, 6, 11, 8, 43, 0),
          type: "PERSONAL",
          courseName: "Personal Task • Maths",
          description: "Do maths homework",
          attachments: [],
          submissionAttachments: [],
          platform: "LH");
      expect(targetAssignment, testAssignment);
    });
    test(
        "Create a custom assignment from Firestore without description or course",
        () {
      MockDocumentSnapshot mockDocument = new MockDocumentSnapshot(mockData: {
        "courseName": "Personal Task",
        "creationTime": Timestamp(1612523345, 0),
        "dueDate": Timestamp(1612609723, 0),
        "platform": "LH",
        "title": "Personal Assignment",
        "type": "PERSONAL",
        "updateTime": Timestamp(1612523345, 0),
      }, id: "docID");
      Assignment testAssignment = Assignment.fromFirestore(mockDocument);
      Assignment targetAssignment = new Assignment(
          title: "Personal Assignment",
          creationTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
          updateTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
          dueDate: new DateTime(2021, 2, 6, 11, 8, 43, 0),
          type: "PERSONAL",
          courseName: "Personal Task",
          attachments: [],
          submissionAttachments: [],
          platform: "LH");
      expect(targetAssignment, testAssignment);
    });
  });
  group("Course", () {
    test("Course with description", () {
      Map<String, Object> courseJson = {
        "id": "2498376001548",
        "name": "A-Level Computing",
        "descriptionHeading": "This is the course's description",
        "courseState": "ACTIVE",
      };
      Course targetCourse = new Course(
          id: "2498376001548",
          platform: "Google Classroom",
          name: "A-Level Computing",
          description: "This is the course's description",
          status: "ACTIVE");
      Course testCourse = Course.fromJson(courseJson);
      expect(targetCourse, testCourse);
    });
    test("Course without description", () {
      Map<String, Object> courseJson = {
        "id": "2498376001548",
        "name": "A-Level Computing",
        "descriptionHeading": null,
        "courseState": "ACTIVE",
      };
      Course targetCourse = new Course(
          id: "2498376001548",
          platform: "Google Classroom",
          name: "A-Level Computing",
          description: "This course has no description",
          status: "ACTIVE");
      Course testCourse = Course.fromJson(courseJson);
      expect(targetCourse, testCourse);
    });
  });
  group("Event", () {
    test("Full, repeating, Firefly event from Firestore document", () {
      MockDocumentSnapshot mockDocument = new MockDocumentSnapshot(mockData: {
        "classSet": "UFM.5",
        "location": "SPS Room 228",
        "name": "Mathematics (Further)",
        "platform": "Firefly",
        "teacher": "Robert Breslin",
        "times": ["1, 0900, 0935, AB", "4, 1115, 1155, AB"]
      }, id: "docID");
      Event testEvent = Event.fromFirestore(mockDocument);
      Event targetEvent = new Event(
          id: "docID",
          classSet: "UFM.5",
          location: "SPS Room 228",
          name: "Mathematics (Further)",
          platform: "Firefly",
          teacher: "Robert Breslin",
          times: [
            ["1", "0900", "0935", "AB"],
            ["4", "1115", "1155", "AB"]
          ]);
      expect(targetEvent, testEvent);
    });
    test("Firefly event from Firestore document with no location or teacher",
        () {
      MockDocumentSnapshot mockDocument = new MockDocumentSnapshot(mockData: {
        "classSet": "UFM.5",
        "name": "Mathematics (Further)",
        "platform": "Firefly",
        "times": ["1, 0900, 0935, AB"]
      }, id: "docID");
      Event testEvent = Event.fromFirestore(mockDocument);
      Event targetEvent = new Event(
          id: "docID",
          classSet: "UFM.5",
          name: "Mathematics (Further)",
          platform: "Firefly",
          times: [
            ["1", "0900", "0935", "AB"]
          ]);
      expect(targetEvent, testEvent);
    });
    test("Full, repeating, custom event from Firestore document", () {
      MockDocumentSnapshot mockDocument = new MockDocumentSnapshot(mockData: {
        "classSet": null,
        "location": "SPS Room 217",
        "name": "Coding Projects Society",
        "platform": "LH",
        "teacher": "PrasadAR",
        "times": ["0, 1235, 1330, AB", "1, 1235, 1330, A", "1, 1330, 1420, B"]
      }, id: "docID");
      Event testEvent = Event.fromFirestore(mockDocument);
      Event targetEvent = new Event(
          id: "docID",
          name: "Coding Projects Society",
          teacher: "PrasadAR",
          location: "SPS Room 217",
          platform: "LH",
          times: [
            ["0", "1235", "1330", "AB"],
            ["1", "1235", "1330", "A"],
            ["1", "1330", "1420", "B"]
          ]);
      expect(targetEvent, testEvent);
    });
    test("custom event from Firestore document with no location or teacher",
        () {
      MockDocumentSnapshot mockDocument = new MockDocumentSnapshot(mockData: {
        "classSet": null,
        "location": null,
        "name": "Catch-Up",
        "platform": "LH",
        "teacher": null,
        "times": ["2, 1500, 1730, AB"]
      }, id: "docID");
      Event testEvent = Event.fromFirestore(mockDocument);
      Event targetEvent =
          new Event(id: "docID", name: "Catch-Up", platform: "LH", times: [
        ["2", "1500", "1730", "AB"]
      ]);
      expect(targetEvent, testEvent);
    });
  });
}
