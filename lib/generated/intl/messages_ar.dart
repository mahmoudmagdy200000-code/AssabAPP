// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(number) => "إضافة أصل #${number}";

  static String m1(count) => "${count} أصول";

  static String m2(count) => "${count}";

  static String m3(branchName) => "مصروفات سريعة لفرع ${branchName}";

  static String m4(count) => "${count} سجل";

  static String m5(count) => "${count} طلب";

  static String m6(count) => "${count} =";

  static String m7(count) => "لديك حاليا ${count} مناطق مضافة";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addAssetNumber": m0,
    "addNewZone": MessageLookupByLibrary.simpleMessage("إضافة منطقة جديدة"),
    "addZonesAndCountAssetsAsNewBranch": MessageLookupByLibrary.simpleMessage(
      "أضف المناطق وقم بعد الأصول كفرع جديد",
    ),
    "age": MessageLookupByLibrary.simpleMessage("العمر"),
    "allocationIncomplete": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون المبلغ المتبقي 0.00 ر.س",
    ),
    "approvalRequestOwner": MessageLookupByLibrary.simpleMessage(
      "طلب الموافقة: المالك",
    ),
    "assetDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الأصل"),
    "assetsCount": m1,
    "bankTransferLabel": MessageLookupByLibrary.simpleMessage("تحويل بنكي"),
    "bankTransfers": MessageLookupByLibrary.simpleMessage("تحويلات بنكية"),
    "branchA": MessageLookupByLibrary.simpleMessage("الفرع أ"),
    "branchB": MessageLookupByLibrary.simpleMessage("الفرع ب"),
    "branchComparisonReportsTitle": MessageLookupByLibrary.simpleMessage(
      "تقارير مقارنة الفروع.",
    ),
    "branchFullName": MessageLookupByLibrary.simpleMessage(
      "الفرع الاسم الكامل",
    ),
    "branchName": MessageLookupByLibrary.simpleMessage("اسم الفرع"),
    "cashHandoverLabel": MessageLookupByLibrary.simpleMessage("تسليم نقدي"),
    "cashHandovers": MessageLookupByLibrary.simpleMessage("تسليمات نقدية"),
    "cashTransferAndOwnerPaymentLog": MessageLookupByLibrary.simpleMessage(
      "سجل تحويل النقد ومدفوعات المالك.",
    ),
    "cashTransferCount": m2,
    "cashVsBankTransfers": MessageLookupByLibrary.simpleMessage(
      "نقدا مقابل التحويلات البنكية",
    ),
    "clickOnAddButtonToGetStarted": MessageLookupByLibrary.simpleMessage(
      "انقر على زر \"إضافة\" للبدء",
    ),
    "completeAndSend": MessageLookupByLibrary.simpleMessage("إكمال وإرسال"),
    "countAssets": MessageLookupByLibrary.simpleMessage("عد الأصول"),
    "countProgress": MessageLookupByLibrary.simpleMessage("تقدم العد:"),
    "custody": MessageLookupByLibrary.simpleMessage("العهدة"),
    "customFilter": MessageLookupByLibrary.simpleMessage("مخصص"),
    "dailyFilter": MessageLookupByLibrary.simpleMessage("يومي"),
    "details": MessageLookupByLibrary.simpleMessage("التفاصيل"),
    "dining": MessageLookupByLibrary.simpleMessage("الطعام"),
    "documentationPhotos": MessageLookupByLibrary.simpleMessage("صور التوثيق"),
    "doneActions": MessageLookupByLibrary.simpleMessage("تم:"),
    "eGMinorIssues": MessageLookupByLibrary.simpleMessage(
      "مشاكل طفيفة، يتطلب التفتيش.",
    ),
    "eGStrangeNoises": MessageLookupByLibrary.simpleMessage(
      "أصوات غريبة، انخفاض الأداء",
    ),
    "excellent": MessageLookupByLibrary.simpleMessage("ممتاز"),
    "expenseLogDateTime": MessageLookupByLibrary.simpleMessage(
      "11 يونيو - 1:24 ص",
    ),
    "expenseRequestRatioTitle": MessageLookupByLibrary.simpleMessage(
      "نسبة طلبات المصروفات",
    ),
    "exportLabel": MessageLookupByLibrary.simpleMessage("تصدير"),
    "fixedAssetsReceiveAssetsAssetType": MessageLookupByLibrary.simpleMessage(
      "نوع الأصل",
    ),
    "fixedAssetsReceiveAssetsAssignedZone":
        MessageLookupByLibrary.simpleMessage("المنطقة المخصصة"),
    "fixedAssetsReceiveAssetsEmptyDesc": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على أصول مستلمة. حاول تحديث الفلاتر أو أعد المحاولة لاحقًا.",
    ),
    "fixedAssetsReceiveAssetsEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد أصول مستلمة",
    ),
    "fixedAssetsReceiveAssetsNewId": MessageLookupByLibrary.simpleMessage(
      "المعرف الجديد",
    ),
    "fixedAssetsReceiveAssetsSubtitle": MessageLookupByLibrary.simpleMessage(
      "راجع الأصول الثابتة المستلمة وتفاصيل حالتها.",
    ),
    "fixedAssetsReceiveAssetsTitle": MessageLookupByLibrary.simpleMessage(
      "استلام الأصول",
    ),
    "fromBranchName": MessageLookupByLibrary.simpleMessage("من اسم الفرع"),
    "fromFiles": MessageLookupByLibrary.simpleMessage("من الملفات"),
    "halt": MessageLookupByLibrary.simpleMessage("إيقاف"),
    "initialAudit": MessageLookupByLibrary.simpleMessage("التدقيق المبدئي"),
    "juneExpenseReportTitle": MessageLookupByLibrary.simpleMessage(
      "تقرير مصروفات يونيو",
    ),
    "juneRangeLabel": MessageLookupByLibrary.simpleMessage("1 - 30 يونيو 2025"),
    "kitchen": MessageLookupByLibrary.simpleMessage("المطبخ"),
    "location": MessageLookupByLibrary.simpleMessage("الموقع"),
    "lowerThanLastMonthLabel": MessageLookupByLibrary.simpleMessage(
      "أقل من الشهر الماضي.",
    ),
    "lowerThanLastMonthPercent": MessageLookupByLibrary.simpleMessage("-8%"),
    "maintenance": MessageLookupByLibrary.simpleMessage("صيانة"),
    "modificationDetails": MessageLookupByLibrary.simpleMessage(
      "تفاصيل التعديل",
    ),
    "modificationSubmitted": MessageLookupByLibrary.simpleMessage(
      "تم تقديم التعديل",
    ),
    "monthlyFilter": MessageLookupByLibrary.simpleMessage("شهري"),
    "needTechnician": MessageLookupByLibrary.simpleMessage("بحاجة لفني"),
    "needsAttention": MessageLookupByLibrary.simpleMessage("يحتاج انتباه"),
    "newPhoto": MessageLookupByLibrary.simpleMessage("صورة جديدة"),
    "newStatus": MessageLookupByLibrary.simpleMessage("الحالة الجديدة"),
    "nextActions": MessageLookupByLibrary.simpleMessage("التالي:"),
    "nonTaxRequests": MessageLookupByLibrary.simpleMessage("طلبات غير ضريبية"),
    "paymentMethodTitle": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
    "pendingReview": MessageLookupByLibrary.simpleMessage("قيد المراجعة"),
    "physicalCountedCash": MessageLookupByLibrary.simpleMessage(
      "النقد الفعلي المحسوب",
    ),
    "physicalCountedCashHint": MessageLookupByLibrary.simpleMessage(
      "أدخل النقد الفعلي في الدرج",
    ),
    "physicalCountedCashRequired": MessageLookupByLibrary.simpleMessage(
      "النقد الفعلي المحسوب مطلوب",
    ),
    "problem": MessageLookupByLibrary.simpleMessage("مشكلة"),
    "quickExpenseForBranch": m3,
    "quickExpensesReportTitle": MessageLookupByLibrary.simpleMessage(
      "تقرير المصروفات السريعة",
    ),
    "quickFilter": MessageLookupByLibrary.simpleMessage("سريع"),
    "reasonForChange": MessageLookupByLibrary.simpleMessage("سبب التغيير"),
    "recorded": MessageLookupByLibrary.simpleMessage("تم التسجيل"),
    "recordsCount": m4,
    "remainingToAllocate": MessageLookupByLibrary.simpleMessage(
      "المتبقي للتوزيع:",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("استبدال"),
    "requestsCount": m5,
    "requiredActions": MessageLookupByLibrary.simpleMessage(
      "الإجراءات المطلوبة",
    ),
    "saveAndAdd": MessageLookupByLibrary.simpleMessage("حفظ وإضافة"),
    "send": MessageLookupByLibrary.simpleMessage("إرسال"),
    "shortageAllocationDesc": MessageLookupByLibrary.simpleMessage(
      "يجب توزيع مبلغ العجز على الأطراف المسؤولة قبل إغلاق الوردية.",
    ),
    "shortageAllocationTitle": MessageLookupByLibrary.simpleMessage(
      "توزيع العجز مطلوب",
    ),
    "shortageToAllocate": MessageLookupByLibrary.simpleMessage(
      "العجز المطلوب توزيعه:",
    ),
    "standardFilter": MessageLookupByLibrary.simpleMessage("قياسي"),
    "store": MessageLookupByLibrary.simpleMessage("المخزن"),
    "storeBranchName": MessageLookupByLibrary.simpleMessage("اسم فرع المتجر"),
    "supplierName1": MessageLookupByLibrary.simpleMessage("اسم المورد (1)"),
    "supplierName2": MessageLookupByLibrary.simpleMessage("اسم المورد (2)"),
    "supplierName3": MessageLookupByLibrary.simpleMessage("اسم المورد (3)"),
    "supplierName4": MessageLookupByLibrary.simpleMessage("اسم المورد (4)"),
    "supplierName5": MessageLookupByLibrary.simpleMessage("اسم المورد (5)"),
    "taxRequests": MessageLookupByLibrary.simpleMessage("طلبات ضريبية"),
    "taxVsNonTaxInvoiceRatio": MessageLookupByLibrary.simpleMessage(
      "نسبة الفواتير الضريبية مقابل غير الضريبية",
    ),
    "timelines": MessageLookupByLibrary.simpleMessage("الجداول الزمنية"),
    "timelinesContentHere": MessageLookupByLibrary.simpleMessage(
      "محتوى الجداول الزمنية هنا",
    ),
    "topSuppliersTitle": MessageLookupByLibrary.simpleMessage("أفضل 5 موردين"),
    "totalCashIn": MessageLookupByLibrary.simpleMessage("إجمالي النقد الداخل"),
    "totalCashOut": MessageLookupByLibrary.simpleMessage("إجمالي النقد الخارج"),
    "totalNumberOfAsset": MessageLookupByLibrary.simpleMessage(
      "إجمالي عدد الأصول",
    ),
    "totalQuickExpenseCount": m6,
    "totalQuickExpenseRequests": MessageLookupByLibrary.simpleMessage(
      "إجمالي طلبات المصروفات السريعة",
    ),
    "trackEverySpendInOnePlace": MessageLookupByLibrary.simpleMessage(
      "تتبع كل المصروفات في مكان واحد",
    ),
    "valueText": MessageLookupByLibrary.simpleMessage("القيمة"),
    "viewDetailsTimelinesAndStatuses": MessageLookupByLibrary.simpleMessage(
      "عرض التفاصيل والجداول الزمنية والحالات.",
    ),
    "weeklyFilter": MessageLookupByLibrary.simpleMessage("أسبوعي"),
    "yearlyFilter": MessageLookupByLibrary.simpleMessage("سنوي"),
    "youCurrentlyHaveNZonesAdded": m7,
    "yourAssetStatusUpdateHasBeenSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال تحديث حالة الأصل الخاص بك إلى الإدارة للموافقة عليه.",
    ),
    "zoneSetup": MessageLookupByLibrary.simpleMessage("إعداد المناطق"),
  };
}
