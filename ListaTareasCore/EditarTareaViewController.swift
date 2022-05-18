//
//  EditarTareaViewController.swift
//  ListaTareasCore
//
//  Created by Mac11 on 11/05/22.
//

import UIKit
import CoreData


class EditarTareaViewController: UIViewController {
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var fechaPicker: UIDatePicker!
    @IBOutlet weak var fechaTarea: UILabel!
    @IBOutlet weak var tituloTarea: UITextField!
    
    @IBOutlet weak var imagenTarea: UIImageView!
    var recibirTarea: Tarea?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gestura
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        imagenTarea.addGestureRecognizer(gestureRecognizer)
        imagenTarea.isUserInteractionEnabled = true
        
        
        
        
        
        tituloTarea.text=recibirTarea?.titulo
        fechaPicker.date=recibirTarea?.fecha ?? Date()
        let imagenCelda = UIImage(data: (recibirTarea?.imagen)!)
        imagenTarea.image = imagenCelda
       
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
    

    @IBAction func guardarBtn(_ sender: UIButton) {
        recibirTarea?.titulo = tituloTarea.text
        recibirTarea?.fecha = fechaPicker.date
        recibirTarea?.imagen = imagenTarea.image?.pngData()
        do{
            try contexto.save()
        }catch{
            print("error: \(error.localizedDescription)")
        }
        
        //Regresar al VC
        navigationController?.popToRootViewController(animated: true)
        
    }
    

}
extension EditarTareaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
