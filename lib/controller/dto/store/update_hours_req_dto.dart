class UpdateHoursReqDto {
  final List<String> openTimeList;
  final List<String> closeTimeList;
  final List<bool> hasBreakTimeList;
  final List<String> startBreakTimeList;
  final List<String> endBreakTimeList;
  final List<bool> hasLastOrderList;
  final List<String> lastOrderList;

  UpdateHoursReqDto({
    required this.openTimeList,
    required this.closeTimeList,
    required this.hasBreakTimeList,
    required this.startBreakTimeList,
    required this.endBreakTimeList,
    required this.hasLastOrderList,
    required this.lastOrderList,
  });

  Map<String, dynamic> toJson() => {
        'openTimeList': openTimeList,
        'closeTimeList': closeTimeList,
        'hasBreakTimeList': hasBreakTimeList,
        'startBreakTimeList': startBreakTimeList,
        'endBreakTimeList': endBreakTimeList,
        'hasLastOrderList': hasLastOrderList,
        'lastOrderList': lastOrderList,
      };
}
