import 'package:yha/core/error/app_failure.dart';
import 'models/project_model.dart';
import 'project_api_service.dart';

class ProjectRepository {
  ProjectRepository(this._api);
  final ProjectApiService _api;

  Future<List<ProjectModel>> getProjects() async {
    try {
      final res = await _api.getProjects();
      return res.projects;
    } catch (e) {
      throw mapDioError(e);
    }
  }
}
