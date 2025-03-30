class BlackCard {
  final String text;
  final int pick;

  BlackCard({required this.text, required this.pick});

  factory BlackCard.fromJson(Map<String, dynamic> json) {
    return BlackCard(
      text: json['text'],
      pick: json['pick'],
    );
  }
}
