import 'package:flutter/material.dart';

class ProjectTile extends StatefulWidget {
  const ProjectTile({super.key});

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  Color color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {},
    );
  }
}
