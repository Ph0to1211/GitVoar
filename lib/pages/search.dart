import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/widgets/repo_item.dart';
import '../common/widgets/user_item.dart';
import '../http/git.dart';

class SearchController extends GetxController {
  ScrollController scrollCont = ScrollController();
  TextEditingController keywordCont = TextEditingController();

  var historyItems = <String>[''].obs;
  var resultItems = <dynamic>[null].obs;

  var keyword = ''.obs;
  var isSearchRepo = true.obs;
  var showToTopBtn = false.obs;
  var showResult = false.obs;
  var hasMore = true.obs;
  var isLoading = false.obs;
  var page = 1.obs;

  void submitSearch() {
    if (keyword.value.isNotEmpty) {
      String item = (isSearchRepo.value) ? '仓库: ${keyword.value}' : '用户: ${keyword.value}';

      if (historyItems.contains(item)) {
        historyItems.remove(item);
      }
      if (historyItems.length >= 20) {
        historyItems.removeAt(historyItems.length - 1);
      } else {
        historyItems.insert(0, item);
      }

      FocusScope.of(Get.context!).unfocus();
      showResult.value = true;
      resultItems.value = [null];
      hasMore.value = true;
      page.value = 1;
      getData();
    }
  }

  void getData() async {
    if (isLoading.value) return;
    isLoading.value = true;
    List<dynamic> items;

    if (isSearchRepo.value) {
      items = await Git(Get.context!).searchRepo(
        keyword: keyword.value,
        queryParameters: {
          'page': page.value,
          'per_page': 10,
        },
      );
    } else {
      items = await Git(Get.context!).searchUser(
        keyword: keyword.value,
        queryParameters: {
          'page': page.value,
          'per_page': 10,
        },
      );
    }

    hasMore.value = items.isNotEmpty && items.length % 10 == 0;
    resultItems.insertAll(resultItems.length - 1, items);
    page.value++;
    isLoading.value = false;
    showResult.value = true;
  }

  void setSearchType(bool isRepo) {
    isSearchRepo.value = isRepo;
  }
}

class SearchPage extends StatelessWidget {
  final SearchController controller = Get.put(SearchController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Obx(() => TextField(
          controller: controller.keywordCont,
          onChanged: (text) {
            controller.keyword.value = text;
            if (text.isEmpty) {
              controller.showResult.value = false;
              controller.isSearchRepo.value = true;
            }
          },
          onSubmitted: (value) => controller.submitSearch(),
          textInputAction: TextInputAction.search,
          autofocus: !controller.showResult.value,
          decoration: InputDecoration(
            hintText: '搜索...',
            border: const UnderlineInputBorder(),
            suffixIcon: (controller.keyword.value != '')
                ? IconButton(
              onPressed: () {
                controller.keywordCont.clear();
                controller.keyword.value = '';
                controller.resultItems.clear();
                controller.hasMore.value = true;
                controller.page.value = 1;
                controller.isSearchRepo.value = true;
                controller.showResult.value = false;
              },
              icon: const Icon(Icons.clear_rounded, size: 22.0),
            )
                : null,
          ),
        )),
        actions: [
          IconButton(
            onPressed: controller.submitSearch,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Obx(() {
      if (controller.showResult.value) {
        return buildSearchResult();
      } else {
        if (controller.keyword.isNotEmpty) {
          return buildOptions();
        } else {
          return buildHistory();
        }
      }
    });
  }

  Widget buildOptions() {
    return ListView(
      children: [
        ListTile(
          leading: Text('搜索仓库：${controller.keyword.value}', style: const TextStyle(fontSize: 15.0)),
          trailing: const Icon(Icons.arrow_forward_rounded, size: 22.0, color: Colors.grey),
          onTap: () {
            controller.setSearchType(true);
            controller.submitSearch();
          },
        ),
        ListTile(
          leading: Text('搜索用户：${controller.keyword.value}', style: const TextStyle(fontSize: 15.0)),
          trailing: const Icon(Icons.arrow_forward_rounded, size: 22.0, color: Colors.grey),
          onTap: () {
            controller.setSearchType(false);
            controller.submitSearch();
          },
        ),
      ],
    );
  }

  Widget buildHistory() {
    return Obx(() {
      if (controller.historyItems.length > 1) {
        return ListView.builder(
          itemCount: controller.historyItems.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                leading: const Text('搜索历史：', style: TextStyle(fontSize: 15.0)),
                trailing: IconButton(
                  onPressed: () {
                    controller.historyItems.clear();
                  },
                  icon: const Icon(Icons.cleaning_services_rounded, size: 22.0, color: Colors.grey),
                ),
              );
            } else {
              String historyItem = controller.historyItems[index - 1];
              bool isRepoSearch = historyItem.startsWith('仓库:');
              return ListTile(
                leading: Text(historyItem, style: const TextStyle(fontSize: 16.0)),
                trailing: const Icon(Icons.arrow_forward_rounded, size: 22.0, color: Colors.grey),
                onTap: () {
                  controller.keywordCont.text = historyItem.substring(4);
                  controller.keyword.value = controller.keywordCont.text;
                  controller.setSearchType(isRepoSearch);
                  controller.submitSearch();
                },
              );
            }
          },
        );
      } else {
        return const Center(child: Text('它需要做点什么...', style: TextStyle(fontSize: 18.0)));
      }
    });
  }

  Widget buildSearchResult() {
    return Obx(() {
      if (controller.resultItems.isEmpty) {
        return const Center(child: Text('你似乎来到了荒芜之地...', style: TextStyle(fontSize: 18.0)));
      }
      return ListView.separated(
        itemCount: controller.resultItems.length,
        itemBuilder: (context, index) {
          if (controller.resultItems[index] == null) {
            if (controller.hasMore.value) {
              controller.getData();
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2.0),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
                child: const Text("没有更多了", style: TextStyle(color: Colors.grey)),
              );
            }
          }
          return controller.isSearchRepo.value
              ? RepoItem(controller.resultItems[index])
              : UserItem(controller.resultItems[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(color: Colors.grey, height: .0, thickness: .0);
        },
      );
    });
  }
}
