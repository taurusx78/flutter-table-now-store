class UpdateTodayReqDto {
  final bool holiday;
  final String businessHours;
  final String breakTime;
  final String lastOrder;

  UpdateTodayReqDto({
    required this.holiday,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
  });

  Map<String, dynamic> toJson() => {
        'holiday': holiday,
        'businessHours': businessHours,
        'breakTime': breakTime,
        'lastOrder': lastOrder,
      };
}
