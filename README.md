# **ToDoApp README**

![ToDo List App]([AppIcon.png](https://github.com/mariaconcettarena/MyNCX/blob/main/todo-app-main/ToDoApp/Assets.xcassets/AppIcon.appiconset/icon.jpeg))

## **Description:**
ToDoApp is a simple iOS application designed to help users manage their tasks efficiently. With this app, users can add, delete, and sort tasks based on their names or due dates. Additionally, the app provides notifications to remind users of pending tasks.

## **Features:**
1. **Add Tasks:** Users can easily add new tasks to their list along with a due date.
2. **Delete Tasks:** Tasks can be deleted individually by swiping left on them.
3. **Sort by Name:** Tasks can be sorted alphabetically by their names.
4. **Sort by Date:** Tasks can be sorted chronologically based on their due dates.
5. **Notifications:** Users receive notifications on the day a task is due, reminding them to complete it.
6. **Permission Handling:** The app handles permission requests for notifications gracefully, ensuring a smooth user experience.

## **Getting Started:**
To get started with the ToDo List App, follow these steps:
1. **Clone the Repository:** Clone this repository to your local machine using `git clone`.
2. **Open in Xcode:** Open the project in Xcode by double-clicking the `.xcodeproj` file.
3. **Build and Run:** Build and run the project on a simulator or a physical device.
4. **Explore:** Explore the app's features, add tasks, sort them, and observe the notification functionality.

## **Requirements:**
- Xcode 12 or later
- iOS 12.0 or later

## **Features:**
### User Interface with UIKit
The ToDo List App utilizes UIKit, Apple's UI framework for building iOS applications. With UIKit, the app provides a familiar and intuitive user interface, making it easy for users to interact with their task lists.
### System Notifications
The app leverages system notifications provided by iOS to remind users of pending tasks. By integrating with the UserNotifications framework, the app schedules notifications for the due dates of tasks. When a task's due date arrives, users receive a notification on their device, prompting them to complete the task.
### Data Structures and Algorithms
The ToDo List App employs the insertion sort algorithm to sort tasks alphabetically by name or chronologically by due date. Insertion sort is a simple sorting algorithm that iterates through an array, gradually building a sorted section of the array by shifting elements one position at a time until the entire array is sorted. This algorithm is well-suited for small data sets, making it efficient for sorting tasks in the ToDo List App.

  
## **Contributing:**
Contributions are welcome! If you find any bugs or have suggestions for new features, please open an issue or submit a pull request.

---
*This README was created by Maria Concetta Arena.*
