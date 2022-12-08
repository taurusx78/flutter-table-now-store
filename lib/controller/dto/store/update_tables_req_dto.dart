class UpdateTablesReqDto {
  final int type; // 감소 (0), 증가 (1), 초기화 (2)
  final bool paused; // 임시중지 여부

  UpdateTablesReqDto({
    required this.type,
    required this.paused,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'paused': paused,
      };
}
