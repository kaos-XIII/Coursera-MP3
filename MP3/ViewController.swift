//
//  ViewController.swift
//  MP3
//
//  Created by Alejandro Veiga López on 30/4/16.
//  Copyright © 2016 Alejandro Veiga López. All rights reserved.
//

/*
Proyecto

Hacer una aplicación que permita seleccionar entre cinco diferentes canciones para reproducir. El reproductor debe tener controles de reproducción y de volumen, así como permitir la selección aleatoria de una canción.

Descripción

Hacer una aplicación en Swift que se pueda correr en el simulador de iOS usando Xcode y que permita:

•	Seleccionar entre varias canciones diferentes

*	La selección se puede hacer con un botón o cualquier otro mecanismo que usted desee (tabla, picker, etc.)

*	Las canciones deben estar “en duro”.

*	Sólo deberá tener entre 7 y 10 segundos de cada canción (por cuestiones de espacio).

•	Al seleccionar una canción deberá aparecer su título y la portada de su CD.

•	En cuanto la canción sea seleccionada deberán aparecer sus datos (título y foto) e iniciará la reproducción de inmediato sin que el usuario tenga que hacer nada más.

•	Se podrá controlar la reproducción con 3 botones: Tocar, Pausar o Detener.

•	Se podrá controlar el volumen (aumentarlo o disminuirlo).

*	Este control puede hacerse con 2 botones (+ y -) o con cualquier otro mecanismo que usted desee (slider, etc.)

•	Debe contener un botón de selección aleatoria (shuffle)

*/

import UIKit

import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var VolumenSlider: UISlider!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var SelecSongPicker: UIPickerView!
    @IBOutlet weak var TiempoSlider: UISlider!
    @IBOutlet weak var TituloLabel: UILabel!
    
    private var reproductor : AVAudioPlayer!
    
    private var canciones: Array<Array<String>> = []
    
    //private var tiempo : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        SelecSongPicker.delegate = self
        SelecSongPicker.dataSource = self
        
        // nombre, extension, titulo, portada
        canciones.append(["Cancion 1", "mp3", "True Frontliner", "frontliner"])
        canciones.append(["Cancion 2", "mp3", "Wild Wild West", "wmf"])
        canciones.append(["Cancion 3", "mp3", "Tell Me", "summer"])
        
        do {
        
            try reproductor = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource(canciones[0][2], withExtension: canciones[0][1])!)
            TituloLabel.text = canciones[0][2]
            coverImage.image = UIImage(named: canciones[0][3])
            
            //tiempo = 0;
            TiempoSlider.minimumValue = 0
            TiempoSlider.value = 0
            TiempoSlider.maximumValue = Float(reproductor.duration)
            VolumenSlider.value = reproductor.volume
        
        }
        catch {
         
            print("Error al cargar archivo de sonido")
        
        }
    
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.actualizarTiempoReproduccion), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PlayAction() {
        
        if !reproductor.playing {
            
            reproductor.play()
        
        }
    
    }

    @IBAction func PauseAcction() {
        
        if reproductor.playing {
            
            reproductor.pause()
            
        }
        
    }

    @IBAction func StopAction() {
        
        if reproductor.playing {
            
            //tiempo = 0
            TiempoSlider.value = 0
            reproductor.stop()
            reproductor.currentTime = 0.0
            
        }
        
    }

    @IBAction func VolumenSlider(sender: UISlider) {
        
        reproductor.volume = Float(sender.value)
        
    }

    @IBAction func ShuffleAction() {
    
        let numRandom = getRandomNumberBetween(0, To: 2)
        
        SelecSongPicker.selectRow(numRandom, inComponent: 0, animated: true)
        pickerView(SelecSongPicker, didSelectRow: numRandom, inComponent: 0)
        
    }
    
    func getRandomNumberBetween (From: Int , To: Int) -> Int {
    
        return From + Int(arc4random_uniform(UInt32(To - From + 1)))
    
    }
    
    
// MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return canciones.count
    
    }
    
// MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, TitleForRow row: Int, forComponent component: Int) -> String? {
        
        return canciones[row][0]
    
    }
 
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        return canciones[row][0]
    
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
         do {
         
            try reproductor = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource(canciones[row][2], withExtension: canciones[row][1])!)
         
            TituloLabel.text = canciones[row][2]
            coverImage.image = UIImage(named: canciones[row][3])
            
            TiempoSlider.value = Float(reproductor.currentTime)
            
            TiempoSlider.minimumValue = 0
            TiempoSlider.value = 0
            TiempoSlider.maximumValue = Float(reproductor.duration)
            
            reproductor.volume = VolumenSlider.value
            
            PlayAction()
         
         }
         catch {
         
         
            print("Error al cargar archivo de sonido")
         
         }
        
    }
    
// NSTimer
    
    func actualizarTiempoReproduccion(){
        
        TiempoSlider.value = Float(reproductor.currentTime)
        /*
        if reproductor.playing {
            
            tiempo += 1
            
            //TiempoSlider.value = Float(tiempo)
            
            
        }*/
        
    }
    
    @IBAction func cambiarTiempoAction(sender: UISlider) {
    
        let nuevoTiempo: NSTimeInterval = NSTimeInterval(sender.value)
        
        //tiempo = Int(TiempoSlider.value)
        
        reproductor.currentTime = nuevoTiempo
        
    }
    
}

