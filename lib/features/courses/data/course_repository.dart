import 'package:yha/core/error/app_failure.dart';
import 'course_api_service.dart';
import 'models/course_model.dart';
import 'package:yha/features/course_detail/data/models/course_detail_response.dart';
import 'package:yha/shared/models/address_model.dart';

class CourseRepository {
  CourseRepository(this._api);
  final CourseApiService _api;

  Future<({List<CourseModel> courses, List<AddressModel> address})> getCourses() async {
    try {
      final res = await _api.getCourses();
      return (courses: res.courses, address: res.address ?? <AddressModel>[]);
    } catch (e) {
      throw mapDioError(e);
    }
  }

  Future<CourseDetailResponse> getCourseDetail(int id) async {
    try {
      return await _api.getCourseDetail(id);
    } catch (e) {
      throw mapDioError(e);
    }
  }
}
