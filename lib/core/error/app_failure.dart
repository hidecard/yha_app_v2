import 'package:dio/dio.dart';
import '../network/api_exceptions.dart';

class AppFailure {
  AppFailure(this.message);
  final String message;
}

AppFailure mapDioError(Object error) {
  if (error is ApiException) {
    return AppFailure(error.message);
  }
  if (error is DioException) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return AppFailure('အချက်အလက်ရယူ၍ မရသေးပါ။ အင်တာနက် connection ကိုစစ်ပြီး ပြန်လည်ကြိုးစားပါ။');
    }
    if (error.type == DioExceptionType.connectionError) {
      return AppFailure('အင်တာနက် connection ကိုစစ်ပြီး ပြန်လည်ကြိုးစားပါ။');
    }
    final code = error.response?.statusCode;
    if (code == 404) {
      return AppFailure('အချက်အလက်မတွေ့ပါ။');
    }
    if (code != null && code >= 500) {
      return AppFailure('ဆာဗာတွင် ပြဿနာရှိနေပါသည်။ ပြန်လည်ကြိုးစားပါ။');
    }
  }
  return AppFailure('အချက်အလက်ရယူ၍ မရသေးပါ။ အင်တာနက် connection ကိုစစ်ပြီး ပြန်လည်ကြိုးစားပါ။');
}
