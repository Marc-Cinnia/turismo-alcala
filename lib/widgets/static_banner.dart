import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/static_banner_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/utils/website_launcher.dart';

class StaticBanner extends StatelessWidget {
  const StaticBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final banner = context.watch<StaticBannerModel>().bannerToShow;

    final spacer = const SizedBox(height: AppConstants.spacing);
    final divider = const Divider();

    return Padding(
      padding: const EdgeInsets.all(AppConstants.shortSpacing),
      child: Column(
        children: [
          divider,
          spacer,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (banner != null && banner.imageUrl.isNotEmpty) {
                  return GestureDetector(
                      onTap: () =>
                          WebsiteLauncher.launchWebsite(banner.navigationUrl),
                      child: SuperNetworkImage(
                        url: banner.imageUrl,
                        width: constraints.maxWidth,
                        height: AppConstants.bannerHeight,
                        fit: BoxFit.fitWidth,
                        placeholderBuilder: () => Center(
                          child: LoaderBuilder.getLoader(),
                        ),
                        cache: false,
                      ));
                }

                if (banner == null) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.all(AppConstants.shortSpacing),
                  child: Center(child: LoaderBuilder.getLoader()),
                );
              },
            ),
          ),
          spacer,
          divider,
        ],
      ),
    );
  }
}
