import 'package:example/editor/step.dart' as step;
import 'package:flutter/material.dart';

class StepListWidget extends StatefulWidget {
  const StepListWidget({super.key});

  @override
  State<StepListWidget> createState() => _StepListWidgetState();
}

class _StepListWidgetState extends State<StepListWidget> {
  late List<step.Step> steps;

  @override
  void initState() {
    steps = List.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Step cards
          ...steps.map((step) => Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(12.0),
                width: 180, // Fixed width for each step card
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Step ID: ${step.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Step Type: ${step.stepType.toString().split('.').last}'),
                    Text(
                        'Action Type: ${step.actionType.toString().split('.').last}'),
                  ],
                ),
              )),

          // Add button at the end of the list
          ElevatedButton(
            onPressed: () {},
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(12.0),
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 32, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
