import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/achievments_model.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/widgets/reward.dart';

class RewardList extends StatelessWidget {
  const RewardList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: AppConstants.shortSpacing);
    final english = context.watch<LanguageModel>().english;
    final detectedBeacons = context.watch<AchievmentsModel>().detectedBeacons;

    final achievmentsLabel = (english)
        ? AppConstants.achievmentsLabelEn
        : AppConstants.achievmentsLabel;

    final noviceExplorerTitle =
        (english) ? AppConstants.noviceExplorerEn : AppConstants.noviceExplorer;

    final noviceExplorerDesc = (english)
        ? AppConstants.noviceExplorerDescEn
        : AppConstants.noviceExplorerDesc;

    final beaconHunterTitle =
        (english) ? AppConstants.beaconHunterEn : AppConstants.beaconHunter;

    final beaconHunterDesc = (english)
        ? AppConstants.beaconHunterDescEn
        : AppConstants.beaconHunterDesc;

    final tirelessTravellerTitle = (english)
        ? AppConstants.tirelessTravellerEn
        : AppConstants.tirelessTraveller;

    final tirelessTravellerDesc = (english)
        ? AppConstants.tirelessTravellerDescEn
        : AppConstants.tirelessTravellerDesc;

    final masterSignalTitle =
        (english) ? AppConstants.masterSignalEn : AppConstants.masterSignal;

    final masterSignalDesc = (english)
        ? AppConstants.masterSignalDescEn
        : AppConstants.masterSignalDesc;

    final expertTrackerTitle =
        (english) ? AppConstants.expertTrackerEn : AppConstants.expertTracker;

    final expertTrackerDesc = (english)
        ? AppConstants.expertTrackerDescEn
        : AppConstants.expertTrackerDesc;

    final localLegendTitle =
        (english) ? AppConstants.localLegendEn : AppConstants.localLegend;

    final localLegendDesc = (english)
        ? AppConstants.localLegendDescEn
        : AppConstants.localLegendDesc;

    final territoryMasterTitle = (english)
        ? AppConstants.territoryMasterEn
        : AppConstants.territoryMaster;

    final territoryMasterDesc = (english)
        ? AppConstants.territoryMasterDescEn
        : AppConstants.territoryMasterDesc;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.shortSpacing,
        right: AppConstants.shortSpacing,
        bottom: AppConstants.contentBottomSpacing,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppConstants.spacing,
              left: AppConstants.spacing,
              right: AppConstants.spacing,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                achievmentsLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.shortSpacing),
          const Divider(),
          const SizedBox(height: AppConstants.shortSpacing),
          Column(
            children: [
              Reward(
                title: noviceExplorerTitle,
                description: noviceExplorerDesc,
                icon: Icons.military_tech_outlined,
                unlocked: detectedBeacons >= 1,
              ),
              spacer,
              Reward(
                title: beaconHunterTitle,
                description: beaconHunterDesc,
                icon: Icons.travel_explore_outlined,
                unlocked: detectedBeacons >= 5,
              ),
              spacer,
              Reward(
                title: tirelessTravellerTitle,
                description: tirelessTravellerDesc,
                icon: Icons.luggage_outlined,
                unlocked: detectedBeacons >= 10,
              ),
              spacer,
              Reward(
                title: masterSignalTitle,
                description: masterSignalDesc,
                icon: Icons.explore_outlined,
                unlocked: detectedBeacons >= 25,
              ),
              spacer,
              Reward(
                title: expertTrackerTitle,
                description: expertTrackerDesc,
                icon: Icons.compass_calibration_outlined,
                unlocked: detectedBeacons >= 50,
              ),
              spacer,
              Reward(
                title: localLegendTitle,
                description: localLegendDesc,
                icon: Icons.tips_and_updates_outlined,
                unlocked: detectedBeacons >= 75,
              ),
              spacer,
              Reward(
                title: territoryMasterTitle,
                description: territoryMasterDesc,
                icon: Icons.verified_outlined,
                unlocked: detectedBeacons == 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
