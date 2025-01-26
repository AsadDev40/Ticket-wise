import 'package:ticket_wise/models/card_model.dart';

class Res {
  static const String lamp = "assets/images/lamp.png";
  static const String chair = "assets/images/chair.png";
  static const String sofa = "assets/images/sofa.png";
  static const String table = "assets/images/table.png";
  static const String table1 = "assets/images/table_1.png";

  static List<PayCard> getPaymentTypes() {
    List<PayCard> cards = [];
    cards.add(PayCard(
        title: "Net Banking",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    cards.add(PayCard(
        title: "Credit Card",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    cards.add(PayCard(
        title: "Debit Card",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    cards.add(PayCard(
        title: "Wallet pay",
        description: "Pay bill using card",
        image: "assets/images/paycard.png"));
    return cards;
  }
}
