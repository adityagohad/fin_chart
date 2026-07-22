import 'package:flutter/material.dart';
import 'package:fin_chart/models/tasks/start_journey.task.dart';
import 'package:fin_chart/models/tasks/attach_video_to_journey.task.dart';
import 'package:fin_chart/models/tasks/hide_video_btn_in_journey.task.dart';
import 'package:fin_chart/models/tasks/add_course_video.task.dart';

Future<StartJourneyTask?> showStartJourneyDialog({
  required BuildContext context,
}) async {
  return showDialog<StartJourneyTask>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Start Journey'),
        content: const Text('A new journey will be started.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(StartJourneyTask());
            },
            child: const Text('Start'),
          ),
        ],
      );
    },
  );
}

Future<AttachVideoToJourneyTask?> showAttachVideoDialog({
  required BuildContext context,
  AttachVideoToJourneyTask? initialTask,
}) async {
  final videoUrlController = TextEditingController(
    text: initialTask?.videoUrl ?? '',
  );

  return showDialog<AttachVideoToJourneyTask>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Attach Video to Journey'),
        content: TextField(
          controller: videoUrlController,
          decoration: const InputDecoration(
            labelText: 'Video URL',
            hintText: 'https://...',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final videoUrl = videoUrlController.text.trim();
              if (videoUrl.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a video URL'),
                  ),
                );
                return;
              }
              Navigator.of(context).pop(
                AttachVideoToJourneyTask(videoUrl: videoUrl),
              );
            },
            child: const Text('Attach'),
          ),
        ],
      );
    },
  );
}

Future<HideVideoBtnInJourneyTask?> showHideVideoBtnDialog({
  required BuildContext context,
}) async {
  return showDialog<HideVideoBtnInJourneyTask>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Hide Video Button'),
        content: const Text('The video button will be hidden for this journey.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(HideVideoBtnInJourneyTask());
            },
            child: const Text('Hide'),
          ),
        ],
      );
    },
  );
}

Future<AddCourseVideoTask?> showAddCourseVideoDialog({
  required BuildContext context,
  AddCourseVideoTask? initialTask,
}) async {
  final titleController = TextEditingController(
    text: initialTask?.title ?? '',
  );
  final videoUrlController = TextEditingController(
    text: initialTask?.videoUrl ?? '',
  );

  return showDialog<AddCourseVideoTask>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Course Video'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter video title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: videoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Video URL',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              final videoUrl = videoUrlController.text.trim();
              if (title.isEmpty || videoUrl.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                  ),
                );
                return;
              }
              Navigator.of(context).pop(
                AddCourseVideoTask(videoUrl: videoUrl, title: title),
              );
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}
