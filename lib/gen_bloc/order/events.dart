class OrderEvent {}

class StartOrderEvent extends OrderEvent {}

class StartSingleOrderEvent extends OrderEvent {
  int id;

  StartSingleOrderEvent(this.id);
}

class StartChangStatusOrderEvent extends OrderEvent {
  String type; //accept_order - finished_order - reject_order
  int id;
  String get url => "provider/$type/$id";
  StartChangStatusOrderEvent(this.type, this.id);
}
