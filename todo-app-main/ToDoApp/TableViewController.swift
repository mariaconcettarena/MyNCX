import UIKit

class TableViewController: UITableViewController {
    
    var tasks = [String]() //array of strings which contains all the tasks of the list
    let userDefaults = UserDefaults.standard //using userdefault to save in memory all the tasks
    
    //HEADING OF THE PAGE: titleLabel
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "To do list" // text of the label
        label.textColor = .black // text color
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold) //text font
        label.translatesAutoresizingMaskIntoConstraints = false //setting this variable false allows to change layout and check sizes avoiding unpredictable settings
        return label
    }()
    
    //RIPRENDI DA QUI CON IL REFACTORING!!!
    
    
    
    
    
    
    
    
    
    
    
    //BUTTON ADD TASK
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        
        
        // let symbolImage = UIImage(systemName: "plus")
        //  button.setImage(symbolImage, for: .normal)
        
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25)
        let symbolImage = UIImage(systemName: "plus", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        
        
        
        button.setTitleColor(.blue, for: .normal) //Colore scritta del bottone
        button.backgroundColor = .systemBackground // Colore del bottone
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30/*,weight: .bold*/) //Font del bottone
        
        button.layer.cornerRadius = 15 // Bordi del bottone
        
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //dimensioni del bottone
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    //BUTTON SORT BY NAME
    lazy var sortByNameButton: UIButton = {
        let button = UIButton(type: .system) //creation of the button as a UIButton type
        
        button.setTitle("Sort by name", for: .normal) //button title
        button.setTitleColor(.white, for: .normal) //color title
        button.backgroundColor = .systemBlue // button color
        button.layer.cornerRadius = 10 // button corners
        
        button.addTarget(self, action: #selector(sortTasksByName), for: .touchUpInside)//function
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true //button width
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true //button height
        
        return button
    }()
    
    //BUTTON Sort by Date
    lazy var sortByDateButton: UIButton = {
        let button = UIButton(type: .system) //creation of the button as a UIButton type
        
        button.setTitle("Sort by Date", for: .normal) //button title
        button.setTitleColor(.white, for: .normal) //color title
        button.backgroundColor = .systemBlue // button color
        button.layer.cornerRadius = 10 // button corners
        
        button.addTarget(self, action: #selector(sortTasksByDate), for: .touchUpInside) //function
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = "Done"
        let action = UIContextualAction(style: .normal, title: title){
            (action, view, completion) in
            
            tableView.beginUpdates()
            self.tasks.remove(at: indexPath.row)
            self.userDefaults.set(self.tasks, forKey: "tasks")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            completion(true)
        }
        action.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
    
    
    //FUNCTION THAT ADDS A TASK
    @objc func addTask() {
        let t = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        
        // Campi relativi al task
        t.addTextField { textField in
            textField.placeholder = "Task name"
        }
        
        // Aggiungi un selettore di data per la data
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        t.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: t.view.leadingAnchor, constant: 8).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: t.view.trailingAnchor, constant: -8).isActive = true
        datePicker.topAnchor.constraint(equalTo: t.view.topAnchor, constant: 60).isActive = true
        
        let alertAddButton = UIAlertAction(title: "Add", style: .default) { [weak self, weak t] _ in
            guard let taskName = t?.textFields?[0].text else {
                return
            }
            
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let dateString = formatter.string(from: selectedDate)
            let task = "\(taskName) - \(dateString)"
            self?.add(task)
        }
        
        t.addAction(alertAddButton)
        present(t, animated: true)
        
        
    }
    
    
    func add(_ task: String) {
        tasks.append(task)
        tableView.reloadData()
        userDefaults.set(tasks, forKey: "tasks")
    }
    
    
    //ALGORITMO DI insertion sort per ordinare i task per nome
    @objc func sortTasksByName() {
        print("Sorting tasks by name...")
        
        for i in 1..<tasks.count {
            var j = i
            while j > 0 && tasks[j - 1] > tasks[j] {
                tasks.swapAt(j - 1, j)
                
                tableView.reloadData()
                
                j -= 1
            }
        }
    }
    
    
    
    //ALGORITMO DI insertion sort per ordinare i task per data
    @objc func sortTasksByDate() {
        print("Sorting tasks by date...")
        
        tasks.sort(by: { task1, task2 in
            // Estrai le date dai task (considerando che la data è alla fine della stringa dopo il simbolo "-")
            let dateString1 = task1.components(separatedBy: " - ").last ?? ""
            let dateString2 = task2.components(separatedBy: " - ").last ?? ""
            
            // Converti le date in oggetti Date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if let date1 = formatter.date(from: dateString1), let date2 = formatter.date(from: dateString2) {
                // Confronta le date
                return date1 < date2
            }
            // se non riesco a ordinare non cambio nulla nella view
            return false
        })
        // Aggiorno con i task ordinati
        tableView.reloadData()
    }
    
    
    
    
    
}
