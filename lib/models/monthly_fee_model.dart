class MonthlyFeeModel {
  String id;
  String month;
  int nominal;

  MonthlyFeeModel(
      {required this.nominal, required this.id, required this.month});

  factory MonthlyFeeModel.fromJson(Map<String, dynamic> json) =>
      MonthlyFeeModel(
          nominal: json['nominal'], id: json['id'], month: json['month']);

  Map<String, dynamic> toJson() =>
      {"id": id, "month": month, "nominal": nominal};
}
