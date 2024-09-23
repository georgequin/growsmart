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
  List<Project> filteredProjects = [];
  List<ProjectResource> filteredProjectResource = [];

  Future<void> init() async {
    await loadDonationCategories();
    await loadProjects();
    notifyListeners();
  }


  void setSelectedCategory(String id) {
    selectedId = id;

    if (id == allCategoriesId) {
      filteredProjects = projects;
    } else {

      filteredProjects = projects.where((project) {
        return project.category?.id == id;
      }).toList();
    }
    notifyListeners();
  }


  void readNotification(notification) async {
    loadingId = notification.id;
    rebuildUi();
    setBusy(true);
    await locator<Repository>().updateNotification(notification.id!)
        .whenComplete(() async {
      await getNotifications();
    });
    setBusy(false);
  }

  Future<void> loadDonationCategories() async {
    dynamic storedDonations = await locator<LocalStorage>().fetch(LocalStorageDir.donationsCategories);

    if (storedDonations != null) {
      categories = List<Map<String, dynamic>>.from(storedDonations)
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
       getDonationsCategories();  // Fetch categories from API if not available locally
      notifyListeners();
    }

    // Add the "All Categories" option at the beginning
    filteredCategories = [
      Category(id: 'all', name: 'All'),
      ...categories,
    ];

    notifyListeners();
  }


  void getDonationsCategories() async {
    setBusyForObject(categories, true);
    try {
      ApiResponse res = await repo.getDonationsCategories();
      if (res.statusCode == 200) {
        print('res.data: ${res.data}');
        print('res.data: ${res.data["data"]}');
        print('res.data: ${res.data["data"]["items"]}');

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
        } else {
          // Handle empty or null 'items' response
          categories = [];
        }
        rebuildUi();
      }
    } catch (e) {
      print(e);
    }
    setBusyForObject(categories, false);
  }

  Future<void> loadProjects() async {
    dynamic storedSellingFast = await locator<LocalStorage>().fetch(LocalStorageDir.projects);
    dynamic storedProjectResource = await locator<LocalStorage>().fetch(LocalStorageDir.projectResource);
    if (storedProjectResource != null) {
      projectResource = List<Map<String, dynamic>>.from(storedSellingFast)
          .map((e) => ProjectResource.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      filteredProjectResource = projectResource;

    } else {
      getProjects();
    }
    notifyListeners();
  }

  void getProjects() async {
    setBusyForObject(projects, true);

    try {
      ApiResponse res = await repo.getProjects();

      if (res.statusCode == 200) {
        if (res.data != null && res.data["data"]["items"] != null) {
          // Extract projects, members, and recent comments from 'items'
          var projectResources = (res.data["data"]["items"] as List)
              .map((e) => ProjectResource.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          print('projrct response is: $projectResources');
          projectResource = projectResources;

          // Separate the project list
          projects = projectResources.map((resource) => resource.project!).toList();
          var members = projectResources.map((resource) => resource.members!).toList();
          var comments = projectResources.map((resource) => resource.recentComments!).toList();
          print('projrct comments is: $comments');
          List<Map<String, dynamic>> storedProjects = projects.map((e) => e.toJson()).toList();
          List<Map<String, dynamic>> storedProjectResources = projectResources.map((resource) => resource.toJson()).toList();

          locator<LocalStorage>().save(LocalStorageDir.projects, storedProjects);
          locator<LocalStorage>().save(LocalStorageDir.projectResource, storedProjectResources);

          filteredProjects = projects;
          filteredProjectResource = projectResource;
        } else {
          projects = [];
        }
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }
    setBusyForObject(projects, false);
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

  Future<void> getNotifications() async {
    try {
      ApiResponse res = await repo.getNotifications(profile.value.id!);
      if (res.statusCode == 200) {
        notifications.value = (res.data["events"] as List)
            .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      log.e(e);
    }
  }
}
