
// todo change to named constructor (.error, .success)
class ApiResponse<Type> {
  Type? data;
  bool isError;
  String? errorMessage;

  ApiResponse({this.data, this.errorMessage, required this.isError});
}