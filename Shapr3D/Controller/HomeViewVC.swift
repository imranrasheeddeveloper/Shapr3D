//
//  HomeViewVC.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 26/07/2021.
//

import UIKit
import MobileCoreServices
class HomeViewVC: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var collectionView : UICollectionView!
    private var convertObj = Conversion()
    var arrayOfData = [Model]()
    let textLabel = UILabel()
    let emptyListImage = UIImageView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        reteriveData()
        
    }
    
    //MARK: - Helper
    func registerNib(){
        collectionView.delegate  = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ConversionCell", bundle: nil), forCellWithReuseIdentifier: "ConversionCell")
    }
    
    func listHaveNoData() {
        collectionView.isHidden = true
        let image = UIImage(named: "emptyTable")
        emptyListImage.image = image
        textLabel.text = "Upload Files"
        textLabel.textColor = .label
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emptyListImage)
        self.view.addSubview(textLabel)
        emptyListImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        emptyListImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        emptyListImage.heightAnchor.constraint(equalToConstant: 200).isActive =  true
        emptyListImage.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: emptyListImage.bottomAnchor, constant: 10).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: emptyListImage.centerXAnchor, constant: 0).isActive = true
        
        
    }
    
    func listHaveData() {
        collectionView.isHidden = false
        emptyListImage.removeFromSuperview()
        textLabel.removeFromSuperview()
    }
    
    func reteriveData() {
        CoreDataHelper.shared.retrieveData(completionalHandler: { [self] data in
            arrayOfData  = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    // MARK: - Long Press Gesture Action Sheet
    @objc func longPressActionCell(longPressGesture : UILongPressGestureRecognizer)
    {
        let point = longPressGesture.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if indexPath != nil
        {
            let alertActionCell = UIAlertController(title: "Delete File", message: "Choose an action for the selected File", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in
                CoreDataHelper.shared.deleteData(model: arrayOfData[indexPath!.row], completionalHandler: { isDeleted in
                    if isDeleted{
                        DocumentHelper.shared.removeFileFromDir(fileName: arrayOfData[indexPath!.row].fileName)
                        arrayOfData.remove(at: indexPath!.row)
                        
                        self.collectionView!.reloadData()
                    }
                    else{
                        print("File Not Delet")
                    }
                })
                
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { acion in
                print("Cancel")
            })
            
            alertActionCell.addAction(deleteAction)
            alertActionCell.addAction(cancelAction)
            self.present(alertActionCell, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - IBAction
    
    @IBAction  func didTapDocumentPickerButton(sender : UIBarButtonItem) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    
    //MARK: - DocumentPicker Delegate & Helper Funtions
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.allowsMultipleSelection = true
        for url in urls{
            if  DocumentHelper.shared.copyFileToDocumentsFolder(nameForFile: url.lastPathComponent, extForFile: ".shapr" , sourceURL: url){
                reteriveData()
            }else{
                print("Error")
            }
        }
        
    }
}


//MARK: - CollectionView Delegate & DataSourcse


extension HomeViewVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfData.count > 0{
            listHaveData()
            return arrayOfData.count
        }
        else{
            listHaveNoData()
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversionCell", for: indexPath) as! ConversionCell
        cell.expandBtn.tag = indexPath.row
        cell.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressActionCell))
        cell.addGestureRecognizer(longPressGesture)
        cell.setupUI(model: arrayOfData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.height / 6 * 4, height: 260)
    }
    
    
}


//MARK:- Cell Delegate
extension HomeViewVC : ConversionCellDelegate{
    func convertToObj(tag: Int) {
        print()
        
        do {
            try convertObj.convert(from: URL(string : "file://\(arrayOfData[tag].filePath)")!, to: URL(string : "file://\(arrayOfData[tag].filePath)")!) { (d) -> ProgressAction in
                type
                print(d)
                
            }
        } catch {
            
        }
        
        
        
    }
    
    func convertToStep(tag: Int) {
        
    }
    
    func convertToStl(tag: Int) {
        
    }
    
    func detailViewExpand(tag: Int) {
        if arrayOfData[tag].isSelected {
            arrayOfData[tag].isSelected = false
        }
        else{
            arrayOfData[tag].isSelected = true
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


