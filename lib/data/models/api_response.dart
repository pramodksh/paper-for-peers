
// todo change to named constructor (.error, .success)
class ApiResponse<Type> {

  bool isError;
  Type? data;
  String? errorMessage;

  ApiResponse._({this.data, this.errorMessage, required this.isError});

  ApiResponse.success({Type? data}) : this._(isError: false, data: data);

  ApiResponse.error({required String errorMessage}) : this._(isError: true, errorMessage: errorMessage);
}