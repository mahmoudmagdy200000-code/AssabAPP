import '../../../../core/enums/receive_goods_quality_enum.dart';
import '../../../../core/models/media_file_model.dart';

class ReceiveGoodsLocalItemModel {
  final String itemId;
  final String productName;
  final String? itemLogo;
  final int qtyOrdered;
  final int qtyReceived;
  final double unitPrice;
  final ReceiveGoodsQualityEnum quality;
  final int termperature;
  final String unit;
  final bool isVariance;
  final String expirationDate;
  final MediaFile? selectedImage;
  final String? note;

  ReceiveGoodsLocalItemModel({
    required this.itemId,
    required this.productName,
    required this.itemLogo,
    required this.qtyOrdered,
    required this.qtyReceived,
    required this.unitPrice,
    required this.quality,
    required this.termperature,
    required this.unit,
    required this.isVariance,
    required this.expirationDate,
    this.selectedImage,
    this.note,
  });
}
