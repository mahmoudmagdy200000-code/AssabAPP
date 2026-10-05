import 'package:assab/core/enums/custody_transactions_types_enum.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:equatable/equatable.dart';

class SelectFilterCustodyTransactionsState extends Equatable {
  final CustodyTransactionsTypesEnum type;
  final TimeKeys time;

  const SelectFilterCustodyTransactionsState({
    this.type = CustodyTransactionsTypesEnum.non,
    this.time = TimeKeys.non,
  });

  SelectFilterCustodyTransactionsState copyWith({
    CustodyTransactionsTypesEnum? type,
    TimeKeys? time,
  }) {
    return SelectFilterCustodyTransactionsState(
      type: type ?? this.type,
      time: time ?? this.time,
    );
  }

  @override
  List<Object> get props => [type, time];
}
