import 'package:flutter/material.dart';

import '../model/on_board_model.dart';

class OnboardLogic {
  final List<OnBoardingModel> onBoardingData = [
    OnBoardingModel(
      title: "Choose Products",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
      imagePath: "assets/on_board_images/on_board1.svg",
    ),
    OnBoardingModel(
      title: "Make Payment",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
      imagePath: "assets/on_board_images/on_board2.svg",
    ),
    OnBoardingModel(
      title: "Get Your Order",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
      imagePath: "assets/on_board_images/on_board3.svg",
    ),
  ];

  int currentPageIndex = 0;
  final pageController = PageController();

  void nextPage() {
    if (currentPageIndex < onBoardingData.length - 1) {
      currentPageIndex++;
      pageController.animateToPage(
        currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPageIndex > 0) {
      currentPageIndex--;
      pageController.animateToPage(
        currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage() {
    currentPageIndex = onBoardingData.length - 1;
    pageController.animateToPage(
      currentPageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool get isLastPage {
    return currentPageIndex == onBoardingData.length - 1;
  }

  bool get isFirstPage {
    return currentPageIndex == 0;
  }
}
