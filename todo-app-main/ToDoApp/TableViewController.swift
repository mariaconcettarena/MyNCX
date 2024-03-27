import UIKit
import UserNotifications

class TableViewController: UITableViewController {
    
    var tasks = [String]() //array of strings which contains all the tasks of the list
    let userDefaults = UserDefaults.standard //using userdefault to save in memory all the tasks
    
    //HEADING OF THE PAGE: titleLabel
    lazy var titleLabel: UILabel = {
        let label = UILabel() //type: UILabel
        label.text = "To do list" // text of the label
        label.textColor = .black // text color
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold) //text font
        label.translatesAutoresizingMaskIntoConstraints = false //setting this variable false allows to change layout and check sizes avoiding unpredictable settings
        return label
    }()
    
    
    
    //BUTTON FOR ADDING A NEW TASK: '+'
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system) //type: UIButton
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25) //size of the '+'
        let symbolImage = UIImage(systemName: "plus", withConfiguration: symbolConfig) //symbol image '+'
        button.setImage(symbolImage, for: .normal)
        button.setTitleColor(.blue, for: .normal) //color of '+'
        
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside) //the button calls the function 'addTask' when tapped
        button.translatesAutoresizingMaskIntoConstraints = false//setting this variable false allows to change layout and check sizes avoiding unpredictable settings
    
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true //button width
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true //button height
        
        return button
    }()
    
    //BUTTON FOR SORTING BY NAME: 'Sort by name'
    lazy var sortByNameButton: UIButton = {
        let button = UIButton(type: .system) //creation of the button as a UIButton type
        
        button.setTitle("Sort by name", for: .normal) //button title
        button.setTitleColor(.white, for: .normal) //color of button title
        button.backgroundColor = .systemBlue // button color
        button.layer.cornerRadius = 10 // button corners
        
        button.addTarget(self, action: #selector(sortTasksByName), for: .touchUpInside)//the button calls the function 'sortTasksByName' when tapped
        button.translatesAutoresizingMaskIntoConstraints = false//setting this variable false allows to change layout and check sizes avoiding unpredictable settings
        
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true //button width
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true //button height
        
        return button
    }()
    
    //BUTTON FOR SORTING BY DATE: 'Sort by date'
    lazy var sortByDateButton: UIButton = {
        let button = UIButton(type: .system) //creation of the button as a UIButton type
        
        button.setTitle("Sort by date", for: .normal) //button title
        button.setTitleColor(.white, for: .normal) //color of button title
        button.backgroundColor = .systemBlue // button color
        button.layer.cornerRadius = 10 // button corners
        
        button.addTarget(self, action: #selector(sortTasksByDate), for: .touchUpInside) //the button calls the function 'sortTasksByDate' when tapped
        button.translatesAutoresizingMaskIntoConstraints = false//setting this variable false allows to change layout and check sizes avoiding unpredictable settings
        
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true //button width
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true //button height
        
        return button
    }()
    
    
    //CREATION OF THE VIEW AND ITS CONTENT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))// To separate the heading from the other elements, I put a little emptyspace
        
        tableView.tableHeaderView = emptyHeaderView //Add the space to the tableView
        
        view.addSubview(titleLabel) //add the title to the view
        view.addSubview(addButton)  //add the '+' button to the view
        view.addSubview(sortByNameButton) //ad the 'sort by name' button to the view
        view.addSubview(sortByDateButton)   //ad the 'sort by date' button to the view
        
        //Adding constraint to all the elements of the view
        NSLayoutConstraint.activate([
            //Constraint for the title of the view
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            
            //Constraint for the '+' button
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            addButton.topAnchor.constraint(equalTo: view.topAnchor),
            
            //Constraint for the 'sort by name' button
            sortByNameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            sortByNameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            
            //Constraint for the 'sort by date' button
            sortByDateButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant:140),
            sortByDateButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
        ])
        
        //Loading form memory (user default) all the tasks
        tasks = userDefaults.object(forKey: "tasks") as? [String] ?? []
    }
    
    
    //Settings for the content of the tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //1 section
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count //loading all the tasks in the tableView
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    //Function which allows the user to delete a task from the list by swiping it to the left
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = "Done" //when you swipe a task to the left
        let action = UIContextualAction(style: .normal, title: title){
            (action, view, completion) in
            
            tableView.beginUpdates()
            self.tasks.remove(at: indexPath.row) //remove the task from memory (userdefault)
            self.userDefaults.set(self.tasks, forKey: "tasks")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            completion(true)
        }
        action.backgroundColor = .systemGreen //background color to the title 'Done'
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    
    //FUNCTION THAT ADDS A TASK; it is called when '+' button is tapped
    @objc func addTask() {
        let task = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert) //when '+' is tapped, an UIAlertController is opened to add the name and the date of the task
        
        task.addTextField { textField in
            textField.placeholder = "Task name" //Placeholder for the field 'name'
        }
        
        // To pick a date, there is a UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        task.view.addSubview(datePicker) //adding a subview for the datepicker when the date is tapped
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        //constraint for the datePicker
        datePicker.leadingAnchor.constraint(equalTo: task.view.leadingAnchor, constant: 8).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: task.view.trailingAnchor, constant: -8).isActive = true
        datePicker.topAnchor.constraint(equalTo: task.view.topAnchor, constant: 60).isActive = true
        
        //button 'Add' of the UIAlertController which adds the task using an UIAlertAction
        let alertAddButton = UIAlertAction(title: "Add", style: .default) { [weak self, weak task] _ in
            guard let taskName = task?.textFields?[0].text else {
                return
            }
            
            let selectedDate = datePicker.date //putting the selected date form the datePicker in 'selectedDate' to store it
            let formatter = DateFormatter() //formatting the Date to have it in a correct format
            formatter.dateStyle = .medium //type of formatter
            let dateString = formatter.string(from: selectedDate) //formatting the date into a String type to store it
            let task = "\(taskName) - \(dateString)" //now the task added has the 'name' and the 'date' in one String
            self?.add(task) //adding the task in memory after the formatting
        }
        
        task.addAction(alertAddButton) //function related to the 'Add' button
        present(task, animated: true) //the task is shown in the list after the add button
        
    }
    
    //Function add which adds the task i memory (userDefault)
    func add(_ task: String) {
        tasks.append(task)
        tableView.reloadData()
        userDefaults.set(tasks, forKey: "tasks")
    }
    
    
    //Insertion sort algorithm which sorts the tasks by their name (alphabetical order)
    @objc func sortTasksByName() {
        // This loop iterates over each index in the range from 1 to one less than the count of tasks array.
        for i in 1..<tasks.count {
            // Assign the current index 'i' to variable 'j'.
            var j = i
            
            // This loop iterates backwards from the current index 'j' to 0,
            // checking if the element at index 'j - 1' is greater than the element at index 'j'.
            // If yes, it swaps the elements and decrements 'j' until the condition is false or 'j' reaches 0.
            while j > 0 && tasks[j - 1] > tasks[j] {
                // Swap the elements at index 'j - 1' and 'j'.
                tasks.swapAt(j - 1, j)
                
                // Reload data in the table view to reflect the updated order of tasks.
                tableView.reloadData()
                
                // Decrement 'j' to continue the comparison with the previous element.
                j -= 1
            }
        }

    }
    
    //Insertion sort algorithm which sorts the tasks by their date (from the oldest to the newest) extracted from each task string.
    @objc func sortTasksByDate() {
        // Sort the tasks array using a closure that compares the dates extracted from each task.
        tasks.sort(by: { task1, task2 in
            // Extract the date strings from the task strings.
            let dateString1 = task1.components(separatedBy: " - ").last ?? ""
            let dateString2 = task2.components(separatedBy: " - ").last ?? ""
            
            // Create a DateFormatter instance to convert date strings to Date objects.
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            // Try to convert the date strings to Date objects.
            if let date1 = formatter.date(from: dateString1), let date2 = formatter.date(from: dateString2) {
                // If both conversions are successful, compare the dates.
                return date1 < date2 // Return true if date1 is earlier than date2.
            }
            // If conversion fails for any date string, return false.
            return false
        })
        // Reload data in the table view to reflect the sorted order of tasks.
        tableView.reloadData()
    }
    
}
