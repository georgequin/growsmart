import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/models/project.dart';
import '../../common/app_colors.dart';


class ProjectDetailsPage extends StatelessWidget {
  final ProjectResource project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), // Adjust padding to move title content closer to the bottom
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Members Count
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/partcipant_icon.png",
                          width: 44,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${project.members?.length ?? 0} Members',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    // Explore Button
                    InkWell(
                      onTap: () {
                        _launchProjectReel(project.project?.projectReel ?? '');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kcWhiteColor, // Capsule background color
                          borderRadius: BorderRadius.circular(20), // Rounded capsule shape
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.play_circle,
                              size: 14, // Reduced icon size
                              color: kcSecondaryColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Project Highlight",
                              style: TextStyle(
                                color: kcBlackColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 10, // Reduced font size
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Project Image
                    Image.network(
                      project.project?.media?.first.url ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                    // Gradient Overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black45, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8.0), // Add margin for better positioning
                decoration: BoxDecoration(
                  color: kcWhiteColor, // Black background for the icon
                  shape: BoxShape.circle, // Circular shape for the background
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: kcBlackColor), // White arrow
                  onPressed: () {
                    Navigator.pop(context); // Handle back navigation
                  },
                ),
              ),
              actions: [
                // Container(
                //   margin: const EdgeInsets.only(right: 16.0), // Align the share icon properly
                //   decoration: BoxDecoration(
                //     color: Colors.black.withOpacity(0.5), // Black background for the icon
                //     shape: BoxShape.circle,
                //   ),
                //   child: IconButton(
                //     icon: const Icon(Icons.share, color: Colors.white), // White share icon
                //     onPressed: () {
                //       _shareProject(context); // Handle sharing
                //     },
                //   ),
                // ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.project?.projectTitle ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Project Description
                        Text(
                          project.project?.projectDescription ?? '',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[600]
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 0.0, left: 0.0, top: 10.0),
                                  child: SvgPicture.asset(
                                    "assets/images/benfits.svg",
                                    height: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                                  child: Text(
                                    'Project Goals',
                                    style: TextStyle(
                                      color: kcBlackColor, // Ensure this color contrasts the background
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                              child: InkWell(
                                onTap: () {
                                  // Handle Explore tap
                                  print('Explore tapped');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: kcSecondaryColor.withOpacity(0.2), // Capsule background color
                                    borderRadius: BorderRadius.circular(20), // Rounded capsule shape
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "See more",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: kcBlackColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_circle_right,
                                        size: 16,
                                        color: kcSecondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Project Goals",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle "See more" button
                              },
                              child: Text("See more"),
                            ),
                          ],
                        ),
                        // Project Goals List
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: project.goals
                        //       .map((goal) => Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 4.0),
                        //     child: Row(
                        //       children: [
                        //         Icon(Icons.check_circle, color: Colors.green),
                        //         SizedBox(width: 8),
                        //         Text(goal),
                        //       ],
                        //     ),
                        //   ))
                        //       .toList(),
                        // ),
                        SizedBox(height: 16),
                        // Comments Section Placeholder
                        // Comments Section
                         Text(
                          "Comments [${project.recentComments?.length}]",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildCommentsSection(context),
                        verticalSpaceSmall,
                        // View All Button
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _showFullComments(context); // View all comments in a bottom sheet
                            },
                            child: const Text(
                              "View All Comments",
                              style: TextStyle(color: kcSecondaryColor),
                            ),
                          ),
                        ),
                        // Donation button
                        SizedBox(height: 24),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ), // Comment Input Box at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCommentInputField(context),
          ),],

      ),
    );
  }

  void _shareProject(BuildContext context) {
    final String shareText = "Help us raise funds for ${project.project?.projectReel}. "
        "Join the effort and make an impact by donating to this great cause! Check it out here: https://yourprojectlink.com";

    Share.share(shareText, subject: 'Donate to a Great Cause!');
  }

  Future<void> _launchProjectReel(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCommentsSection(BuildContext context) {
    // Assuming you have a list of recent comments from the project
    List<Comment> recentComments = project.recentComments ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.3, // 30% of the screen height
      child: ListView.builder(
        itemCount: recentComments.length,
        itemBuilder: (context, index) {
          final comment = recentComments[index];
          final String initials = '${comment.user?.firstname?[0] ?? ''}${comment.user?.lastname?[0] ?? ''}';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The ListTile for the user's initials, name, and comment text
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[400],
                  child: Text(
                    initials.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    // User's name
                    Text(
                      '${comment.user?.firstname} ${comment.user?.lastname}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black, // Ensure dark color for name
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Timestamp
                    Text(
                      '1 hr ago',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    comment.comment ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == 'Reply') {
                      // Handle reply logic
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Reply'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ),
              // Custom layout for comment container with rounded background

              Stack(
                children: [
                  // Container(
                  //   margin: const EdgeInsets.only(left: 56, right: 16), // Indent to align with avatar
                  //   padding: const EdgeInsets.all(12.0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[100], // Background color for the comment box
                  //     borderRadius: BorderRadius.circular(12), // Rounded corners
                  //   ),
                  //   child: Text(
                  //     comment.comment ?? '',
                  //     style: const TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.black87,
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 8,
                  //   right: 8,
                  //   child: FloatingActionButton(
                  //     onPressed: () {
                  //       // Handle donation action
                  //     },
                  //     mini: true,
                  //     backgroundColor: Colors.orange, // Use appropriate color
                  //     child: const Icon(
                  //       Icons.monetization_on,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const Divider(), // Divider between comments
            ],
          );
        },
      ),
    );

  }

  // Bottom sheet to show all comments
  void _showFullComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "All Comments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: project.recentComments?.length, // Assume you have all comments here
                  itemBuilder: (context, index) {
                    final comment = project.recentComments?[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${comment?.user?.firstname} ${comment?.user?.lastname}'),
                      ),
                      title: Text('${comment?.user?.firstname} ${comment?.user?.lastname}'),
                      subtitle: Text(comment?.comment ?? ''),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // Comment input field pinned at the bottom
  Widget _buildCommentInputField(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              // Collect the comment and send it via API
              final commentText = _commentController.text;
              if (commentText.isNotEmpty) {
                // Call API to send comment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment added')),
                );
                _commentController.clear();
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

}

