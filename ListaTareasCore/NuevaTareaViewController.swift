//
//  NuevaTareaViewController.swift
//  ListaTareasCore
//
//  Created by Mac11 on 11/05/22.
//

import UIKit
import CoreData

class NuevaTareaViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fechaTarea: UIDatePicker!
    @IBOutlet weak var textoTarea: UITextField!
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hacemos la gestura
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        imagenTarea.addGestureRecognizer(gestureRecognizer)
        imagenTarea.isUserInteractionEnabled = true
        
        //habilitar la escritura
        textoTarea.delegate = self
        textoTarea.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    @objc func clickImagen(gesture: UITapGestureRecognizer){
        print("cambiar imagen")
        //crear viewcontroller temporal para las fotos
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }


    @IBOutlet weak var imagenTarea: UIImageView!
    @IBAction func guardarBtn(_ sender: UIBarButtonItem) {
        //validar que no ete vacio
        if let tarea = textoTarea.text, !tarea.isEmpty{
            let fecha = fechaTarea.date
            let imagen = imagenTarea.image?.pngData()
            //creamos un nuevo objeto
            
            let nuevoElemento = Tarea(context: self.contexto)
            nuevoElemento.titulo = tarea
            nuevoElemento.fecha = fecha
            nuevoElemento.imagen = imagen
            
            do{
                try contexto.save()
                print("se guardo correctamente")
            }catch{
                print("error: \(error.localizedDescription)")
            }
            navigationController?.popToRootViewController(animated: true)
        }else{
            textoTarea.placeholder = "Escribe un titulo"
        }
    }
    
}
extension NuevaTareaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenTarea.image=imagenSeleccionada
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
