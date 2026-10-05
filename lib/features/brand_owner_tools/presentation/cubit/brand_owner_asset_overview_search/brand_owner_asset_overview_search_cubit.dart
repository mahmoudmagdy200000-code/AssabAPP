import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_asset_overview_model.dart';
import 'brand_owner_asset_overview_search_state.dart';

@injectable
class BrandOwnerAssetOverviewSearchCubit
    extends SafeCubit<BrandOwnerAssetOverviewSearchState> {
  List<BrandOwnerAssetOverviewBranchModel> _allBranches = [];
  List<BrandOwnerAssetOverviewAssetModel> _allAssets = [];

  BrandOwnerAssetOverviewSearchCubit()
    : super(const BrandOwnerAssetOverviewSearchInitial());

  void setData({
    required List<BrandOwnerAssetOverviewBranchModel> branches,
    required List<BrandOwnerAssetOverviewAssetModel> assets,
  }) {
    _allBranches = branches;
    _allAssets = assets;
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(
        BrandOwnerAssetOverviewSearchResult(
          branches: _allBranches,
          assets: _allAssets,
          query: query,
        ),
      );
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filteredBranches =
        _allBranches.where((b) {
          return b.branchName.toLowerCase().contains(lowerQuery) ||
              b.managerName.toLowerCase().contains(lowerQuery);
        }).toList();

    final filteredAssets =
        _allAssets.where((a) {
          return a.name.toLowerCase().contains(lowerQuery) ||
              a.code.toLowerCase().contains(lowerQuery);
        }).toList();

    emit(
      BrandOwnerAssetOverviewSearchResult(
        branches: filteredBranches,
        assets: filteredAssets,
        query: query,
      ),
    );
  }
}
