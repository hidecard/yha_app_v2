import 'package:yha/core/network/api_client.dart';
import 'package:yha/core/network/api_endpoints.dart';
import 'models/courses_response.dart';
import 'package:yha/features/course_detail/data/models/course_detail_response.dart';

class CourseApiService {
  CourseApiService(this._client);
  final ApiClient _client;

  Future<CoursesResponse> getCourses() async {
    final res = await _client.get(ApiEndpoints.courses);
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CoursesResponse.fromJson(data);
    }
    return CoursesResponse(courses: []);
  }

  Future<CourseDetailResponse> getCourseDetail(int id) async {
    final res = await _client.get(ApiEndpoints.courseDetail(id));
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CourseDetailResponse.fromJson(data);
    }
    return CourseDetailResponse();
  }
}
