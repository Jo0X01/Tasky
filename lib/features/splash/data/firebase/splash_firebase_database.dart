import 'package:tasky/core/constant/app_constants.dart';
import 'package:tasky/core/models/firebase/firebase_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasky/features/splash/data/models/onboarding_model.dart';

abstract class SplashFirebaseDatabase {
  static CollectionReference<OnboardingModel> get getOnboardingCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseAppConstantAssetsFirestore.collectionName)
          .withConverter<OnboardingModel>(
            fromFirestore: (snapshot, options) =>
                OnboardingModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  static ResultResponse<List<OnboardingModel>> getOnboardingData() async {
    try {
      final result = await getOnboardingCollection
          .doc(OnboardingModel.collectionName)
          .get();
      List<OnboardingModel> onboardingList =
          result[OnboardingModel.indicatorCollectionName]
          .map<OnboardingModel>((e) => OnboardingModel.fromJson(e))
          .toList();
      return FBResultSuccess(onboardingList);
    } catch (e) {
      return FBResultError(e.toString());
    }
  }
}
