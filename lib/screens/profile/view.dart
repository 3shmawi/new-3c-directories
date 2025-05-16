import 'package:flutter/material.dart';

final isDark = ValueNotifier<bool>(false);

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'My Profile',
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 24,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
            child: SingleChildScrollView(
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740"),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.primaryColor,
                            width: 3,
                          ),
                        ),
                      ),
                      Text(
                        'Alex Johnson',
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x10000000),
                          offset: Offset(
                            0,
                            2,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 12,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: theme.primaryColor,
                                  size: 24,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: textTheme.labelMedium,
                                      ),
                                      Text('alex.johnson@example.com',
                                          style: textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 12,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: theme.primaryColor,
                                    size: 24,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Phone',
                                            style: textTheme.labelMedium),
                                        Text('+1 (555) 123-4567',
                                            style: textTheme.bodyMedium),
                                      ],
                                    ),
                                  ),
                                ]),
                          ]),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x10000000),
                          offset: Offset(
                            0,
                            2,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Text('About Me', style: textTheme.titleMedium),
                          Text(
                            'I\'m a professional UI/UX designer with over 5 years of experience creating beautiful and functional interfaces. I specialize in mobile app design and user experience optimization. I love collaborating with developers and product managers to bring ideas to life.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x10000000),
                          offset: Offset(
                            0,
                            2,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Settings',
                            style: textTheme.titleMedium,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.dividerColor)),
                            child: ValueListenableBuilder(
                                valueListenable: isDark,
                                builder: (_, value, __) {
                                  return SwitchListTile(
                                      title: Text("Dark Theme"),
                                      value: value,
                                      onChanged: (v) {
                                        isDark.value = v;
                                      });
                                }),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Change Password',
                                style: textTheme.bodyMedium,
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Change Password',
                                style: textTheme.bodyMedium,
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
