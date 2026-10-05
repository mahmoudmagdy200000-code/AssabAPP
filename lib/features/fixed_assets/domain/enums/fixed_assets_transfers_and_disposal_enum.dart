import '../strategies/fixed_assets_transfers_and_disposal_strategy.dart';

enum FixedAssetsTransfersAndDisposalEnum {
  transferToBranch('transfer_to_branch'),
  disposal('disposal'),
  externalTransfer('external_transfer');

  final String _value;

  const FixedAssetsTransfersAndDisposalEnum(this._value);

  String get value => _value;

  static FixedAssetsTransfersAndDisposalEnum fromString(String value) {
    return FixedAssetsTransfersAndDisposalEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid FixedAssetsTransfersAndDisposalEnum value: $value',
      ),
    );
  }

  FixedAssetsTransfersAndDisposalStrategy get strategy {
    switch (this) {
      case FixedAssetsTransfersAndDisposalEnum.transferToBranch:
        return TransferToBranchFixedAssetsTransfersAndDisposalStrategy();
      case FixedAssetsTransfersAndDisposalEnum.disposal:
        return DisposalFixedAssetsTransfersAndDisposalStrategy();
      case FixedAssetsTransfersAndDisposalEnum.externalTransfer:
        return ExternalTransferFixedAssetsTransfersAndDisposalStrategy();
    }
  }
}
