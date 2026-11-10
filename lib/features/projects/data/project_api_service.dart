import 'package:yha/core/network/api_client.dart';
import 'package:yha/core/network/api_endpoints.dart';
import 'models/projects_response.dart';

class ProjectApiService {
  ProjectApiService(this._client);
  final ApiClient _client;

  Future<ProjectsResponse> getProjects() async {
    final res = await _client.get(ApiEndpoints.projects);
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return ProjectsResponse.fromJson(data);
    }
    return ProjectsResponse(projects: []);
  }
}
