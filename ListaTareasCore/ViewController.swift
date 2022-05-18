//
//  ViewController.swift
//  ListaTareasCore
//
//  Created by Mac11 on 11/05/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listaTareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaTarea.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = listaTareas[indexPath.row].titulo
        //formatear fecha
        let formatoFecha = DateFormatter()
        formatoFecha.dateStyle = .full
        let fechaMuestra = formatoFecha.string(from: listaTareas[indexPath.row].fecha ?? Date())
        
        celda.detailTextLabel?.text = "\(fechaMuestra)"
        let imagenCelda = UIImage(data: listaTareas[indexPath.row].imagen!)
        celda.imageView?.image = imagenCelda
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaTarea.deselectRow(at: indexPath, animated: true)
        //guardar la tarea a mandar
        tareaMandar = listaTareas[indexPath.row]
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar=UIContextualAction(style: .normal, title: "Borrar") { (_, _, _) in
            self.contexto.delete(self.listaTareas[indexPath.row])
            self.listaTareas.remove(at: indexPath.row)
            do{
                try self.contexto.save()
            }catch{
                print("Error al eliminar datos")
            }
            self.tablaTarea.reloadData()
        }
        accionEliminar.image=UIImage(systemName: "trash")
        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            let objDestino = segue.destination as! EditarTareaViewController
            objDestino.recibirTarea = tareaMandar
        }
    }

    @IBOutlet weak var tablaTarea: UITableView!
    var tareaMandar: Tarea?
    var listaTareas = [Tarea]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaTarea.delegate=self
        tablaTarea.dataSource=self
        //leer info
        leerTarea()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        leerTarea()
    }
    
    func leerTarea() {
        let solicitud: NSFetchRequest<Tarea> = Tarea.fetchRequest()
        
        do{
            listaTareas = try contexto.fetch(solicitud)
        }catch{
            print("error: \(error.localizedDescription)")
        }
        tablaTarea.reloadData()
    }
    

    @IBAction func agregarTareaBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "nuevo", sender: self)
    }
    
}



