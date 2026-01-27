import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_network_image/super_network_image.dart';

import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/models/cellar_model.dart';
import 'package:valdeiglesias/models/eat_model.dart';
import 'package:valdeiglesias/models/guided_tours_model.dart';
import 'package:valdeiglesias/models/incident_model.dart';
import 'package:valdeiglesias/models/news_model.dart';
import 'package:valdeiglesias/models/practical_information_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/models/section_model.dart';
import 'package:valdeiglesias/models/shop_model.dart';
import 'package:valdeiglesias/models/sleep_model.dart';
import 'package:valdeiglesias/models/valdeiglesias_model.dart';
import 'package:valdeiglesias/models/document_model.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';

class Sections extends StatelessWidget {
  const Sections({
    super.key,
    required this.accessible,
    required this.english,
  });

  /// Whether the sections widget must be rendered in accessible mode or not
  final bool accessible;
  final bool english;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SectionModel>();
    final items = (english) ? model.itemsEn : model.items;

    if (model.items.isNotEmpty && model.itemsEn.isNotEmpty) {
      if (accessible) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: model.items.length,
          itemBuilder: _buildAccessibleList,
        );
      }

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: _gridDelegate(),
        itemCount: model.items.length,
        itemBuilder: _buildItems,
      );
    }

    return Center(child: LoaderBuilder.getLoader());
  }

  SliverGridDelegate _gridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    );
  }

  Widget _buildItems(context, index) {
    return SizedBox(
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Consumer<SectionModel>(
          builder: (context, model, child) {
            final items = (english) ? model.itemsEn : model.items;

            return Builder(
              builder: (context) {
                if (items.isEmpty) {
                  return Center(child: _getLoader());
                }

                return GestureDetector(
                  onTap: () {
                    String routeName = items[index].routeName;

                    if (AppConstants.screens[routeName] != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: RouteSettings(name: routeName),
                          builder: (context) {
                            return MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (context) => ValdeiglesiasModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) =>
                                      PracticalInformationModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => NewsModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => IncidentModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => DocumentModel(),
                                ),
                              ],
                              child: _screenToNavigate(routeName, accessible),
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            AppConstants.cardBorderRadius),
                        child: SuperNetworkImage(
                          url: items[index].backgroundImage.url,
                          fit: BoxFit.fitHeight,
                          placeholderBuilder: () => Center(
                            child: LoaderBuilder.getLoader(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(AppConstants.shortSpacing),
                          child: Text(
                            items[index].label,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color.fromARGB(255, 255, 255, 255), // Color del texto de los apartados
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccessibleList(context, index) {
    return SizedBox(
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Consumer<SectionModel>(
          builder: (context, model, child) {
            return Builder(
              builder: (context) {
                final items = (english) ? model.itemsEn : model.items;

                if (model.items.isEmpty || model.itemsEn.isEmpty) {
                  return Center(child: _getLoader());
                }

                return ListTile(
                  title: Text(
                    items[index].label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppConstants.primary,
                        ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppConstants.primary,
                  ),
                  onTap: () {
                    String routeName = items[index].routeName;

                    if (AppConstants.accessibleScreens[routeName] != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (context) => ValdeiglesiasModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => EatModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => SleepModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => NewsModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => GuidedToursModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) =>
                                      PracticalInformationModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => ScheduleModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => ShopModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => IncidentModel(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => DocumentModel(),
                                ),
                              ],
                              child: _screenToNavigate(routeName, accessible),
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  CircularProgressIndicator _getLoader() {
    return const CircularProgressIndicator(color: AppConstants.primary);
  }

  Widget _screenToNavigate(String routeName, bool accessible) {
    if (accessible) {
      return AppConstants.accessibleScreens[routeName]!;
    }

    return AppConstants.screens[routeName]!;
  }
}
