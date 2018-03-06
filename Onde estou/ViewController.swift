//
//  ViewController.swift
//  Onde estou
//
//  Created by 5A Nucleo Desenvolvimento on 06/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    let gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacaoUsuario = locations.last!
        let latitude = localizacaoUsuario.coordinate.latitude
        let longitude = localizacaoUsuario.coordinate.longitude
        
        self.latitudeLabel.text = String(describing: latitude)
        self.longitudeLabel.text = String(describing: longitude)
        
        if localizacaoUsuario.speed > 0 {
            self.velocidadeLabel.text = String(describing: localizacaoUsuario.speed)
        }
        
        let coordenadas = CLLocationCoordinate2DMake(latitude, longitude)
        let areaExibicao = MKCoordinateSpanMake(0.01, 0.01)
        let regiao = MKCoordinateRegionMake(coordenadas, areaExibicao)
        self.mapa.setRegion(regiao, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, erro) in
            if erro == nil {
                if let dadosLocal = detalhesLocal?.first {
                
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil {
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    
                    var country = ""
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
                    
                    self.enderecoLabel.text = thoroughfare + "-"
                                                + subThoroughfare + " / "
                                                + locality + " / "
                                                + country
                }
            } else {
                print(erro!)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertaController = UIAlertController(title: "Permissão de Localzação", message: "Necessário permissão para acesso à sua localização!", preferredStyle: .alert)
            
            let acaoConfiguracao = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaController.addAction(acaoConfiguracao)
            alertaController.addAction(acaoCancelar)
            
            present(alertaController, animated: true, completion: nil)
        }
    }

}

