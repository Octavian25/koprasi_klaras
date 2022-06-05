class BalanceModel {
  String id;
  int balance;

  BalanceModel({required this.id, required this.balance});

  factory BalanceModel.fromJson(Map<String, dynamic> data) =>
      BalanceModel(id: data['id'], balance: data['balance']);

  Map<String, dynamic> toJson() => {"id": id, "balance": balance};
}
