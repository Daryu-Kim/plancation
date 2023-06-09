import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:plancation/modules/another.dart';
import 'package:plancation/styles/body_style.dart';

class DiaryItemPage extends StatefulWidget {
  const DiaryItemPage(
      {super.key,
      required this.diaryData,
      required this.authorName,
      required this.authorImagePath,
      required this.calendarUsersCount});

  final Map diaryData;
  final String authorName;
  final String? authorImagePath;
  final int calendarUsersCount;

  @override
  DiaryItemPageState createState() => DiaryItemPageState();
}

class DiaryItemPageState extends State<DiaryItemPage> {
  showManageModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 217 - 24,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)),
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                width: double.infinity,
                height: 48,
                child: const Text(
                  "게시물 관리",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
              InkWell(
                onTap: null,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 72,
                  child: Text(
                    "수정",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              InkWell(
                onTap: null,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 72,
                  child: Text(
                    "삭제",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Logger().e(widget.authorImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: 64,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_rounded,
                        color: CupertinoColors.white, size: 28),
                  ),
                ),
                Text(
                  DateFormat('yyyy/MM/dd (EEE)')
                      .format(widget.diaryData['postTime'].toDate()),
                  style: const TextStyle(
                    fontSize: 18,
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: 64,
                  child: TextButton(
                      onPressed: showManageModal,
                      child: const Text(
                        "관리",
                        style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            height: setBodyHeightNotIncludeBNB(context),
            padding: BodyStyle().bodyPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.calendarUsersCount != 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: widget.authorImagePath != null
                                    ? Image.network(widget.authorImagePath!,
                                        height: 56,
                                        width: 56,
                                        fit: BoxFit.cover)
                                    : CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Text(
                                          widget.authorName.length < 3
                                              ? widget.authorName
                                              : widget.authorName
                                                  .substring(0, 3),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: Text(
                                    widget.authorName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.diaryData['postTitle'],
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : const SizedBox(),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(100),
                  //       color: Theme.of(context).colorScheme.inverseSurface),
                  //   child: Text(
                  //     DateFormat('hh:mm')
                  //         .format(widget.diaryData['postTime'].toDate()),
                  //     style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w700,
                  //         color: Theme.of(context).colorScheme.surface),
                  //   ),
                  // )
                ],
              ),
              const SizedBox(height: 24),
              widget.diaryData['postImagePath'] != null
                  ? Image.network(
                      widget.diaryData['postImagePath'],
                      fit: BoxFit.cover,
                      isAntiAlias: true,
                    )
                  : const SizedBox(),
              const SizedBox(height: 24),
              Text(
                widget.diaryData['postContent'],
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
