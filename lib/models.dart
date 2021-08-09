//イベント
class Event {
  int id;
  String title;
  String createdAt;

  Event(this.id, this.title, this.createdAt);
}

//支払い
class Payment {
  int id;
  int payerId;
  int eventId;
  String title;
  int price;
  String memo;

  Payment(
      this.id,
      this.payerId,
      this.eventId,
      this.title,
      this.price,
      this.memo
    );
}