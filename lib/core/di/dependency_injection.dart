import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/brand_owner_tools/data/repositories/brand_owner_fixed_assets_requests_repository_impl.dart';
import '../../features/brand_owner_tools/domain/repositories/brand_owner_fixed_assets_requests_repository.dart';
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_disposal_and_external_transfer_requests_use_case.dart';
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_handover_reports_requests_use_case.dart';
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_modification_requests_use_case.dart';
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_review_audit_requests_use_case.dart';
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_transfer_requests_use_case.dart';
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_fixed_assets_requests/brand_owner_fixed_assets_requests_cubit.dart';

import 'dependency_injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => await getIt.init();
