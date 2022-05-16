//
//  ViewController.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 13/5/22.
//

import UIKit

class NewAlertViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AlertServiceDelegate {
      
    private let alertService: AlertService
    private var tiposAlerta: [AlertType] = AlertType.allCases
    private var currentPage = 0
    private var selectedAlert: AlertType? = nil
    var latitude = 1.0
    var longitude = 1.0
    
    @IBOutlet weak var stackViewDescripcion: UIStackView!
    @IBOutlet weak var textViewTipoAlerta: UITextView!
    @IBOutlet weak var buttonUbicarEnMapa: UIButton!
    @IBOutlet weak var buttonEnviarAlerta: UIButton!
    @IBOutlet weak var collectionViewAlertas: UICollectionView!
    @IBOutlet weak var pageControlAlertas: UIPageControl!
    @IBOutlet weak var textFieldDescripcionAlerta: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func enviarAlerta(_ sender: UIButton) {
        guard let alert = self.selectedAlert else { return }
        let descripcion = textFieldDescripcionAlerta.text
        textFieldDescripcionAlerta.text = ""
        selectedAlert = nil
        collectionViewAlertas.reloadData()
        validateToEnableButton()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        alertService.notifyAlert(latitude: self.latitude, longitude: self.longitude, alertType: alert.id(), text: descripcion ?? alert.rawValue)
    }
    
    init(alertService: AlertService) {
        self.alertService = alertService
        super.init(nibName: "NewAlertView", bundle: nil)
        self.alertService.delegate = self
    }
       
    required convenience init?(coder: NSCoder) {
        self.init(alertService: AlertService())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
        setAlertas()
    }
    
    private func configureUIElements() {
        self.navigationController!.navigationBar.isHidden = true
        view.backgroundColor = .black
        
        pageControlAlertas.numberOfPages = Int(ceil(Double(tiposAlerta.count) / 6))
        
        let cornerRadius = CGFloat(5)
        
        stackViewDescripcion.layer.cornerRadius = cornerRadius
        buttonUbicarEnMapa.layer.cornerRadius = cornerRadius
        buttonEnviarAlerta.layer.cornerRadius = cornerRadius
    }
    
    private func setAlertas() {
        collectionViewAlertas.register(AlertTypeCustomViewCell.self, forCellWithReuseIdentifier: AlertTypeCustomViewCell.identifier)
        collectionViewAlertas.dataSource = self
        collectionViewAlertas.delegate = self
    }
    
    private func showDialog() {
        let title = alertService.response.error == 99 ? "Error" : "Envío correcto"
        let message = alertService.response.message
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Entiendo", style: .default))
        present(ac, animated: true)
    }
    
    //Delegate
    func alertServiceDelegateDidUpdate(_: AlertService) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        showDialog()
    }
    
    // * Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiposAlerta.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewAlertas.dequeueReusableCell(withReuseIdentifier: AlertTypeCustomViewCell.identifier, for: indexPath) as! AlertTypeCustomViewCell
        
        cell.set(alertType: tiposAlerta[indexPath.row], isChecked: false)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAlert = tiposAlerta[indexPath.row]
        
        let cell = collectionViewAlertas.cellForItem(at: indexPath) as! AlertTypeCustomViewCell
        cell.check()
        
        validateToEnableButton()
        textViewTipoAlerta.text = selectedAlert!.rawValue
    }
    
    func validateToEnableButton() {
        if selectedAlert != nil {
            buttonEnviarAlerta.isEnabled = true
            return
        }
        
        buttonEnviarAlerta.isEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionViewAlertas.cellForItem(at: indexPath) as! AlertTypeCustomViewCell
        
        cell.uncheck()
    }
    
    // FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
    //Pager
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControlAlertas.currentPage = currentPage
    }
}

