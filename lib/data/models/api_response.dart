class ApiResponse<Type> {
  Type data;
  bool isError;
  String errorMessage;

  ApiResponse({this.data, this.errorMessage, this.isError});
}