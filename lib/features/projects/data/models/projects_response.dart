import 'project_model.dart';

class ProjectsResponse {
  ProjectsResponse({required this.projects});
  final List<ProjectModel> projects;

  factory ProjectsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['projects'];
    return ProjectsResponse(
      projects: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(ProjectModel.fromJson)
              .toList()
          : <ProjectModel>[],
    );
  }
}
