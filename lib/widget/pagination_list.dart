import 'dart:async';

import 'package:flutter/material.dart';

typedef PaginationBuilder<T> = Future<List<T>> Function(int currentListSize);
typedef GroupedHeaderBuilder<T> = Widget Function(
    BuildContext context, int currentIndex, T? previousItem, T currentItem);

class PaginationList<T> extends StatefulWidget {
  const PaginationList({
    Key? key,
    required this.itemBuilder,
    required this.onError,
    required this.onEmpty,
    required this.pageFetch,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.singlePage = false,
    this.autoFetch = true,
    this.groupedHeaderBuilder,
    this.padding = const EdgeInsets.all(0),
    this.initialData = const [],
    this.physics,
    this.separatorWidget = const SizedBox(height: 0, width: 0),
    this.onPageLoading = const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    ),
    this.onLoading = const SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        backgroundColor: Colors.amber,
      ),
    ),
  }) : super(key: key);

  final bool autoFetch;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final List<T> initialData;
  final PaginationBuilder<T> pageFetch;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget onEmpty;
  final Widget Function(dynamic) onError;
  final Widget separatorWidget;
  final Widget onPageLoading;
  final Widget onLoading;
  final bool singlePage;
  final GroupedHeaderBuilder<T>? groupedHeaderBuilder;
  final ScrollController? scrollController;

  @override
  PaginationListState<T> createState() => PaginationListState<T>();
}

Widget img() {
  return const Image(
    image: AssetImage("assets/loadingRainbow.gif"),
    height: 25,
    width: 25,
  );
}

class PaginationListState<T> extends State<PaginationList<T>>
    with AutomaticKeepAliveClientMixin<PaginationList<T>> {
  final List<T?> _itemList = <T?>[];
  dynamic _error;
  final StreamController<PageState?> _streamController =
      StreamController<PageState?>();
  late final ScrollController? _scrollController = widget.scrollController;
  PageState? latestPageState;

  @override
  void initState() {
    _itemList.addAll(widget.initialData);
    if (widget.initialData.isNotEmpty) _itemList.add(null);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController?.addListener(()  {
// nextPageTrigger will have a value equivalent to 80% of the list size.
        var nextPageTrigger =
            0.8 * (_scrollController?.position.maxScrollExtent ?? 0);

// _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
        if ((_scrollController?.position.pixels ?? 0) > nextPageTrigger) {
          if (_itemList.last != null && latestPageState != PageState.pageEmpty && latestPageState != PageState.firstEmpty) {
            _itemList.add(null);
            latestPageState = PageState.pageLoad;
            _streamController.add(PageState.pageLoad);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<PageState?>(
      stream: _streamController.stream,
      initialData:
          (_itemList.isEmpty) ? PageState.firstLoad : PageState.pageLoaded,
      builder: (BuildContext context, AsyncSnapshot<PageState?> snapshot) {
        if (!snapshot.hasData) {
          return widget.onLoading;
        }
        if (snapshot.data == PageState.firstLoad) {
          fetchPageData();
          return widget.onLoading;
        }
        if (snapshot.data == PageState.firstEmpty) {
          return widget.onEmpty;
        }
        if (snapshot.data == PageState.firstError) {
          return widget.onError(_error);
        }
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if (_itemList[index] == null &&
                snapshot.data == PageState.pageLoad) {
              fetchPageData(offset: index);
              return widget.onPageLoading;
            }
            if (_itemList[index] == null &&
                snapshot.data == PageState.pageError) {
              return widget.onError(_error);
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.groupedHeaderBuilder?.call(
                      context,
                      index,
                      index == 0 ? null : _itemList[index - 1],
                      _itemList[index] as T,
                    ) ??
                    const SizedBox.shrink(),
                widget.itemBuilder(
                  context,
                  _itemList[index] as T,
                ),
              ],
            );
          },
          shrinkWrap: widget.shrinkWrap,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          padding: widget.padding,
          itemCount: _itemList.length,
          separatorBuilder: (BuildContext context, int index) =>
              widget.separatorWidget,
        );
      },
    );
  }

  void fetchPageData({int offset = 0}) {
    widget.pageFetch(offset - widget.initialData.length).then(
      (List<T> list) {
        if (_itemList.contains(null)) {
          _itemList.remove(null);
        }
        // list = list ?? <T>[];
        if (list.isEmpty) {
          if (offset == 0) {
            latestPageState = PageState.firstEmpty;
            _streamController.add(PageState.firstEmpty);
          } else {
            latestPageState = PageState.pageEmpty;
            _streamController.add(PageState.pageEmpty);
          }
          return;
        }

        _itemList.addAll(list);
        latestPageState = PageState.pageLoaded;
        _streamController.add(PageState.pageLoaded);
      },
      onError: (dynamic error) {
        this._error = error;
        if (offset == 0) {
          latestPageState = PageState.firstError;
          _streamController.add(PageState.firstError);
        } else {
          if (!_itemList.contains(null)) {
            _itemList.add(null);
          }
          latestPageState = PageState.pageError;
          _streamController.add(PageState.pageError);
        }
      },
    );
  }

  void reloadData() {
    _itemList.clear();
    latestPageState = null;
    _streamController.add(null);
    setState(() {});
    fetchPageData();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  getSeparator(BuildContext context, int index) {
    if (widget.groupedHeaderBuilder == null) {
      return widget.separatorWidget;
    } else {
      if (index == 0) {
        return widget.groupedHeaderBuilder
                ?.call(context, index, null, _itemList[index] as T) ??
            const SizedBox.shrink();
      } else {
        return widget.groupedHeaderBuilder?.call(
                context, index, _itemList[index - 1], _itemList[index] as T) ??
            const SizedBox.shrink();
      }
    }
  }
}

enum PageState {
  pageLoaded,
  pageError,
  pageEmpty,
  firstEmpty,
  firstLoad,
  firstError,
  pageLoad,
}
