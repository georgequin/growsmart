import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:stacked/stacked.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../core/data/models/project.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';

class NotificationViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("NotificationViewModel");
  String loadingId = "";
  static const String allCategoriesId = 'all';

  String selectedId = allCategoriesId;
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  String searchQuery = '';
  List<Project> projects = [];
  List<ProjectResource> projectResource = [];
  List<ProjectResource> filteredProjectResource = [];

  Future<void> init() async {
    setBusy(true);
    await loadDonationCategories();
    await loadProjects();
    setBusy(false);
    notifyListeners();
  }


  void setSelectedCategory(String id) {
    selectedId = id;

    if (id == allCategoriesId) {
      filteredProjectResource = projectResource;
    } else {
      print('id is: $id');
      filteredProjectResource = projectResource.where((project) {
        return project.project?.category?.id == id;
      }).toList();
    }

    notifyListeners();
  }


  // void readNotification(notification) async {
  //   loadingId = notification.id;
  //   rebuildUi();
  //   setBusy(true);
  //   await locator<Repository>().updateNotification(notification.id!)
  //       .whenComplete(() async {
  //     await getNotifications();
  //   });
  //   setBusy(false);
  // }


  Future<void> loadDonationCategories() async {
    dynamic storedDonations = await locator<LocalStorage>().fetch(LocalStorageDir.donationsCategories);
    if (storedDonations != null) {
      categories = List<Map<String, dynamic>>.from(storedDonations)
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Add the "All Categories" option
      filteredCategories = [
        Category(id: 'all', name: 'All'),
        ...categories,
      ];
      notifyListeners();

    }
    await getDonationsCategories();
    notifyListeners();
  }



  Future<void> getDonationsCategories() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse res = await repo.getDonationsCategories();
      if (res.statusCode == 200) {

        if (res.data != null && res.data["data"]["items"] != null) {
          // Extract categories from 'items'
          categories = (res.data["data"]["items"] as List)
              .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          // Save the categories locally
          List<Map<String, dynamic>> storedCategories = categories.map((e) => e.toJson()).toList();
          locator<LocalStorage>().save(LocalStorageDir.donationsCategories, storedCategories);

          // Apply any filtering logic here if needed (currently just assigning)
          filteredCategories = categories;
          filteredCategories = [
            Category(id: 'all', name: 'All'),
            ...categories,
          ];
        }
        rebuildUi();
      }
    } catch (e) {
      print(e);
    }finally{
      setBusy(false);
      notifyListeners();
    }

  }

  Future<void> loadProjects() async {
    dynamic storedSellingFast = await locator<LocalStorage>().fetch(LocalStorageDir.projects);
    dynamic storedProjectResource = await locator<LocalStorage>().fetch(LocalStorageDir.projectResource);
    if (storedProjectResource != null) {
      projectResource = List<Map<String, dynamic>>.from(storedProjectResource)
          .map((e) => ProjectResource.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      filteredProjectResource = projectResource;
      notifyListeners();

      await getProjects();
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getProjects() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.getProjects();

      if (res.statusCode == 200) {
        if (res.data != null && res.data["data"]["items"] != null) {
          // Extract projects, members, and recent comments from 'items'
          projectResource = (res.data["data"]["items"] as List)
              .map((e) => ProjectResource.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          filteredProjectResource = projectResource;

          // Separate the project list
          projects = projectResource.map((resource) => resource.project!).toList();


          List<Map<String, dynamic>> storedProjectResources = projectResource.map((resource) => resource.toJson()).toList();
          locator<LocalStorage>().save(LocalStorageDir.projectResource, storedProjectResources);
          notifyListeners();
        }
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }finally{
      setBusy(false);
    }
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    if (searchQuery.isEmpty) {
      filteredProjectResource = projectResource;
    } else {
      filteredProjectResource = projectResource.where((service) {
        return service.project!.projectTitle!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            service.project!.projectDescription!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }


}
