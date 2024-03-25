import UIKit

class TableViewController: UITableViewController {
    
    var tasks = [String]()
    let userDefaults = UserDefaults.standard
    
    
    //BUTTON ADD TASK
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add a new task", for: .normal)
        button.setTitleColor(.white, for: .normal) //Colore scritta del bottone
        button.backgroundColor = .systemBlue // Colore del bottone
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18) //Font del bottone
        button.layer.cornerRadius = 15 // Bordi del bottone
        
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //dimensioni del bottone
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
     
    //BUTTON SORT BY NAME
    lazy var sortByNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sort by name", for: .normal)
        button.setTitleColor(.white, for: .normal) //Colore scritta del bottone
        button.backgroundColor = .systemPink // Colore del bottone
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15) //Font del bottone
        button.layer.cornerRadius = 30 // Bordi del bottone
        button.addTarget(self, action: #selector(sortTasksByName), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return button
    }()
    
    //bottone SORT BY DATE
    lazy var sortByDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sort by Date", for: .normal)
        button.setTitleColor(.white, for: .normal) //Colore scritta del bottone
        button.backgroundColor = .systemPurple // Colore del bottone
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15) //Font del bottone
        button.layer.cornerRadius = 30 // Bordi del bottone
        button.addTarget(self, action: #selector(sortTasksByDate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 90))//per un pò di spazio tra il bottone e i task
        
        tableView.tableHeaderView = emptyHeaderView
        
        view.addSubview(addButton)
        view.addSubview(sortByNameButton)
        view.addSubview(sortByDateButton)
               
        //POSIZIONO I BOTTONI
               NSLayoutConstraint.activate([
                //ADD TASK BUTTON
                   addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

                   //SORT BY NAME BUTTON
                   sortByNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
                   sortByNameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                   
                 
                   //SORT BY DATE BUTTON
                   sortByDateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
                   sortByDateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                   
               ])
        
        //azione per il sort
        sortByNameButton.addTarget(self, action: #selector(sortTasksByName), for: .touchUpInside)
               
               // CARICO I TASK SALVATI
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
    @objc func addTask(){
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
                
                //ANIMAZIONE DURANTE GLI SWAP
                let fromIndexPath = IndexPath(row: j, section: 0)
                let toIndexPath = IndexPath(row: j - 1, section: 0)
                tableView.moveRow(at: fromIndexPath, to: toIndexPath) // Aggiorno con i task ordinati
                
                j -= 1
            }
        }
    }
    
    
    
    //ALGORITMO DI insertion sort per ordinare i task per data
    @objc func sortTasksByDate() {
        print("Sorting tasks by date...")
        
        // Salva l'array dei task originale
        let originalTasks = tasks
        
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
        
        // Identifica le modifiche nell'array dei task
        var moves = [(from: IndexPath, to: IndexPath)]()
        for (index, task) in tasks.enumerated() {
            if let originalIndex = originalTasks.firstIndex(of: task), index != originalIndex {
                moves.append((IndexPath(row: originalIndex, section: 0), IndexPath(row: index, section: 0)))
            }
        }
        
        // Aggiorna la tabella con un'animazione appropriata
        tableView.beginUpdates()
        for move in moves {
            tableView.moveRow(at: move.from, to: move.to)
        }
        tableView.endUpdates()
    }

    
    

    
  
}
