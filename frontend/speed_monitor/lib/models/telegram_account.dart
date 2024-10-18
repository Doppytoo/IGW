class TelegramAccount {
  final int id;
  final String fullName;

  TelegramAccount({required this.id, required this.fullName});

  TelegramAccount.fromJson(Map<String, dynamic> json)
      : this(
          id: json['account_id'],
          fullName: json['full_name'],
        );
}
